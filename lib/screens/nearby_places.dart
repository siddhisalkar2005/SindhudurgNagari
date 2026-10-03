import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class NearbyPlaces extends StatefulWidget {
  final int language;

  const NearbyPlaces({
    super.key,
    this.language = 2,
  });

  @override
  State<NearbyPlaces> createState() => _NearbyPlacesState();
}

class _NearbyPlacesState extends State<NearbyPlaces> {
  Position? currentPosition;

  bool isLoading = true;
  String? errorMessage;

  List<Place> places = [];

  @override
  void initState() {
    super.initState();
    loadNearbyPlaces();
  }

  // =========================================================
  // LANGUAGE
  // =========================================================

  String get screenTitle {
    if (widget.language == 0) {
      return 'जवळील ठिकाणे';
    }

    if (widget.language == 1) {
      return 'आस-पास की जगहें';
    }

    return 'Nearby Places';
  }

  String get locationText {
    if (widget.language == 0) {
      return 'तुमच्या सध्याच्या स्थानाजवळ';
    }

    if (widget.language == 1) {
      return 'आपके वर्तमान स्थान के पास';
    }

    return 'Near your current location';
  }

  String get nearbyText {
    if (widget.language == 0) {
      return 'जवळील ठिकाणे';
    }

    if (widget.language == 1) {
      return 'आस-पास की जगहें';
    }

    return 'Nearby Places';
  }

  String get refreshingText {
    if (widget.language == 0) {
      return 'ठिकाणे शोधत आहे...';
    }

    if (widget.language == 1) {
      return 'जगहें खोजी जा रही हैं...';
    }

    return 'Finding places near you...';
  }

  String get noPlacesText {
    if (widget.language == 0) {
      return 'जवळपास कोणतीही ठिकाणे सापडली नाहीत';
    }

    if (widget.language == 1) {
      return 'आस-पास कोई जगह नहीं मिली';
    }

    return 'No nearby places found';
  }

  // =========================================================
  // LOAD LOCATION + PLACES
  // =========================================================

  Future<void> loadNearbyPlaces() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final position = await getCurrentLocation();

      currentPosition = position;

      final nearby = await fetchPlaces(
        position.latitude,
        position.longitude,
      );

      if (!mounted) return;

      setState(() {
        places = nearby;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  // =========================================================
  // CURRENT LOCATION
  // =========================================================

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled =
        await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception(
        'Location service is disabled.',
      );
    }

    LocationPermission permission =
        await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission =
          await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception(
        'Location permission denied.',
      );
    }

    if (permission ==
        LocationPermission.deniedForever) {
      throw Exception(
        'Location permission permanently denied.',
      );
    }

    return await Geolocator.getCurrentPosition(
      locationSettings:
          const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  // =========================================================
  // OPENSTREETMAP - REAL NEARBY PLACES
  // =========================================================

  Future<List<Place>> fetchPlaces(
    double latitude,
    double longitude,
  ) async {
    const double radius = 30000;

    final query = '''
[out:json][timeout:25];

(
  node["tourism"="attraction"](around:$radius,$latitude,$longitude);
  way["tourism"="attraction"](around:$radius,$latitude,$longitude);

  node["tourism"="viewpoint"](around:$radius,$latitude,$longitude);
  way["tourism"="viewpoint"](around:$radius,$latitude,$longitude);

  node["tourism"="museum"](around:$radius,$latitude,$longitude);
  way["tourism"="museum"](around:$radius,$latitude,$longitude);

  node["historic"="castle"](around:$radius,$latitude,$longitude);
  way["historic"="castle"](around:$radius,$latitude,$longitude);

  node["historic"="fort"](around:$radius,$latitude,$longitude);
  way["historic"="fort"](around:$radius,$latitude,$longitude);

  node["natural"="beach"](around:$radius,$latitude,$longitude);
  way["natural"="beach"](around:$radius,$latitude,$longitude);

  node["tourism"="beach_resort"](around:$radius,$latitude,$longitude);
  way["tourism"="beach_resort"](around:$radius,$latitude,$longitude);
);

out center tags;
''';

    final response = await http.post(
      Uri.parse(
        'https://overpass-api.de/api/interpreter',
      ),
      headers: {
        'Content-Type':
            'application/x-www-form-urlencoded',
      },
      body: {
        'data': query,
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Unable to load nearby places.',
      );
    }

    final data = jsonDecode(response.body);

    final List elements = data['elements'] ?? [];

    final List<Place> result = [];

    for (final element in elements) {
      final tags =
          Map<String, dynamic>.from(
        element['tags'] ?? {},
      );

      String? name = tags['name'];

      if (name == null || name.trim().isEmpty) {
        continue;
      }

      double? placeLat;
      double? placeLon;

      if (element['lat'] != null &&
          element['lon'] != null) {
        placeLat =
            (element['lat'] as num).toDouble();

        placeLon =
            (element['lon'] as num).toDouble();
      } else if (element['center'] != null) {
        placeLat =
            (element['center']['lat'] as num)
                .toDouble();

        placeLon =
            (element['center']['lon'] as num)
                .toDouble();
      }

      if (placeLat == null || placeLon == null) {
        continue;
      }

      final distance = Geolocator.distanceBetween(
        latitude,
        longitude,
        placeLat,
        placeLon,
      );

      final category =
          getCategory(tags);

      result.add(
        Place(
          name: name,
          latitude: placeLat,
          longitude: placeLon,
          distance: distance,
          category: category,
          imageUrl: tags['image'],
        ),
      );
    }

    // Remove duplicates.
    final unique = <String, Place>{};

    for (final place in result) {
      unique[
          '${place.name.toLowerCase()}_${place.latitude.toStringAsFixed(3)}'] =
          place;
    }

    final sorted =
        unique.values.toList();

    sorted.sort(
      (a, b) =>
          a.distance.compareTo(b.distance),
    );

    // Get Wikimedia images.
    final finalPlaces = <Place>[];

    for (final place in sorted.take(12)) {
      String? image = place.imageUrl;

      if (image == null ||
          image.isEmpty) {
        image = await getWikimediaImage(
          place.latitude,
          place.longitude,
        );
      }

      finalPlaces.add(
        place.copyWith(
          imageUrl: image,
        ),
      );
    }

    return finalPlaces;
  }

  // =========================================================
  // CATEGORY
  // =========================================================

  String getCategory(
    Map<String, dynamic> tags,
  ) {
    if (tags['natural'] == 'beach' ||
        tags['tourism'] == 'beach_resort') {
      return 'beach';
    }

    if (tags['historic'] == 'castle' ||
        tags['historic'] == 'fort') {
      return 'fort';
    }

    if (tags['tourism'] == 'museum') {
      return 'museum';
    }

    if (tags['tourism'] == 'viewpoint') {
      return 'viewpoint';
    }

    return 'place';
  }

  // =========================================================
  // WIKIMEDIA IMAGE
  // =========================================================

  Future<String?> getWikimediaImage(
    double latitude,
    double longitude,
  ) async {
    try {
      final uri = Uri.parse(
        'https://commons.wikimedia.org/w/api.php'
        '?action=query'
        '&generator=geosearch'
        '&ggsprimary=all'
        '&ggsnamespace=6'
        '&ggsradius=5000'
        '&ggslimit=1'
        '&ggscoord=$latitude|$longitude'
        '&prop=imageinfo'
        '&iiprop=url'
        '&iiurlwidth=900'
        '&format=json'
        '&origin=*',
      );

      final response =
          await http.get(uri);

      if (response.statusCode != 200) {
        return null;
      }

      final data =
          jsonDecode(response.body);

      final pages =
          data['query']?['pages'];

      if (pages == null) {
        return null;
      }

      for (final page in pages.values) {
        final imageInfo =
            page['imageinfo'];

        if (imageInfo != null &&
            imageInfo.isNotEmpty) {
          return imageInfo[0]['thumburl'] ??
              imageInfo[0]['url'];
        }
      }
    } catch (_) {
      return null;
    }

    return null;
  }

  // =========================================================
  // CATEGORY LABEL
  // =========================================================

  String categoryLabel(String category) {
    if (widget.language == 0) {
      switch (category) {
        case 'beach':
          return 'समुद्र किनारा';
        case 'fort':
          return 'किल्ला';
        case 'museum':
          return 'संग्रहालय';
        case 'viewpoint':
          return 'निसर्गरम्य ठिकाण';
        default:
          return 'पर्यटन स्थळ';
      }
    }

    if (widget.language == 1) {
      switch (category) {
        case 'beach':
          return 'समुद्र तट';
        case 'fort':
          return 'किला';
        case 'museum':
          return 'संग्रहालय';
        case 'viewpoint':
          return 'दृश्य स्थल';
        default:
          return 'पर्यटन स्थल';
      }
    }

    switch (category) {
      case 'beach':
        return 'Beach';
      case 'fort':
        return 'Fort';
      case 'museum':
        return 'Museum';
      case 'viewpoint':
        return 'Viewpoint';
      default:
        return 'Tourist Place';
    }
  }

  // =========================================================
  // DISTANCE
  // =========================================================

  String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.round()} m';
    }

    return '${(meters / 1000).toStringAsFixed(1)} km';
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF5FAFC),

      appBar: AppBar(
        elevation: 0,
        backgroundColor:
            const Color(0xFF063B5C),
        foregroundColor: Colors.white,

        titleSpacing: 4,

        title: Text(
          screenTitle,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 21,
          ),
        ),

        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed:
                isLoading
                    ? null
                    : loadNearbyPlaces,
            icon: const Icon(
              Icons.refresh_rounded,
            ),
          ),

          const SizedBox(width: 6),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: loadNearbyPlaces,
        color:
            const Color(0xFF087E8B),

        child: isLoading
            ? _buildLoading()
            : errorMessage != null
                ? _buildError()
                : _buildContent(),
      ),
    );
  }

  // =========================================================
  // LOADING
  // =========================================================

  Widget _buildLoading() {
    return ListView(
      physics:
          const AlwaysScrollableScrollPhysics(),

      padding:
          const EdgeInsets.all(16),

      children: [
        _buildLocationHeader(),

        const SizedBox(height: 20),

        Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child:
                  CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),

            const SizedBox(width: 10),

            Text(
              refreshingText,
              style: const TextStyle(
                color:
                    Color(0xFF063B5C),
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        ...List.generate(
          3,
          (_) => _buildSkeleton(),
        ),
      ],
    );
  }

  // =========================================================
  // CONTENT
  // =========================================================

  Widget _buildContent() {
    return ListView(
      physics:
          const AlwaysScrollableScrollPhysics(),

      padding:
          const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        25,
      ),

      children: [
        _buildLocationHeader(),

        const SizedBox(height: 24),

        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,

          children: [
            Text(
              nearbyText,
              style: const TextStyle(
                fontSize: 23,
                fontWeight:
                    FontWeight.w800,
                color:
                    Color(0xFF063B5C),
              ),
            ),

            if (places.isNotEmpty)
              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 6,
                ),
                decoration:
                    BoxDecoration(
                  color:
                      const Color(0xFFE2F8F8),
                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                ),
                child: Text(
                  '${places.length}',
                  style:
                      const TextStyle(
                    color:
                        Color(0xFF087E8B),
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 14),

        if (places.isEmpty)
          _buildEmpty()
        else
          ...places.map(
            (place) =>
                _buildPlaceCard(place),
          ),
      ],
    );
  }

  // =========================================================
  // LOCATION HEADER
  // =========================================================

  Widget _buildLocationHeader() {
    return Container(
      padding:
          const EdgeInsets.all(16),

      decoration: BoxDecoration(
        gradient:
            const LinearGradient(
          colors: [
            Color(0xFF063B5C),
            Color(0xFF087E8B),
          ],
        ),

        borderRadius:
            BorderRadius.circular(20),

        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            height: 46,
            width: 46,

            decoration:
                BoxDecoration(
              color:
                  Colors.white.withValues(
                alpha: 0.16,
              ),
              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.my_location_rounded,
              color: Colors.white,
              size: 23,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  locationText,
                  style:
                      const TextStyle(
                    color:
                        Colors.white,
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  'GPS location • Live',
                  style:
                      TextStyle(
                    color:
                        Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.gps_fixed_rounded,
            color:
                Color(0xFFFFD27A),
            size: 21,
          ),
        ],
      ),
    );
  }

  // =========================================================
  // PLACE CARD
  // =========================================================

  Widget _buildPlaceCard(
    Place place,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 16,
      ),

      decoration:
          BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(22),

        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),

      clipBehavior:
          Clip.antiAlias,

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          SizedBox(
            height: 175,
            width: double.infinity,
            child:
                _buildPlaceImage(place),
          ),

          Padding(
            padding:
                const EdgeInsets.fromLTRB(
              16,
              13,
              12,
              14,
            ),

            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      Row(
                        children: [
                          Container(
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 9,
                              vertical: 5,
                            ),

                            decoration:
                                BoxDecoration(
                              color:
                                  const Color(
                                0xFFE2F8F8,
                              ),
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                20,
                              ),
                            ),

                            child: Text(
                              categoryLabel(
                                place.category,
                              ),
                              style:
                                  const TextStyle(
                                color:
                                    Color(
                                  0xFF087E8B,
                                ),
                                fontSize: 10,
                                fontWeight:
                                    FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 7,
                      ),

                      Text(
                        place.name,
                        maxLines: 2,
                        overflow:
                            TextOverflow.ellipsis,
                        style:
                            const TextStyle(
                          color:
                              Color(0xFF063B5C),
                          fontSize: 18,
                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            size: 15,
                            color:
                                Color(0xFF087E8B),
                          ),

                          const SizedBox(
                            width: 3,
                          ),

                          Text(
                            formatDistance(
                              place.distance,
                            ),
                            style:
                                const TextStyle(
                              color:
                                  Colors.black54,
                              fontSize: 12,
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                Container(
                  height: 46,
                  width: 46,

                  decoration:
                      BoxDecoration(
                    color:
                        const Color(
                      0xFFE2F8F8,
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      15,
                    ),
                  ),

                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 17,
                    color:
                        Color(0xFF087E8B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // IMAGE
  // =========================================================

  Widget _buildPlaceImage(
    Place place,
  ) {
    if (place.imageUrl == null ||
        place.imageUrl!.isEmpty) {
      return _buildImagePlaceholder(
        place,
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          place.imageUrl!,
          fit: BoxFit.cover,

          loadingBuilder:
              (
            context,
            child,
            loadingProgress,
          ) {
            if (loadingProgress ==
                null) {
              return child;
            }

            return _buildImagePlaceholder(
              place,
              loading: true,
            );
          },

          errorBuilder:
              (
            context,
            error,
            stackTrace,
          ) {
            return _buildImagePlaceholder(
              place,
            );
          },
        ),

        // Dark bottom gradient
        const DecoratedBox(
          decoration:
              BoxDecoration(
            gradient:
                LinearGradient(
              begin:
                  Alignment.topCenter,
              end:
                  Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black54,
              ],
            ),
          ),
        ),

        Positioned(
          left: 13,
          bottom: 12,
          child: Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),

            decoration:
                BoxDecoration(
              color: Colors.black54,
              borderRadius:
                  BorderRadius.circular(20),
            ),

            child: Row(
              children: [
                const Icon(
                  Icons.photo_camera_outlined,
                  color: Colors.white,
                  size: 14,
                ),
                const SizedBox(width: 5),
                const Text(
                  'Place photo',
                  style:
                      TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),

        Positioned(
          right: 12,
          top: 12,
          child: Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),

            decoration:
                BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(20),
            ),

            child: Text(
              formatDistance(
                place.distance,
              ),
              style:
                  const TextStyle(
                color:
                    Color(0xFF063B5C),
                fontSize: 11,
                fontWeight:
                    FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder(
    Place place, {
    bool loading = false,
  }) {
    return Container(
      decoration:
          const BoxDecoration(
        gradient:
            LinearGradient(
          colors: [
            Color(0xFF063B5C),
            Color(0xFF087E8B),
          ],
          begin:
              Alignment.topLeft,
          end:
              Alignment.bottomRight,
        ),
      ),

      child: Center(
        child: loading
            ? const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              )
            : Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Icon(
                    place.category ==
                            'beach'
                        ? Icons.beach_access_rounded
                        : place.category ==
                                'fort'
                            ? Icons
                                .account_balance_rounded
                            : Icons
                                .travel_explore_rounded,
                    color: Colors.white,
                    size: 45,
                  ),

                  const SizedBox(
                    height: 7,
                  ),

                  Text(
                    place.name,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style:
                        const TextStyle(
                      color:
                          Colors.white,
                      fontSize: 13,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),

                  const SizedBox(
                    height: 3,
                  ),

                  Text(
                    widget.language == 0
                        ? 'फोटो उपलब्ध नाही'
                        : widget.language == 1
                            ? 'फोटो उपलब्ध नहीं'
                            : 'Photo unavailable',
                    style:
                        const TextStyle(
                      color:
                          Colors.white70,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // =========================================================
  // EMPTY
  // =========================================================

  Widget _buildEmpty() {
    return Container(
      padding:
          const EdgeInsets.all(30),

      decoration:
          BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(22),
      ),

      child: Column(
        children: [
          const Icon(
            Icons.location_off_rounded,
            size: 50,
            color:
                Color(0xFF087E8B),
          ),

          const SizedBox(height: 12),

          Text(
            noPlacesText,
            textAlign: TextAlign.center,
            style:
                const TextStyle(
              color:
                  Color(0xFF063B5C),
              fontWeight:
                  FontWeight.w700,
            ),
          ),

          const SizedBox(height: 14),

          ElevatedButton.icon(
            onPressed:
                loadNearbyPlaces,
            icon: const Icon(
              Icons.refresh,
            ),
            label: const Text(
              'Refresh',
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // ERROR
  // =========================================================

  Widget _buildError() {
    return ListView(
      physics:
          const AlwaysScrollableScrollPhysics(),

      padding:
          const EdgeInsets.all(25),

      children: [
        const SizedBox(height: 60),

        const Icon(
          Icons.location_disabled_rounded,
          size: 65,
          color:
              Color(0xFF087E8B),
        ),

        const SizedBox(height: 20),

        Text(
          errorMessage ??
              'Something went wrong.',
          textAlign:
              TextAlign.center,
          style:
              const TextStyle(
            color:
                Color(0xFF063B5C),
            fontSize: 15,
            fontWeight:
                FontWeight.w600,
          ),
        ),

        const SizedBox(height: 20),

        Center(
          child:
              ElevatedButton.icon(
            onPressed:
                loadNearbyPlaces,
            icon: const Icon(
              Icons.refresh,
            ),
            label:
                const Text(
              'Try Again',
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // SKELETON
  // =========================================================

  Widget _buildSkeleton() {
    return Container(
      height: 230,
      margin:
          const EdgeInsets.only(
        bottom: 16,
      ),

      decoration:
          BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(22),
      ),

      child: Column(
        children: [
          Container(
            height: 155,
            decoration:
                BoxDecoration(
              color:
                  Colors.black12,
              borderRadius:
                  BorderRadius.circular(
                22,
              ),
            ),
          ),

          const SizedBox(height: 12),

          Padding(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Row(
              children: [
                Container(
                  height: 15,
                  width: 180,
                  color:
                      Colors.black12,
                ),

                const Spacer(),

                Container(
                  height: 35,
                  width: 35,
                  decoration:
                      const BoxDecoration(
                    color:
                        Colors.black12,
                    shape:
                        BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================
// PLACE MODEL
// =========================================================

class Place {
  final String name;
  final double latitude;
  final double longitude;
  final double distance;
  final String category;
  final String? imageUrl;

  const Place({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.category,
    this.imageUrl,
  });

  Place copyWith({
    String? imageUrl,
  }) {
    return Place(
      name: name,
      latitude: latitude,
      longitude: longitude,
      distance: distance,
      category: category,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
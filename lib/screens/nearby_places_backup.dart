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

  List<Map<String, dynamic>> places = [];

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadNearbyPlaces();
  }

  String get pageTitle {
    if (widget.language == 0) return 'जवळील ठिकाणे';
    if (widget.language == 1) return 'आस-पास की जगहें';
    return 'Nearby Places';
  }

  String get subtitle {
    if (widget.language == 0) {
      return 'तुमच्या सध्याच्या स्थानाजवळील पर्यटनस्थळे';
    }

    if (widget.language == 1) {
      return 'आपके वर्तमान स्थान के पास के पर्यटन स्थल';
    }

    return 'Tourist places near your current location';
  }

  String get loadingText {
    if (widget.language == 0) return 'जवळील ठिकाणे शोधत आहे...';
    if (widget.language == 1) return 'आस-पास की जगहें खोज रहे हैं...';
    return 'Finding nearby places...';
  }

  String get locationText {
    if (widget.language == 0) return 'तुमचे सध्याचे स्थान';
    if (widget.language == 1) return 'आपका वर्तमान स्थान';
    return 'Your current location';
  }

  String get noPlacesText {
    if (widget.language == 0) {
      return 'तुमच्या आसपास पर्यटनस्थळे सापडली नाहीत.';
    }

    if (widget.language == 1) {
      return 'आपके आसपास कोई पर्यटन स्थल नहीं मिला।';
    }

    return 'No tourist places found nearby.';
  }

  String get retryText {
    if (widget.language == 0) return 'पुन्हा प्रयत्न करा';
    if (widget.language == 1) return 'फिर से कोशिश करें';
    return 'Try Again';
  }

  Future<void> _loadNearbyPlaces() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final permission = await Geolocator.checkPermission();

      LocationPermission finalPermission = permission;

      if (permission == LocationPermission.denied) {
        finalPermission = await Geolocator.requestPermission();
      }

      if (finalPermission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }

      if (finalPermission == LocationPermission.deniedForever) {
        throw Exception('Location permission permanently denied');
      }

      final serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        throw Exception('Location service is disabled');
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      currentPosition = position;

      final nearbyPlaces = await _fetchPlaces(
        position.latitude,
        position.longitude,
      );

      if (!mounted) return;

      setState(() {
        places = nearbyPlaces;
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

  Future<List<Map<String, dynamic>>> _fetchPlaces(
    double latitude,
    double longitude,
  ) async {
    const radius = 30000;

    final query = '''
[out:json][timeout:25];

(
  node["tourism"="attraction"](around:$radius,$latitude,$longitude);
  way["tourism"="attraction"](around:$radius,$latitude,$longitude);
  relation["tourism"="attraction"](around:$radius,$latitude,$longitude);

  node["historic"="castle"](around:$radius,$latitude,$longitude);
  way["historic"="castle"](around:$radius,$latitude,$longitude);
  relation["historic"="castle"](around:$radius,$latitude,$longitude);

  node["historic"="fort"](around:$radius,$latitude,$longitude);
  way["historic"="fort"](around:$radius,$latitude,$longitude);
  relation["historic"="fort"](around:$radius,$latitude,$longitude);

  node["natural"="beach"](around:$radius,$latitude,$longitude);
  way["natural"="beach"](around:$radius,$latitude,$longitude);

  node["tourism"="museum"](around:$radius,$latitude,$longitude);
  way["tourism"="museum"](around:$radius,$latitude,$longitude);

  node["tourism"="viewpoint"](around:$radius,$latitude,$longitude);
  way["tourism"="viewpoint"](around:$radius,$latitude,$longitude);
);

out center tags;
''';

    final url = Uri.parse(
      'https://overpass-api.de/api/interpreter',
    );

    final response = await http.post(
      url,
      body: query,
    );

    if (response.statusCode != 200) {
      throw Exception('Unable to load nearby places');
    }

    final data = jsonDecode(response.body);

    final List elements = data['elements'] ?? [];

    final List<Map<String, dynamic>> result = [];

    for (final element in elements) {
      final tags = element['tags'] ?? {};

      String? name = tags['name'];

      if (name == null || name.toString().trim().isEmpty) {
        continue;
      }

      double? placeLat;
      double? placeLon;

      if (element['lat'] != null &&
          element['lon'] != null) {
        placeLat = (element['lat'] as num).toDouble();
        placeLon = (element['lon'] as num).toDouble();
      } else if (element['center'] != null) {
        placeLat =
            (element['center']['lat'] as num).toDouble();
        placeLon =
            (element['center']['lon'] as num).toDouble();
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

      String type = 'Attraction';
      IconData icon = Icons.place;

      if (tags['natural'] == 'beach') {
        type = 'Beach';
        icon = Icons.beach_access;
      } else if (tags['historic'] == 'castle' ||
          tags['historic'] == 'fort') {
        type = 'Fort';
        icon = Icons.castle;
      } else if (tags['tourism'] == 'museum') {
        type = 'Museum';
        icon = Icons.museum;
      } else if (tags['tourism'] == 'viewpoint') {
        type = 'Viewpoint';
        icon = Icons.visibility;
      }

      result.add({
        'name': name.toString(),
        'distance': distance,
        'type': type,
        'icon': icon,
        'lat': placeLat,
        'lon': placeLon,
      });
    }

    result.sort(
      (a, b) =>
          (a['distance'] as double)
              .compareTo(b['distance'] as double),
    );

    final unique = <String>{};
    final filtered = <Map<String, dynamic>>[];

    for (final place in result) {
      final name = place['name'].toString();

      if (unique.add(name.toLowerCase())) {
        filtered.add(place);
      }
    }

    return filtered.take(30).toList();
  }

  String _distanceText(double meters) {
    if (meters < 1000) {
      return '${meters.round()} m';
    }

    return '${(meters / 1000).toStringAsFixed(1)} km';
  }

  String _typeText(String type) {
    if (widget.language == 0) {
      if (type == 'Beach') return 'समुद्रकिनारा';
      if (type == 'Fort') return 'किल्ला';
      if (type == 'Museum') return 'संग्रहालय';
      if (type == 'Viewpoint') return 'दृश्यस्थळ';
      return 'पर्यटनस्थळ';
    }

    if (widget.language == 1) {
      if (type == 'Beach') return 'समुद्र तट';
      if (type == 'Fort') return 'किला';
      if (type == 'Museum') return 'संग्रहालय';
      if (type == 'Viewpoint') return 'दृश्य स्थल';
      return 'पर्यटन स्थल';
    }

    return type;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFC),

      appBar: AppBar(
        backgroundColor: const Color(0xFF063B5C),
        foregroundColor: Colors.white,
        title: Text(
          pageTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _loadNearbyPlaces,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: Color(0xFF087E8B),
            ),
            const SizedBox(height: 18),
            Text(
              loadingText,
              style: const TextStyle(
                color: Color(0xFF063B5C),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_off,
                size: 65,
                color: Color(0xFF087E8B),
              ),
              const SizedBox(height: 15),
              Text(
                errorMessage!.contains('permission')
                    ? 'Location permission is required.'
                    : 'Unable to get your current location.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF063B5C),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _loadNearbyPlaces,
                icon: const Icon(Icons.refresh),
                label: Text(retryText),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadNearbyPlaces,
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          _locationCard(),

          const SizedBox(height: 24),

          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF063B5C),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          if (places.isEmpty)
            _emptyCard()
          else
            ...places.map(
              (place) => _placeCard(place),
            ),
        ],
      ),
    );
  }

  Widget _locationCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF063B5C),
            Color(0xFF087E8B),
          ],
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              color: const Color(0xFFFFD27A),
              borderRadius:
                  BorderRadius.circular(17),
            ),
            child: const Icon(
              Icons.my_location,
              color: Color(0xFF063B5C),
              size: 28,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  locationText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  currentPosition == null
                      ? ''
                      : '${currentPosition!.latitude.toStringAsFixed(4)}, '
                          '${currentPosition!.longitude.toStringAsFixed(4)}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeCard(
    Map<String, dynamic> place,
  ) {
    final distance =
        place['distance'] as double;

    return Card(
      elevation: 3,
      margin:
          const EdgeInsets.only(bottom: 14),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              height: 65,
              width: 65,
              decoration: BoxDecoration(
                color: const Color(0xFFE2F8F8),
                borderRadius:
                    BorderRadius.circular(18),
              ),
              child: Icon(
                place['icon'] as IconData,
                color: const Color(0xFF087E8B),
                size: 32,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    place['name'].toString(),
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF063B5C),
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    _typeText(
                      place['type'].toString(),
                    ),
                    style: const TextStyle(
                      color: Color(0xFF087E8B),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      const Icon(
                        Icons.near_me,
                        size: 15,
                        color: Colors.black45,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _distanceText(distance),
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.black38,
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyCard() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.travel_explore,
            size: 60,
            color: Color(0xFF087E8B),
          ),
          const SizedBox(height: 12),
          Text(
            noPlacesText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF063B5C),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
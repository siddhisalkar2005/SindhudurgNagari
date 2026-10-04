import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String language;

  const HomePage({
    super.key,
    this.language = 'en',
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String selectedLanguage;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedLanguage = widget.language;
  }

  // ============================================================
  // TRANSLATIONS
  // ============================================================

  String t(String en, String mr, String hi) {
    switch (selectedLanguage) {
      case 'mr':
        return mr;
      case 'hi':
        return hi;
      default:
        return en;
    }
  }

  // ============================================================
  // COLORS
  // ============================================================

  static const Color navy = Color(0xFF073B66);
  static const Color blue = Color(0xFF087FC1);
  static const Color lightBlue = Color(0xFFEAF7FF);
  static const Color background = Color(0xFFF7FBFD);
  static const Color textDark = Color(0xFF12324A);
  static const Color textGrey = Color(0xFF71818C);

  // ============================================================
  // TALUKAS
  // ============================================================

  final List<String> talukas = [
    'Malvan',
    'Kudal',
    'Sawantwadi',
    'Vengurla',
    'Kankavli',
    'Devgad',
    'Vaibhavwadi',
    'Dodamarg',
  ];

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      drawer: _buildDrawer(context),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            _buildHome(context),
            _buildMapPage(context),
            _buildFavoritesPage(context),
            _buildProfilePage(context),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  // ============================================================
  // HOME
  // ============================================================

  Widget _buildHome(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: _buildTopBar(context),
        ),

        SliverToBoxAdapter(
          child: _buildMapHero(context),
        ),

        SliverToBoxAdapter(
          child: _buildSearchBar(context),
        ),

        SliverToBoxAdapter(
          child: _buildSectionTitle(
            t('Explore', 'अन्वेषण करा', 'अन्वेषण करें'),
            null,
          ),
        ),

        SliverToBoxAdapter(
          child: _buildMainFeatures(context),
        ),

        SliverToBoxAdapter(
          child: _buildSmartFeatures(context),
        ),

        SliverToBoxAdapter(
          child: _buildQuickLinks(context),
        ),

        SliverToBoxAdapter(
          child: _buildTalukaSection(context),
        ),

        SliverToBoxAdapter(
          child: _buildTopPicks(context),
        ),

        SliverToBoxAdapter(
          child: _buildTripPlannerBanner(context),
        ),

        SliverToBoxAdapter(
          child: _buildPassBanner(context),
        ),

        SliverToBoxAdapter(
          child: _buildFooterSpace(),
        ),
      ],
    );
  }

  // ============================================================
  // TOP BAR
  // ============================================================

  Widget _buildTopBar(BuildContext context) {
    return Container(
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE8EFF3),
          ),
        ),
      ),
      child: Row(
        children: [
          Builder(
            builder: (context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(
                  Icons.menu_rounded,
                  size: 28,
                  color: navy,
                ),
              );
            },
          ),

          const SizedBox(width: 4),

          // Logo
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: lightBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/sindhudurg.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return const Icon(
                    Icons.landscape_rounded,
                    color: blue,
                    size: 25,
                  );
                },
              ),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              'SindhudurgNagri',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: navy,
                letterSpacing: -0.4,
              ),
            ),
          ),

          // Language
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => _showLanguageDialog(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 8,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.language_rounded,
                    color: navy,
                    size: 22,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    selectedLanguage.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: navy,
                    ),
                  ),
                ],
              ),
            ),
          ),

          IconButton(
            onPressed: () {
              _openFeature(
                context,
                'Notifications',
                Icons.notifications_none_rounded,
              );
            },
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: navy,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MAP HERO
  // ============================================================

  Widget _buildMapHero(BuildContext context) {
    return Container(
      height: 300,
      margin: const EdgeInsets.only(bottom: 0),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/sindhudurg_map.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFB9E9F7),
                        Color(0xFFEAF9FD),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                );
              },
            ),
          ),

          // Light overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.08),
                    Colors.white.withOpacity(0.15),
                    Colors.white.withOpacity(0.55),
                  ],
                ),
              ),
            ),
          ),

          // Map pins
          Positioned(
            left: 50,
            top: 70,
            child: _mapPin(
              Icons.castle_rounded,
              Colors.redAccent,
            ),
          ),

          Positioned(
            left: 145,
            top: 125,
            child: _mapPin(
              Icons.temple_hindu_rounded,
              Colors.deepOrange,
            ),
          ),

          Positioned(
            right: 90,
            top: 75,
            child: _mapPin(
              Icons.restaurant_rounded,
              Colors.orange,
            ),
          ),

          Positioned(
            right: 45,
            bottom: 65,
            child: _mapPin(
              Icons.beach_access_rounded,
              Colors.teal,
            ),
          ),

          Positioned(
            left: 100,
            bottom: 65,
            child: _mapPin(
              Icons.location_on_rounded,
              blue,
            ),
          ),

          // Text
          Positioned(
            right: 20,
            top: 35,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  t(
                    'Discover',
                    'शोधा',
                    'खोजें',
                  ),
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w500,
                    color: navy,
                  ),
                ),
                Text(
                  t(
                    'Sindhudurg',
                    'सिंधुदुर्ग',
                    'सिंधुदुर्ग',
                  ),
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: navy,
                  ),
                ),
                Text(
                  t(
                    'on Map',
                    'नकाशावर',
                    'मानचित्र पर',
                  ),
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                    color: navy,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapPin(IconData icon, Color color) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.35),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 23,
      ),
    );
  }

  // ============================================================
  // SEARCH
  // ============================================================

  Widget _buildSearchBar(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -28),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          height: 58,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 18),

              const Icon(
                Icons.search_rounded,
                color: navy,
                size: 28,
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  t(
                    'Search nearby places...',
                    'जवळची ठिकाणे शोधा...',
                    'नजदीकी स्थान खोजें...',
                  ),
                  style: const TextStyle(
                    color: textGrey,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              IconButton(
                onPressed: () {
                  _showSearchDialog(context);
                },
                icon: const Icon(
                  Icons.tune_rounded,
                  color: navy,
                ),
              ),

              const SizedBox(width: 6),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _buildSectionTitle(
    String title,
    VoidCallback? onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        0,
        20,
        14,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: textDark,
              ),
            ),
          ),
          if (onTap != null)
            TextButton(
              onPressed: onTap,
              child: Text(
                t(
                  'View All',
                  'सर्व पहा',
                  'सभी देखें',
                ),
                style: const TextStyle(
                  color: blue,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ============================================================
  // MAIN 6 FEATURES
  // ============================================================

  Widget _buildMainFeatures(BuildContext context) {
    final features = [
      _FeatureData(
        'Nearby Places',
        'जवळची ठिकाणे',
        'नजदीकी स्थान',
        Icons.location_on_rounded,
        const Color(0xFFE9F5FF),
        const Color(0xFF087FC1),
      ),
      _FeatureData(
        'Tourist Places',
        'पर्यटन स्थळे',
        'पर्यटन स्थल',
        Icons.landscape_rounded,
        const Color(0xFFEAF8F0),
        const Color(0xFF219653),
      ),
      _FeatureData(
        'Food Guide',
        'खाद्य मार्गदर्शक',
        'भोजन गाइड',
        Icons.restaurant_rounded,
        const Color(0xFFFFF3E8),
        const Color(0xFFE85D2A),
      ),
      _FeatureData(
        'Stay',
        'निवास',
        'ठहरने की जगह',
        Icons.hotel_rounded,
        const Color(0xFFF0EAFF),
        const Color(0xFF6C36C9),
      ),
      _FeatureData(
        'Transport Info',
        'वाहतूक माहिती',
        'परिवहन जानकारी',
        Icons.directions_bus_rounded,
        const Color(0xFFE7F8F7),
        const Color(0xFF007C83),
      ),
      _FeatureData(
        'Events & Festivals',
        'कार्यक्रम व उत्सव',
        'कार्यक्रम व त्योहार',
        Icons.event_rounded,
        const Color(0xFFFFEAF0),
        const Color(0xFFE52B63),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: features.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.92,
        ),
        itemBuilder: (context, index) {
          final item = features[index];

          return _featureCard(
            context,
            item,
          );
        },
      ),
    );
  }

  Widget _featureCard(
    BuildContext context,
    _FeatureData item,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        _openFeature(
          context,
          t(
            item.en,
            item.mr,
            item.hi,
          ),
          item.icon,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: item.background,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: item.color.withOpacity(0.08),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                item.icon,
                color: item.color,
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              t(item.en, item.mr, item.hi),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: navy,
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SMART FEATURES
  // ============================================================

  Widget _buildSmartFeatures(BuildContext context) {
    final smartFeatures = [
      _SmartFeature(
        'AI Trip Planner',
        'AI ट्रिप प्लॅनर',
        'AI ट्रिप प्लानर',
        Icons.smart_toy_rounded,
      ),
      _SmartFeature(
        'Hidden Places',
        'लपलेली ठिकाणे',
        'छुपे स्थान',
        Icons.explore_rounded,
      ),
      _SmartFeature(
        'Digital Konkan Pass',
        'डिजिटल कोकण पास',
        'डिजिटल कोंकण पास',
        Icons.confirmation_number_rounded,
      ),
      _SmartFeature(
        'Weather',
        'हवामान',
        'मौसम',
        Icons.wb_sunny_rounded,
      ),
      _SmartFeature(
        'Reviews & Ratings',
        'अभिप्राय व रेटिंग',
        'समीक्षा व रेटिंग',
        Icons.star_rounded,
      ),
      _SmartFeature(
        'Map & Navigation',
        'नकाशा व नेव्हिगेशन',
        'मानचित्र व नेविगेशन',
        Icons.navigation_rounded,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        8,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  t(
                    'Smart Travel',
                    'स्मार्ट प्रवास',
                    'स्मार्ट यात्रा',
                  ),
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: textDark,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: smartFeatures.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.05,
            ),
            itemBuilder: (context, index) {
              final item = smartFeatures[index];

              return InkWell(
                borderRadius: BorderRadius.circular(17),
                onTap: () {
                  if (index == 0) {
                    _showTripPlanner(context);
                  } else if (index == 2) {
                    _showDigitalPass(context);
                  } else {
                    _openFeature(
                      context,
                      t(
                        item.en,
                        item.mr,
                        item.hi,
                      ),
                      item.icon,
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF07518D),
                        Color(0xFF0796CF),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(17),
                    boxShadow: [
                      BoxShadow(
                        color: blue.withOpacity(0.18),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Icon(
                        item.icon,
                        color: Colors.white,
                        size: 28,
                      ),
                      const SizedBox(height: 7),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 4,
                        ),
                        child: Text(
                          t(
                            item.en,
                            item.mr,
                            item.hi,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ============================================================
  // QUICK LINKS
  // ============================================================

  Widget _buildQuickLinks(BuildContext context) {
    final links = [
      _QuickLink(
        'Forts',
        'किल्ले',
        'किले',
        Icons.account_balance_rounded,
      ),
      _QuickLink(
        'Beaches',
        'समुद्रकिनारे',
        'समुद्र तट',
        Icons.beach_access_rounded,
      ),
      _QuickLink(
        'Temples',
        'मंदिरे',
        'मंदिर',
        Icons.temple_hindu_rounded,
      ),
      _QuickLink(
        'Culture',
        'संस्कृती',
        'संस्कृति',
        Icons.theater_comedy_rounded,
      ),
      _QuickLink(
        'Food',
        'खाद्यपदार्थ',
        'भोजन',
        Icons.restaurant_rounded,
      ),
    ];

    return Column(
      children: [
        const SizedBox(height: 18),

        _buildSectionTitle(
          t(
            'Quick Links',
            'द्रुत दुवे',
            'त्वरित लिंक',
          ),
          () {},
        ),

        SizedBox(
          height: 145,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: links.length,
            itemBuilder: (context, index) {
              final item = links[index];

              return InkWell(
                borderRadius: BorderRadius.circular(17),
                onTap: () {
                  _openFeature(
                    context,
                    t(
                      item.en,
                      item.mr,
                      item.hi,
                    ),
                    item.icon,
                  );
                },
                child: Container(
                  width: 130,
                  margin: const EdgeInsets.only(
                    right: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(17),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                navy,
                                blue,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius:
                                const BorderRadius.vertical(
                              top: Radius.circular(17),
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              item.icon,
                              size: 42,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          t(
                            item.en,
                            item.mr,
                            item.hi,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: navy,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ============================================================
  // TALUKA SECTION
  // ============================================================

  Widget _buildTalukaSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        24,
        16,
        4,
      ),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: lightBlue,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.location_city_rounded,
                    color: blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    t(
                      'Explore by Taluka',
                      'तालुकानुसार शोधा',
                      'तालुका के अनुसार खोजें',
                    ),
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: textDark,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Text(
              t(
                'Sindhudurg → 8 Talukas → Villages → Tourist Places',
                'सिंधुदुर्ग → ८ तालुके → गावे → पर्यटन स्थळे',
                'सिंधुदुर्ग → ८ तालुके → गाँव → पर्यटन स्थल',
              ),
              style: const TextStyle(
                fontSize: 13,
                color: textGrey,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 14),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: talukas.map((taluka) {
                return InkWell(
                  onTap: () {
                    _showTalukaPlaces(
                      context,
                      taluka,
                    );
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F8FC),
                      borderRadius:
                          BorderRadius.circular(20),
                      border: Border.all(
                        color: blue.withOpacity(0.12),
                      ),
                    ),
                    child: Text(
                      taluka,
                      style: const TextStyle(
                        color: navy,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TOP PICKS
  // ============================================================

  Widget _buildTopPicks(BuildContext context) {
    final places = [
      _PlaceData(
        'Sindhudurg Fort',
        'सिंधुदुर्ग किल्ला',
        'सिंधुदुर्ग किला',
        Icons.account_balance_rounded,
      ),
      _PlaceData(
        'Tarkarli Beach',
        'तारकर्ली समुद्रकिनारा',
        'तारकर्ली समुद्र तट',
        Icons.beach_access_rounded,
      ),
      _PlaceData(
        'Kunkeshwar Temple',
        'कुणकेश्वर मंदिर',
        'कुणकेश्वर मंदिर',
        Icons.temple_hindu_rounded,
      ),
      _PlaceData(
        'Vengurla Beach',
        'वेंगुर्ला समुद्रकिनारा',
        'वेंगुर्ला समुद्र तट',
        Icons.waves_rounded,
      ),
    ];

    return Column(
      children: [
        const SizedBox(height: 24),

        _buildSectionTitle(
          t(
            'Top Picks',
            'लोकप्रिय स्थळे',
            'लोकप्रिय स्थान',
          ),
          () {},
        ),

        SizedBox(
          height: 185,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: places.length,
            itemBuilder: (context, index) {
              final place = places[index];

              return InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () {
                  _showPlaceDetails(
                    context,
                    place,
                  );
                },
                child: Container(
                  width: 205,
                  margin: const EdgeInsets.only(
                    right: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF083F70),
                                Color(0xFF0B92C9),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius:
                                const BorderRadius.vertical(
                              top: Radius.circular(18),
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              place.icon,
                              color: Colors.white,
                              size: 48,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          t(
                            place.en,
                            place.mr,
                            place.hi,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: navy,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ============================================================
  // TRIP PLANNER BANNER
  // ============================================================

  Widget _buildTripPlannerBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        24,
        16,
        0,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => _showTripPlanner(context),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF064C85),
                Color(0xFF0AA0D5),
              ],
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: blue.withOpacity(0.20),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.smart_toy_rounded,
                  color: Colors.white,
                  size: 31,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      t(
                        'Plan Your Perfect Trip',
                        'तुमची परिपूर्ण सहल प्लॅन करा',
                        'अपनी परफेक्ट ट्रिप प्लान करें',
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      t(
                        'AI-powered day-wise itinerary',
                        'AI आधारित दिवसनिहाय प्रवास',
                        'AI आधारित दिन-वार यात्रा',
                      ),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  t(
                    'Plan',
                    'प्लॅन',
                    'प्लान',
                  ),
                  style: const TextStyle(
                    color: navy,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DIGITAL PASS BANNER
  // ============================================================

  Widget _buildPassBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        14,
        16,
        0,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _showDigitalPass(context),
        child: Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFD9EAF2),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4D9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.confirmation_number_rounded,
                  color: Color(0xFFE49A00),
                  size: 29,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      t(
                        'Digital Konkan Pass',
                        'डिजिटल कोकण पास',
                        'डिजिटल कोंकण पास',
                      ),
                      style: const TextStyle(
                        color: navy,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      t(
                        'One pass • Multiple experiences',
                        'एक पास • अनेक अनुभव',
                        'एक पास • अनेक अनुभव',
                      ),
                      style: const TextStyle(
                        color: textGrey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: navy,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooterSpace() {
    return const SizedBox(height: 25);
  }

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: NavigationBar(
        height: 68,
        backgroundColor: Colors.white,
        elevation: 0,
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        indicatorColor: lightBlue,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(
              Icons.home_rounded,
              color: navy,
            ),
            label: t('Home', 'मुख्यपृष्ठ', 'होम'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.map_outlined),
            selectedIcon: const Icon(
              Icons.map_rounded,
              color: navy,
            ),
            label: t('Map', 'नकाशा', 'मानचित्र'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.favorite_border_rounded),
            selectedIcon: const Icon(
              Icons.favorite_rounded,
              color: Colors.redAccent,
            ),
            label: t(
              'Favorites',
              'आवडते',
              'पसंदीदा',
            ),
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline_rounded),
            selectedIcon: const Icon(
              Icons.person_rounded,
              color: navy,
            ),
            label: t(
              'Profile',
              'प्रोफाइल',
              'प्रोफ़ाइल',
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DRAWER
  // ============================================================

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                22,
                30,
                22,
                25,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF064775),
                    Color(0xFF0B9ACD),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(18),
                    ),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(18),
                      child: Image.asset(
                        'assets/images/sindhudurg.png',
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) {
                          return const Icon(
                            Icons.landscape,
                            color: blue,
                            size: 34,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'SindhudurgNagri',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    t(
                      'Discover • Explore • Experience',
                      'शोधा • भटका • अनुभव घ्या',
                      'खोजें • घूमें • अनुभव करें',
                    ),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                children: [
                  _drawerItem(
                    context,
                    Icons.home_rounded,
                    t('Home', 'मुख्यपृष्ठ', 'होम'),
                    () => Navigator.pop(context),
                  ),
                  _drawerItem(
                    context,
                    Icons.smart_toy_rounded,
                    t(
                      'AI Trip Planner',
                      'AI ट्रिप प्लॅनर',
                      'AI ट्रिप प्लानर',
                    ),
                    () {
                      Navigator.pop(context);
                      _showTripPlanner(context);
                    },
                  ),
                  _drawerItem(
                    context,
                    Icons.location_on_rounded,
                    t(
                      'Nearby Places',
                      'जवळची ठिकाणे',
                      'नजदीकी स्थान',
                    ),
                    () {
                      Navigator.pop(context);
                      _openFeature(
                        context,
                        'Nearby Places',
                        Icons.location_on_rounded,
                      );
                    },
                  ),
                  _drawerItem(
                    context,
                    Icons.landscape_rounded,
                    t(
                      'Tourist Places',
                      'पर्यटन स्थळे',
                      'पर्यटन स्थल',
                    ),
                    () {
                      Navigator.pop(context);
                      _openFeature(
                        context,
                        'Tourist Places',
                        Icons.landscape_rounded,
                      );
                    },
                  ),
                  _drawerItem(
                    context,
                    Icons.restaurant_rounded,
                    t(
                      'Food Guide',
                      'खाद्य मार्गदर्शक',
                      'भोजन गाइड',
                    ),
                    () {
                      Navigator.pop(context);
                      _openFeature(
                        context,
                        'Food Guide',
                        Icons.restaurant_rounded,
                      );
                    },
                  ),
                  _drawerItem(
                    context,
                    Icons.wb_sunny_rounded,
                    t(
                      'Weather',
                      'हवामान',
                      'मौसम',
                    ),
                    () {
                      Navigator.pop(context);
                      _openFeature(
                        context,
                        'Weather',
                        Icons.wb_sunny_rounded,
                      );
                    },
                  ),
                  _drawerItem(
                    context,
                    Icons.directions_bus_rounded,
                    t(
                      'Transport Info',
                      'वाहतूक माहिती',
                      'परिवहन जानकारी',
                    ),
                    () {
                      Navigator.pop(context);
                      _openFeature(
                        context,
                        'Transport Info',
                        Icons.directions_bus_rounded,
                      );
                    },
                  ),
                  _drawerItem(
                    context,
                    Icons.event_rounded,
                    t(
                      'Events & Festivals',
                      'कार्यक्रम व उत्सव',
                      'कार्यक्रम व त्योहार',
                    ),
                    () {
                      Navigator.pop(context);
                      _openFeature(
                        context,
                        'Events & Festivals',
                        Icons.event_rounded,
                      );
                    },
                  ),
                  _drawerItem(
                    context,
                    Icons.hotel_rounded,
                    t(
                      'Stay',
                      'निवास',
                      'ठहरने की जगह',
                    ),
                    () {
                      Navigator.pop(context);
                      _openFeature(
                        context,
                        'Stay',
                        Icons.hotel_rounded,
                      );
                    },
                  ),

                  const Divider(),

                  _drawerItem(
                    context,
                    Icons.confirmation_number_rounded,
                    t(
                      'Digital Konkan Pass',
                      'डिजिटल कोकण पास',
                      'डिजिटल कोंकण पास',
                    ),
                    () {
                      Navigator.pop(context);
                      _showDigitalPass(context);
                    },
                  ),

                  _drawerItem(
                    context,
                    Icons.favorite_rounded,
                    t(
                      'Favorites',
                      'आवडते',
                      'पसंदीदा',
                    ),
                    () {
                      Navigator.pop(context);
                      setState(() {
                        _currentIndex = 2;
                      });
                    },
                  ),

                  _drawerItem(
                    context,
                    Icons.notifications_rounded,
                    t(
                      'Notifications',
                      'सूचना',
                      'सूचनाएं',
                    ),
                    () {
                      Navigator.pop(context);
                      _openFeature(
                        context,
                        'Notifications',
                        Icons.notifications_rounded,
                      );
                    },
                  ),

                  _drawerItem(
                    context,
                    Icons.star_rounded,
                    t(
                      'Reviews & Ratings',
                      'अभिप्राय व रेटिंग',
                      'समीक्षा व रेटिंग',
                    ),
                    () {
                      Navigator.pop(context);
                      _openFeature(
                        context,
                        'Reviews & Ratings',
                        Icons.star_rounded,
                      );
                    },
                  ),

                  _drawerItem(
                    context,
                    Icons.help_rounded,
                    t(
                      'Help & Support',
                      'मदत व समर्थन',
                      'मदद व सहायता',
                    ),
                    () {
                      Navigator.pop(context);
                      _openFeature(
                        context,
                        'Help & Support',
                        Icons.help_rounded,
                      );
                    },
                  ),

                  _drawerItem(
                    context,
                    Icons.info_rounded,
                    t(
                      'About Us',
                      'आमच्याबद्दल',
                      'हमारे बारे में',
                    ),
                    () {
                      Navigator.pop(context);
                      _openFeature(
                        context,
                        'About Us',
                        Icons.info_rounded,
                      );
                    },
                  ),

                  _drawerItem(
                    context,
                    Icons.language_rounded,
                    t(
                      'Language',
                      'भाषा',
                      'भाषा',
                    ),
                    () {
                      Navigator.pop(context);
                      _showLanguageDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: navy,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: textDark,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        size: 20,
        color: Colors.grey,
      ),
    );
  }

  // ============================================================
  // MAP PAGE
  // ============================================================

  Widget _buildMapPage(BuildContext context) {
    return Column(
      children: [
        _buildSimplePageHeader(
          t(
            'Map & Navigation',
            'नकाशा व नेव्हिगेशन',
            'मानचित्र व नेविगेशन',
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/sindhudurg_map.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      color: const Color(0xFFDFF3F8),
                      child: const Center(
                        child: Icon(
                          Icons.map_rounded,
                          size: 90,
                          color: blue,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 25,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.15),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.navigation_rounded,
                        color: blue,
                        size: 30,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          t(
                            'Explore Sindhudurg on Map',
                            'नकाशावर सिंधुदुर्ग एक्सप्लोर करा',
                            'मानचित्र पर सिंधुदुर्ग देखें',
                          ),
                          style: const TextStyle(
                            color: navy,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // FAVORITES PAGE
  // ============================================================

  Widget _buildFavoritesPage(BuildContext context) {
    return Column(
      children: [
        _buildSimplePageHeader(
          t(
            'Favorites',
            'आवडते',
            'पसंदीदा',
          ),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.redAccent
                        .withOpacity(0.10),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite_border_rounded,
                    size: 48,
                    color: Colors.redAccent,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  t(
                    'Your favorite places will appear here',
                    'तुमची आवडती ठिकाणे येथे दिसतील',
                    'आपके पसंदीदा स्थान यहां दिखाई देंगे',
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: textDark,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PROFILE PAGE
  // ============================================================

  Widget _buildProfilePage(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSimplePageHeader(
            t(
              'Profile',
              'प्रोफाइल',
              'प्रोफ़ाइल',
            ),
          ),
          const SizedBox(height: 30),
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: lightBlue,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_rounded,
              color: navy,
              size: 55,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            t(
              'Welcome Traveller',
              'स्वागत आहे प्रवासी',
              'स्वागत है यात्री',
            ),
            style: const TextStyle(
              color: navy,
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 25),
          _profileOption(
            Icons.language_rounded,
            t(
              'Language',
              'भाषा',
              'भाषा',
            ),
            () => _showLanguageDialog(context),
          ),
          _profileOption(
            Icons.notifications_rounded,
            t(
              'Notifications',
              'सूचना',
              'सूचनाएं',
            ),
            () {},
          ),
          _profileOption(
            Icons.star_rounded,
            t(
              'Reviews & Ratings',
              'अभिप्राय व रेटिंग',
              'समीक्षा व रेटिंग',
            ),
            () {},
          ),
          _profileOption(
            Icons.help_rounded,
            t(
              'Help & Support',
              'मदत व समर्थन',
              'मदद व सहायता',
            ),
            () {},
          ),
          _profileOption(
            Icons.info_outline_rounded,
            t(
              'About Us',
              'आमच्याबद्दल',
              'हमारे बारे में',
            ),
            () {},
          ),
        ],
      ),
    );
  }

  Widget _profileOption(
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: navy,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: textDark,
            fontWeight: FontWeight.w700,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
        ),
      ),
    );
  }

  Widget _buildSimplePageHeader(String title) {
    return Container(
      height: 68,
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.travel_explore_rounded,
            color: blue,
            size: 28,
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              color: navy,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LANGUAGE DIALOG
  // ============================================================

  void _showLanguageDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                t(
                  'Select Language',
                  'भाषा निवडा',
                  'भाषा चुनें',
                ),
                style: const TextStyle(
                  color: navy,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 18),
              _languageOption(
                context,
                'English',
                'EN',
                'en',
              ),
              _languageOption(
                context,
                'मराठी',
                'MR',
                'mr',
              ),
              _languageOption(
                context,
                'हिंदी',
                'HI',
                'hi',
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _languageOption(
    BuildContext context,
    String title,
    String code,
    String language,
  ) {
    final selected = selectedLanguage == language;

    return ListTile(
      onTap: () {
        setState(() {
          selectedLanguage = language;
        });
        Navigator.pop(context);
      },
      leading: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: selected
              ? lightBlue
              : const Color(0xFFF4F7F9),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Center(
          child: Text(
            code,
            style: const TextStyle(
              color: navy,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),
      trailing: selected
          ? const Icon(
              Icons.check_circle_rounded,
              color: blue,
            )
          : null,
    );
  }

  // ============================================================
  // SEARCH DIALOG
  // ============================================================

  void _showSearchDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            t(
              'Search Sindhudurg',
              'सिंधुदुर्ग शोधा',
              'सिंधुदुर्ग खोजें',
            ),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: t(
                'Place, beach, fort, food...',
                'ठिकाण, समुद्रकिनारा, किल्ला, खाद्य...',
                'स्थान, समुद्र तट, किला, भोजन...',
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
              ),
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(14),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                t('Cancel', 'रद्द करा', 'रद्द करें'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _openFeature(
                  context,
                  controller.text.isEmpty
                      ? 'Search'
                      : controller.text,
                  Icons.search_rounded,
                );
              },
              child: Text(
                t('Search', 'शोधा', 'खोजें'),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // AI TRIP PLANNER
  // ============================================================

  void _showTripPlanner(BuildContext context) {
    String? destination;
    String days = '3';
    String budget = 'Medium';
    final interests = <String>{};

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 22,
                bottom: MediaQuery.of(context)
                        .viewInsets
                        .bottom +
                    20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 45,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius:
                              BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: lightBlue,
                            borderRadius:
                                BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.smart_toy_rounded,
                            color: blue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            t(
                              'AI Trip Planner',
                              'AI ट्रिप प्लॅनर',
                              'AI ट्रिप प्लानर',
                            ),
                            style: const TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w900,
                              color: navy,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Text(
                      t(
                        'Destination / Taluka',
                        'गंतव्य / तालुका',
                        'गंतव्य / तालुका',
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: textDark,
                      ),
                    ),

                    const SizedBox(height: 8),

                    DropdownButtonFormField<String>(
                      value: destination,
                      decoration:
                          InputDecoration(
                        hintText: t(
                          'Select Taluka',
                          'तालुका निवडा',
                          'तालुका चुनें',
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                      ),
                      items: talukas
                          .map(
                            (item) =>
                                DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setModalState(() {
                          destination = value;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    Text(
                      t(
                        'Trip Duration',
                        'सहलीचा कालावधी',
                        'यात्रा की अवधि',
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: textDark,
                      ),
                    ),

                    const SizedBox(height: 8),

                    DropdownButtonFormField<String>(
                      value: days,
                      decoration:
                          InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                      ),
                      items: [
                        '1',
                        '2',
                        '3',
                        '4',
                        '5',
                        '7',
                      ]
                          .map(
                            (item) =>
                                DropdownMenuItem(
                              value: item,
                              child: Text(
                                '$item ${t('Days', 'दिवस', 'दिन')}',
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setModalState(() {
                          days = value ?? '3';
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    Text(
                      t(
                        'Budget',
                        'बजेट',
                        'बजट',
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: textDark,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Wrap(
                      spacing: 8,
                      children: [
                        'Low',
                        'Medium',
                        'High',
                      ].map((item) {
                        final selected =
                            budget == item;

                        return ChoiceChip(
                          label: Text(
                            item == 'Low'
                                ? t(
                                    'Low',
                                    'कमी',
                                    'कम',
                                  )
                                : item == 'Medium'
                                    ? t(
                                        'Medium',
                                        'मध्यम',
                                        'मध्यम',
                                      )
                                    : t(
                                        'High',
                                        'जास्त',
                                        'अधिक',
                                      ),
                          ),
                          selected: selected,
                          onSelected: (_) {
                            setModalState(() {
                              budget = item;
                            });
                          },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      t(
                        'Interests',
                        'आवडी',
                        'रुचियां',
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: textDark,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        'Beach',
                        'Fort',
                        'Temple',
                        'Garden',
                        'Food',
                      ].map((item) {
                        final selected =
                            interests.contains(item);

                        return FilterChip(
                          label: Text(item),
                          selected: selected,
                          onSelected: (_) {
                            setModalState(() {
                              if (selected) {
                                interests.remove(item);
                              } else {
                                interests.add(item);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 22),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);

                          _showItineraryResult(
                            context,
                            destination ??
                                'Sindhudurg',
                            days,
                            budget,
                            interests,
                          );
                        },
                        icon: const Icon(
                          Icons.auto_awesome_rounded,
                        ),
                        label: Text(
                          t(
                            'Generate My Trip',
                            'माझी सहल तयार करा',
                            'मेरी यात्रा बनाएं',
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: navy,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ============================================================
  // ITINERARY RESULT
  // ============================================================

  void _showItineraryResult(
    BuildContext context,
    String destination,
    String days,
    String budget,
    Set<String> interests,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                color: blue,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  t(
                    'Your AI Trip',
                    'तुमची AI सहल',
                    'आपकी AI यात्रा',
                  ),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                _resultRow(
                  'Destination',
                  destination,
                ),
                _resultRow(
                  'Duration',
                  '$days days',
                ),
                _resultRow(
                  'Budget',
                  budget,
                ),
                _resultRow(
                  'Interests',
                  interests.isEmpty
                      ? 'All'
                      : interests.join(', '),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Day-wise itinerary will be generated here using your selected preferences.',
                  style: TextStyle(
                    color: textGrey,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () =>
                  Navigator.pop(context),
              child: Text(
                t(
                  'Done',
                  'पूर्ण',
                  'पूर्ण',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _resultRow(
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            color: textDark,
            fontSize: 14,
          ),
          children: [
            TextSpan(
              text: '$title: ',
              style: const TextStyle(
                fontWeight: FontWeight.w800,
              ),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // DIGITAL KONKAN PASS
  // ============================================================

  void _showDigitalPass(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 20),

              const Icon(
                Icons.confirmation_number_rounded,
                color: Color(0xFFE49A00),
                size: 50,
              ),

              const SizedBox(height: 10),

              Text(
                t(
                  'Digital Konkan Pass',
                  'डिजिटल कोकण पास',
                  'डिजिटल कोंकण पास',
                ),
                style: const TextStyle(
                  color: navy,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 18),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF064775),
                      Color(0xFF0B9ACD),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.qr_code_2_rounded,
                      color: Colors.white,
                      size: 100,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'KONKAN-PASS-2026',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              _passInfo(
                Icons.person_rounded,
                t(
                  'User',
                  'वापरकर्ता',
                  'उपयोगकर्ता',
                ),
                'Traveller',
              ),

              _passInfo(
                Icons.confirmation_number_rounded,
                'Pass ID',
                'KNP-2026-001',
              ),

              _passInfo(
                Icons.calendar_month_rounded,
                t(
                  'Validity',
                  'वैधता',
                  'वैधता',
                ),
                '30 Days',
              ),

              _passInfo(
                Icons.location_on_rounded,
                t(
                  'Included Locations',
                  'समाविष्ट स्थळे',
                  'शामिल स्थान',
                ),
                'Selected Tourist Locations',
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: navy,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    t(
                      'Generate Pass',
                      'पास तयार करा',
                      'पास बनाएं',
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _passInfo(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(
            icon,
            color: blue,
            size: 20,
          ),
          const SizedBox(width: 10),
          Text(
            '$title: ',
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: textDark,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: textGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TALUKA PLACES
  // ============================================================

  void _showTalukaPlaces(
    BuildContext context,
    String taluka,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        final categories = [
          (
            'Hidden Places',
            Icons.explore_rounded,
          ),
          (
            'Beaches',
            Icons.beach_access_rounded,
          ),
          (
            'Temples',
            Icons.temple_hindu_rounded,
          ),
          (
            'Forts',
            Icons.account_balance_rounded,
          ),
          (
            'Gardens',
            Icons.park_rounded,
          ),
        ];

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                taluka,
                style: const TextStyle(
                  color: navy,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                t(
                  'Explore places in $taluka',
                  '$taluka मधील स्थळे शोधा',
                  '$taluka के स्थान खोजें',
                ),
                style: const TextStyle(
                  color: textGrey,
                ),
              ),
              const SizedBox(height: 18),
              ...categories.map(
                (category) => ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    _openFeature(
                      context,
                      '$taluka - ${category.$1}',
                      category.$2,
                    );
                  },
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: lightBlue,
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                    child: Icon(
                      category.$2,
                      color: blue,
                    ),
                  ),
                  title: Text(
                    category.$1,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // PLACE DETAILS
  // ============================================================

  void _showPlaceDetails(
    BuildContext context,
    _PlaceData place,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF064775),
                      Color(0xFF0B9ACD),
                    ],
                  ),
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: Icon(
                  place.icon,
                  color: Colors.white,
                  size: 70,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                t(
                  place.en,
                  place.mr,
                  place.hi,
                ),
                style: const TextStyle(
                  color: navy,
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              const Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star_rounded,
                    color: Colors.amber,
                  ),
                  Text(
                    ' 4.8',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '  •  Sindhudurg',
                    style: TextStyle(
                      color: textGrey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                t(
                  'Explore this beautiful destination and discover its history, culture and natural beauty.',
                  'या सुंदर ठिकाणाचा इतिहास, संस्कृती आणि नैसर्गिक सौंदर्याचा अनुभव घ्या.',
                  'इस खूबसूरत स्थान के इतिहास, संस्कृति और प्राकृतिक सुंदरता का अनुभव करें।',
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: textGrey,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      _currentIndex = 1;
                    });
                  },
                  icon: const Icon(
                    Icons.navigation_rounded,
                  ),
                  label: Text(
                    t(
                      'View on Map',
                      'नकाशावर पहा',
                      'मानचित्र पर देखें',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: navy,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // GENERIC FEATURE
  // ============================================================

  void _openFeature(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FeaturePlaceholderPage(
          title: title,
          icon: icon,
          language: selectedLanguage,
        ),
      ),
    );
  }
}

// =================================================================
// DATA CLASSES
// =================================================================

class _FeatureData {
  final String en;
  final String mr;
  final String hi;
  final IconData icon;
  final Color background;
  final Color color;

  _FeatureData(
    this.en,
    this.mr,
    this.hi,
    this.icon,
    this.background,
    this.color,
  );
}

class _SmartFeature {
  final String en;
  final String mr;
  final String hi;
  final IconData icon;

  _SmartFeature(
    this.en,
    this.mr,
    this.hi,
    this.icon,
  );
}

class _QuickLink {
  final String en;
  final String mr;
  final String hi;
  final IconData icon;

  _QuickLink(
    this.en,
    this.mr,
    this.hi,
    this.icon,
  );
}

class _PlaceData {
  final String en;
  final String mr;
  final String hi;
  final IconData icon;

  _PlaceData(
    this.en,
    this.mr,
    this.hi,
    this.icon,
  );
}

// =================================================================
// FEATURE PLACEHOLDER
// =================================================================

class FeaturePlaceholderPage extends StatelessWidget {
  final String title;
  final IconData icon;
  final String language;

  const FeaturePlaceholderPage({
    super.key,
    required this.title,
    required this.icon,
    required this.language,
  });

  String t(String en, String mr, String hi) {
    switch (language) {
      case 'mr':
        return mr;
      case 'hi':
        return hi;
      default:
        return en;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF073B66),
        elevation: 0,
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF7FF),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 50,
                  color: const Color(0xFF087FC1),
                ),
              ),
              const SizedBox(height: 22),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF073B66),
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                t(
                  'This feature page is ready to be connected with Firebase/API data.',
                  'हे फीचर पेज Firebase/API डेटाशी जोडण्यासाठी तयार आहे.',
                  'यह फीचर पेज Firebase/API डेटा से जोड़ने के लिए तैयार है।',
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF71818C),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton.icon(
                onPressed: () =>
                    Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_rounded,
                ),
                label: Text(
                  t(
                    'Back',
                    'मागे',
                    'वापस',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF073B66),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
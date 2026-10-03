import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final int language;

  const HomePage({
    super.key,
    this.language = 2,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int selectedLanguage;

  @override
  void initState() {
    super.initState();
    selectedLanguage = widget.language;
  }

  // ============================================================
  // LANGUAGE
  // 0 = Marathi
  // 1 = Hindi
  // 2 = English
  // ============================================================

  String text(String marathi, String hindi, String english) {
    if (selectedLanguage == 0) return marathi;
    if (selectedLanguage == 1) return hindi;
    return english;
  }

  // ============================================================
  // LANGUAGE SELECTOR
  // ============================================================

  void showLanguageDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text(
            'Select Language',
            style: TextStyle(
              color: Color(0xFF063B5C),
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _languageOption(
                dialogContext,
                0,
                'मराठी',
                '🇮🇳',
              ),
              _languageOption(
                dialogContext,
                1,
                'हिंदी',
                '🇮🇳',
              ),
              _languageOption(
                dialogContext,
                2,
                'English',
                '🇬🇧',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _languageOption(
    BuildContext dialogContext,
    int language,
    String name,
    String flag,
  ) {
    final bool selected = selectedLanguage == language;

    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      leading: Text(
        flag,
        style: const TextStyle(fontSize: 23),
      ),
      title: Text(
        name,
        style: TextStyle(
          fontWeight:
              selected ? FontWeight.w800 : FontWeight.w500,
          color: selected
              ? const Color(0xFF087E8B)
              : const Color(0xFF333333),
        ),
      ),
      trailing: selected
          ? const Icon(
              Icons.check_circle,
              color: Color(0xFF087E8B),
            )
          : null,
      onTap: () {
        setState(() {
          selectedLanguage = language;
        });

        Navigator.pop(dialogContext);
      },
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFC),

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: const Color(0xFF063B5C),
        foregroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () {},
        ),

        title: const Text(
          'SindhudurgNagri',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 19,
          ),
        ),

        centerTitle: true,

        actions: [
          IconButton(
            icon: const Icon(Icons.language_rounded),
            onPressed: showLanguageDialog,
          ),

          IconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
            ),
            onPressed: () {},
          ),
        ],
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),

        child: Column(
          children: [

            // ==================================================
            // HERO SECTION
            // ==================================================

            Container(
              width: double.infinity,

              padding: const EdgeInsets.fromLTRB(
                20,
                25,
                20,
                30,
              ),

              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF063B5C),
                    Color(0xFF087E8B),
                  ],
                ),

                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(
                    text(
                      'सिंधुदुर्गचा शोध घ्या',
                      'सिंधुदुर्ग की खोज करें',
                      'Discover Sindhudurg',
                    ),

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    text(
                      'निसर्ग • इतिहास • संस्कृती',
                      'प्रकृति • इतिहास • संस्कृति',
                      'Nature • History • Culture',
                    ),

                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // SEARCH
                  Container(
                    height: 52,

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(17),
                    ),

                    child: TextField(
                      decoration: InputDecoration(
                        hintText: text(
                          'ठिकाणे, खाद्यपदार्थ शोधा...',
                          'जगह, भोजन खोजें...',
                          'Search places, food...',
                        ),

                        hintStyle:
                            const TextStyle(
                          color: Colors.grey,
                        ),

                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: Color(0xFF087E8B),
                        ),

                        border: InputBorder.none,

                        contentPadding:
                            const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ==================================================
            // EXPLORE
            // ==================================================

            Padding(
              padding: const EdgeInsets.fromLTRB(
                18,
                25,
                18,
                0,
              ),

              child: Align(
                alignment: Alignment.centerLeft,

                child: Text(
                  text(
                    'एक्सप्लोर करा',
                    'एक्सप्लोर करें',
                    'Explore',
                  ),

                  style: const TextStyle(
                    color: Color(0xFF063B5C),
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // ==================================================
            // BASIC FEATURES
            // ==================================================

            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 14,
              ),

              child: GridView.count(
                crossAxisCount: 3,

                shrinkWrap: true,

                physics:
                    const NeverScrollableScrollPhysics(),

                mainAxisSpacing: 12,
                crossAxisSpacing: 12,

                childAspectRatio: 0.95,

                children: [

                  _featureCard(
                    Icons.location_on_rounded,
                    text(
                      'जवळील ठिकाणे',
                      'आस-पास',
                      'Nearby',
                    ),
                  ),

                  _featureCard(
                    Icons.account_balance_rounded,
                    text(
                      'पर्यटनस्थळे',
                      'पर्यटन स्थल',
                      'Tourist Places',
                    ),
                  ),

                  _featureCard(
                    Icons.restaurant_rounded,
                    text(
                      'खाद्य',
                      'भोजन',
                      'Food',
                    ),
                  ),

                  _featureCard(
                    Icons.hotel_rounded,
                    text(
                      'राहण्याची सोय',
                      'ठहरने की जगह',
                      'Stay',
                    ),
                  ),

                  _featureCard(
                    Icons.directions_bus_rounded,
                    text(
                      'वाहतूक',
                      'परिवहन',
                      'Transport',
                    ),
                  ),

                  _featureCard(
                    Icons.event_rounded,
                    text(
                      'कार्यक्रम',
                      'कार्यक्रम',
                      'Events',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ==================================================
            // SPECIAL FEATURES
            // ==================================================

            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 14,
              ),

              child: Row(
                children: [

                  Expanded(
                    child: _specialFeature(
                      Icons.smart_toy_rounded,
                      text(
                        'AI Trip\nPlanner',
                        'AI Trip\nPlanner',
                        'AI Trip\nPlanner',
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: _specialFeature(
                      Icons.map_rounded,
                      text(
                        'Hidden\nPlaces',
                        'Hidden\nPlaces',
                        'Hidden\nPlaces',
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: _specialFeature(
                      Icons.confirmation_number_rounded,
                      text(
                        'Konkan\nPass',
                        'Konkan\nPass',
                        'Konkan\nPass',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ==================================================
            // TOP PICKS
            // ==================================================

            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 18,
              ),

              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                children: [

                  Text(
                    text(
                      'लोकप्रिय ठिकाणे',
                      'लोकप्रिय जगहें',
                      'Top Picks',
                    ),

                    style: const TextStyle(
                      color: Color(0xFF063B5C),
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  TextButton(
                    onPressed: () {},

                    child: Text(
                      text(
                        'सर्व पहा',
                        'सभी देखें',
                        'View All',
                      ),

                      style: const TextStyle(
                        color: Color(0xFF087E8B),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ==================================================
            // PLACE CARDS
            // ==================================================

            SizedBox(
              height: 190,

              child: ListView(
                scrollDirection:
                    Axis.horizontal,

                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 16,
                ),

                children: [

                  _placeCard(
                    text(
                      'सिंधुदुर्ग किल्ला',
                      'सिंधुदुर्ग किला',
                      'Sindhudurg Fort',
                    ),
                    Icons.account_balance_rounded,
                  ),

                  _placeCard(
                    text(
                      'तारकर्ली बीच',
                      'तारकर्ली बीच',
                      'Tarkarli Beach',
                    ),
                    Icons.beach_access_rounded,
                  ),

                  _placeCard(
                    text(
                      'कुणकेश्वर मंदिर',
                      'कुणकेश्वर मंदिर',
                      'Kunkeshwar Temple',
                    ),
                    Icons.temple_hindu_rounded,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ==================================================
            // AI TRIP PLANNER BANNER
            // ==================================================

            Container(
              margin:
                  const EdgeInsets.symmetric(
                horizontal: 16,
              ),

              padding:
                  const EdgeInsets.all(20),

              decoration: BoxDecoration(
                gradient:
                    const LinearGradient(
                  colors: [
                    Color(0xFF063B5C),
                    Color(0xFF087E8B),
                  ],
                ),

                borderRadius:
                    BorderRadius.circular(24),

                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),

              child: Row(
                children: [

                  Container(
                    width: 58,
                    height: 58,

                    decoration:
                        BoxDecoration(
                      color:
                          Colors.white.withOpacity(
                        0.15,
                      ),
                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.smart_toy_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        Text(
                          text(
                            'तुमची परिपूर्ण ट्रिप प्लॅन करा',
                            'अपनी परफेक्ट ट्रिप प्लान करें',
                            'Plan Your Perfect Trip',
                          ),

                          style:
                              const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight:
                                FontWeight.w800,
                          ),
                        ),

                        const SizedBox(height: 10),

                        SizedBox(
                          height: 42,

                          child:
                              ElevatedButton(
                            onPressed: () {},

                            style:
                                ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.white,

                              foregroundColor:
                                  const Color(
                                0xFF063B5C,
                              ),

                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius
                                        .circular(14),
                              ),
                            ),

                            child: Text(
                              text(
                                'माझी ट्रिप प्लॅन करा',
                                'मेरी ट्रिप प्लान करें',
                                'Plan My Trip',
                              ),

                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),

      // ========================================================
      // BOTTOM NAVIGATION
      // ========================================================

      bottomNavigationBar:
          NavigationBar(
        backgroundColor: Colors.white,

        selectedIndex: 0,

        destinations: [

          NavigationDestination(
            icon: const Icon(
              Icons.home_outlined,
            ),

            selectedIcon: const Icon(
              Icons.home_rounded,
            ),

            label: text(
              'होम',
              'होम',
              'Home',
            ),
          ),

          NavigationDestination(
            icon: const Icon(
              Icons.map_outlined,
            ),

            selectedIcon: const Icon(
              Icons.map_rounded,
            ),

            label: text(
              'नकाशा',
              'मानचित्र',
              'Map',
            ),
          ),

          NavigationDestination(
            icon: const Icon(
              Icons.favorite_outline_rounded,
            ),

            selectedIcon: const Icon(
              Icons.favorite_rounded,
            ),

            label: text(
              'आवडते',
              'पसंदीदा',
              'Favorites',
            ),
          ),

          NavigationDestination(
            icon: const Icon(
              Icons.person_outline_rounded,
            ),

            selectedIcon: const Icon(
              Icons.person_rounded,
            ),

            label: text(
              'प्रोफाइल',
              'प्रोफाइल',
              'Profile',
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FEATURE CARD
  // ============================================================

  Widget _featureCard(
    IconData icon,
    String title,
  ) {
    return Card(
      elevation: 2,

      color: Colors.white,

      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(18),
      ),

      child: InkWell(
        borderRadius:
            BorderRadius.circular(18),

        onTap: () {},

        child: Padding(
          padding:
              const EdgeInsets.all(8),

          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [

              Container(
                width: 46,
                height: 46,

                decoration:
                    const BoxDecoration(
                  color: Color(0xFFE2F7F8),
                  shape: BoxShape.circle,
                ),

                child: Icon(
                  icon,
                  color:
                      const Color(0xFF087E8B),
                  size: 25,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                title,

                textAlign:
                    TextAlign.center,

                maxLines: 2,

                overflow:
                    TextOverflow.ellipsis,

                style:
                    const TextStyle(
                  color:
                      Color(0xFF063B5C),
                  fontSize: 12.5,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SPECIAL FEATURE
  // ============================================================

  Widget _specialFeature(
    IconData icon,
    String title,
  ) {
    return InkWell(
      onTap: () {},

      borderRadius:
          BorderRadius.circular(18),

      child: Container(
        height: 95,

        padding:
            const EdgeInsets.all(8),

        decoration:
            BoxDecoration(
          gradient:
              const LinearGradient(
            colors: [
              Color(0xFF087E8B),
              Color(0xFF20C7D2),
            ],
          ),

          borderRadius:
              BorderRadius.circular(18),

          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            Icon(
              icon,
              color: Colors.white,
              size: 29,
            ),

            const SizedBox(height: 7),

            Text(
              title,

              textAlign:
                  TextAlign.center,

              style:
                  const TextStyle(
                color: Colors.white,
                fontSize: 11.5,
                fontWeight:
                    FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PLACE CARD
  // ============================================================

  Widget _placeCard(
    String name,
    IconData icon,
  ) {
    return Container(
      width: 155,

      margin:
          const EdgeInsets.only(
        right: 12,
      ),

      decoration:
          BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),

        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Container(
            height: 115,

            decoration:
                const BoxDecoration(
              gradient:
                  LinearGradient(
                colors: [
                  Color(0xFF063B5C),
                  Color(0xFF087E8B),
                ],
              ),

              borderRadius:
                  BorderRadius.only(
                topLeft:
                    Radius.circular(20),
                topRight:
                    Radius.circular(20),
              ),
            ),

            child: Center(
              child: Icon(
                icon,
                color: Colors.white,
                size: 55,
              ),
            ),
          ),

          Padding(
            padding:
                const EdgeInsets.all(10),

            child: Text(
              name,

              maxLines: 1,

              overflow:
                  TextOverflow.ellipsis,

              style:
                  const TextStyle(
                color:
                    Color(0xFF063B5C),
                fontWeight:
                    FontWeight.w800,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
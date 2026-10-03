import 'package:flutter/material.dart';
import 'nearby_places.dart';

class HomePage extends StatelessWidget {
  final int language;

  const HomePage({
    super.key,
    this.language = 2,
  });

  String get title {
    if (language == 0) {
      return 'सिंधुदुर्गनगरी 🌊';
    } else if (language == 1) {
      return 'सिंधुदुर्गनगरी 🌊';
    } else {
      return 'SindhudurgNagri 🌊';
    }
  }

  String get welcome {
    if (language == 0) {
      return 'सिंधुदुर्गमध्ये स्वागत आहे 👋';
    } else if (language == 1) {
      return 'सिंधुदुर्ग में आपका स्वागत है 👋';
    } else {
      return 'Welcome to Sindhudurg 👋';
    }
  }

  String get exploreTitle {
    if (language == 0) {
      return 'सिंधुदुर्ग एक्सप्लोर करा';
    } else if (language == 1) {
      return 'सिंधुदुर्ग एक्सप्लोर करें';
    } else {
      return 'Explore Sindhudurg';
    }
  }

  String get nearbyPlaces {
    if (language == 0) {
      return 'जवळील ठिकाणे';
    } else if (language == 1) {
      return 'आस-पास की जगहें';
    } else {
      return 'Nearby Places';
    }
  }

  String get weather {
    if (language == 0) {
      return 'हवामान';
    } else if (language == 1) {
      return 'मौसम';
    } else {
      return 'Weather';
    }
  }

  String get food {
    if (language == 0) {
      return 'स्थानिक खाद्य';
    } else if (language == 1) {
      return 'स्थानीय भोजन';
    } else {
      return 'Local Food';
    }
  }

  String get stay {
    if (language == 0) {
      return 'राहण्याची सोय';
    } else if (language == 1) {
      return 'ठहरने की जगह';
    } else {
      return 'Stay';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFC),

      appBar: AppBar(
        backgroundColor: const Color(0xFF063B5C),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF063B5C),
                    Color(0xFF087E8B),
                  ],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    welcome,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    language == 0
                        ? 'समुद्रकिनारे, किल्ले, खाद्यसंस्कृती आणि सुंदर ठिकाणे शोधा.'
                        : language == 1
                            ? 'समुद्र तट, किले, स्थानीय भोजन और खूबसूरत जगहें खोजें।'
                            : 'Discover beaches, forts, food and beautiful places.',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Text(
              exploreTitle,
              style: const TextStyle(
                color: Color(0xFF063B5C),
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            // NEARBY PLACES
            _buildCard(
              context,
              Icons.location_on,
              nearbyPlaces,
              true,
            ),

            // WEATHER
            _buildCard(
              context,
              Icons.wb_sunny,
              weather,
              false,
            ),

            // FOOD
            _buildCard(
              context,
              Icons.restaurant,
              food,
              false,
            ),

            // STAY
            _buildCard(
              context,
              Icons.hotel,
              stay,
              false,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        backgroundColor: Colors.white,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: language == 0
                ? 'होम'
                : language == 1
                    ? 'होम'
                    : 'Home',
          ),
          NavigationDestination(
            icon: const Icon(Icons.explore_outlined),
            selectedIcon: const Icon(Icons.explore),
            label: language == 0
                ? 'एक्सप्लोर'
                : language == 1
                    ? 'खोजें'
                    : 'Explore',
          ),
          NavigationDestination(
            icon: const Icon(Icons.favorite_outline),
            selectedIcon: const Icon(Icons.favorite),
            label: language == 0
                ? 'आवडते'
                : language == 1
                    ? 'पसंदीदा'
                    : 'Favorites',
          ),
          NavigationDestination(
            icon: const Icon(Icons.info_outline),
            selectedIcon: const Icon(Icons.info),
            label: language == 0
                ? 'माहिती'
                : language == 1
                    ? 'जानकारी'
                    : 'About',
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    IconData icon,
    String text,
    bool isNearby,
  ) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),

        leading: CircleAvatar(
          radius: 27,
          backgroundColor: const Color(0xFFE2F8F8),
          child: Icon(
            icon,
            color: const Color(0xFF087E8B),
          ),
        ),

        title: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF063B5C),
            fontSize: 17,
          ),
        ),

        subtitle: isNearby
            ? Text(
                language == 0
                    ? 'तुमच्या जवळील पर्यटनस्थळे शोधा'
                    : language == 1
                        ? 'अपने आस-पास के पर्यटन स्थल खोजें'
                        : 'Find real places near you',
              )
            : null,

        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),

        // ⭐ ACTUAL NEARBY PLACES SCREEN
        onTap: isNearby
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NearbyPlaces(
                      language: language,
                    ),
                  ),
                );
              }
            : null,
      ),
    );
  }
}
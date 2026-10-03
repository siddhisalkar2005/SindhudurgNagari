import 'dart:async';

import 'package:flutter/material.dart';
import 'language_selection.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int currentPage = 0;

  final PageController _pageController = PageController();

  final List<Map<String, String>> pages = [
    {
      'title': 'Discover Sindhudurg',
      'subtitle':
          'Explore the beauty, history and hidden treasures of Sindhudurg.',
    },
    {
      'title': 'Explore Your Way',
      'subtitle':
          'Find beaches, forts, food, stays and amazing experiences.',
    },
    {
      'title': 'Travel Smarter',
      'subtitle':
          'Get useful recommendations based on your location and weather.',
    },
  ];

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(
      const Duration(seconds: 4),
      (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (currentPage < pages.length - 1) {
          currentPage++;

          _pageController.animateToPage(
            currentPage,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
        } else {
          timer.cancel();
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // ============================================================
  // OPEN LANGUAGE SELECTION
  // ============================================================

  void openLanguageScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LanguageSelectionPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [

          // ======================================================
          // ONE FULL SCREEN IMAGE
          // ======================================================

          Image.asset(
            'assets/images/sindhudurg.png',
            fit: BoxFit.cover,

            errorBuilder: (context, error, stackTrace) {
              return Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF0A7890),
                      Color(0xFF063B5C),
                    ],
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.landscape_rounded,
                    color: Colors.white70,
                    size: 100,
                  ),
                ),
              );
            },
          ),

          // ======================================================
          // DARK OVERLAY
          // ======================================================

          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black54,
                  Colors.transparent,
                  Colors.black87,
                ],
                stops: [
                  0.0,
                  0.48,
                  1.0,
                ],
              ),
            ),
          ),

          // ======================================================
          // MAIN CONTENT
          // ======================================================

          SafeArea(
            child: Column(
              children: [

                // ==================================================
                // TOP BRANDING
                // ==================================================

                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    22,
                    18,
                    22,
                    10,
                  ),

                  child: Row(
                    children: [

                      // LOGO
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF20C7D2),
                              Color(0xFF087DC1),
                            ],
                          ),
                          borderRadius:
                              BorderRadius.circular(17),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 12,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.castle_rounded,
                              color: Colors.white,
                              size: 25,
                            ),
                            Icon(
                              Icons.waves_rounded,
                              color: Colors.white,
                              size: 13,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 13),

                      // APP NAME
                      const Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SindhudurgNagri',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.3,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'YOUR SINDHUDURG TRAVEL COMPANION',
                            style: TextStyle(
                              color: Color(0xFFB9F4F2),
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ==================================================
                // LOCATION CHIP
                // ==================================================

                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: 22,
                      top: 12,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.35),
                      borderRadius:
                          BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white24,
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          color: Color(0xFFFFD27A),
                          size: 17,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Sindhudurg, Maharashtra',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ==================================================
                // SLIDING CONTENT
                // ==================================================

                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: pages.length,

                    onPageChanged: (index) {
                      setState(() {
                        currentPage = index;
                      });
                    },

                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                        ),
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.end,
                          children: [

                            // TITLE
                            Text(
                              pages[index]['title']!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 31,
                                fontWeight: FontWeight.w800,
                                height: 1.15,
                                shadows: [
                                  Shadow(
                                    color: Colors.black54,
                                    blurRadius: 8,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 12),

                            // SUBTITLE
                            Text(
                              pages[index]['subtitle']!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14.5,
                                height: 1.5,
                                fontWeight: FontWeight.w500,
                                shadows: [
                                  Shadow(
                                    color: Colors.black54,
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // ==================================================
                // PAGE INDICATORS
                // ==================================================

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: List.generate(
                    pages.length,
                    (index) {
                      return AnimatedContainer(
                        duration:
                            const Duration(milliseconds: 300),
                        margin:
                            const EdgeInsets.symmetric(
                          horizontal: 4,
                        ),
                        height: 6,
                        width: currentPage == index
                            ? 28
                            : 7,
                        decoration: BoxDecoration(
                          color: currentPage == index
                              ? const Color(0xFF35D5D7)
                              : Colors.white54,
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 18),

                // ==================================================
                // BEGIN YOUR JOURNEY BUTTON
                // ==================================================

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 58,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFF087DC1),
                          Color(0xFF20C7D2),
                        ],
                      ),
                      borderRadius:
                          BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.30),
                          blurRadius: 15,
                          offset: const Offset(0, 7),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: openLanguageScreen,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.transparent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Text(
                            'Begin Your Journey',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // ==================================================
                // FOOTER
                // ==================================================

                const Text(
                  'Discover  •  Explore  •  Experience',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.4,
                  ),
                ),

                const SizedBox(height: 15),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
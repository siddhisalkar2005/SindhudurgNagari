import 'package:flutter/material.dart';
import 'login_page.dart';

class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({super.key});

  @override
  State<LanguageSelectionPage> createState() =>
      _LanguageSelectionPageState();
}

class _LanguageSelectionPageState
    extends State<LanguageSelectionPage> {
  int selectedLanguage = -1;

  final List<Map<String, dynamic>> languages = [
    {
      'title': 'मराठी',
      'subtitle': 'तुमच्या भाषेत सिंधुदुर्ग अनुभवूया',
      'icon': Icons.translate_rounded,
    },
    {
      'title': 'हिन्दी',
      'subtitle': 'अपनी भाषा में सिंधुदुर्ग खोजें',
      'icon': Icons.language_rounded,
    },
    {
      'title': 'English',
      'subtitle': 'Explore Sindhudurg with ease',
      'icon': Icons.public_rounded,
    },
  ];

  // ============================================================
  // LANGUAGE SELECT
  // ============================================================

  void selectLanguage(int index) {
    setState(() {
      selectedLanguage = index;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(
          language: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FA),

      body: SafeArea(
        child: Column(
          children: [

            // ====================================================
            // HEADER
            // ====================================================

            Container(
              width: double.infinity,

              padding: const EdgeInsets.fromLTRB(
                24,
                28,
                24,
                32,
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
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  // APP NAME
                  Row(
                    children: [

                      Container(
                        height: 50,
                        width: 50,

                        decoration: BoxDecoration(
                          gradient:
                              const LinearGradient(
                            colors: [
                              Color(0xFF20C7D2),
                              Color(0xFF087DC1),
                            ],
                          ),

                          borderRadius:
                              BorderRadius.circular(16),
                        ),

                        child: const Icon(
                          Icons.castle_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),

                      const SizedBox(width: 12),

                      const Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          Text(
                            'SindhudurgNagri',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight:
                                  FontWeight.w800,
                            ),
                          ),

                          SizedBox(height: 3),

                          Text(
                            'YOUR SINDHUDURG TRAVEL COMPANION',
                            style: TextStyle(
                              color: Color(0xFFB9F4F2),
                              fontSize: 8,
                              fontWeight:
                                  FontWeight.w700,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // TITLE
                  const Text(
                    'Choose your language',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 29,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Explore Sindhudurg in the language you are most comfortable with.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            // ====================================================
            // LANGUAGE CARDS
            // ====================================================

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  25,
                  20,
                  10,
                ),

                itemCount: languages.length,

                itemBuilder: (context, index) {
                  final language = languages[index];

                  final bool isSelected =
                      selectedLanguage == index;

                  return GestureDetector(
                    onTap: () {
                      selectLanguage(index);
                    },

                    child: AnimatedContainer(
                      duration:
                          const Duration(milliseconds: 250),

                      margin: const EdgeInsets.only(
                        bottom: 16,
                      ),

                      padding: const EdgeInsets.all(18),

                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFDDF7F7)
                            : Colors.white,

                        borderRadius:
                            BorderRadius.circular(22),

                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF087E8B)
                              : Colors.transparent,
                          width: 2,
                        ),

                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withOpacity(0.08),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),

                      child: Row(
                        children: [

                          // ==================================================
                          // ICON
                          // ==================================================

                          AnimatedContainer(
                            duration:
                                const Duration(
                              milliseconds: 250,
                            ),

                            height: 58,
                            width: 58,

                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF087E8B)
                                  : const Color(0xFFEAF6F7),

                              borderRadius:
                                  BorderRadius.circular(17),
                            ),

                            child: Icon(
                              language['icon']
                                  as IconData,

                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF087E8B),

                              size: 28,
                            ),
                          ),

                          const SizedBox(width: 16),

                          // ==================================================
                          // TEXT
                          // ==================================================

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,

                              children: [

                                Text(
                                  language['title']
                                      as String,

                                  style: const TextStyle(
                                    color:
                                        Color(0xFF063B5C),
                                    fontSize: 20,
                                    fontWeight:
                                        FontWeight.w800,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  language['subtitle']
                                      as String,

                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12.5,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // ==================================================
                          // SELECT / NEXT
                          // ==================================================

                          AnimatedSwitcher(
                            duration:
                                const Duration(
                              milliseconds: 200,
                            ),

                            child: isSelected
                                ? const CircleAvatar(
                                    key: ValueKey(
                                      'selected',
                                    ),

                                    radius: 18,

                                    backgroundColor:
                                        Color(0xFF087E8B),

                                    child: Icon(
                                      Icons.check_rounded,
                                      color: Colors.white,
                                      size: 21,
                                    ),
                                  )
                                : const Icon(
                                    key: ValueKey('next'),
                                    Icons
                                        .arrow_forward_ios_rounded,
                                    size: 16,
                                    color: Colors.black26,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // ====================================================
            // BOTTOM MESSAGE
            // ====================================================

            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                5,
                20,
                22,
              ),

              child: Column(
                children: [

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,

                    children: [

                      const Icon(
                        Icons.explore_rounded,
                        color: Color(0xFF087E8B),
                        size: 18,
                      ),

                      const SizedBox(width: 7),

                      Text(
                        selectedLanguage == -1
                            ? 'Your journey starts here'
                            : 'Great choice! Let’s explore Sindhudurg',

                        style: const TextStyle(
                          color: Color(0xFF063B5C),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 9),

                  const Text(
                    'You can change your language later',
                    style: TextStyle(
                      color: Colors.black38,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
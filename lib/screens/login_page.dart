import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  /// 0 = Marathi
  /// 1 = Hindi
  /// 2 = English
  final int language;

  const LoginPage({
    super.key,
    this.language = 2,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // ============================================================
  // CONTROLLERS
  // ============================================================

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  bool passwordVisible = false;
  bool isLoading = false;

  // ============================================================
  // LANGUAGE CODE
  // ============================================================

  /// Converts LoginPage language integer
  /// into HomePage language String.
  ///
  /// 0 -> mr
  /// 1 -> hi
  /// 2 -> en
  String get languageCode {
    switch (widget.language) {
      case 0:
        return 'mr';

      case 1:
        return 'hi';

      default:
        return 'en';
    }
  }

  // ============================================================
  // TRANSLATION HELPER
  // ============================================================

  String tr(
    String english,
    String marathi,
    String hindi,
  ) {
    switch (widget.language) {
      case 0:
        return marathi;

      case 1:
        return hindi;

      default:
        return english;
    }
  }

  // ============================================================
  // TEXTS
  // ============================================================

  String get welcome => tr(
        'Welcome Back',
        'पुन्हा स्वागत आहे',
        'वापसी पर स्वागत है',
      );

  String get subtitle => tr(
        'Continue your journey with SindhudurgNagri',
        'SindhudurgNagri सोबत तुमचा प्रवास सुरू ठेवा',
        'SindhudurgNagri के साथ अपनी यात्रा जारी रखें',
      );

  String get emailLabel => tr(
        'Email',
        'ईमेल',
        'ईमेल',
      );

  String get emailHint => tr(
        'Enter your email',
        'तुमचा ईमेल टाका',
        'अपना ईमेल दर्ज करें',
      );

  String get passwordLabel => tr(
        'Password',
        'पासवर्ड',
        'पासवर्ड',
      );

  String get passwordHint => tr(
        'Enter your password',
        'तुमचा पासवर्ड टाका',
        'अपना पासवर्ड दर्ज करें',
      );

  String get forgotPasswordText => tr(
        'Forgot Password?',
        'पासवर्ड विसरलात?',
        'पासवर्ड भूल गए?',
      );

  String get loginText => tr(
        'Login',
        'लॉगिन',
        'लॉगिन',
      );

  String get createAccountText => tr(
        'Create New Account',
        'नवीन खाते तयार करा',
        'नया खाता बनाएं',
      );

  String get emailRequired => tr(
        'Please enter your email',
        'कृपया ईमेल टाका',
        'कृपया ईमेल दर्ज करें',
      );

  String get invalidEmail => tr(
        'Please enter a valid email',
        'कृपया योग्य ईमेल टाका',
        'कृपया सही ईमेल दर्ज करें',
      );

  String get passwordRequired => tr(
        'Please enter your password',
        'कृपया पासवर्ड टाका',
        'कृपया पासवर्ड दर्ज करें',
      );

  String get passwordLength => tr(
        'Password must be at least 6 characters',
        'पासवर्ड किमान 6 अक्षरांचा असावा',
        'पासवर्ड कम से कम 6 अक्षरों का होना चाहिए',
      );

  // ============================================================
  // SNACKBAR
  // ============================================================

  void showMessage(
    String message, {
    bool success = false,
  }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor:
              success ? Colors.green : Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  // ============================================================
  // LOGIN
  // ============================================================

  Future<void> loginUser() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      showMessage(
        tr(
          'Login successful',
          'लॉगिन यशस्वी झाले',
          'लॉगिन सफल हुआ',
        ),
        success: true,
      );

      await Future.delayed(
        const Duration(milliseconds: 500),
      );

      if (!mounted) return;

      // ========================================================
      // IMPORTANT:
      // LoginPage uses int language.
      // HomePage receives String language.
      // ========================================================

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomePage(
            language: languageCode,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      String message;

      switch (e.code) {
        case 'user-not-found':
          message = tr(
            'No account found with this email',
            'या ईमेलसाठी खाते सापडले नाही',
            'इस ईमेल के लिए कोई खाता नहीं मिला',
          );
          break;

        case 'wrong-password':
        case 'invalid-credential':
          message = tr(
            'Invalid email or password',
            'ईमेल किंवा पासवर्ड चुकीचा आहे',
            'ईमेल या पासवर्ड गलत है',
          );
          break;

        case 'invalid-email':
          message = invalidEmail;
          break;

        case 'user-disabled':
          message = tr(
            'This account has been disabled',
            'हे खाते बंद केले आहे',
            'यह खाता बंद कर दिया गया है',
          );
          break;

        case 'too-many-requests':
          message = tr(
            'Too many attempts. Please try again later.',
            'खूप प्रयत्न झाले. कृपया नंतर पुन्हा प्रयत्न करा.',
            'बहुत अधिक प्रयास हुए। कृपया बाद में पुनः प्रयास करें।',
          );
          break;

        case 'network-request-failed':
          message = tr(
            'Please check your internet connection',
            'कृपया इंटरनेट कनेक्शन तपासा',
            'कृपया अपना इंटरनेट कनेक्शन जांचें',
          );
          break;

        default:
          message = tr(
            'Login failed. Please try again.',
            'लॉगिन करण्यात समस्या आली. पुन्हा प्रयत्न करा.',
            'लॉगिन में समस्या हुई। कृपया पुनः प्रयास करें।',
          );
      }

      showMessage(message);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      showMessage(
        tr(
          'Something went wrong',
          'काहीतरी चुकीचे झाले',
          'कुछ गलत हो गया',
        ),
      );
    }
  }

  // ============================================================
  // CREATE ACCOUNT
  // ============================================================

  Future<void> createNewAccount() async {
    final TextEditingController email =
        TextEditingController();

    final TextEditingController password =
        TextEditingController();

    bool dialogPasswordVisible = false;
    bool creatingAccount = false;

    try {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (
              dialogContext,
              setDialogState,
            ) {
              return AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(26),
                ),

                // ==================================================
                // TITLE
                // ==================================================

                title: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        gradient:
                            const LinearGradient(
                          colors: [
                            Color(0xFF087DC1),
                            Color(0xFF20C7D2),
                          ],
                        ),
                        borderRadius:
                            BorderRadius.circular(13),
                      ),
                      child: const Icon(
                        Icons.person_add_alt_1_rounded,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        createAccountText,
                        style: const TextStyle(
                          color: Color(0xFF124A78),
                          fontWeight: FontWeight.w800,
                          fontSize: 19,
                        ),
                      ),
                    ),
                  ],
                ),

                // ==================================================
                // CONTENT
                // ==================================================

                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 8),

                      // EMAIL
                      TextField(
                        controller: email,
                        keyboardType:
                            TextInputType.emailAddress,
                        decoration:
                            InputDecoration(
                          hintText: emailHint,
                          prefixIcon:
                              const Icon(
                            Icons.email_outlined,
                            color:
                                Color(0xFF159ED2),
                          ),
                          filled: true,
                          fillColor:
                              const Color(0xFFF1F9FC),
                          border:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(
                              15,
                            ),
                            borderSide:
                                BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // PASSWORD
                      TextField(
                        controller: password,
                        obscureText:
                            !dialogPasswordVisible,
                        decoration:
                            InputDecoration(
                          hintText: tr(
                            'Create password',
                            'पासवर्ड तयार करा',
                            'पासवर्ड बनाएं',
                          ),
                          prefixIcon:
                              const Icon(
                            Icons.lock_outline,
                            color:
                                Color(0xFF159ED2),
                          ),
                          suffixIcon:
                              IconButton(
                            onPressed: () {
                              setDialogState(() {
                                dialogPasswordVisible =
                                    !dialogPasswordVisible;
                              });
                            },
                            icon: Icon(
                              dialogPasswordVisible
                                  ? Icons
                                      .visibility_outlined
                                  : Icons
                                      .visibility_off_outlined,
                              color:
                                  const Color(0xFF159ED2),
                            ),
                          ),
                          filled: true,
                          fillColor:
                              const Color(0xFFF1F9FC),
                          border:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(
                              15,
                            ),
                            borderSide:
                                BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Align(
                        alignment:
                            Alignment.centerLeft,
                        child: Text(
                          passwordLength,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ==================================================
                // ACTIONS
                // ==================================================

                actions: [
                  TextButton(
                    onPressed: creatingAccount
                        ? null
                        : () {
                            Navigator.pop(
                              dialogContext,
                            );
                          },
                    child: Text(
                      tr(
                        'Cancel',
                        'रद्द करा',
                        'रद्द करें',
                      ),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: creatingAccount
                        ? null
                        : () async {
                            final emailText =
                                email.text.trim();

                            final passwordText =
                                password.text.trim();

                            // ------------------------------
                            // VALIDATION
                            // ------------------------------

                            if (emailText.isEmpty) {
                              showMessage(
                                emailRequired,
                              );
                              return;
                            }

                            if (!RegExp(
                              r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                            ).hasMatch(
                              emailText,
                            )) {
                              showMessage(
                                invalidEmail,
                              );
                              return;
                            }

                            if (passwordText.length <
                                6) {
                              showMessage(
                                passwordLength,
                              );
                              return;
                            }

                            setDialogState(() {
                              creatingAccount = true;
                            });

                            try {
                              // ----------------------------
                              // FIREBASE CREATE ACCOUNT
                              // ----------------------------

                              await FirebaseAuth
                                  .instance
                                  .createUserWithEmailAndPassword(
                                email: emailText,
                                password:
                                    passwordText,
                              );

                              if (!mounted) return;

                              Navigator.pop(
                                dialogContext,
                              );

                              showMessage(
                                tr(
                                  'Account created successfully',
                                  'खाते यशस्वीपणे तयार झाले',
                                  'खाता सफलतापूर्वक बनाया गया',
                                ),
                                success: true,
                              );

                              await Future.delayed(
                                const Duration(
                                  milliseconds: 500,
                                ),
                              );

                              if (!mounted) return;

                              // Firebase automatically
                              // signs in the new user.

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      HomePage(
                                    language:
                                        languageCode,
                                  ),
                                ),
                              );
                            } on FirebaseAuthException catch (e) {
                              if (!mounted) return;

                              setDialogState(() {
                                creatingAccount =
                                    false;
                              });

                              String message;

                              switch (e.code) {
                                case 'email-already-in-use':
                                  message = tr(
                                    'An account already exists with this email',
                                    'या ईमेलवर खाते आधीच आहे',
                                    'इस ईमेल से खाता पहले से मौजूद है',
                                  );
                                  break;

                                case 'invalid-email':
                                  message =
                                      invalidEmail;
                                  break;

                                case 'weak-password':
                                  message = tr(
                                    'Password is too weak',
                                    'पासवर्ड खूप कमजोर आहे',
                                    'पासवर्ड बहुत कमजोर है',
                                  );
                                  break;

                                case 'network-request-failed':
                                  message = tr(
                                    'Please check your internet connection',
                                    'कृपया इंटरनेट कनेक्शन तपासा',
                                    'कृपया अपना इंटरनेट कनेक्शन जांचें',
                                  );
                                  break;

                                default:
                                  message = tr(
                                    'Could not create account',
                                    'खाते तयार करता आले नाही',
                                    'खाता नहीं बनाया जा सका',
                                  );
                              }

                              showMessage(
                                message,
                              );
                            }
                          },
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF159ED2),
                      foregroundColor:
                          Colors.white,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                    ),
                    child: creatingAccount
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<
                                      Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            tr(
                              'Create Account',
                              'खाते तयार करा',
                              'खाता बनाएं',
                            ),
                          ),
                  ),
                ],
              );
            },
          );
        },
      );
    } finally {
      email.dispose();
      password.dispose();
    }
  }

  // ============================================================
  // FORGOT PASSWORD
  // ============================================================

  Future<void> forgotPassword() async {
    final TextEditingController email =
        TextEditingController();

    bool sending = false;

    try {
      await showDialog(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (
              dialogContext,
              setDialogState,
            ) {
              return AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(25),
                ),

                title: Text(
                  tr(
                    'Forgot Password?',
                    'पासवर्ड विसरलात?',
                    'पासवर्ड भूल गए?',
                  ),
                  style: const TextStyle(
                    color: Color(0xFF124A78),
                    fontWeight: FontWeight.w800,
                  ),
                ),

                content: TextField(
                  controller: email,
                  keyboardType:
                      TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: emailHint,
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: Color(0xFF159ED2),
                    ),
                    filled: true,
                    fillColor:
                        const Color(0xFFF1F9FC),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                actions: [
                  TextButton(
                    onPressed: sending
                        ? null
                        : () {
                            Navigator.pop(
                              dialogContext,
                            );
                          },
                    child: Text(
                      tr(
                        'Cancel',
                        'रद्द करा',
                        'रद्द करें',
                      ),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: sending
                        ? null
                        : () async {
                            final emailText =
                                email.text.trim();

                            if (emailText.isEmpty) {
                              showMessage(
                                emailRequired,
                              );
                              return;
                            }

                            if (!RegExp(
                              r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                            ).hasMatch(
                              emailText,
                            )) {
                              showMessage(
                                invalidEmail,
                              );
                              return;
                            }

                            setDialogState(() {
                              sending = true;
                            });

                            try {
                              await FirebaseAuth
                                  .instance
                                  .sendPasswordResetEmail(
                                email: emailText,
                              );

                              if (!mounted) return;

                              Navigator.pop(
                                dialogContext,
                              );

                              showMessage(
                                tr(
                                  'Password reset email sent',
                                  'पासवर्ड रीसेट ईमेल पाठवला',
                                  'पासवर्ड रीसेट ईमेल भेजा गया',
                                ),
                                success: true,
                              );
                            } on FirebaseAuthException catch (e) {
                              if (!mounted) return;

                              setDialogState(() {
                                sending = false;
                              });

                              String message;

                              switch (e.code) {
                                case 'user-not-found':
                                  message = tr(
                                    'No account found with this email',
                                    'या ईमेलसाठी खाते सापडले नाही',
                                    'इस ईमेल के लिए कोई खाता नहीं मिला',
                                  );
                                  break;

                                case 'invalid-email':
                                  message =
                                      invalidEmail;
                                  break;

                                default:
                                  message = tr(
                                    'Could not send password reset email',
                                    'पासवर्ड रीसेट ईमेल पाठवता आले नाही',
                                    'पासवर्ड रीसेट ईमेल नहीं भेजा जा सका',
                                  );
                              }

                              showMessage(
                                message,
                              );
                            }
                          },
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF159ED2),
                      foregroundColor:
                          Colors.white,
                    ),
                    child: sending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<
                                      Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            tr(
                              'Send',
                              'पाठवा',
                              'भेजें',
                            ),
                          ),
                  ),
                ],
              );
            },
          );
        },
      );
    } finally {
      email.dispose();
    }
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ======================================================
          // BACKGROUND
          // ======================================================

          Container(
            decoration:
                const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF063B5C),
                  Color(0xFF087E8B),
                  Color(0xFF20C7D2),
                ],
              ),
            ),
          ),

          // ======================================================
          // DECORATIVE CIRCLE 1
          // ======================================================

          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    Colors.white.withOpacity(0.08),
              ),
            ),
          ),

          // ======================================================
          // DECORATIVE CIRCLE 2
          // ======================================================

          Positioned(
            bottom: -100,
            left: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    Colors.white.withOpacity(0.07),
              ),
            ),
          ),

          // ======================================================
          // WAVE
          // ======================================================

          Positioned(
            top: 60,
            right: 25,
            child: Icon(
              Icons.waves_rounded,
              size: 70,
              color:
                  Colors.white.withOpacity(0.15),
            ),
          ),

          // ======================================================
          // MAIN CONTENT
          // ======================================================

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics:
                    const BouncingScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 25,
                ),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(34),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 12,
                      sigmaY: 12,
                    ),
                    child: Container(
                      constraints:
                          const BoxConstraints(
                        maxWidth: 520,
                      ),
                      padding:
                          const EdgeInsets.fromLTRB(
                        28,
                        28,
                        28,
                        25,
                      ),
                      decoration:
                          BoxDecoration(
                        color: Colors.white
                            .withOpacity(0.94),
                        borderRadius:
                            BorderRadius.circular(34),
                        border: Border.all(
                          color: Colors.white
                              .withOpacity(0.8),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(0.22),
                            blurRadius: 35,
                            offset:
                                const Offset(0, 18),
                          ),
                        ],
                      ),

                      // ==================================================
                      // FORM
                      // ==================================================

                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // ============================================
                            // LOGO
                            // ============================================

                            Container(
                              width: 88,
                              height: 88,
                              decoration:
                                  BoxDecoration(
                                gradient:
                                    const LinearGradient(
                                  begin:
                                      Alignment.topLeft,
                                  end: Alignment
                                      .bottomRight,
                                  colors: [
                                    Color(
                                        0xFF087DC1),
                                    Color(
                                        0xFF20C7D2),
                                  ],
                                ),
                                borderRadius:
                                    BorderRadius
                                        .circular(27),
                              ),
                              child: const Column(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,
                                children: [
                                  Icon(
                                    Icons
                                        .castle_rounded,
                                    color:
                                        Colors.white,
                                    size: 38,
                                  ),
                                  Icon(
                                    Icons
                                        .waves_rounded,
                                    color:
                                        Colors.white,
                                    size: 21,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(
                              height: 14,
                            ),

                            // ============================================
                            // APP NAME
                            // ============================================

                            RichText(
                              text:
                                  const TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        'Sindhudurg',
                                    style:
                                        TextStyle(
                                      color: Color(
                                          0xFF124A78),
                                      fontSize: 26,
                                      fontWeight:
                                          FontWeight
                                              .w900,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Nagri',
                                    style:
                                        TextStyle(
                                      color: Color(
                                          0xFF12A8CF),
                                      fontSize: 26,
                                      fontWeight:
                                          FontWeight
                                              .w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(
                              height: 5,
                            ),

                            Text(
                              tr(
                                'Explore • Discover • Experience',
                                'अन्वेषण • शोध • अनुभव',
                                'अन्वेषण • खोज • अनुभव',
                              ),
                              style:
                                  const TextStyle(
                                color:
                                    Color(0xFF669DB4),
                                fontSize: 12,
                                fontWeight:
                                    FontWeight.w600,
                                letterSpacing: 0.8,
                              ),
                            ),

                            const SizedBox(
                              height: 25,
                            ),

                            // ============================================
                            // PERSON ICON
                            // ============================================

                            Container(
                              width: 68,
                              height: 68,
                              decoration:
                                  BoxDecoration(
                                shape:
                                    BoxShape.circle,
                                color:
                                    const Color(
                                  0xFFE0F5FB,
                                ),
                                border:
                                    Border.all(
                                  color:
                                      const Color(
                                    0xFFBFE9F4,
                                  ),
                                ),
                              ),
                              child: const Icon(
                                Icons
                                    .person_rounded,
                                color:
                                    Color(0xFF159ED2),
                                size: 38,
                              ),
                            ),

                            const SizedBox(
                              height: 15,
                            ),

                            // ============================================
                            // WELCOME
                            // ============================================

                            Text(
                              welcome,
                              textAlign:
                                  TextAlign.center,
                              style:
                                  const TextStyle(
                                color:
                                    Color(0xFF124A78),
                                fontSize: 30,
                                fontWeight:
                                    FontWeight.w900,
                              ),
                            ),

                            const SizedBox(
                              height: 7,
                            ),

                            Text(
                              subtitle,
                              textAlign:
                                  TextAlign.center,
                              style:
                                  const TextStyle(
                                color:
                                    Color(0xFF7798A6),
                                fontSize: 13.5,
                                height: 1.5,
                              ),
                            ),

                            const SizedBox(
                              height: 28,
                            ),

                            // ============================================
                            // EMAIL LABEL
                            // ============================================

                            Align(
                              alignment:
                                  Alignment.centerLeft,
                              child: Text(
                                emailLabel,
                                style:
                                    const TextStyle(
                                  color: Color(
                                      0xFF174A8B),
                                  fontSize: 15,
                                  fontWeight:
                                      FontWeight.w800,
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 9,
                            ),

                            // ============================================
                            // EMAIL FIELD
                            // ============================================

                            TextFormField(
                              controller:
                                  emailController,
                              keyboardType:
                                  TextInputType
                                      .emailAddress,
                              textInputAction:
                                  TextInputAction
                                      .next,
                              validator:
                                  (value) {
                                if (value ==
                                        null ||
                                    value
                                        .trim()
                                        .isEmpty) {
                                  return emailRequired;
                                }

                                if (!RegExp(
                                  r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                ).hasMatch(
                                  value.trim(),
                                )) {
                                  return invalidEmail;
                                }

                                return null;
                              },
                              decoration:
                                  InputDecoration(
                                hintText:
                                    emailHint,
                                prefixIcon:
                                    const Icon(
                                  Icons
                                      .email_outlined,
                                  color: Color(
                                      0xFF20A9D3),
                                ),
                                filled: true,
                                fillColor:
                                    const Color(
                                        0xFFF8FCFE),
                                contentPadding:
                                    const EdgeInsets
                                        .symmetric(
                                  vertical: 18,
                                  horizontal: 15,
                                ),
                                border:
                                    OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius
                                          .circular(18),
                                  borderSide:
                                      const BorderSide(
                                    color: Color(
                                        0xFFD5E4EA),
                                  ),
                                ),
                                enabledBorder:
                                    OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius
                                          .circular(18),
                                  borderSide:
                                      const BorderSide(
                                    color: Color(
                                        0xFFD5E4EA),
                                  ),
                                ),
                                focusedBorder:
                                    OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius
                                          .circular(18),
                                  borderSide:
                                      const BorderSide(
                                    color: Color(
                                        0xFF20A9D3),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 20,
                            ),

                            // ============================================
                            // PASSWORD LABEL
                            // ============================================

                            Align(
                              alignment:
                                  Alignment.centerLeft,
                              child: Text(
                                passwordLabel,
                                style:
                                    const TextStyle(
                                  color: Color(
                                      0xFF174A8B),
                                  fontSize: 15,
                                  fontWeight:
                                      FontWeight.w800,
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 9,
                            ),

                            // ============================================
                            // PASSWORD FIELD
                            // ============================================

                            TextFormField(
                              controller:
                                  passwordController,
                              obscureText:
                                  !passwordVisible,
                              textInputAction:
                                  TextInputAction.done,
                              onFieldSubmitted:
                                  (_) {
                                if (!isLoading) {
                                  loginUser();
                                }
                              },
                              validator:
                                  (value) {
                                if (value ==
                                        null ||
                                    value.isEmpty) {
                                  return passwordRequired;
                                }

                                if (value.length <
                                    6) {
                                  return passwordLength;
                                }

                                return null;
                              },
                              decoration:
                                  InputDecoration(
                                hintText:
                                    passwordHint,
                                prefixIcon:
                                    const Icon(
                                  Icons
                                      .lock_outline_rounded,
                                  color: Color(
                                      0xFF20A9D3),
                                ),
                                suffixIcon:
                                    IconButton(
                                  onPressed: () {
                                    setState(() {
                                      passwordVisible =
                                          !passwordVisible;
                                    });
                                  },
                                  icon: Icon(
                                    passwordVisible
                                        ? Icons
                                            .visibility_outlined
                                        : Icons
                                            .visibility_off_outlined,
                                    color: const Color(
                                        0xFF20A9D3),
                                  ),
                                ),
                                filled: true,
                                fillColor:
                                    const Color(
                                        0xFFF8FCFE),
                                contentPadding:
                                    const EdgeInsets
                                        .symmetric(
                                  vertical: 18,
                                  horizontal: 15,
                                ),
                                border:
                                    OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius
                                          .circular(18),
                                  borderSide:
                                      const BorderSide(
                                    color: Color(
                                        0xFFD5E4EA),
                                  ),
                                ),
                                enabledBorder:
                                    OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius
                                          .circular(18),
                                  borderSide:
                                      const BorderSide(
                                    color: Color(
                                        0xFFD5E4EA),
                                  ),
                                ),
                                focusedBorder:
                                    OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius
                                          .circular(18),
                                  borderSide:
                                      const BorderSide(
                                    color: Color(
                                        0xFF20A9D3),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),

                            // ============================================
                            // FORGOT PASSWORD
                            // ============================================

                            Align(
                              alignment:
                                  Alignment.centerRight,
                              child: TextButton(
                                onPressed:
                                    isLoading
                                        ? null
                                        : forgotPassword,
                                child: Text(
                                  forgotPasswordText,
                                  style:
                                      const TextStyle(
                                    color: Color(
                                        0xFF159ED2),
                                    fontWeight:
                                        FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 8,
                            ),

                            // ============================================
                            // LOGIN BUTTON
                            // ============================================

                            Container(
                              width:
                                  double.infinity,
                              height: 58,
                              decoration:
                                  BoxDecoration(
                                gradient:
                                    const LinearGradient(
                                  colors: [
                                    Color(
                                        0xFF087DC1),
                                    Color(
                                        0xFF20C7D2),
                                  ],
                                ),
                                borderRadius:
                                    BorderRadius
                                        .circular(19),
                              ),
                              child:
                                  ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : loginUser,
                                style:
                                    ElevatedButton
                                        .styleFrom(
                                  backgroundColor:
                                      Colors
                                          .transparent,
                                  disabledBackgroundColor:
                                      Colors
                                          .transparent,
                                  foregroundColor:
                                      Colors.white,
                                  elevation: 0,
                                  shadowColor:
                                      Colors
                                          .transparent,
                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      19,
                                    ),
                                  ),
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        width: 25,
                                        height: 25,
                                        child:
                                            CircularProgressIndicator(
                                          strokeWidth:
                                              2.5,
                                          valueColor:
                                              AlwaysStoppedAnimation<
                                                  Color>(
                                            Colors
                                                .white,
                                          ),
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                        children: [
                                          Text(
                                            loginText,
                                            style:
                                                const TextStyle(
                                              fontSize:
                                                  17,
                                              fontWeight:
                                                  FontWeight
                                                      .w800,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 12,
                                          ),
                                          const Icon(
                                            Icons
                                                .arrow_forward_rounded,
                                            size: 23,
                                          ),
                                        ],
                                      ),
                              ),
                            ),

                            const SizedBox(
                              height: 23,
                            ),

                            // ============================================
                            // CREATE ACCOUNT
                            // ============================================

                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color:
                                        const Color(
                                      0xFFD0E5EC,
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding:
                                      const EdgeInsets
                                          .symmetric(
                                    horizontal: 10,
                                  ),
                                  child: TextButton(
                                    onPressed:
                                        isLoading
                                            ? null
                                            : createNewAccount,
                                    child: Text(
                                      createAccountText,
                                      style:
                                          const TextStyle(
                                        color: Color(
                                            0xFF159ED2),
                                        fontSize: 14.5,
                                        fontWeight:
                                            FontWeight
                                                .w800,
                                      ),
                                    ),
                                  ),
                                ),

                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color:
                                        const Color(
                                      0xFFD0E5EC,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 5,
                            ),

                            // ============================================
                            // FOOTER
                            // ============================================

                            Text(
                              tr(
                                'Your Sindhudurg journey starts here',
                                'तुमचा सिंधुदुर्ग प्रवास येथे सुरू होतो',
                                'आपकी सिंधुदुर्ग यात्रा यहाँ से शुरू होती है',
                              ),
                              textAlign:
                                  TextAlign.center,
                              style:
                                  const TextStyle(
                                color:
                                    Color(0xFF91AAB5),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
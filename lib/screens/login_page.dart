import 'dart:ui';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final int language;

  const LoginPage({
    super.key,
    this.language = 2,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool passwordVisible = false;

  // ============================================================
  // LANGUAGE
  // ============================================================

  String get welcome {
    if (widget.language == 0) return "पुन्हा स्वागत आहे";
    if (widget.language == 1) return "वापसी पर स्वागत है";
    return "Welcome Back";
  }

  String get subtitle {
    if (widget.language == 0) {
      return "SindhudurgNagri सोबत तुमचा प्रवास सुरू ठेवा";
    }

    if (widget.language == 1) {
      return "SindhudurgNagri के साथ अपनी यात्रा जारी रखें";
    }

    return "Continue your journey with SindhudurgNagri";
  }

  String get emailLabel {
    if (widget.language == 0) return "ईमेल किंवा मोबाईल नंबर";
    if (widget.language == 1) return "ईमेल या मोबाइल नंबर";
    return "Email or Mobile Number";
  }

  String get emailHint {
    if (widget.language == 0) {
      return "ईमेल किंवा मोबाईल नंबर टाका";
    }

    if (widget.language == 1) {
      return "अपना ईमेल या मोबाइल नंबर दर्ज करें";
    }

    return "Enter email or mobile number";
  }

  String get passwordLabel {
    if (widget.language == 0) return "पासवर्ड";
    if (widget.language == 1) return "पासवर्ड";
    return "Password";
  }

  String get passwordHint {
    if (widget.language == 0) return "तुमचा पासवर्ड टाका";
    if (widget.language == 1) return "अपना पासवर्ड दर्ज करें";
    return "Enter your password";
  }

  String get forgot {
    if (widget.language == 0) return "पासवर्ड विसरलात?";
    if (widget.language == 1) return "पासवर्ड भूल गए?";
    return "Forgot Password?";
  }

  String get login {
    if (widget.language == 0) return "लॉगिन";
    if (widget.language == 1) return "लॉगिन";
    return "Login";
  }

  String get createAccount {
    if (widget.language == 0) return "नवीन खाते तयार करा";
    if (widget.language == 1) return "नया खाता बनाएं";
    return "Create New Account";
  }

  String get emailError {
    if (widget.language == 0) {
      return "कृपया ईमेल किंवा मोबाईल नंबर टाका";
    }

    if (widget.language == 1) {
      return "कृपया ईमेल या मोबाइल नंबर दर्ज करें";
    }

    return "Please enter email or mobile number";
  }

  String get passwordError {
    if (widget.language == 0) {
      return "कृपया पासवर्ड टाका";
    }

    if (widget.language == 1) {
      return "कृपया पासवर्ड दर्ज करें";
    }

    return "Please enter your password";
  }

  String get passwordLengthError {
    if (widget.language == 0) {
      return "पासवर्ड किमान 6 अक्षरांचा असावा";
    }

    if (widget.language == 1) {
      return "पासवर्ड कम से कम 6 अक्षरों का होना चाहिए";
    }

    return "Password must be at least 6 characters";
  }

  // ============================================================
  // LOGIN
  // ============================================================

  void loginUser() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.language == 0
                ? "लॉगिन यशस्वी झाले"
                : widget.language == 1
                    ? "लॉगिन सफल हुआ"
                    : "Login successful",
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // ============================================================
  // FORGOT PASSWORD
  // ============================================================

  void forgotPassword() {
    final email = TextEditingController();

    final String title = widget.language == 0
        ? "पासवर्ड विसरलात?"
        : widget.language == 1
            ? "पासवर्ड भूल गए?"
            : "Forgot Password?";

    final String hint = widget.language == 0
        ? "तुमचा ईमेल टाका"
        : widget.language == 1
            ? "अपना ईमेल दर्ज करें"
            : "Enter your email";

    final String cancel = widget.language == 0
        ? "रद्द करा"
        : widget.language == 1
            ? "रद्द करें"
            : "Cancel";

    final String submit = widget.language == 0
        ? "पाठवा"
        : widget.language == 1
            ? "भेजें"
            : "Submit";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF124A78),
              fontWeight: FontWeight.w800,
            ),
          ),
          content: TextField(
            controller: email,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: const Icon(
                Icons.email_outlined,
                color: Color(0xFF159ED2),
              ),
              filled: true,
              fillColor: const Color(0xFFF1F9FC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      widget.language == 0
                          ? "पासवर्ड रीसेट विनंती पाठवली"
                          : widget.language == 1
                              ? "पासवर्ड रीसेट अनुरोध भेजा गया"
                              : "Password reset request submitted",
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF159ED2),
                foregroundColor: Colors.white,
              ),
              child: Text(submit),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // CREATE ACCOUNT
  // ============================================================

  void createNewAccount() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.language == 0
              ? "नवीन खाते तयार करण्याचे पेज लवकरच येईल"
              : widget.language == 1
                  ? "नया खाता बनाने का पेज जल्द आएगा"
                  : "Create New Account page coming soon",
        ),
      ),
    );
  }

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
            decoration: const BoxDecoration(
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
          // DECORATIVE CIRCLES
          // ======================================================

          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),

          Positioned(
            bottom: -100,
            left: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),

          // ======================================================
          // WAVE ICON
          // ======================================================

          Positioned(
            top: 60,
            right: 25,
            child: Icon(
              Icons.waves_rounded,
              size: 70,
              color: Colors.white.withOpacity(0.15),
            ),
          ),

          // ======================================================
          // MAIN
          // ======================================================

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 25,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(34),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 12,
                      sigmaY: 12,
                    ),
                    child: Container(
                      constraints: const BoxConstraints(
                        maxWidth: 520,
                      ),
                      padding: const EdgeInsets.fromLTRB(
                        28,
                        28,
                        28,
                        25,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.94),
                        borderRadius:
                            BorderRadius.circular(34),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.8),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.22),
                            blurRadius: 35,
                            offset: const Offset(0, 18),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [

                            // ==========================================
                            // BRAND LOGO
                            // ==========================================

                            Container(
                              width: 88,
                              height: 88,
                              decoration: BoxDecoration(
                                gradient:
                                    const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF087DC1),
                                    Color(0xFF20C7D2),
                                  ],
                                ),
                                borderRadius:
                                    BorderRadius.circular(27),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF159ED2)
                                        .withOpacity(0.35),
                                    blurRadius: 18,
                                    offset: const Offset(0, 8),
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
                                    size: 38,
                                  ),
                                  Icon(
                                    Icons.waves_rounded,
                                    color: Colors.white,
                                    size: 21,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 14),

                            // ==========================================
                            // APP NAME
                            // ==========================================

                            RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Sindhudurg",
                                    style: TextStyle(
                                      color: Color(0xFF124A78),
                                      fontSize: 26,
                                      fontWeight:
                                          FontWeight.w900,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Nagri",
                                    style: TextStyle(
                                      color: Color(0xFF12A8CF),
                                      fontSize: 26,
                                      fontWeight:
                                          FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              widget.language == 0
                                  ? "अन्वेषण • शोध • अनुभव"
                                  : widget.language == 1
                                      ? "अन्वेषण • खोज • अनुभव"
                                      : "Explore • Discover • Experience",
                              style: const TextStyle(
                                color: Color(0xFF669DB4),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.8,
                              ),
                            ),

                            const SizedBox(height: 25),

                            // ==========================================
                            // WELCOME ICON
                            // ==========================================

                            Container(
                              width: 68,
                              height: 68,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFE0F5FB),
                                border: Border.all(
                                  color: const Color(0xFFBFE9F4),
                                ),
                              ),
                              child: const Icon(
                                Icons.person_rounded,
                                color: Color(0xFF159ED2),
                                size: 38,
                              ),
                            ),

                            const SizedBox(height: 15),

                            // ==========================================
                            // WELCOME TEXT
                            // ==========================================

                            Text(
                              welcome,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF124A78),
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                              ),
                            ),

                            const SizedBox(height: 7),

                            Text(
                              subtitle,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF7798A6),
                                fontSize: 13.5,
                                height: 1.5,
                              ),
                            ),

                            const SizedBox(height: 28),

                            // ==========================================
                            // EMAIL LABEL
                            // ==========================================

                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                emailLabel,
                                style: const TextStyle(
                                  color: Color(0xFF174A8B),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),

                            const SizedBox(height: 9),

                            // ==========================================
                            // EMAIL
                            // ==========================================

                            TextFormField(
                              controller: emailController,
                              keyboardType:
                                  TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty) {
                                  return emailError;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: emailHint,
                                prefixIcon: const Icon(
                                  Icons.person_outline_rounded,
                                  color: Color(0xFF20A9D3),
                                ),
                                filled: true,
                                fillColor:
                                    const Color(0xFFF8FCFE),
                                contentPadding:
                                    const EdgeInsets.symmetric(
                                  vertical: 18,
                                  horizontal: 15,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(18),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFD5E4EA),
                                  ),
                                ),
                                enabledBorder:
                                    OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(18),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFD5E4EA),
                                  ),
                                ),
                                focusedBorder:
                                    OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(18),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF20A9D3),
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // ==========================================
                            // PASSWORD LABEL
                            // ==========================================

                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                passwordLabel,
                                style: const TextStyle(
                                  color: Color(0xFF174A8B),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),

                            const SizedBox(height: 9),

                            // ==========================================
                            // PASSWORD
                            // ==========================================

                            TextFormField(
                              controller: passwordController,
                              obscureText: !passwordVisible,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty) {
                                  return passwordError;
                                }

                                if (value.length < 6) {
                                  return passwordLengthError;
                                }

                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: passwordHint,
                                prefixIcon: const Icon(
                                  Icons.lock_outline_rounded,
                                  color: Color(0xFF20A9D3),
                                ),
                                suffixIcon: IconButton(
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
                                    color:
                                        const Color(0xFF20A9D3),
                                  ),
                                ),
                                filled: true,
                                fillColor:
                                    const Color(0xFFF8FCFE),
                                contentPadding:
                                    const EdgeInsets.symmetric(
                                  vertical: 18,
                                  horizontal: 15,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(18),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFD5E4EA),
                                  ),
                                ),
                                enabledBorder:
                                    OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(18),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFD5E4EA),
                                  ),
                                ),
                                focusedBorder:
                                    OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(18),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF20A9D3),
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),

                            // ==========================================
                            // FORGOT
                            // ==========================================

                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: forgotPassword,
                                child: Text(
                                  forgot,
                                  style: const TextStyle(
                                    color: Color(0xFF159ED2),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 8),

                            // ==========================================
                            // LOGIN BUTTON
                            // ==========================================

                            Container(
                              width: double.infinity,
                              height: 58,
                              decoration: BoxDecoration(
                                gradient:
                                    const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color(0xFF087DC1),
                                    Color(0xFF20C7D2),
                                  ],
                                ),
                                borderRadius:
                                    BorderRadius.circular(19),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF159ED2)
                                        .withOpacity(0.32),
                                    blurRadius: 16,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: loginUser,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.transparent,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shadowColor:
                                      Colors.transparent,
                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(19),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      login,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight:
                                            FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Icon(
                                      Icons
                                          .arrow_forward_rounded,
                                      size: 23,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 23),

                            // ==========================================
                            // CREATE ACCOUNT
                            // ==========================================

                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color:
                                        const Color(0xFFD0E5EC),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: TextButton(
                                    onPressed:
                                        createNewAccount,
                                    child: Text(
                                      createAccount,
                                      style: const TextStyle(
                                        color:
                                            Color(0xFF159ED2),
                                        fontSize: 14.5,
                                        fontWeight:
                                            FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color:
                                        const Color(0xFFD0E5EC),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 5),

                            // ==========================================
                            // FOOTER
                            // ==========================================

                            Text(
                              widget.language == 0
                                  ? "तुमचा सिंधुदुर्ग प्रवास येथे सुरू होतो"
                                  : widget.language == 1
                                      ? "आपकी सिंधुदुर्ग यात्रा यहाँ से शुरू होती है"
                                      : "Your Sindhudurg journey starts here",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF91AAB5),
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
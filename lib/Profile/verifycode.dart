import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:staygo/Beranda/beranda.dart';
import 'package:staygo/Profile/profilePage.dart';
import 'package:staygo/navigationBottom.dart';
import 'package:staygo/repository.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VerifyCode extends StatefulWidget {
  final int customerId;
  final String accessToken;

  const VerifyCode(
      {Key? key,
      required this.customerId,
      required this.accessToken})
      : super(key: key);

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  String email = '';
  bool isLoading = true;

  bool isLoadingSend = false;

  bool canResend = false;
  int countdownSeconds = 60;
  Timer? _countdownTimer;

  final TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Panggil API untuk mendapatkan data terbaru
    _fetchProfile();
    _startCountdown();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _codeController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    setState(() {
      canResend = false;
      countdownSeconds = 30;
    });

    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdownSeconds > 0) {
        setState(() {
          countdownSeconds--;
        });
      } else {
        setState(() {
          canResend = true;
        });
        timer.cancel();
      }
    });
  }

  Future<void> _sendVerificationCode() async {
    setState(() {
      isLoadingSend = true; // Show loading indicator when the request is sent
    });

    try {
      final repository = VerificationEmailRepository();
      final response = await repository.sendVerifikasi(
        accessToken: widget.accessToken,
        email: email,
      );

      _startCountdown();

      if (response['status']) {
        // If verification code sent successfully, navigate to next screen
        Fluttertoast.showToast(msg: 'Terkirim kode dengan email' + email);
      } else {
        // Show error message if sending verification code fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  response['message'] ?? 'Failed to send verification code')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error sending verification code: $error")),
      );
    }
  }

  Future<void> _fetchProfile() async {
    try {
      final repository = CustomerRepository();
      final response =
          await repository.getProfile(widget.customerId, widget.accessToken);

      if (response['status']) {
        final data = response['data'];
        setState(() {
          email = data['email'] ?? '';
          isLoading = false;
        });
      } else {
        // Handle error
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching profile: $error")),
      );
    }
  }

  Future<void> _verifyCode() async {
    if (_codeController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter the verification code.');
      return;
    }

    try {
      final repository = VerificationEmailRepository();
      final response = await repository.verifyEmail(
        accessToken: widget.accessToken,
        email: email,
        verificationCode: _codeController.text,
      );

      if (response['status'] == true) {
        // Display success message and navigate or do something else
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Success'),
            content: Text(response['message']),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BottomNavigation(
                            accessToken: widget.accessToken,
                            customerId: widget.customerId)),
                  );
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // Show error message in pop-up
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text(response['message']),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context), // Close dialog
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Error verifying email: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.07,
              ),
              Text(
                'Verifikasi Kode Email',
                style: GoogleFonts.urbanist(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontSize: 32.0,
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          'Silakan masukkan kode verifikasi yang telah kami kirim ke email Anda ',
                      style: GoogleFonts.urbanist(
                        fontSize: 14.0,
                        color: const Color(0xff808d9e),
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                    TextSpan(
                      text: email,
                      style: GoogleFonts.urbanist(
                        fontSize: 14.0,
                        color: const Color(0xff005BE0),
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.1,
              ),

              /// pinput package we will use here
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  width: width,
                  child: Pinput(
                    controller: _codeController,
                    length: 4,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    defaultPinTheme: PinTheme(
                      height: 60.0,
                      width: 60.0,
                      textStyle: GoogleFonts.urbanist(
                        fontSize: 24.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black.withOpacity(0.5),
                          width: 1.0,
                        ),
                      ),
                    ),
                    focusedPinTheme: PinTheme(
                      height: 60.0,
                      width: 60.0,
                      textStyle: GoogleFonts.urbanist(
                        fontSize: 24.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 16.0,
              ),
              canResend
                  ? Center(
                      child: TextButton(
                        onPressed: _sendVerificationCode,
                        child: Text(
                                'Resend Button',
                                style: GoogleFonts.urbanist(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    )
                  : Center(
                      child: Text(
                        'Kirim ulang dalam $countdownSeconds detik',
                        style: GoogleFonts.urbanist(
                          fontSize: 14.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

              /// Continue Button
              const Expanded(child: SizedBox()),
              InkWell(
                onTap: _verifyCode,
                borderRadius: BorderRadius.circular(30.0),
                child: Ink(
                  height: 55.0,
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Color(0xFF06283D),
                  ),
                  child: Center(
                    child: Text(
                      'Continue',
                      style: GoogleFonts.urbanist(
                        fontSize: 15.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 16.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

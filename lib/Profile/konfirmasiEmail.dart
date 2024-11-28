import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:staygo/Profile/verifycode.dart';
import 'package:staygo/repository.dart';

class KonfirmasiEmail extends StatefulWidget {
  final int customerId;
  final String accessToken;

  const KonfirmasiEmail(
      {Key? key,
      required this.customerId,
      required this.accessToken})
      : super(key: key);

  @override
  State<KonfirmasiEmail> createState() => _KonfirmasiEmailState();
}

class _KonfirmasiEmailState extends State<KonfirmasiEmail> {
  String email = '';
  bool isLoading = true;

  bool isLoadingSend = false;

  @override
  void initState() {
    super.initState();
    // Panggil API untuk mendapatkan data terbaru
    _fetchProfile();
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

      setState(() {
        isLoadingSend = false; // Hide loading indicator after response
      });

      if (response['status']) {
        // If verification code sent successfully, navigate to next screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyCode(
                accessToken: widget.accessToken,
                customerId: widget.customerId,),
          ),
        );
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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.all(8), // Margin to add space around the button
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white, // Background color of the circle
          ),
          child: Transform.translate(
            offset: Offset(4, 0), // Shift to the right by 4 pixels
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        title: Text('Verifikasi Email'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('assets/image_verifikasi.jpg'),
              Text(
                textAlign: TextAlign.center,
                'Verification Email',
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
                          'Klik lanjutkan untuk mendapatkan kode verifikasi email anda pada ',
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
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 16.0), // Adjust padding if needed
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoadingSend
                ? null
                : _sendVerificationCode, // Disable button while loading
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF06283D), // Same color as given
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50), // Rounded corners
              ),
              padding:
                  EdgeInsets.symmetric(vertical: 15), // Height of the button
            ),
            child: isLoadingSend
                ? CircularProgressIndicator(
                    color: Colors.white) // Show loading spinner
                : Text(
                    'Lanjutkan',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

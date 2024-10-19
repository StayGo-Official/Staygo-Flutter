import 'package:flutter/material.dart';

class KonfirmasiEmail extends StatefulWidget {
  const KonfirmasiEmail({super.key});

  @override
  State<KonfirmasiEmail> createState() => _KonfirmasiEmailState();
}

class _KonfirmasiEmailState extends State<KonfirmasiEmail> {
  @override
  Widget build(BuildContext context) {
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
    );
  }
}
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:staygo/Beranda/kosthomepage.dart';
import 'package:staygo/Beranda/ojekhomepage.dart';
import 'package:staygo/constants.dart';
import 'package:staygo/repository.dart';

class BerandaPage extends StatefulWidget {
  final String nama;
  final int customerId;
  final String accessToken;

  const BerandaPage({
    required this.nama,
    required this.customerId,
    required this.accessToken,
  });

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  
  String username = '';
  String nama = '';
  String email = '';
  String noHp = '';
  String alamat = '';
  String ttl = '';
  String image = '';

  bool isLoading = true;

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
          username = data['username'] ?? '';
          nama = data['nama'] ?? '';
          email = data['email'] ?? '';
          noHp = data['noHp'] ?? '';
          alamat = data['alamat'] ?? '';
          ttl = data['ttl'] ?? '';
          image = data['image'] ?? ''; // URL gambar
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

  @override
  Widget build(BuildContext context) {
    String profileImage = image.isEmpty ? 'profile.png' : image;

    return Column(
      children: [
        // Custom Header
        Container(
          height: 200, // Adjust height as needed
          padding: EdgeInsets.all(20), // Padding for the entire header
          color: Color(0xFF06283D), // Header background color
          width: double.infinity, // Full width
          child: Column(
            children: [
              SizedBox(height: 50), // Space above the white container
              Container(
                padding: EdgeInsets.all(15), // Padding for the inner container
                decoration: BoxDecoration(
                  color: Colors.white, // White background for the inner container
                  borderRadius: BorderRadius.circular(35), // Rounded corners
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile Picture
                    CircleAvatar(
                      radius: 30, // Larger radius for bigger avatar
                      backgroundImage: NetworkImage(
                        AppConstants.baseUrlImage + profileImage
                      ), // Replace with your profile image
                    ),
                    SizedBox(width: 15), // Space between avatar and text

                    // Greeting and Subtext
                    Expanded(
                      // Expanded to allow the text to take available space
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Halo, $nama! ', // Replace with dynamic name if necessary
                                style: TextStyle(
                                  fontSize: 17, // Larger font size
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black, // Text color inside white container
                                ),
                              ),
                              Text('👋', style: TextStyle(fontSize: 17)), // Wave emoji
                            ],
                          ),
                          SizedBox(height: 5), // Space between greeting and message
                          Text(
                            'Ayo pesan Kost dan Ojek Sesuai Kebutuhan anda!',
                            style: TextStyle(
                              fontSize: 16, // Supporting text font size
                              color: Colors.black54, // Text color for supporting text
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Body Content
        Expanded(
          child: Container(
            margin: EdgeInsets.all(20), // Margin for spacing
            padding: EdgeInsets.all(15), // Padding inside the container
            decoration: BoxDecoration(
              color: Color(0xFFB9C2C7), // Light grey background for large container
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                // First small container
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Ojekhomepage(nama: nama, accessToken: widget.accessToken, );
                          },
                        ),
                      );
                    },
                    // Makes the container take up half the available space
                    child: Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.only(bottom: 15), // Margin between two containers
                      decoration: BoxDecoration(
                        color: Colors.blue, // Blue background
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/logo-ojek.png', // Replace with your image path
                            height: 140, // Adjust the image height
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center, // Centers text vertically
                              children: [
                                Text(
                                  'StayGo',
                                  style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Ojek Online',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Ayo Pesan Sekarang >',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Second small container
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return kostHomepage(nama: nama, customerId: widget.customerId, accessToken: widget.accessToken);
                          },
                        ),
                      );
                    },
                    // Makes the container take up the other half of the available space
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.blue, // Blue background
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/logo-kos.png', // Replace with your image path
                            height: 110, // Adjust the image height
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center, // Centers text vertically
                              children: [
                                Text(
                                  'StayGo',
                                  style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Kost/Rumah Sewa',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Ayo Pesan Sekarang >',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

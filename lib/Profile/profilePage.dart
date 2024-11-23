// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names

import 'package:flutter/material.dart';
import 'package:staygo/Profile/editProfile.dart';
import 'package:staygo/Profile/konfirmasiEmail.dart';
import 'package:staygo/Profile/resetPassword.dart';
import 'package:staygo/loginpage.dart';
import 'package:staygo/navigationBottom.dart';
import 'package:url_launcher/url_launcher.dart';

class Profilepage extends StatelessWidget {
  final String username;
  final String email;
  final String noHp;
  final String alamat;

  const Profilepage({Key? key, required this.username, required this.email, required this.noHp, required this.alamat}) : super(key: key);

  void _launchPlayStore() async {
  const url =
      'https://play.google.com'; // Ganti 'com.example.staygo' dengan ID aplikasi Play Store yang ingin dibuka
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

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
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Space above the white container
            Container(
              padding: EdgeInsets.all(15), // Padding for the outer container
              child: Column(
                children: [
                  Container(
                    padding:
                        EdgeInsets.all(15), // Padding for the outer container
                    decoration: BoxDecoration(
                      color: Colors
                          .white, // White background for the whole container
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                            20), // Rounded corner for the top left
                        topRight: Radius.circular(
                            20), // Rounded corner for the top right
                      ),
                      border: Border(
                        top: BorderSide(
                            width: 1,
                            color: Colors.grey), // Solid border on top
                        left: BorderSide(
                            width: 1,
                            color: Colors.grey), // Solid border on left
                        right: BorderSide(
                            width: 1,
                            color: Colors.grey), // Solid border on right
                        // No border at the bottom
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40, // Radius of the avatar
                          backgroundImage: AssetImage(
                              'assets/profile.png'), // Your profile image
                        ),
                        SizedBox(
                            width:
                                20), // Horizontal space between the avatar and the text
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                username,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(email),
                              Text(noHp),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Container for the promotional text
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return BottomNavigation(username: username, email: email, noHp: noHp, alamat: alamat,);
                          },
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 219, 230,
                            236), // Light orange background for the text container
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(
                              20), // Rounded corner for the bottom left
                          bottomRight: Radius.circular(
                              20), // Rounded corner for the bottom right
                        ),
                        border: Border.all(
                          color: Color.fromARGB(
                              255, 72, 111, 202), // Color of the border
                          width: 1, // Width of the border
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Pesan Ojek dan Sewa Kos Dengan senang hati, yuk!',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 50, 49, 49),
                                fontWeight: FontWeight.normal,
                              ),
                              softWrap: true,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios, // Ikon panah ke kanan
                            color:
                                Color.fromARGB(255, 72, 111, 202), // Warna ikon
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Body Content
            Container(
              // Margin for spacing
              padding: EdgeInsets.all(15), // Padding inside the container
              decoration: BoxDecoration(
                color:
                    Colors.white, // Light grey background for large container
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  // Second small container
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Akun dan Keamanan',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.edit,
                  color: Colors.black), // Change icon as needed
              title: Text('Ubah Data Akun'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return EditProfile();
                    },
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.email_outlined,
                  color: Colors.black), // Change icon as needed
              title: Text('Verifikasi Email'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return KonfirmasiEmail();
                    },
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.lock_outlined,
                  color: Colors.black), // Change icon as needed
              title: Text('Ganti Password'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ResetPassword();
                    },
                  ),
                );
              },
            ),

            Container(
              // Margin for spacing
              padding: EdgeInsets.all(15), // Padding inside the container
              decoration: BoxDecoration(
                color:
                    Colors.white, // Light grey background for large container
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  // Second small container
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Info Lainnya',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: Icon(Icons.star_border,
                  color: Colors.black), // Change icon as needed
              title: Text('Beri Rating'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                _launchPlayStore();
              },
            ),
            ListTile(
              leading: Icon(Icons.business_center,
                  color: Colors.black), // Change icon as needed
              title: Text('StayGo for Business'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Navigate or perform actions
              },
            ),
            ListTile(
              leading: Icon(Icons.document_scanner,
                  color: Colors.black), // Change icon as needed
              title: Text('Syarat dan Ketentuan'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Navigate or perform actions
              },
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip_outlined,
                  color: Colors.black), // Change icon as needed
              title: Text('Kebijakan dan Privasi'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Navigate or perform actions
              },
            ),
            ListTile(
              leading: Icon(Icons.logout_outlined,
                  color: Colors.red), // Change icon as needed
              title: Text(
                'Keluar',
                style: TextStyle(
                  color: Colors.red, // Set text color to red
                  fontWeight: FontWeight.bold, // Optional: make it bold
                ),
              ),
              onTap: () {
                // Navigate or perform actions
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginPage();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

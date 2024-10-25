import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri _whatsappUrl = Uri.parse(
    'https://api.whatsapp.com/send?phone=6285836184623&text=Halo%20saya%20mau%20pesan%20Ojek');

class Detailojeknurul extends StatefulWidget {
  const Detailojeknurul({super.key});

  @override
  State<Detailojeknurul> createState() => _DetailojeknurulState();
}

class _DetailojeknurulState extends State<Detailojeknurul> {
  int _currentIndex = 0;

  Future<void> _launchWhatsApp() async {
    if (!await launchUrl(_whatsappUrl)) {
      throw Exception('Could not launch $_whatsappUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar:
          true, // Extend body behind the AppBar to overlap it
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carousel for images
            Container(
              height: 260, // Adjust height of the image container
              width: double.infinity,
              child: PageView(
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: [
                  Image.asset(
                    'assets/nurul.png',
                    fit: BoxFit.cover,
                  )
                ],
              ),
            ),

            // Border radius decoration below the carousel
            Container(
              height: 10,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
            ),

            // Page indicators for the carousel
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildIndicator(0 == _currentIndex),
                SizedBox(width: 5),
                buildIndicator(1 == _currentIndex),
              ],
            ),

            // Kost Detail Information Section Full Screen Width
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              padding:
                  const EdgeInsets.all(15.0), // Padding inside the container
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kost Title
                  Text(
                    'Ojek Nurul',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),

                  // Location Row
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 20, color: Colors.blue),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          'Blang pulo, Muara Satu, Lhokseumawe',
                          style: TextStyle(fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  // Rating Row
                  Row(
                    children: [
                      Icon(Icons.star, size: 20, color: Colors.orange),
                      SizedBox(width: 5),
                      Text(
                        '4,5/5 (100 reviewers)',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // Availability Row
                  Row(
                    children: [
                      Icon(Icons.check_circle, size: 20, color: Colors.green),
                      SizedBox(width: 5),
                      Text(
                        'Tersedia',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Deskripsi Pengemudi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    'Nama Lengkap: Nurul Azizah',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),

                  Text(
                    'Jenis Kelamin: Wanita',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 16.0), // Adjust padding if needed
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _launchWhatsApp,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF06283D), // Same color as given
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50), // Rounded corners
              ),
              padding:
                  EdgeInsets.symmetric(vertical: 15), // Height of the button
            ),
            child: Text(
              'Pesan Ojek',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget buildIndicator(bool isActive) {
    return Container(
      height: 8,
      width: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.blue : Colors.grey,
      ),
    );
  }
}

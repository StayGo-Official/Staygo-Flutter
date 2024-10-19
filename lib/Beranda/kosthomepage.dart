// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, camel_case_types

import 'package:flutter/material.dart';
import 'package:staygo/Favorite/favorite.dart';
import 'package:staygo/kost/detailkost.dart';

class kostHomepage extends StatefulWidget {
  const kostHomepage({super.key});

  @override
  State<kostHomepage> createState() => _kostHomepageState();
}

class _kostHomepageState extends State<kostHomepage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom Header
            Container(
              padding: EdgeInsets.all(20), // Padding for the entire header
              color: Colors.white, // Background color
              width: double.infinity, // Full width
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Picture
                  CircleAvatar(
                    radius: 30, // Larger radius for bigger avatar
                    backgroundImage: AssetImage(
                        'assets/profile.png'), // Replace with your profile image
                  ),
                  SizedBox(width: 15), // Space between avatar and text

                  // Greeting and Subtext
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Halo, Widia! ', // Replace with dynamic name if necessary
                              style: TextStyle(
                                fontSize: 20, // Larger font size
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text('👋',
                                style: TextStyle(fontSize: 20)), // Wave emoji
                          ],
                        ),
                        SizedBox(
                            height: 5), // Space between greeting and message
                        Text(
                          'Mau Cari kost-kostan?',
                          style: TextStyle(
                            fontSize: 16, // Supporting text font size
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Icons for Favorite and Notifications
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return FavoritePage();
                            },
                          ),
                        );
                    },
                    icon:
                        Icon(Icons.favorite_outline, color: Color(0xFF05283c)),
                    iconSize: 25,
                  ),
                  IconButton(
                    onPressed: () {
                      // Tampilkan pop-up dialog ketika ikon notifikasi ditekan
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Notifikasi'),
                            content: Text(
                                'Tidak ada notifikasi baru saat ini.'), // Pesan dalam pop-up
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Tutup dialog
                                },
                                child: Text('Tutup'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.notifications_outlined,
                        color: Color(0xFF05283c)),
                    iconSize: 25,
                  ),
                ],
              ),
            ),

            // Search bar and buttons
            Padding(
              padding: EdgeInsets.all(15), // Padding for the search and buttons
              child: Column(
                children: [
                  // Search bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Cari kost anda',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  SizedBox(
                      height: 20), // Spacing between search bar and buttons

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCategoryButton('assets/termurah.png', 'Termurah'),
                      _buildCategoryButton('assets/tahunan.png', 'Tahunan'),
                      _buildCategoryButton('assets/kalender.png', 'Bulanan'),
                      _buildCategoryButton('assets/terbersih.png', 'Terbersih'),
                    ],
                  ),
                ],
              ),
            ),

            // Booking History Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Riwayat Pemesanan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            // Booking Card without outer container
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3), // Shadow color
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: Offset(0, 3), // Shadow position
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(
                    15.0), // Padding inside the small container
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Section
                    Container(
                      width: 100, // Smaller width for the image
                      height: 100, // Smaller height for the image
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/kos1.png'), // Replace with your kost image
                          fit: BoxFit
                              .cover, // Ensure the image fits the container
                        ),
                      ),
                    ),
                    SizedBox(width: 15), // Space between image and text
                    // Detail Section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kost Pak Mukhsin',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10), // Space between elements
                          Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  size: 23, color: Colors.blue),
                              SizedBox(width: 5),
                              Text('9/8/2024 - 9/8/2025'),
                            ],
                          ),
                          SizedBox(height: 10), // Space between elements
                          Row(
                            children: [
                              Icon(Icons.location_on_outlined,
                                  size: 23, color: Colors.blue),
                              SizedBox(width: 5),
                              Text('Jl. Bukit Indah'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Rekomendasi Terbaik',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            // Horizontal Carousel for Recommended Kost
            Container(
              height: 280, // Height of the carousel
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount:
                    3, // Set count to 3 to show three different recommendations
                itemBuilder: (context, index) {
                  // Defining data for each item
                  final kostList = [
                    {
                      'image': 'assets/kos1.png',
                      'title': 'Kost dekat dengan Universitas',
                      'location': 'Blang Pulo',
                      'rating': '4,2/5 (reviewers)',
                      'price': 'Rp 8.000.000 /tahun',
                      'ratingColor': Colors.orange,
                    },
                    {
                      'image': 'assets/kos2.png',
                      'title': 'Kost Nyaman di Tengah Kota',
                      'location': 'Bukit Indah',
                      'rating': '4,8/5 (reviewers)',
                      'price': 'Rp 6.500.000 /tahun',
                      'ratingColor': Colors.orange,
                    },
                    {
                      'image': 'assets/kos3.png',
                      'title': 'Kost Murah dan Bersih',
                      'location': 'Jl. Mawar',
                      'rating': '4,5/5 (reviewers)',
                      'price': 'Rp 5.000.000 /tahun',
                      'ratingColor': Colors.orange,
                    },
                  ];

                  // Get the data for the current item
                  final kost = kostList[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return DetailKost();
                            },
                          ),
                        );
                    },
                    child: Container(
                      width: 160,
                      margin: EdgeInsets.all(10), // Margin between items
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: Offset(0, 3), // Shadow position
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Kost Image
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                            child: Image.asset(
                              kost['image'] as String, // Cast to String
                              width: 160,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  kost['title'] as String, // Cast to String
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(Icons.location_on_outlined,
                                        size: 16, color: Colors.blue),
                                    SizedBox(width: 5),
                                    Text(
                                      kost['location']
                                          as String, // Cast to String
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(Icons.star,
                                        size: 16,
                                        color: kost['ratingColor']
                                            as Color), // Cast to Color
                                    SizedBox(width: 5),
                                    Text(
                                      kost['rating']
                                          as String, // Cast to String
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Text(
                                  kost['price'] as String, // Cast to String
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String imagePath, String label) {
    return Column(
      children: [
        Container(
          width: 80, // Adjust width of the button
          height: 80, // Adjust height of the button
          decoration: BoxDecoration(
            color: Color(0xFFD3EAFF),
            borderRadius: BorderRadius.circular(20), // Set border radius to 20
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0), // Padding for the image
            child: Image.asset(imagePath), // Load image from assets
          ),
          alignment: Alignment.center, // Center the icon
        ),
        SizedBox(height: 5),
        Text(label),
      ],
    );
  }
}

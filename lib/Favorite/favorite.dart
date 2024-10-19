// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, unused_field

import 'package:flutter/material.dart';
import 'package:staygo/kost/detailkost.dart';
import 'package:staygo/ojek/detailojek.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  int _currentIndex = 0;

  String selectedOption = 'Ojek';

  final List<Map<String, String>> items = [
    {'name': 'Irvan', 'gender': 'Cowok', 'image': 'assets/kos2.png'},
    {'name': 'Taufik', 'gender': 'Cowok', 'image': 'assets/kos2.png'},
    {'name': 'Widya', 'gender': 'Cewek', 'image': 'assets/kos2.png'},
    {'name': 'Ahnad', 'gender': 'Cowok', 'image': 'assets/kos2.png'},
    {'name': 'fauzan', 'gender': 'Cowok', 'image': 'assets/kos2.png'},
    {'name': 'Siti', 'gender': 'Cewek', 'image': 'assets/kos2.png'},
    {'name': 'Maya', 'gender': 'Cewek', 'image': 'assets/kos2.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Transform.translate(
            offset: Offset(4, 0),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        title: Text('Favorite'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedOption = 'Ojek';
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/ride_icon.png',
                            width: 40, height: 40),
                        SizedBox(height: 5),
                        Text(
                          'Ojek',
                          style:
                              TextStyle(color: Color(0xFF06283D), fontSize: 16),
                        ),
                        if (selectedOption == 'Ojek')
                          Container(
                            width: 30,
                            height: 2,
                            color: Color(0xFF06283D),
                          ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedOption = 'Kost';
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/kost-icon.png',
                            width: 40, height: 40),
                        SizedBox(height: 5),
                        Text(
                          'Kost',
                          style:
                              TextStyle(color: Color(0xFF06283D), fontSize: 16),
                        ),
                        if (selectedOption == 'Kost')
                          Container(
                            width: 30,
                            height: 2,
                            color: Color(0xFF06283D),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          // Conditional rendering based on selectedOption
          selectedOption == 'Ojek' ? buildOjekSection() : buildKostSection(),
        ],
      ),
    );
  }

  Widget buildOjekSection() {
    // Put your 'untuk Ojek' code here and return the widget
    return SizedBox(
      height: 540,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(13.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: const Color.fromARGB(255, 109, 109, 109),
                    width: 2), // Border color
                borderRadius: BorderRadius.circular(15), // Rounded corners
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(13),
                            topRight: Radius.circular(13),
                            bottomLeft: Radius.circular(13),
                            bottomRight: Radius.circular(13),
                          ), // Sesuaikan dengan radius yang diinginkan
                          child: Image.asset(
                            items[index]['image']!,
                            fit: BoxFit.cover,
                            height: 120,
                            width: double.infinity,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'Tersedia\n${items[index]['name']} (${items[index]['gender']})',
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Color(0xFF06283D),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                          iconSize: 25.0,
                          onPressed: () {
                            // Action ketika icon favorite ditekan
                          },
                        ),
                      ],
                    ), // Memberikan sedikit ruang antara icon dan teks
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Detailojek();
                            },
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 25.0,
                            color: Color(
                                0xFF06283D), // Menyesuaikan warna icon jika diperlukan
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Pesan Sekarang...',
                            style: TextStyle(
                              color: Color(0xFF06283D),
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildKostSection() {
    // Put your 'untuk Kost' code here and return the widget
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        GestureDetector(
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
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
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
                        fit:
                            BoxFit.cover, // Ensure the image fits the container
                      ),
                    ),
                  ),
                  SizedBox(width: 15), // Space between image and text
                  // Detail Section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Kost Pak Mukhsin',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.favorite, color: Colors.red),
                              iconSize: 20,
                              onPressed: () {
                                // Tambahkan aksi yang diinginkan ketika tombol ditekan
                                print('Favorit ditekan');
                              },
                            ),
                          ],
                        ), // Space between elements
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
        ),
        GestureDetector(
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
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
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
                            'assets/kos2.png'), // Replace with your kost image
                        fit:
                            BoxFit.cover, // Ensure the image fits the container
                      ),
                    ),
                  ),
                  SizedBox(width: 15), // Space between image and text
                  // Detail Section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Kost Murah dan Bersih',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.favorite, color: Colors.red),
                              iconSize: 20,
                              onPressed: () {
                                // Tambahkan aksi yang diinginkan ketika tombol ditekan
                                print('Favorit ditekan');
                              },
                            ),
                          ],
                        ), // Space between elements
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
                            Text('Jl. Mawar'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
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
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
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
                            'assets/kos3.png'), // Replace with your kost image
                        fit:
                            BoxFit.cover, // Ensure the image fits the container
                      ),
                    ),
                  ),
                  SizedBox(width: 15), // Space between image and text
                  // Detail Section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Kost Dekat UNIMAL',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.favorite, color: Colors.red),
                              iconSize: 20,
                              onPressed: () {
                                // Tambahkan aksi yang diinginkan ketika tombol ditekan
                                print('Favorit ditekan');
                              },
                            ),
                          ],
                        ), // Space between elements
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
        ),
      ],
    );
  }
}

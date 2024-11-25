// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_element

import 'package:flutter/material.dart';
import 'package:staygo/ojek/detailojek.dart';
import 'package:staygo/constants.dart';
import 'package:staygo/models.dart';
import 'package:staygo/repository.dart';

class Ojekhomepage extends StatefulWidget {
  final String username;

  const Ojekhomepage({Key? key, required this.username}) : super(key: key);

  @override
  State<Ojekhomepage> createState() => _OjekhomepageState();
}

class _OjekhomepageState extends State<Ojekhomepage> {
  String selectedOption = 'Ride'; // Default selected option

  late Future<List<Ojek>> ojekList;

  @override
  void initState() {
    super.initState();
    ojekList = RepositoryOjek().getDataOjek();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // Membungkus dengan SingleChildScrollView
        child: Column(
          children: [
            // Custom Header
            Container(
                height: 120, // Adjust height as needed
                padding: EdgeInsets.all(20), // Padding for the entire header
                color: Color(0xFF06283D), // Header background color
                width: double.infinity, // Full width
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30), // Spacing for the status bar
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color:
                            Colors.white, // Background color of the search box
                        borderRadius:
                            BorderRadius.circular(13), // Rounded corners
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search', // Placeholder text
                          icon: Icon(Icons.search), // Search icon
                          border: InputBorder.none, // No default border
                        ),
                      ),
                    ),
                  ],
                )),

            // Container with "Selamat datang Widia"
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.all(15), // Padding inside the container
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromARGB(255, 109, 109, 109),
                      width: 2), // Border color
                  borderRadius: BorderRadius.circular(15), // Rounded corners
                ),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18), // Default text style
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Selamat datang ', // First part of the text
                        style: TextStyle(
                            fontWeight: FontWeight.normal), // Normal weight
                      ),
                      TextSpan(
                        text: widget.username, // Second part of the text
                        style: TextStyle(
                            fontWeight: FontWeight.bold), // Bold weight
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity, // Full width
                padding: EdgeInsets.all(15), // Padding inside the container
                decoration: BoxDecoration(
                  color:
                      Colors.white, // Background color of the options container
                  borderRadius: BorderRadius.circular(15), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3), // Shadow color
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: Offset(0, 3), // Shadow position
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly, // Distribute space evenly
                  children: [
                    // Ride Option
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedOption = 'Ride'; // Update selected option
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/ride_icon.png',
                              width: 40, height: 40), // Ride icon
                          SizedBox(height: 5), // Space between icon and text
                          Column(
                            children: [
                              Text(
                                'Ride',
                                style: TextStyle(
                                    color: Color(0xFF06283D), fontSize: 16),
                              ),
                              if (selectedOption ==
                                  'Ride') // Show underline if selected
                                Container(
                                  width: 30, // Adjust width of the underline
                                  height: 2,
                                  color: Color(0xFF06283D), // Underline color
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Food Option
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedOption = 'Food'; // Update selected option
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/food_icon.png',
                              width: 40, height: 40), // Food icon
                          SizedBox(height: 5), // Space between icon and text
                          Column(
                            children: [
                              Text(
                                'Food',
                                style: TextStyle(
                                    color: Color(0xFF06283D), fontSize: 16),
                              ),
                              if (selectedOption ==
                                  'Food') // Show underline if selected
                                Container(
                                  width: 30, // Adjust width of the underline
                                  height: 2,
                                  color: Color(0xFF06283D), // Underline color
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(
              height: 10,
            ),
            // Vertical Carousel using PageView
            selectedOption == 'Ride' ? buildRideSection() : buildFoodSection(),
          ],
        ),
      ),
    );
  }

  Widget buildRideSection() {
    // Put your 'untuk Ojek' code here and return the widget
    return SizedBox(
      height: 490, // Set height for the grid container
      child: FutureBuilder<List<Ojek>>(
        future: ojekList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final ojekListData = snapshot.data!;

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two cards per row
                childAspectRatio: 0.75,
              ),
              itemCount: ojekListData.length, // Number of items
              itemBuilder: (context, index) {
                final Ojek ojek = ojekListData[index];

                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 109, 109, 109),
                        width: 2,
                      ), // Border color
                      borderRadius:
                          BorderRadius.circular(15), // Rounded corners
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
                                ),
                                child: Image.network(
                                  AppConstants.baseUrlImage + ojek.images.first,
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
                                  '${ojek.status ? 'Tersedia' : 'Tidak Tersedia'}\n${ojek.nama} (${ojek.gender})',
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Color(0xFF06283D),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.favorite_border),
                                iconSize: 29.0,
                                onPressed: () {
                                  // Action ketika icon favorite ditekan
                                },
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).popAndPushNamed(
                                '/detail-ojek',
                                arguments: {
                                  'id': ojek.id,
                                  'nama': ojek.nama,
                                  'alamat': ojek.alamat,
                                  'status': ojek.status,
                                  'gender': ojek.gender,
                                  'images': ojek.images,
                                },
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 25.0,
                                  color: Color(0xFF06283D),
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
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget buildFoodSection() {
    // Put your 'untuk Ojek' code here and return the widget
    return SizedBox(
      height: 490, // Set height for the grid container
      child: FutureBuilder<List<Ojek>>(
        future: ojekList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final ojekListData = snapshot.data!;

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two cards per row
                childAspectRatio: 0.75,
              ),
              itemCount: ojekListData.length, // Number of items
              itemBuilder: (context, index) {
                final Ojek ojek = ojekListData[index];

                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 109, 109, 109),
                        width: 2,
                      ), // Border color
                      borderRadius:
                          BorderRadius.circular(15), // Rounded corners
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
                                ),
                                child: Image.network(
                                  AppConstants.baseUrlImage + ojek.images.first,
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
                                  '${ojek.status ? 'Tersedia Food' : 'Tidak Tersedia'}\n${ojek.nama} (${ojek.gender})',
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Color(0xFF06283D),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.favorite_border),
                                iconSize: 29.0,
                                onPressed: () {
                                  // Action ketika icon favorite ditekan
                                },
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).popAndPushNamed(
                                '/detail-ojek',
                                arguments: {
                                  'id': ojek.id,
                                  'nama': ojek.nama,
                                  'alamat': ojek.alamat,
                                  'status': ojek.status,
                                  'gender': ojek.gender,
                                  'images': ojek.images,
                                },
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 25.0,
                                  color: Color(0xFF06283D),
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
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
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

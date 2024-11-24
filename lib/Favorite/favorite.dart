// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, unused_field

import 'package:flutter/material.dart';
import 'package:staygo/kost/detailkost.dart';
import 'package:staygo/ojek/detailojek.dart';
import 'package:staygo/constants.dart';
import 'package:staygo/repository.dart';

class FavoritePage extends StatefulWidget {
  final String accessToken;

  const FavoritePage({Key? key, required this.accessToken}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final FavoriteKostRepository favoriteRepo = FavoriteKostRepository();

  late Future<List<dynamic>> _favoriteKost;

  @override
  void initState() {
    super.initState();
    _favoriteKost = favoriteRepo.fetchFavoriteKost(widget.accessToken);
  }

  int _currentIndex = 0;

  String selectedOption = 'Ojek';

  final List<Map<String, String>> items = [
    {'name': 'Irvan', 'gender': 'Cowok', 'image': 'assets/kos2.png'},
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
      height: 520,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
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
  return FutureBuilder<List<dynamic>>(
    future: _favoriteKost, // Use the fetched favorite kost data
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(child: Text('No favorite kost found'));
      } else {
        final favoriteKostList = snapshot.data!;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: favoriteKostList.length,
          itemBuilder: (context, index) {
            final kost = favoriteKostList[index]['kost']; // Access kost data
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailKost(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3), // Shadow color
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: const Offset(0, 3), // Shadow position
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(15), // Padding inside the container
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Section
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          AppConstants.baseUrlImage + kost['images'][0], // First image from the URL array
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 15), // Space between image and text
                      // Detail Section
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    kost['namaKost'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis, // Prevent overflow
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.favorite, color: Colors.red),
                                  iconSize: 20,
                                  onPressed: () {
                                    // Add favorite button action if needed
                                    print('Favorite tapped');
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined,
                                    size: 18, color: Colors.blue),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    kost['alamat'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                    overflow: TextOverflow.ellipsis, // Prevent overflow
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(Icons.price_change_outlined,
                                    size: 18, color: Colors.green),
                                const SizedBox(width: 5),
                                Text(
                                  'Rp${kost['hargaPerbulan']}/bulan',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
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
            );
          },
        );
      }
    },
  );
}

}

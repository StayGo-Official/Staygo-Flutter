// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, camel_case_types

import 'package:flutter/material.dart';
import 'package:staygo/Favorite/favorite.dart';
import 'package:staygo/constants.dart';
import 'package:staygo/kost/allkost.dart';
import 'package:staygo/models.dart';
import 'package:staygo/repository.dart';

class kostHomepage extends StatefulWidget {
  final String nama;
  final String accessToken;
  final int customerId;

  const kostHomepage(
      {Key? key,
      required this.nama,
      required this.customerId,
      required this.accessToken})
      : super(key: key);

  @override
  State<kostHomepage> createState() => _kostHomepageState();
}

class _kostHomepageState extends State<kostHomepage> {
  late Future<List<Kost>> kostList;

  String searchQuery = '';
  List<Kost> originalKostList = [];
  List<Kost> filteredKostList = [];

  String username = '';
  String nama = '';
  String email = '';
  String noHp = '';
  String alamat = '';
  String ttl = '';
  String image = '';

  bool isLoading = true;

  void filterKostList(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      if (searchQuery.isEmpty) {
        filteredKostList =
            originalKostList; // Return the original data if search is empty
      } else {
        filteredKostList = originalKostList.where((kost) {
          // Check if the search query matches either the namaKost or alamat
          return kost.namaKost.toLowerCase().contains(searchQuery) ||
              kost.alamat.toLowerCase().contains(searchQuery);
        }).toList();
      }
    });
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
  void initState() {
    super.initState();
    _fetchProfile();
    if (widget.accessToken.isEmpty) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      kostList = RepositoryKost().getDataKost();
      kostList.then((data) {
        setState(() {
          originalKostList = data; // Simpan data asli
          filteredKostList = data; // Inisialisasi data yang akan ditampilkan
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String profileImage = image.isEmpty ? 'profile.png' : image;

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
                    backgroundImage: NetworkImage(AppConstants.baseUrlImage +
                        profileImage), // Replace with your profile image
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
                              'Halo, ' +
                                  nama, // Replace with dynamic name if necessary
                              style: TextStyle(
                                fontSize: 17, // Larger font size
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text('👋',
                                style: TextStyle(fontSize: 17)), // Wave emoji
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
                      onChanged: filterKostList,
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
                child: Row(
                  children: [
                    Text(
                      'Rekomendasi Terbaik',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return AllKost(accessToken: widget.accessToken,);
                            },
                          ),
                        );
                      },
                      child: Text(
                        'Lihat Semua',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Horizontal Carousel for Recommended Kost
            Container(
              height: 280,
              child: filteredKostList.isEmpty
                  ? Center(
                      child:
                          Text('Tidak ada kost yang sesuai dengan pencarian'),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: filteredKostList.length,
                      itemBuilder: (context, index) {
                        final Kost kost = filteredKostList[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              '/detail-kost',
                              arguments: {
                                'namaKost': kost.namaKost,
                                'hargaPerbulan': kost.hargaPerbulan,
                                'hargaPertahun': kost.hargaPertahun,
                                'tersedia': kost.tersedia,
                                'gender': kost.gender,
                                'fasilitas': kost.fasilitas,
                                'deskripsi': kost.deskripsi,
                                'alamat': kost.alamat,
                                'latitude': kost.latitude,
                                'longitude': kost.longitude,
                                'images': kost.images,
                                'accessToken': widget.accessToken,
                                'kostId': kost.id,
                                'customerId': widget.customerId,
                              },
                            );
                          },
                          child: Container(
                            width: 160,
                            margin: EdgeInsets.all(10),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  ),
                                  child: Image.network(
                                    AppConstants.baseUrlImage +
                                        kost.images.first,
                                    width: 160,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        kost.namaKost,
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
                                          Expanded(
                                            child: Text(
                                              kost.alamat,
                                              style: TextStyle(fontSize: 12),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        kost.hargaPertahun == 0
                                            ? "Rp. ${kost.hargaPerbulan} /bulan" // Jika hargaPertahun == 0, tampilkan hargaPerbulan
                                            : "Rp. ${kost.hargaPertahun} /tahun", // Jika hargaPertahun != 0, tampilkan hargaPertahun
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

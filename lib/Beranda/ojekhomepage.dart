// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_element

import 'package:flutter/material.dart';
import 'package:staygo/ojek/detailojek.dart';
import 'package:staygo/constants.dart';
import 'package:staygo/models.dart';
import 'package:staygo/repository.dart';

class Ojekhomepage extends StatefulWidget {
  final String nama;
  final String accessToken;
  final int customerId;

  const Ojekhomepage(
      {Key? key,
      required this.nama,
      required this.accessToken,
      required this.customerId})
      : super(key: key);

  @override
  State<Ojekhomepage> createState() => _OjekhomepageState();
}

class _OjekhomepageState extends State<Ojekhomepage> {
  bool isFavorited = false;
  bool isFavorite = false;
  bool isLoading = false;

  String selectedOption = 'Ride'; // Default selected option

  String searchQuery = '';
  List<Ojek> originalOjekList = [];
  List<Ojek> filteredOjekList = [];

  late Future<List<Ojek>> ojekList;

  final FavoriteOjekRepository _repository = FavoriteOjekRepository();

  void toggleFavorite() {
    setState(() {
      isFavorited = !isFavorited;
    });
  }

  void filterOjekList(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      if (searchQuery.isEmpty) {
        filteredOjekList = originalOjekList; // Tampilkan semua data
      } else {
        filteredOjekList = originalOjekList.where((ojek) {
          return ojek.nama.toLowerCase().contains(searchQuery) ||
              ojek.namaLengkap.toLowerCase().contains(searchQuery);
        }).toList();
      }
    });
  }

  Future<void> _addToFavorite(int ojekId) async {
    setState(() {
      isLoading = true; // Tampilkan indikator loading
    });

    try {
      // Panggil fungsi repository
      final response = await _repository.addFavorite(
        accessToken: widget.accessToken,
        ojekId: ojekId,
      );

      if (response['status'] == true) {
        // Jika berhasil, set status isFavorite menjadi true
        setState(() {
          isFavorite = true;
        });

        // Tampilkan pesan sukses
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message']),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Jika gagal, tampilkan pesan error dari backend
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(response['message'] ?? 'Gagal menambahkan ke favorit'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      // Tangani error yang tidak diantisipasi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: ${error.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false; // Matikan indikator loading setelah selesai
      });
    }
  }

  void fetchData({required bool isRide}) {
    setState(() {
      ojekList = RepositoryOjek().getDataOjek(
        isRide: isRide,
        isFood: !isRide,
        accessToken: widget.accessToken,
      );
      ojekList.then((data) {
        setState(() {
          originalOjekList = data; // Perbarui originalOjekList dengan data baru
          filteredOjekList = data; // Reset filteredOjekList
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    toggleFavorite();
    if (widget.accessToken.isEmpty) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ojekList = RepositoryOjek().getDataOjek(
        isRide: true,
        isFood: false,
        accessToken: widget.accessToken,
      );
      ojekList.then((data) {
        setState(() {
          originalOjekList = data; // Simpan data asli
          filteredOjekList = data; // Inisialisasi data yang akan ditampilkan
        });
      });
    }
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
                        onChanged: filterOjekList,
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
                        text: widget.nama, // Second part of the text
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
                          fetchData(isRide: true);
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
                          fetchData(isRide: false); // Ambil data kategori Food
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/food_icon.png',
                              width: 40, height: 40), // Food icon
                          SizedBox(height: 5),
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
                                  width: 30,
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
            return Container(
              child: filteredOjekList.isEmpty
                  ? Center(
                      child:
                          Text('Tidak ada Ojek yang sesuai dengan pencarian'),
                    )
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Two cards per row
                        childAspectRatio: 0.75,
                      ),
                      itemCount: filteredOjekList.length, // Number of items
                      itemBuilder: (context, index) {
                        final Ojek ojek = filteredOjekList[index];

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
                                          AppConstants.baseUrlImage +
                                              ojek.images.first,
                                          fit: BoxFit.cover,
                                          height: 120,
                                          width: double.infinity,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                        icon: isLoading
                                            ? SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                ),
                                              )
                                            : Icon(
                                                ojek.isFavorite
                                                    ? Icons.favorite
                                                    : Icons.favorite_outline,
                                                color: ojek.isFavorite
                                                    ? Colors.red[400]
                                                    : Colors.black,
                                              ),
                                        iconSize: 29.0,
                                        onPressed: isLoading
                                            ? null
                                            : () => _addToFavorite(ojek.id),
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).popAndPushNamed(
                                        '/detail-ojek',
                                        arguments: {
                                          'ojekId': ojek.id,
                                          'nama': ojek.nama,
                                          'namaLengkap': ojek.namaLengkap,
                                          'alamat': ojek.alamat,
                                          'status': ojek.status,
                                          'gender': ojek.gender,
                                          'images': ojek.images,
                                          'accessToken': widget.accessToken,
                                          'customerId': widget.customerId,
                                        },
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                    ),
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
            return filteredOjekList.isEmpty
                ? Center(
                    child:
                        Text('Tidak ada Makanan yang sesuai dengan pencarian'),
                  )
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Two cards per row
                      childAspectRatio: 0.75,
                    ),
                    itemCount: filteredOjekList.length, // Number of items
                    itemBuilder: (context, index) {
                      final Ojek ojek = filteredOjekList[index];

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
                                        AppConstants.baseUrlImage +
                                            ojek.images.first,
                                        fit: BoxFit.cover,
                                        height: 120,
                                        width: double.infinity,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                      icon: isLoading
                                          ? SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : Icon(
                                              ojek.isFavorite
                                                  ? Icons.favorite
                                                  : Icons.favorite_outline,
                                              color: ojek.isFavorite
                                                  ? Colors.red[400]
                                                  : Colors.black,
                                            ),
                                      iconSize: 29.0,
                                      onPressed: isLoading
                                          ? null // Nonaktifkan tombol saat loading
                                          : () async {
                                              setState(() {
                                                isFavorite = !isFavorite;
                                                isLoading =
                                                    true; // Aktifkan loading
                                              });

                                              try {
                                                if (isFavorite) {
                                                  await _addToFavorite(ojek.id);
                                                }
                                              } finally {
                                                setState(() {
                                                  isLoading =
                                                      false; // Matikan loading
                                                });
                                              }
                                            },
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).popAndPushNamed(
                                      '/detail-ojek',
                                      arguments: {
                                        'ojekId': ojek.id,
                                        'nama': ojek.nama,
                                        'namaLengkap': ojek.namaLengkap,
                                        'alamat': ojek.alamat,
                                        'status': ojek.status,
                                        'gender': ojek.gender,
                                        'images': ojek.images,
                                        'accessToken': widget.accessToken,
                                        'customerId': widget.customerId,
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

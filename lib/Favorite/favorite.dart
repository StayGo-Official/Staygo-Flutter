// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, unused_field

import 'package:flutter/material.dart';
import 'package:staygo/kost/detailkost.dart';
import 'package:staygo/ojek/detailojek.dart';
import 'package:staygo/constants.dart';
import 'package:staygo/repository.dart';

class FavoritePage extends StatefulWidget {
  final String accessToken;
  final int customerId;

  const FavoritePage({Key? key, required this.accessToken, required this.customerId}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final FavoriteKostRepository favoriteRepo = FavoriteKostRepository();
  final FavoriteOjekRepository favoriteRepoOjek = FavoriteOjekRepository();

  late Future<List<dynamic>> _favoriteKost;
  late Future<List<dynamic>> _favoriteOjek;

  @override
  void initState() {
    super.initState();
    _favoriteKost = favoriteRepo.fetchFavoriteKost(widget.accessToken);
    _favoriteOjek = favoriteRepoOjek.fetchFavoriteOjek(widget.accessToken);
  }

  int _currentIndex = 0;

  String selectedOption = 'Ojek';

  Future<void> deleteFavoriteItem({
    required BuildContext context,
    required String accessToken,
    required int favoriteId,
    required String kostName,
    required List<dynamic> favoriteKostList,
    required int index,
  }) async {
    // Tampilkan dialog konfirmasi
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Favorit'),
        content:
            Text('Apakah Anda yakin ingin menghapus "$kostName" dari favorit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // Batal
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), // Hapus
            child: Text('Hapus'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      try {
        // Panggil fungsi repository untuk menghapus favorit
        final response = await favoriteRepo.deleteFavorite(
          accessToken: accessToken,
          favoriteId: favoriteId,
        );

        if (response['status'] == true) {
          // Hapus item dari UI
          favoriteKostList.removeAt(index);
          setState(() {});

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Favorit berhasil dihapus!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text(response['message'] ?? 'Gagal menghapus favorit')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
    }
  }

  Future<void> deleteFavoriteOjekItem({
    required BuildContext context,
    required String accessToken,
    required int favoriteId,
    required String ojekName,
    required List<dynamic> favoriteOjekList,
    required int index,
  }) async {
    // Tampilkan dialog konfirmasi
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Favorit'),
        content:
            Text('Apakah Anda yakin ingin menghapus "$ojekName" dari favorit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // Batal
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), // Hapus
            child: Text('Hapus'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      try {
        // Panggil fungsi repository untuk menghapus favorit
        final response = await favoriteRepoOjek.deleteFavorite(
          accessToken: accessToken,
          favoriteId: favoriteId,
        );

        if (response['status'] == true) {
          // Hapus item dari UI
          favoriteOjekList.removeAt(index);
          setState(() {});

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Favorit berhasil dihapus!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text(response['message'] ?? 'Gagal menghapus favorit')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
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
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
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
    return FutureBuilder<List<dynamic>>(
      future: _favoriteOjek, // Use the fetched favorite Ojek data
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No favorite ojek found'));
        } else {
          final favoriteOjekList = snapshot.data!;
          return SizedBox(
            height: 520,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
              ),
              itemCount: favoriteOjekList.length,
              itemBuilder: (context, index) {
                final ojekData = favoriteOjekList[index]['ojek'];
                return Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 109, 109, 109),
                          width: 2), // Border color
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
                                ), // Sesuaikan dengan radius yang diinginkan
                                child: Image.network(
                                  AppConstants.baseUrlImage +
                                      ojekData['images'][0],
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
                                  'Tersedia\n${ojekData['nama']} (${ojekData['gender']})',
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
                                  Icons.delete,
                                  color: Colors.blue,
                                ),
                                iconSize: 25.0,
                                onPressed: () {
                                  final favoriteId =
                                      favoriteOjekList[index]['id'];
                                  final ojekName = ojekData['nama'];

                                  // Panggil fungsi deleteFavoriteItem
                                  deleteFavoriteOjekItem(
                                    context: context,
                                    accessToken: widget.accessToken,
                                    favoriteId: favoriteId,
                                    ojekName: ojekName,
                                    favoriteOjekList: favoriteOjekList,
                                    index: index,
                                  );
                                },
                              ),
                            ],
                          ), // Memberikan sedikit ruang antara icon dan teks
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Detailojek(
                                    accessToken: widget.accessToken,
                                    customerId: widget.customerId,
                                    ojekId: ojekData['id'],
                                  ),
                                  settings: RouteSettings(arguments: ojekData),
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
      },
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
                      builder: (context) => DetailKost(
                        accessToken: widget.accessToken,
                        customerId: widget.customerId,
                        kostId: kost['id'],
                      ),
                      settings: RouteSettings(arguments: kost),
                    ),
                  );
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                    padding: const EdgeInsets.all(
                        15), // Padding inside the container
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image Section
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            AppConstants.baseUrlImage +
                                kost['images']
                                    [0], // First image from the URL array
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                            width: 15), // Space between image and text
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
                                      overflow: TextOverflow
                                          .ellipsis, // Prevent overflow
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize
                                        .min, // Row hanya selebar isi
                                    children: [
                                      // Icon Favorite Button
                                      GestureDetector(
                                        onTap: () {
                                          print('Favorite tapped');
                                        },
                                        child: const Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                          size: 24, // Ukuran ikon
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      // Icon Trash Button
                                      GestureDetector(
                                        onTap: () {
                                          final favoriteId =
                                              favoriteKostList[index]['id'];
                                          final kostName = kost['namaKost'];

                                          // Panggil fungsi deleteFavoriteItem
                                          deleteFavoriteItem(
                                            context: context,
                                            accessToken: widget.accessToken,
                                            favoriteId: favoriteId,
                                            kostName: kostName,
                                            favoriteKostList: favoriteKostList,
                                            index: index,
                                          );
                                        },
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.blue,
                                          size: 24, // Ukuran ikon
                                        ),
                                      ),
                                    ],
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
                                      overflow: TextOverflow
                                          .ellipsis, // Prevent overflow
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

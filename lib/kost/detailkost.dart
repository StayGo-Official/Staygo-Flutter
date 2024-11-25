// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:staygo/repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:staygo/constants.dart';

final Uri _whatsappUrl = Uri.parse(
    'https://api.whatsapp.com/send?phone=6281360903248&text=Halo%20saya%20mau%20bertanya%20tentang%20Kamar%20Kost%20nya');

class DetailKost extends StatefulWidget {
  final String accessToken;
  final int kostId;

  DetailKost({
    required this.accessToken,
    required this.kostId,
    Key? key,
  }) : super(key: key) {
    if (accessToken.isEmpty) {
      throw Exception('Access token is required');
    }
  }

  @override
  State<DetailKost> createState() => _DetailKostState();
}

class _DetailKostState extends State<DetailKost> {
  bool isFavorite = false;
  bool isLoading = false;

  final FavoriteKostRepository _repository = FavoriteKostRepository();

  Future<void> _addToFavorite() async {
    setState(() {
      isLoading = true; // Tampilkan indikator loading
    });

    try {
      // Panggil fungsi repository
      final response = await _repository.addFavorite(
        accessToken: widget.accessToken,
        kostId: widget.kostId,
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

  Future<void> _checkIfFavorite() async {
    try {
      final response = await _repository.checkIfFavorite(
        accessToken: widget.accessToken,
        kostId: widget.kostId,
      );

      // Periksa respons API
      if (response['status'] == true) {
        setState(() {
          isFavorite = true; // Jika sudah favorit, ubah status ke true
        });
      } else {
        setState(() {
          isFavorite = false; // Jika belum favorit, ubah status ke false
        });
      }
    } catch (error) {
      // Tangani error dengan mencetak ke konsol atau log
      print('Error checking favorite status: $error');
    }
  }

  int _currentIndex =
      0; // For tracking the index of the current page in the PageView

  Future<void> _launchGoogleMaps(double latitude, double longitude) async {
    final Uri url =
        Uri.parse('https://www.google.com/maps?q=$latitude,$longitude');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _launchWhatsApp() async {
    if (!await launchUrl(_whatsappUrl)) {
      throw Exception('Could not launch $_whatsappUrl');
    }
  }

  @override
  void initState() {
    super.initState();
    _checkIfFavorite(); // Periksa status favorit saat halaman dimuat
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? kostData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (kostData == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Detail Kost'),
        ),
        body: Center(
          child: Text('Data kost tidak tersedia'),
        ),
      );
    }

    List<String> imageUrls = (kostData['images'] as List<dynamic>?)
            ?.map((image) => AppConstants.baseUrlImage + image.toString())
            .toList() ??
        [];

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
                children: imageUrls.map((imageUrl) {
                  return Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  );
                }).toList(),
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
              children: List.generate(kostData['images'].length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: buildIndicator(
                      index == _currentIndex), // Check if this index is active
                );
              }),
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
                    kostData['namaKost'],
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
                          kostData['alamat'],
                          style: TextStyle(fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // Price Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rp. ' + kostData['hargaPerbulan'].toString(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '/Perbulan',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  // Price Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rp. ' + kostData['hargaPertahun'].toString(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '/Pertahun',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
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
                        kostData['tersedia'].toString() + ' Kamar Tersedia',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // Type of Kost
                  Text(
                    'Kost Khusus ' + kostData['gender'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),

                  SizedBox(height: 7),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Fasilitas',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  SizedBox(
                      height: 10), // Spacing between search bar and buttons

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: kostData['fasilitas']?.map<Widget>((facility) {
                          // Tentukan ikon berdasarkan nama fasilitas
                          String iconPath;
                          switch (facility.toLowerCase()) {
                            case 'wifi':
                              iconPath = 'assets/wifi-icon.png';
                              break;
                            case 'lemari':
                              iconPath = 'assets/icon-lemari.png';
                              break;
                            case 'ac':
                              iconPath = 'assets/icon-ac.png';
                              break;
                            case 'kasur':
                            case 'tempat tidur':
                              iconPath = 'assets/icon-tempat-tidur.png';
                              break;
                            case 'tv':
                            case 'televisi':
                              iconPath = 'assets/icon-tv.png';
                              break;
                            default:
                              iconPath =
                                  'assets/kamar-icon.png'; // Ikon default
                          }

                          return _buildCategoryButton(iconPath, facility);
                        }).toList() ??
                        [], // Jika null, tampilkan daftar kosong
                  ),

                  SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Kebijakan Properti',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPolicyItem(
                          '1. Seluruh fasilitas kost, hanya diperuntukkan bagi Penyewa kost/penyewa kamar, bukan untuk umum.'),
                      SizedBox(height: 5),
                      _buildPolicyItem(
                          '2. Penyewa kost dilarang menerima tamu dan/atau membawa teman ke kamar kost. Sebaiknya menerima tamu atau teman adalah di tempat terbuka atau tempat umum lainnya, seperti warung atau café/resto.'),
                      SizedBox(height: 5),
                      _buildPolicyItem(
                          '3. Penyewa kost tidak diperkenankan merokok di dalam kamar maupun di lingkungan rumah kost.'),
                    ],
                  ),

                  SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Deskripsi Properti',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    kostData['deskripsi'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),

                  SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Detail Lokasi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    kostData['alamat'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),

                  Center(
                    child: TextButton(
                      onPressed: () {
                        final latitude = kostData['latitude'];
                        final longitude = kostData['longitude'];

                        // Pastikan latitude dan longitude tersedia
                        if (latitude != null && longitude != null) {
                          _launchGoogleMaps(latitude, longitude);
                        } else {
                          // Tampilkan pesan kesalahan jika data tidak tersedia
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Lokasi tidak tersedia'),
                            ),
                          );
                        }
                      },
                      child: Text(
                        'Buka Google Maps',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 40),

                  Text(
                    '',
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                child: ElevatedButton(
                  onPressed: _launchWhatsApp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF06283D), // Warna tombol
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50), // Sudut membulat
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: 15), // Tinggi tombol "Pesan Kost"
                  ),
                  child: Text(
                    'Pesan Kost',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10), // Spasi antara tombol
            FloatingActionButton(
              onPressed: isLoading
                  ? null
                  : _addToFavorite, // Panggil fungsi tambah favorit
              backgroundColor: Colors.white, // Warna tombol favorit
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50), // Sudut membulat
              ),
              child: isLoading
                  ? CircularProgressIndicator(
                      color: Colors
                          .red, // Indikator loading jika proses sedang berjalan
                    )
                  : Icon(
                      isFavorite
                          ? Icons.favorite
                          : Icons
                              .favorite_border, // Ubah ikon berdasarkan status favorit
                      color: isFavorite
                          ? Colors.red
                          : Colors.grey, // Warna sesuai status favorit
                    ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // Widget to build carousel page indicators
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

  // Widget to build each policy item
  Widget _buildPolicyItem(String policyText) {
    return Text(
      policyText,
      style: TextStyle(
        fontSize: 14,
        color: Colors.black54, // Reduced opacity for a lighter color
      ),
    );
  }
}

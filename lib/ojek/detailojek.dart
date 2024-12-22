import 'package:flutter/material.dart';
import 'package:staygo/ojek/formpembayaran.dart';
import 'package:staygo/repository.dart';
import 'package:staygo/constants.dart';

class Detailojek extends StatefulWidget {
  final String accessToken;
  final String nama;
  final String noHp;
  final int customerId;
  final int ojekId;

  Detailojek({
    required this.accessToken,
    required this.nama,
    required this.noHp,
    required this.customerId,
    required this.ojekId,
    Key? key,
  }) : super(key: key) {
    if (accessToken.isEmpty) {
      throw Exception('Access token is required');
    }
  }

  @override
  State<Detailojek> createState() => _DetailojekState();
}

class _DetailojekState extends State<Detailojek> {
  int _currentIndex = 0;

  bool isLoading = false;
  bool isLoadingOrder = false;

  String username = '';
  String nama = '';
  String email = '';
  String noHp = '';
  String alamat = '';
  String ttl = '';
  bool isVerified = false;
  String image = '';

  final OrderOjekRepository _repositoryOrderOjek = OrderOjekRepository();

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
          isVerified = data['isVerified'] ?? false; // Ensure boolean value
          image = data['image'] ?? '';
        });
      } else {
        // Handle error if profile is not found
        setState(() {
          isVerified = false; // Default to false if not found
        });
      }
    } catch (e) {
      // Handle error in fetching profile
      print('Error fetching profile: $e');
    }
  }

  Future<void> _menuPembayaran() async {
    setState(() {
      isLoadingOrder = true; // Tampilkan indikator loading
    });
    final Map<String, dynamic> ojekData = 
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    if (!isVerified) {
      // Show alert dialog asking the user to verify their email
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Verifikasi Email"),
            content: Text("Silahkan Verifikasi Email Terlebih dahulu"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text("Tutup"),
              ),
            ],
          );
        },
      );
    } else {
      
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FormPembayaran(accessToken: widget.accessToken, customerId: widget.customerId, ojekId: widget.ojekId, nama: widget.nama, noHp: ojekData['noHp'] ?? '',)),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> ojekData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    List<String> imageUrls = ojekData['images']
        .map<String>((image) =>
            AppConstants.baseUrlImage + image) // Gabungkan dengan baseUrlImage
        .toList();

    if (ojekData == null) {
      print("Data tidak tersedia");
      return Scaffold(body: Center(child: Text("Data tidak ditemukan")));
    }

    print(ojekData); // Cek isi ojekData
    String namaLengkap = ojekData['namaLengkap'] ?? 'Tidak ada data';

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
              children: List.generate(ojekData['images'].length, (index) {
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
                    ojekData['nama'],
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
                          ojekData['alamat'],
                          style: TextStyle(fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  // Rating Row
                  // Row(
                  //   children: [
                  //     Icon(Icons.star, size: 20, color: Colors.orange),
                  //     SizedBox(width: 5),
                  //     Text(
                  //       '4,5/5 (100 reviewers)',
                  //       style: TextStyle(fontSize: 14),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(height: 10),

                  // Availability Row
                  Row(
                    children: [
                      Icon(Icons.check_circle, size: 20, color: Colors.green),
                      SizedBox(width: 5),
                      Text(
                        ojekData['status'] ? 'Tersedia' : 'Tidak Tersedia',
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
                    'Nama Lengkap: ' + namaLengkap,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),

                  Text(
                    'Jenis Kelamin: ' + ojekData['gender'],
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
            onPressed: _menuPembayaran,
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

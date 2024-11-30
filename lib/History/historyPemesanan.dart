// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_const_constructors_in_immutables, use_super_parameters

import 'package:flutter/material.dart';
import 'package:staygo/constants.dart';
import 'package:staygo/ojek/detailojek.dart';
import 'package:staygo/repository.dart';

class HistoryPemesanan extends StatefulWidget {
  final String accessToken;
  final int customerId;
  const HistoryPemesanan(
      {Key? key, required this.accessToken, required this.customerId})
      : super(key: key);

  @override
  _HistoryPemesananState createState() => _HistoryPemesananState();
}

class _HistoryPemesananState extends State<HistoryPemesanan> {
  String selectedOption = 'Ojek';

  int _currentIndex = 0;

  final OrderKostRepository orderRepo = OrderKostRepository();
  final OrderOjekRepository orderRepoOjek = OrderOjekRepository();

  late Future<List<dynamic>> _orderKost;
  late Future<List<dynamic>> _orderOjek;

  @override
  void initState() {
    super.initState();
    _orderKost = orderRepo.fetchOrderKost(widget.accessToken);
    _orderOjek = orderRepoOjek.fetchOrderOjek(widget.accessToken);
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
        title: Text('History'),
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
    return FutureBuilder<List<dynamic>>(
      future: _orderOjek, // Use the fetched order Ojek data
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No order ojek found'));
        } else {
          final orderOjekList = snapshot.data!.reversed.toList();
          return SizedBox(
            height: 520,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
              ),
              itemCount: orderOjekList.length,
              itemBuilder: (context, index) {
                final ojekData = orderOjekList[index]['ojek'];
                return Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Container(
                    // Your existing Ojek grid item code
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
                              ],
                            ), // Memberikan sedikit ruang antara icon dan teks
                            Expanded(
                              // Allow text to expand and wrap
                              child: Text(
                                'Terima Kasih telah menggunakan jasa kami!',
                                style: TextStyle(
                                  color: Color(0xFF06283D),
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
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
      future: _orderKost, // Use the fetched order kost data
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No order kost found'));
        } else {
          final orderKostList = snapshot.data!.reversed.toList();
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orderKostList.length,
            itemBuilder: (context, index) {
              final kost = orderKostList[index]['kost']; // Access kost data
              return Padding(
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
                  padding:
                      const EdgeInsets.all(15), // Padding inside the container
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
                                    overflow: TextOverflow
                                        .ellipsis, // Prevent overflow
                                  ),
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
              );
            },
          );
        }
      },
    );
  }
}

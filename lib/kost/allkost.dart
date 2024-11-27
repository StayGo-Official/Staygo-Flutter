import 'package:flutter/material.dart';
import 'package:staygo/constants.dart';
import 'package:staygo/models.dart';
import 'package:staygo/repository.dart';

class AllKost extends StatefulWidget {
  final String accessToken;

  const AllKost({Key? key, required this.accessToken}) : super(key: key);

  @override
  State<AllKost> createState() => _AllKostState();
}

class _AllKostState extends State<AllKost> {
  late Future<List<Kost>> kostList;

  String searchQuery = '';
  List<Kost> originalKostList = [];
  List<Kost> filteredKostList = [];
  bool isAscending = true;

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

  void filterByCategory(String category) {
    setState(() {
      if (category == 'Termurah') {
        filteredKostList = List.from(originalKostList)
          ..sort((a, b) => isAscending
              ? a.hargaPertahun.compareTo(b.hargaPertahun)
              : b.hargaPertahun.compareTo(a.hargaPertahun));
        isAscending = !isAscending; // Toggle sorting order
      } else if (category == 'Tahunan') {
        filteredKostList =
            originalKostList.where((kost) => kost.hargaPertahun > 0).toList();
      } else if (category == 'Bulanan') {
        filteredKostList =
            originalKostList.where((kost) => kost.hargaPerbulan > 0).toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar and buttons
            SizedBox(height: 25),

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
                      GestureDetector(
                        onTap: () => filterByCategory('Termurah'),
                        child: _buildCategoryButton(
                            'assets/termurah.png', 'Termurah'),
                      ),
                      GestureDetector(
                        onTap: () => filterByCategory('Tahunan'),
                        child: _buildCategoryButton(
                            'assets/tahunan.png', 'Tahunan'),
                      ),
                      GestureDetector(
                        onTap: () => filterByCategory('Bulanan'),
                        child: _buildCategoryButton(
                            'assets/kalender.png', 'Bulanan'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Kost Terbaik',
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
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: 520,
              child: filteredKostList.isEmpty
                  ? Center(
                      child:
                          Text('Tidak ada kost yang sesuai dengan pencarian'),
                    )
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Two cards per row
                        childAspectRatio: 0.70,
                      ),
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

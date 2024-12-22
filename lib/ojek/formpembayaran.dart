// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:staygo/models.dart';
import 'package:staygo/ojek/midtrans.dart';
import 'package:staygo/repository.dart';
import 'package:google_fonts/google_fonts.dart';

class FormPembayaran extends StatefulWidget {
  final String accessToken;
  final String nama;
  final String noHp;
  final int customerId;
  final int ojekId;

  FormPembayaran({
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
  State<FormPembayaran> createState() => _FormPembayaranState();
}

class _FormPembayaranState extends State<FormPembayaran> {
  String email = '';
  bool isLoading = true;

  String selectedLocation = 'Kota Lhokseumawe';
  List<String> locations = [
    'Kota Lhokseumawe',
    'Blang Pulo',
    'Krueng Geukeuh',
    'Bukit Indah',
    'Simpang Len',
    'Bathupat',
  ];

  String selectedDestination = 'Kota Lhokseumawe';
  List<String> Destinations = [
    'Kota Lhokseumawe',
    'Blang Pulo',
    'Krueng Geukeuh',
    'Bukit Indah',
    'Simpang Len',
    'Bathupat',
  ];

  int calculatePrice(String location, String destination) {
    if (location == 'Kota Lhokseumawe') {
      switch (destination) {
        case 'Kota Lhokseumawe':
          return 10000;
        case 'Blang Pulo':
          return 15000;
        case 'Krueng Geukeuh':
          return 20000;
        case 'Bukit Indah':
          return 15000;
        case 'Simpang Len':
          return 12000;
        case 'Bathupat':
          return 15000;
        default:
          return 10000;
      }
    } else if (location == 'Blang Pulo') {
      switch (destination) {
        case 'Kota Lhokseumawe':
          return 15000;
        case 'Blang Pulo':
          return 8000;
        case 'Krueng Geukeuh':
          return 12000;
        case 'Bukit Indah':
          return 10000;
        case 'Simpang Len':
          return 10000;
        case 'Bathupat':
          return 10000;
        default:
          return 10000;
      }
    } else if (location == 'Krueng Geukeuh') {
      switch (destination) {
        case 'Kota Lhokseumawe':
          return 20000;
        case 'Blang Pulo':
          return 15000;
        case 'Krueng Geukeuh':
          return 10000;
        case 'Bukit Indah':
          return 15000;
        case 'Simpang Len':
          return 15000;
        case 'Bathupat':
          return 13000;
        default:
          return 10000;
      }
    } else if (location == 'Bukit Indah') {
      switch (destination) {
        case 'Kota Lhokseumawe':
          return 15000;
        case 'Blang Pulo':
          return 10000;
        case 'Krueng Geukeuh':
          return 15000;
        case 'Bukit Indah':
          return 8000;
        case 'Simpang Len':
          return 10000;
        case 'Bathupat':
          return 10000;
        default:
          return 10000;
      }
    } else if (location == 'Bathupat') {
      switch (destination) {
        case 'Kota Lhokseumawe':
          return 17000;
        case 'Blang Pulo':
          return 10000;
        case 'Krueng Geukeuh':
          return 13000;
        case 'Bukit Indah':
          return 10000;
        case 'Simpang Len':
          return 10000;
        case 'Bathupat':
          return 8000;
        default:
          return 10000;
      }
    } else if (location == 'Simpang Len') {
      switch (destination) {
        case 'Kota Lhokseumawe':
          return 15000;
        case 'Blang Pulo':
          return 10000;
        case 'Krueng Geukeuh':
          return 15000;
        case 'Bukit Indah':
          return 10000;
        case 'Simpang Len':
          return 8000;
        case 'Bathupat':
          return 10000;
        default:
          return 10000;
      }
    }
    return 10000; // Default if no match
  }

  Future<void> _fetchProfile() async {
    try {
      final repository = CustomerRepository();
      final response =
          await repository.getProfile(widget.customerId, widget.accessToken);

      if (response['status']) {
        final data = response['data'];
        setState(() {
          email = data['email'] ?? '';
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

  Future<void> _addOrderOjekAndProceedToPayment() async {
    final price = calculatePrice(selectedLocation, selectedDestination);

    // Panggil API untuk menambah order ojek
    try {
      final orderRepository = OrderOjekRepository();
      final orderResponse = await orderRepository.addOrder(
        accessToken: widget.accessToken,
        ojekId: widget.ojekId,
        harga: price,
        lokasi: selectedLocation,
        tujuan: selectedDestination,
      );

      if (orderResponse['status'] == true) {
        // Jika order berhasil ditambahkan, lanjutkan ke pembayaran
        final int orderId = orderResponse['data']['id'];

        _paymentOjek(price, orderId);
      } else {
        // Jika gagal menambahkan order, tampilkan pesan error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(orderResponse['message'])),
        );
      }
    } catch (error) {
      print('Error adding order ojek: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add order. Please try again.')),
      );
    }
  }

  // Fungsi untuk melakukan pembayaran ojek
  Future<void> _paymentOjek(int price, int orderId) async {
    try {
      final PaymentRepository paymentRepository = PaymentRepository();
      final MidtransResponse response = await paymentRepository.createPayment(
        ojekId: widget.ojekId,
        nama: widget.nama,
        price: price,
      );

      if (response.status) {
        print("Payment URL: ${response.redirect_url}");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Midtrans(
              url: response.redirect_url,
              accessToken: widget.accessToken,
              noHp: widget.noHp,
              customerId: widget.customerId,
              orderId: orderId,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
      }
    } catch (error) {
      print("Payment Error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to process payment. Please try again.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Panggil API untuk mendapatkan data terbaru
    _fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
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
        title: Text('Form Pembayaran'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('assets/pay.jpg'),
              Text(
                textAlign: TextAlign.center,
                'Konfirmasi Pembayaran',
                style: GoogleFonts.urbanist(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontSize: 27.0,
                ),
              ),
              Text(
                textAlign: TextAlign.center,
                'Dari:',
                style: GoogleFonts.urbanist(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.location_city, color: Colors.grey),
                  SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedLocation,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                        ),
                      ),
                      items: locations.map((String location) {
                        return DropdownMenuItem<String>(
                          value: location,
                          child: Text(location),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedLocation = newValue!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8.0,
              ),
              Text(
                textAlign: TextAlign.center,
                'Tujuan ke?',
                style: GoogleFonts.urbanist(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.location_city, color: Colors.grey),
                  SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedDestination,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                        ),
                      ),
                      items: locations.map((String location) {
                        return DropdownMenuItem<String>(
                          value: location,
                          child: Text(location),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedDestination = newValue!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Anda memesan ojek atas nama ',
                      style: GoogleFonts.urbanist(
                        fontSize: 14.0,
                        color: const Color(0xff808d9e),
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                    TextSpan(
                      text: widget.nama,
                      style: GoogleFonts.urbanist(
                        fontSize: 14.0,
                        color: const Color(0xff005BE0),
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                    TextSpan(
                      text: " total harga yang dibayar ",
                      style: GoogleFonts.urbanist(
                        fontSize: 14.0,
                        color: const Color(0xff808d9e),
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                    TextSpan(
                      text:
                          '${calculatePrice(selectedLocation, selectedDestination)}',
                      style: GoogleFonts.urbanist(
                        fontSize: 14.0,
                        color: const Color(0xff005BE0),
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 16.0), // Adjust padding if needed
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _addOrderOjekAndProceedToPayment,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF06283D), // Same color as given
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50), // Rounded corners
              ),
              padding:
                  EdgeInsets.symmetric(vertical: 15), // Height of the button
            ),
            child: Text(
              'Bayar Sekarang',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

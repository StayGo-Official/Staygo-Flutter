// ignore_for_file: avoid_single_cascade_in_expression_statements

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:staygo/navigationBottom.dart';
import 'package:staygo/repository.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri _whatsappUrl = Uri.parse(
    'https://api.whatsapp.com/send?phone=6281264384767&text=Halo%20saya%20mau%20pesan%20Ojek');

class PaymentSuccess extends StatefulWidget {
  final String accessToken;
  final int orderId;
  final int customerId;
  
  const PaymentSuccess({Key? key, required this.accessToken, required this.orderId, required this.customerId}) : super(key: key);

  @override
  State<PaymentSuccess> createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {
  bool _isDialogShown = false;

  Future<void> _updateOrderStatusToSuccess() async {
    final orderRepository = OrderOjekRepository();

    try {
      final response = await orderRepository.updateOrderStatusSuccess(
        accessToken: widget.accessToken,
        orderId: widget.orderId,  // Pass the orderId to update
      );

      if (response['status'] == true) {
        print("Order status updated to success");
      } else {
        print("Failed to update order status: ${response['message']}");
      }
    } catch (error) {
      print("Error updating order status: $error");
    }
  }

  @override
  void initState() {
    super.initState();
    if (!_isDialogShown) {
      _isDialogShown = true;
      // Menampilkan dialog setelah frame pertama selesai
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.rightSlide,
          title: 'Payment Success',
          desc: 'Selamat Pembayaran Berhasil dilakukan',
          btnOkOnPress: () async {

            await _updateOrderStatusToSuccess();

            if (!await launchUrl(_whatsappUrl)) {
              throw Exception('Could not launch $_whatsappUrl');
            }

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return BottomNavigation(
                    accessToken: widget.accessToken,
                    customerId: widget.customerId,
                  );
                },
              ),
            );

          },
        )..show();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Pastikan background putih
    );
  }
}

// ignore_for_file: avoid_single_cascade_in_expression_statements

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:staygo/Beranda/beranda.dart';
import 'package:staygo/navigationBottom.dart';
import 'package:staygo/repository.dart';

class PaymentFailed extends StatefulWidget {
  final int customerId;
  final String accessToken;
  final int orderId;

  const PaymentFailed({Key? key, required this.accessToken, required this.customerId, required this.orderId,}) : super(key: key);

  @override
  State<PaymentFailed> createState() => _PaymentFailedState();
}

class _PaymentFailedState extends State<PaymentFailed> {
  bool _isDialogShown = false;

  // Function to send PATCH request to update the order status to failed
  Future<void> _updateOrderStatusToFailed() async {
    final orderRepository = OrderOjekRepository();

    try {
      final response = await orderRepository.updateOrderStatusFailed(
        accessToken: widget.accessToken,
        orderId: widget.orderId,  // Pass the orderId to update
      );

      if (response['status'] == true) {
        print("Order status updated to failed");
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
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'Payment Failed',
          desc: 'Maaf Pembayaran Anda Gagal dilakukan',
          btnOkOnPress: () async {

            await _updateOrderStatusToFailed();

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
      backgroundColor: Colors.white,  // Pastikan background putih
      body: Center(
        child: Text(
          'Payment Failed',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

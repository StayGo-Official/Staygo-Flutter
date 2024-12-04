import 'package:flutter/material.dart';
import 'package:staygo/ojek/payments/paymentfailed.dart';
import 'package:staygo/ojek/payments/paymentsuccess.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Midtrans extends StatefulWidget {
  final String url;
  final int customerId;
  final String accessToken;
  final int orderId;

  const Midtrans(
      {Key? key,
      required this.url,
      required this.customerId,
      required this.accessToken,
      required this.orderId,})
      : super(key: key);

  @override
  State<Midtrans> createState() => _MidtransState();
}

class _MidtransState extends State<Midtrans> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            print('onPageStarted: $url');
            if (url.contains('status_code=202')) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return PaymentFailed(
                      accessToken: widget.accessToken,
                      customerId: widget.customerId,
                      orderId: widget.orderId,
                    );
                  },
                ),
              );
            }
            if (url.contains('status_code=201')) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return PaymentFailed(
                      accessToken: widget.accessToken,
                      customerId: widget.customerId,
                      orderId: widget.orderId,
                    );
                  },
                ),
              );
            }
            if (url.contains('status_code=200&transaction_status=settlement')) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return PaymentSuccess(accessToken: widget.accessToken, orderId: widget.orderId, customerId: widget.customerId,);
                  },
                ),
              );
            }
          },
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));

    print("Loading URL: ${widget.url}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: controller),
    );
  }
}

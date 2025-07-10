import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BookingWebViewScreen extends StatefulWidget {
  final String url;

  const BookingWebViewScreen({super.key, required this.url});

  @override
  State<BookingWebViewScreen> createState() => _BookingWebViewScreenState();
}

class _BookingWebViewScreenState extends State<BookingWebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('تفاصيل الحجز')),
      body: SafeArea(
        child: WebViewWidget(
          controller: _controller,
        ),
      ),
    );
  }
}

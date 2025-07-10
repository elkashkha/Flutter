import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'offers_details_body.dart';

class OffersDetails extends StatelessWidget {
  const OffersDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: const OffersDetailsBody(),
    );
  }
}

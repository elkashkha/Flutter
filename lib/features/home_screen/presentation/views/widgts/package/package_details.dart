import 'package:elkashkha/features/home_screen/presentation/views/widgts/package/package_details_body.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class PackageDetails extends StatelessWidget {
  const PackageDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,),

      backgroundColor: Colors.white,
      body: const PackageDetailsBody(),
    );
  }
}

import 'package:elkashkha/core/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ListProjects extends StatelessWidget {
  const ListProjects({super.key});

  final List<String> images = const [
    "assets/images/undraw_celebrating_2aox 1.png",
    "assets/images/undraw_celebrating_2aox 1.png",
    "assets/images/undraw_celebrating_2aox 1.png",
    "assets/images/undraw_celebrating_2aox 1.png",
    "assets/images/undraw_celebrating_2aox 1.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                'اعمالك',
                style: GoogleFonts.notoKufiArabic(
                    color:AppTheme.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.add,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'اضافة صور',
                      style: GoogleFonts.notoKufiArabic(
                        color: Colors.grey[800],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )

            ],
          ),
        ),        SizedBox(
          height: 71,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10), // البوردر
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      images[index],
                      fit: BoxFit.cover,
                      height: 71,
                      width: 71,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

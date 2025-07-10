import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/app_theme.dart';

class RateService extends StatelessWidget {
  final String name;
  final int rating;
  final String comment;
  final String userImage;
  final String reviewDate;

  const RateService({
    super.key,
    required this.name,
    required this.rating,
    required this.comment,
    required this.userImage,
    required this.reviewDate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Color(0xfffcfcfc),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  color: Colors.white54,
                  width: 107,
                  height: 23,
                  child: Center(
                    child: Text(
                      name,
                      style: GoogleFonts.tajawal(
                        textStyle: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.primary,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(userImage),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 50.0, top: 2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: List.generate(
                      5,
                          (index) => Icon(
                        index < rating
                            ? CupertinoIcons.star_fill
                            : CupertinoIcons.star,
                        color: Colors.amber,
                        size: 18,
                      ),
                    ),
                  ),
                  Text(
                    comment.isNotEmpty ? comment : 'لا توجد تعليقات',
                    style: GoogleFonts.tajawal(
                      textStyle: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.primary,
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    textAlign: TextAlign.right,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      'تاريخ المراجعة: $reviewDate',
                      style: GoogleFonts.tajawal(
                        textStyle: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.primary,
                          height: 1.5,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
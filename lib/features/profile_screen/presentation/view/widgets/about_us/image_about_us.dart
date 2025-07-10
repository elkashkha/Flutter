import 'package:flutter/material.dart';

class ImageGrid extends StatelessWidget {
  final List<String> imageUrls;

  const ImageGrid({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,

      ),
      itemCount: imageUrls.length,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(_getBorderRadius(index)),
          child: Image.network(

            imageUrls[index],
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  double _getBorderRadius(int index) {
    switch (index) {
      case 0:
        return 30;
      case 1:
        return 100;
      case 2:
        return 20;
      case 3:
        return 50;
      default:
        return 10;
    }
  }
}

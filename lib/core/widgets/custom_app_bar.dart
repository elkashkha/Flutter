import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;

  const CustomAppBar({super.key, required this.title, this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      backgroundColor: isDark ? const Color(0xff151414) : Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: onBackPressed != null
          ? IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: isDark ? Colors.white : Colors.black),
        onPressed: onBackPressed ?? () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
      )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

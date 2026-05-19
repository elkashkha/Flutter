import 'package:flutter/cupertino.dart';

class LogoScissors extends StatelessWidget {
  const LogoScissors({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/shiny-scissors-VUXIdfPWUO.png',
          height: 40,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 8),
        Image.asset(
          'assets/images/55b1adc337b9fd5c644cf814642fffae37ec9020.png',
          height: 75,
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}

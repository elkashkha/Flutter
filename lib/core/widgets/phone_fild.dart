import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../../core/app_theme.dart';


class PhoneNumberField extends StatefulWidget {
  final TextEditingController controller;
  final Function(PhoneNumber) onChanged;

  const PhoneNumberField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  _PhoneNumberFieldState createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  late PhoneNumber _phoneNumber;
  String phoneCode = '+20';

  @override
  void initState() {
    super.initState();
    _phoneNumber = PhoneNumber(isoCode: 'EG');
    widget.controller.text = '';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.94,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: InternationalPhoneNumberInput(
        cursorColor: AppTheme.gray,
        onInputChanged: (PhoneNumber number) {
          setState(() {
            phoneCode = number.dialCode ?? '+20';
          });
          widget.controller.text = number.phoneNumber ?? '';
          widget.onChanged(number);
        },
        onInputValidated: (bool isValid) {
          debugPrint("Phone Number Valid: $isValid");
        },
        selectorConfig: const SelectorConfig(
          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
          setSelectorButtonAsPrefixIcon: false,
          useEmoji: true,
        ),
        ignoreBlank: false,
        textAlign: TextAlign.right,
        autoValidateMode: AutovalidateMode.onUserInteraction,
        selectorTextStyle: const TextStyle(color: Colors.black),
        textStyle: const TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        inputDecoration: InputDecoration(
          hintStyle: const TextStyle(color: AppTheme.gray),
          hintText: AppLocalizations.of(context)!.phone_number,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppTheme.gray, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppTheme.gray, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppTheme.gray, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        keyboardType: TextInputType.phone,
        initialValue: _phoneNumber,
      ),
    );
  }
}
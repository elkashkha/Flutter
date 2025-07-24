import 'package:elkashkha/core/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class CustomTimePicker extends StatefulWidget {
  final Function(TimeOfDay?) onTimeSelected;
  final TimeOfDay? initialTime;
  final String? hintText;

  const CustomTimePicker({
    Key? key,
    required this.onTimeSelected,
    this.initialTime,
    this.hintText,
  }) : super(key: key);

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    selectedTime = widget.initialTime;
  }

  String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final format = DateFormat('HH:mm'); // ✅ صيغة مقبولة من الـ API
    return format.format(dt);
  }



  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
      widget.onTimeSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return GestureDetector(
      onTap: () => _selectTime(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.gray ,width: 1.5),
        ),
        child: Row(
          children: [
            Icon(Icons.access_time, color: Colors.grey.shade700),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                selectedTime != null
                    ? formatTimeOfDay(selectedTime!)
                    : widget.hintText ?? localizations?.enter_time ?? 'Select Time',
                style: TextStyle(
                  fontSize: 16,
                  color: selectedTime != null
                      ? Colors.black87
                      : Colors.grey.shade600,
                ),
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  final Function(DateTime?)? onDateSelected;

  const CustomDatePicker({super.key, this.onDateSelected});

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime _selectedDay = DateTime.now();
  late List<DateTime> _daysInMonth;

  @override
  void initState() {
    super.initState();
    _generateDaysInMonth(_selectedDay);
  }

  void _generateDaysInMonth(DateTime month) {
    int daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    _daysInMonth = List.generate(
      daysInMonth,
      (index) => DateTime(month.year, month.month, index + 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final DateFormat monthFormat = DateFormat('MMMM', locale);
    final DateFormat dayNameFormat = DateFormat('EEEE', locale);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              localization.select_date, // Or custom text "اختر اليوم"
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            Row(
              children: [
                Icon(Icons.arrow_drop_down, color: isDark ? Colors.white70 : Colors.grey),
                Text(
                  monthFormat.format(_selectedDay),
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.white70 : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            reverse: locale == 'ar', // Scroll from right to left in Arabic
            itemCount: _daysInMonth.length,
            itemBuilder: (context, index) {
              final day = _daysInMonth[index];
              final isSelected = DateUtils.isSameDay(day, _selectedDay);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDay = day;
                  });
                  if (widget.onDateSelected != null) {
                    widget.onDateSelected!(day);
                  }
                },
                child: Container(
                  width: 70,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: isSelected
                      ? BoxDecoration(
                          border: Border.all(color: isDark ? Colors.white : Colors.black, width: 1.5),
                          borderRadius: BorderRadius.circular(35),
                        )
                      : null,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dayNameFormat.format(day),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected 
                              ? (isDark ? Colors.white : Colors.black) 
                              : (isDark ? Colors.white38 : Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${day.day}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected 
                              ? (isDark ? Colors.white : Colors.black) 
                              : (isDark ? Colors.white38 : Colors.grey),
                        ),
                      ),
                    ],
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

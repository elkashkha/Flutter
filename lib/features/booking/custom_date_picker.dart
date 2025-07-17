import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDatePicker extends StatefulWidget {
  final Function(DateTime?)? onDateSelected;

  const CustomDatePicker({super.key, this.onDateSelected});

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          localization.select_date,
          style: GoogleFonts.tajawal(
            textStyle: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.040,
              color: Colors.white,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2050, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.grey.shade700,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: const TextStyle(color: Colors.black),
              weekendTextStyle: const TextStyle(color: Colors.grey),
              defaultTextStyle: const TextStyle(color: Colors.white),
            ),
            headerStyle: HeaderStyle(
              titleTextStyle: GoogleFonts.tajawal(
                textStyle: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              formatButtonVisible: false,
              titleCentered: true,
              leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.white),
              rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.white),
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekendStyle: TextStyle(color: Colors.grey),
              weekdayStyle: TextStyle(color: Colors.white),
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              if (widget.onDateSelected != null) {
                widget.onDateSelected!(selectedDay);
              }
            },
          ),
        ),
      ],
    );
  }
}

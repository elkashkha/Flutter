import 'package:flutter/material.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/app_theme.dart';
import '../../core/change_language_cubit/change_language_cubit.dart';

class CustomDatePicker extends StatefulWidget {
  final Function(DateTime?)? onDateSelected;

  const CustomDatePicker({super.key, this.onDateSelected});

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    final languageCode = context.watch<LanguageCubit>().state.languageCode;

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
            height: 170,
            width: 343,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: EasyDateTimeLine(
              initialDate: selectedDate,
              onDateChange: (newDate) {
                setState(() {
                  selectedDate = newDate;
                });
                if (widget.onDateSelected != null) {
                  widget.onDateSelected!(newDate);
                }
              },
              headerProps: EasyHeaderProps(
                monthPickerType: MonthPickerType.switcher,
                selectedDateFormat: SelectedDateFormat.fullDateDMY,
                showSelectedDate: true,
                selectedDateStyle: GoogleFonts.tajawal(
                  textStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                monthStyle: GoogleFonts.tajawal(
                  textStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              dayProps: const EasyDayProps(
                height: 60,
                width: 46,
                todayHighlightStyle: TodayHighlightStyle.none,
                todayStyle: DayStyle(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  dayStrStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  monthStrStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                inactiveDayStyle: DayStyle(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  dayStrStyle: TextStyle(color: Colors.grey),
                  monthStrStyle: TextStyle(color: Colors.grey),
                ),
                activeDayStyle: DayStyle(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  dayStrStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  monthStrStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              activeColor: Colors.white,
              locale: languageCode,
            )),
      ],
    );
  }
}

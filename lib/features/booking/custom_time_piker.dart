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
  final List<TimeOfDay> _availableTimes = [];
  final ScrollController _scrollController = ScrollController();
  bool _isUserScrolling = false;

  @override
  void initState() {
    super.initState();
    selectedTime = widget.initialTime;
    _generateTimes();

    // Defer jumping to initial time until the layout is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (selectedTime != null) {
        int index = _availableTimes.indexOf(selectedTime!);
        if (index != -1 && _scrollController.hasClients) {
          _scrollController.jumpTo(index * 50.0);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _generateTimes() {
    for (int i = 9; i <= 23; i++) {
      _availableTimes.add(TimeOfDay(hour: i, minute: 0));
      _availableTimes.add(TimeOfDay(hour: i, minute: 30));
    }
  }

  String formatTimeOfDay(TimeOfDay time, BuildContext context) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final locale = Localizations.localeOf(context).languageCode;
    final format = DateFormat('hh:mm a', locale);
    return format.format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "اختر الوقت", // Fallback if no localization is available for this exact phrase
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        if (selectedTime != null)
          Center(
            child: Text(
              formatTimeOfDay(selectedTime!, context),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          )
        else
          Center(
            child: Text(
              widget.hintText ?? localization.enter_time,
              style: TextStyle(fontSize: 16, color: isDark ? Colors.white60 : Colors.grey.shade600),
            ),
          ),
        const SizedBox(height: 8),
        Center(
          child: Container(
            width: 2,
            height: 10,
            color: isDark ? Colors.white : Colors.black,
            margin: const EdgeInsets.only(bottom: 2),
          ),
        ),
        SizedBox(
          height: 60,
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              if (notification is ScrollStartNotification) {
                _isUserScrolling = true;
              } else if (notification is ScrollUpdateNotification) {
                if (_isUserScrolling) {
                  double offset = _scrollController.offset;
                  int index = (offset / 50).round();
                  if (index < 0) index = 0;
                  if (index >= _availableTimes.length)
                    index = _availableTimes.length - 1;

                  final newTime = _availableTimes[index];
                  if (selectedTime != newTime) {
                    setState(() {
                      selectedTime = newTime;
                    });
                    widget.onTimeSelected(newTime);
                  }
                }
              } else if (notification is ScrollEndNotification) {
                _isUserScrolling = false;
                double offset = _scrollController.offset;
                int index = (offset / 50).round();
                if (index < 0) index = 0;
                if (index >= _availableTimes.length)
                  index = _availableTimes.length - 1;

                Future.microtask(() {
                  if (_scrollController.hasClients) {
                    _scrollController.animateTo(
                      index * 50.0,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                    );
                  }
                });
              }
              return false;
            },
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              reverse: locale == 'ar',
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 2 - 25),
              itemCount: _availableTimes.length,
              itemBuilder: (context, index) {
                final time = _availableTimes[index];
                final isSelected = selectedTime == time;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTime = time;
                    });
                    widget.onTimeSelected(time);
                    if (_scrollController.hasClients) {
                      _scrollController.animateTo(
                        index * 50.0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Container(
                    width: 50,
                    color: Colors.transparent, // to make tap area bigger
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: isSelected ? 2 : 1,
                          height: isSelected ? 25 : (index % 2 == 0 ? 15 : 8),
                          color: isSelected
                              ? (isDark ? Colors.white : Colors.black)
                              : (isDark ? Colors.white30 : Colors.grey.shade400),
                        ),
                        const SizedBox(height: 4),
                        if (isSelected)
                          Text(
                            formatTimeOfDay(time, context).split(' ')[0],
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        else if (index % 2 == 0)
                          Text(
                            formatTimeOfDay(time, context).split(' ')[0],
                            style: TextStyle(
                              fontSize: 10,
                              color: isDark ? Colors.white30 : Colors.grey.shade400,
                            ),
                          )
                        else
                          const SizedBox(height: 12),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

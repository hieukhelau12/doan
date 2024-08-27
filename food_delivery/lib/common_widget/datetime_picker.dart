import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';

class PickerMultiSelectionItemWidget extends StatefulWidget {
  const PickerMultiSelectionItemWidget({
    super.key,
    required this.pickerType,
  });

  final DateTimePickerType pickerType;

  @override
  State<PickerMultiSelectionItemWidget> createState() =>
      _PickerMultiSelectionItemWidgetState();
}

class _PickerMultiSelectionItemWidgetState
    extends State<PickerMultiSelectionItemWidget> {
  final ValueNotifier<DateTime> start = ValueNotifier(DateTime.now());
  final ValueNotifier<DateTime> end = ValueNotifier(DateTime.now());
  DateTime? _defaultStart;
  DateTime? _defaultEnd;
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    _defaultStart = DateTime.now();
    _defaultEnd = DateTime.now();
  }

  bool _isDateChanged(DateTime date1, DateTime date2) {
    return DateTime(date1.year, date1.month, date1.day) !=
        DateTime(date2.year, date2.month, date2.day);
  }

  @override
  Widget build(BuildContext context) {
    bool hasSelectedDate = (_defaultStart != null && _defaultEnd != null) &&
        (_isDateChanged(start.value, _defaultStart!) ||
            _isDateChanged(end.value, _defaultEnd!));
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          setState(() {
            isSelected = true;
          });

          final result = await showBoardDateTimeMultiPicker(
            context: context,
            pickerType: widget.pickerType,
            options: const BoardDateTimeOptions(
              languages: BoardPickerLanguages.en(),
              startDayOfWeek: DateTime.sunday,
              pickerFormat: PickerFormat.dmy,
            ),
          );
          if (result != null) {
            start.value = result.start;
            end.value = result.end;
          }
          setState(() {
            isSelected = false;
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Row(
            children: [
              ValueListenableBuilder(
                valueListenable: start,
                builder: (context, data, _) {
                  return Text(
                    BoardDateFormat(widget.pickerType.format).format(data),
                    style: TextStyle(
                        fontSize: 14,
                        color: hasSelectedDate
                            ? TColor.primary
                            : TColor.primaryText,
                        fontWeight: FontWeight.w600),
                  );
                },
              ),
              const SizedBox(height: 4),
              ValueListenableBuilder(
                valueListenable: end,
                builder: (context, data, _) {
                  return Text(
                    ' - ${BoardDateFormat(widget.pickerType.format).format(data)}',
                    style: TextStyle(
                        fontSize: 14,
                        color: hasSelectedDate
                            ? TColor.primary
                            : TColor.primaryText,
                        fontWeight: FontWeight.w600),
                  );
                },
              ),
              isSelected
                  ? Icon(
                      Icons.keyboard_arrow_up,
                      color:
                          hasSelectedDate ? TColor.primary : TColor.primaryText,
                    )
                  : Icon(
                      Icons.keyboard_arrow_down,
                      color:
                          hasSelectedDate ? TColor.primary : TColor.primaryText,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

extension DateTimePickerTypeExtension on DateTimePickerType {
  String get title {
    switch (this) {
      case DateTimePickerType.date:
        return 'Date';
      case DateTimePickerType.datetime:
        return 'DateTime';
      case DateTimePickerType.time:
        return 'Time';
    }
  }

  IconData get icon {
    switch (this) {
      case DateTimePickerType.date:
        return Icons.date_range_rounded;
      case DateTimePickerType.datetime:
        return Icons.date_range_rounded;
      case DateTimePickerType.time:
        return Icons.schedule_rounded;
    }
  }

  Color get color {
    switch (this) {
      case DateTimePickerType.date:
        return Colors.blue;
      case DateTimePickerType.datetime:
        return Colors.orange;
      case DateTimePickerType.time:
        return Colors.pink;
    }
  }

  String get format {
    switch (this) {
      case DateTimePickerType.date:
        return 'dd/MM/yyyy';
      case DateTimePickerType.datetime:
        return 'yyyy/MM/dd HH:mm';
      case DateTimePickerType.time:
        return 'HH:mm';
    }
  }

  String formatter({bool withSecond = false}) {
    switch (this) {
      case DateTimePickerType.date:
        return 'yyyy/MM/dd';
      case DateTimePickerType.datetime:
        return 'yyyy/MM/dd HH:mm';
      case DateTimePickerType.time:
        return withSecond ? 'HH:mm:ss' : 'HH:mm';
    }
  }
}

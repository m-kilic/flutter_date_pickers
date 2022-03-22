import 'package:flutter_date_pickers/src/day_type.dart';
import 'package:flutter_date_pickers/src/i_selectable_picker.dart';
import 'package:flutter_date_pickers/src/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("WeekSelectable test.", () {
    test("getDayType() returns correct type for different dates", () {
      final selectedDate = DateTime(2020, 10, 5); // Monday
      final firstDayOfWeekIndex = 1; // Week starts from Monday

      final firstDate = selectedDate.subtract(const Duration(days: 10));
      final lastDate = selectedDate.add(const Duration(days: 10));
      final disabledDate = selectedDate.subtract(const Duration(days: 5));

      // ignore: prefer_function_declarations_over_variables
      final selectablePredicate =
          (d) => !DatePickerUtils.sameDate(d, disabledDate);

      final selectableLogic = WeekSelectable(
          selectedDate, firstDayOfWeekIndex, firstDate, lastDate,
          selectableDayPredicate: selectablePredicate);

      final notSelectedEnabledDateType = selectableLogic.getDayType(firstDate);
      expect(notSelectedEnabledDateType, DayType.notSelected);

      final disabledDateType = selectableLogic.getDayType(disabledDate);
      expect(disabledDateType, DayType.disabled);

      final weekStart =
          DatePickerUtils.getFirstDayOfWeek(selectedDate, firstDayOfWeekIndex);

      final weekEnd =
          DatePickerUtils.getLastDayOfWeek(selectedDate, firstDayOfWeekIndex);

      final startPeriodDateType = selectableLogic.getDayType(weekStart);
      expect(startPeriodDateType, DayType.start);

      final endPeriodDateType = selectableLogic.getDayType(weekEnd);
      expect(endPeriodDateType, DayType.end);

      // Count of the week days which is not start and not end (7 - 2).
      final middleDaysCount = 5;
      final middleDates = List.generate(
          middleDaysCount, (i) => weekStart.add(Duration(days: i + 1)));

      for (DateTime date in middleDates) {
        final middlePeriodDateType = selectableLogic.getDayType(date);
        expect(middlePeriodDateType, DayType.middle,
            reason: "Incorrect DayType for the date ${date.toString()} "
                "in week ${weekStart.toString()} - ${weekEnd.toString()}");
      }
    });
  });

  test(
      "firstDate's time is midnight "
      "and lastDate's time is millisecond before the next day midnight", () {
    final selectedDate = DateTime(2020, 10, 5); // Monday
    final firstDayOfWeekIndex = 1; // Week starts from Monday

    final firstDate = selectedDate.subtract(const Duration(days: 10));
    final lastDate = selectedDate.add(const Duration(days: 10));

    final startOfTheFirstDate =
        DateTime(firstDate.year, firstDate.month, firstDate.day);
    final endOfTheLastDate =
        DateTime(lastDate.year, lastDate.month, lastDate.day, 23, 59, 59, 999);

    final selectableLogic = WeekSelectable(
      selectedDate,
      firstDayOfWeekIndex,
      firstDate,
      lastDate,
    );

    expect(selectableLogic.firstDate, startOfTheFirstDate);
    expect(selectableLogic.lastDate, endOfTheLastDate);
  });
}
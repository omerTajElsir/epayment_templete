import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:timezone/timezone.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter/scheduler.dart';

List<DateTime> _getRecurrenceDateTimeCollection(
    String rRule, DateTime recurrenceStartDate,
    {DateTime specificStartDate, DateTime specificEndDate}) {
  if (specificEndDate != null) {
    specificEndDate = DateTime(specificEndDate.year, specificEndDate.month,
        specificEndDate.day, 23, 59, 59);
  }

  final List<DateTime> recDateCollection = <DateTime>[];
  final dynamic isSpecificDateRange =
      specificStartDate != null && specificEndDate != null;
  final List<String> ruleSeparator = <String>['=', ';', ','];
  const String weeklySeparator = ';';

  final List<String> ruleArray = _splitRule(rRule, ruleSeparator);
  int weeklyByDayPos;
  int recCount = 0;
  final List<String> values = _findKeyIndex(ruleArray);
  final String reccount = values[0];
  final String daily = values[1];
  final String weekly = values[2];
  final String monthly = values[3];
  final String yearly = values[4];
  //String bySetPos = values[5];
  final String bySetPosCount = values[6];
  final String interval = values[7];
  final String intervalCount = values[8];
  //String until = values[9];
  final String untilValue = values[10];
  //String count = values[11];
  final String byDay = values[12];
  final String byDayValue = values[13];
  final String byMonthDay = values[14];
  final String byMonthDayCount = values[15];
  //final String byMonth = values[16];
  final String byMonthCount = values[17];
  //String weeklyByDay = values[18];
  //int byMonthDayPosition = int.parse(values[19]);
  //int byDayPosition = int.parse(values[20]);
  final List<String> weeklyRule = rRule.split(weeklySeparator);
  final List<String> weeklyRules = _findWeeklyRule(weeklyRule);
  if (weeklyRules.isNotEmpty) {
    // weeklyByDay = weeklyRules[0];
    weeklyByDayPos = int.parse(weeklyRules[1]);
  }

  if (ruleArray.isNotEmpty && rRule != null && rRule != '') {
    DateTime addDate = recurrenceStartDate;
    if (reccount != null && reccount != '') {
      recCount = int.parse(reccount);
    }

    DateTime endDate;
    if (rRule.contains('UNTIL')) {
      endDate = DateTime.parse(untilValue);
      endDate = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 0);
      if (isSpecificDateRange) {
        endDate =
            (endDate.isAfter(specificEndDate) || endDate == specificEndDate)
                ? specificEndDate
                : endDate;
      }
    }

    if (isSpecificDateRange && !rRule.contains('COUNT') && endDate == null) {
      endDate = specificEndDate;
    }

    if (daily == 'DAILY') {
      if (!rRule.contains('BYDAY')) {
        final int dailyDayGap =
            !rRule.contains('INTERVAL') ? 1 : int.parse(intervalCount);
        int tempcount = 0;
        while (tempcount < recCount ||
            (endDate != null &&
                (addDate.isBefore(endDate) || addDate == endDate))) {
          if (isSpecificDateRange) {
            if ((addDate.isAfter(specificStartDate) ||
                    addDate == specificStartDate) &&
                (addDate.isBefore(specificEndDate) ||
                    addDate == specificEndDate)) {
              recDateCollection.add(addDate);
            }
          } else {
            recDateCollection.add(addDate);
          }

          addDate = addDate.add(Duration(days: dailyDayGap));
          tempcount++;
        }
      } else {
        while (recDateCollection.length < recCount ||
            (endDate != null &&
                (addDate.isBefore(endDate) || addDate == endDate))) {
          if (addDate.weekday != DateTime.sunday &&
              addDate.weekday != DateTime.saturday) {
            if (isSpecificDateRange) {
              if ((addDate.isAfter(specificStartDate) ||
                      addDate == specificStartDate) &&
                  (addDate.isBefore(specificEndDate) ||
                      addDate == specificEndDate)) {
                recDateCollection.add(addDate);
              }
            } else {
              recDateCollection.add(addDate);
            }
          }

          addDate = addDate.add(const Duration(days: 1));
        }
      }
    } else if (weekly == 'WEEKLY') {
      int tempCount = 0;
      final int weeklyWeekGap = ruleArray.length > 4 && interval == 'INTERVAL'
          ? int.parse(intervalCount)
          : 1;
      final bool isweeklyselected = weeklyRule[weeklyByDayPos].length > 6;

      // Below code modified for fixing issue while setting rule as "FREQ=WEEKLY;COUNT=10;BYDAY=MO" along with specified start and end date.
      while ((tempCount < recCount && isweeklyselected) ||
          (endDate != null &&
              (addDate.isBefore(endDate) || addDate == endDate))) {
        if (isSpecificDateRange) {
          if ((addDate.isAfter(specificStartDate) ||
                  addDate == specificStartDate) &&
              (addDate.isBefore(specificEndDate) ||
                  addDate == specificEndDate)) {
            _setWeeklyRecurrenceDate(
                addDate, weeklyRule, weeklyByDayPos, recDateCollection);
          }

          if (addDate.isAfter(specificEndDate)) {
            break;
          }
        } else {
          _setWeeklyRecurrenceDate(
              addDate, weeklyRule, weeklyByDayPos, recDateCollection);
        }

        if (_isRecurrenceDate(addDate, weeklyRule, weeklyByDayPos)) {
          tempCount++;
        }

        addDate = addDate.weekday == DateTime.saturday
            ? addDate.add(Duration(days: ((weeklyWeekGap - 1) * 7) + 1))
            : addDate.add(const Duration(days: 1));
      }
    } else if (monthly == 'MONTHLY') {
      final int monthlyMonthGap = ruleArray.length > 4 && interval == 'INTERVAL'
          ? int.parse(intervalCount)
          : 1;
      if (byMonthDay == 'BYMONTHDAY') {
        final int monthDate = int.parse(byMonthDayCount);
        if (monthDate < 30) {
          final int currDate = int.parse(recurrenceStartDate.day.toString());
          final DateTime temp = DateTime(addDate.year, addDate.month, monthDate,
              addDate.hour, addDate.minute, addDate.second);
          addDate = monthDate < currDate
              ? DateTime(temp.year, temp.month + 1, temp.day, temp.hour,
                  temp.minute, temp.second)
              : temp;
          int tempcount = 0;
          while (tempcount < recCount ||
              (endDate != null &&
                  (addDate.isBefore(endDate) || addDate == endDate))) {
            if (addDate.month == 2 && monthDate > 28) {
              addDate = DateTime(
                  addDate.year,
                  addDate.month,
                  DateTime(addDate.year, addDate.month + 1, 1)
                      .subtract(const Duration(days: 1))
                      .day,
                  addDate.hour,
                  addDate.minute,
                  addDate.second);
              if (isSpecificDateRange) {
                if ((addDate.isAfter(specificStartDate) ||
                        addDate == specificStartDate) &&
                    (addDate.isBefore(specificEndDate) ||
                        addDate == specificEndDate)) {
                  recDateCollection.add(addDate);
                }

                if (addDate.isAfter(specificEndDate)) {
                  break;
                }
              } else {
                recDateCollection.add(addDate);
              }

              addDate = DateTime(addDate.year, addDate.month + monthlyMonthGap,
                  monthDate, addDate.hour, addDate.minute, addDate.second);
            } else {
              if (isSpecificDateRange) {
                if ((addDate.isAfter(specificStartDate) ||
                        addDate == specificStartDate) &&
                    (addDate.isBefore(specificEndDate) ||
                        addDate == specificEndDate)) {
                  recDateCollection.add(addDate);
                }

                if (addDate.isAfter(specificEndDate)) {
                  break;
                }
              } else {
                recDateCollection.add(addDate);
              }

              addDate = DateTime(addDate.year, addDate.month + monthlyMonthGap,
                  addDate.day, addDate.hour, addDate.minute, addDate.second);
            }

            tempcount++;
          }
        } else {
          addDate = DateTime(
              addDate.year,
              addDate.month,
              DateTime(addDate.year, addDate.month + 1, 1)
                  .subtract(const Duration(days: 1))
                  .day,
              addDate.hour,
              addDate.minute,
              addDate.second);
          int tempcount = 0;
          while (tempcount < recCount ||
              (endDate != null &&
                  (addDate.isBefore(endDate) || addDate == endDate))) {
            if (isSpecificDateRange) {
              if ((addDate.isAfter(specificStartDate) ||
                      addDate == specificStartDate) &&
                  (addDate.isBefore(specificEndDate) ||
                      addDate == specificEndDate)) {
                recDateCollection.add(addDate);
              }

              if (addDate.isAfter(specificEndDate)) {
                break;
              }
            } else {
              recDateCollection.add(addDate);
            }

            addDate = DateTime(
                addDate.year,
                addDate.month + monthlyMonthGap,
                DateTime(addDate.year, addDate.month + monthlyMonthGap, 1)
                    .subtract(const Duration(days: 1))
                    .day,
                addDate.hour,
                addDate.minute,
                addDate.second);
            tempcount++;
          }
        }
      } else if (byDay == 'BYDAY') {
        dynamic tempRecDateCollectionCount = 0;
        while (recDateCollection.length < recCount ||
            (endDate != null &&
                (addDate.isBefore(endDate) || addDate == endDate))) {
          final DateTime monthStart = DateTime(addDate.year, addDate.month, 1,
              addDate.hour, addDate.minute, addDate.second);
          final DateTime weekStartDate =
              monthStart.add(Duration(days: -monthStart.weekday));
          final int monthStartWeekday = monthStart.weekday;
          final int nthweekDay = _getWeekDay(byDayValue);
          int nthWeek;
          if (monthStartWeekday <= nthweekDay) {
            nthWeek = int.parse(bySetPosCount) - 1;
          } else {
            nthWeek = int.parse(bySetPosCount);
          }

          addDate = weekStartDate.add(Duration(days: nthWeek * 7));
          addDate = addDate.add(Duration(days: nthweekDay));
          if (addDate.isBefore(recurrenceStartDate)) {
            addDate = DateTime(addDate.year, addDate.month + 1, addDate.day,
                addDate.hour, addDate.minute, addDate.second);
            continue;
          }

          if (isSpecificDateRange) {
            if ((addDate.isAfter(specificStartDate) ||
                    addDate == specificStartDate) &&
                (addDate.isBefore(specificEndDate) ||
                    addDate == specificEndDate) &&
                (tempRecDateCollectionCount < recCount ||
                    rRule.contains('UNTIL'))) {
              recDateCollection.add(addDate);
            }

            if (addDate.isAfter(specificEndDate)) {
              break;
            }
          } else {
            recDateCollection.add(addDate);
          }

          addDate = DateTime(
              addDate.year,
              addDate.month + monthlyMonthGap,
              addDate.day - (addDate.day - 1),
              addDate.hour,
              addDate.minute,
              addDate.second);
          tempRecDateCollectionCount++;
        }
      }
    } else if (yearly == 'YEARLY') {
      final int yearlyYearGap = ruleArray.length > 4 && interval == 'INTERVAL'
          ? int.parse(intervalCount)
          : 1;
      if (byMonthDay == 'BYMONTHDAY') {
        final int monthIndex = int.parse(byMonthCount);
        final int dayIndex = int.parse(byMonthDayCount);
        if (monthIndex > 0 && monthIndex <= 12) {
          final int bound = DateTime(addDate.year, addDate.month + 1, 1)
              .subtract(const Duration(days: 1))
              .day;
          if (bound >= dayIndex) {
            final DateTime specificDate = DateTime(addDate.year, monthIndex,
                dayIndex, addDate.hour, addDate.minute, addDate.second);
            if (specificDate.isBefore(addDate)) {
              addDate = specificDate;
              addDate = DateTime(addDate.year + 1, addDate.month, addDate.day,
                  addDate.hour, addDate.minute, addDate.second);
              if (isSpecificDateRange) {
                if ((addDate.isAfter(specificStartDate) ||
                        addDate == specificStartDate) &&
                    (addDate.isBefore(specificEndDate) ||
                        addDate == specificEndDate)) {
                  recDateCollection.add(addDate);
                }
              } else {
                recDateCollection.add(addDate);
              }
            } else {
              addDate = specificDate;
            }

            int tempcount = 0;
            while (tempcount < recCount ||
                (endDate != null &&
                    (addDate.isBefore(endDate) || addDate == endDate))) {
              if (!recDateCollection.contains(addDate)) {
                if (isSpecificDateRange) {
                  if ((addDate.isAfter(specificStartDate) ||
                          addDate == specificStartDate) &&
                      (addDate.isBefore(specificEndDate) ||
                          addDate == specificEndDate)) {
                    recDateCollection.add(addDate);
                  }

                  if (addDate.isAfter(specificEndDate)) {
                    break;
                  }
                } else {
                  recDateCollection.add(addDate);
                }
              }

              addDate = DateTime(addDate.year + yearlyYearGap, addDate.month,
                  addDate.day, addDate.hour, addDate.minute, addDate.second);
              tempcount++;
            }
          }
        }
      } else if (byDay == 'BYDAY') {
        final int monthIndex = int.parse(byMonthCount);
        DateTime monthStart = DateTime(addDate.year, monthIndex, 1,
            addDate.hour, addDate.minute, addDate.second);
        DateTime weekStartDate =
            monthStart.add(Duration(days: -monthStart.weekday));
        int monthStartWeekday = monthStart.weekday;
        int nthweekDay = _getWeekDay(byDayValue);
        int nthWeek;
        if (monthStartWeekday <= nthweekDay) {
          nthWeek = int.parse(bySetPosCount) - 1;
        } else {
          nthWeek = int.parse(bySetPosCount);
        }

        monthStart = weekStartDate.add(Duration(days: nthWeek * 7));
        monthStart = monthStart.add(Duration(days: nthweekDay));

        if ((monthStart.month != addDate.month &&
                monthStart.isBefore(addDate)) ||
            (monthStart.month == addDate.month &&
                (monthStart.isBefore(addDate) ||
                    monthStart.isBefore(recurrenceStartDate)))) {
          addDate = DateTime(addDate.year + 1, addDate.month, addDate.day,
              addDate.hour, addDate.minute, addDate.second);
          monthStart = DateTime(addDate.year, monthIndex, 1, addDate.hour,
              addDate.minute, addDate.second);
          weekStartDate = monthStart.add(Duration(days: -monthStart.weekday));
          monthStartWeekday = monthStart.weekday;
          nthweekDay = _getWeekDay(byDayValue);
          if (monthStartWeekday <= nthweekDay) {
            nthWeek = int.parse(bySetPosCount) - 1;
          } else {
            nthWeek = int.parse(bySetPosCount);
          }

          monthStart = weekStartDate.add(Duration(days: nthWeek * 7));
          monthStart = monthStart.add(Duration(days: nthweekDay));

          addDate = monthStart;

          if (!recDateCollection.contains(addDate)) {
            if (isSpecificDateRange) {
              if ((addDate.isAfter(specificStartDate) ||
                      addDate == specificStartDate) &&
                  (addDate.isBefore(specificEndDate) ||
                      addDate == specificEndDate)) {
                recDateCollection.add(addDate);
              }
            } else {
              recDateCollection.add(addDate);
            }
          }
        } else {
          addDate = monthStart;
        }

        int tempcount = 0;
        while (tempcount < recCount ||
            (endDate != null &&
                (addDate.isBefore(endDate) || addDate == endDate))) {
          if (!recDateCollection.contains(addDate)) {
            if (isSpecificDateRange) {
              if ((addDate.isAfter(specificStartDate) ||
                      addDate == specificStartDate) &&
                  (addDate.isBefore(specificEndDate) ||
                      addDate == specificEndDate)) {
                recDateCollection.add(addDate);
              }

              if (addDate.isAfter(specificEndDate)) {
                break;
              }
            } else {
              recDateCollection.add(addDate);
            }
          }

          addDate = DateTime(addDate.year + yearlyYearGap, addDate.month,
              addDate.day, addDate.hour, addDate.minute, addDate.second);

          monthStart = DateTime(addDate.year, monthIndex, 1, addDate.hour,
              addDate.minute, addDate.second);

          weekStartDate = monthStart.add(Duration(days: -monthStart.weekday));
          monthStartWeekday = monthStart.weekday;
          nthweekDay = _getWeekDay(byDayValue);
          if (monthStartWeekday <= nthweekDay) {
            nthWeek = int.parse(bySetPosCount) - 1;
          } else {
            nthWeek = int.parse(bySetPosCount);
          }

          monthStart = weekStartDate.add(Duration(days: nthWeek * 7));
          monthStart = monthStart.add(Duration(days: nthweekDay));

          if (monthStart.month != addDate.month &&
              monthStart.isBefore(addDate)) {
            addDate = monthStart;
            addDate = DateTime(addDate.year + 1, addDate.month, addDate.day,
                addDate.hour, addDate.minute, addDate.second);
            if (!recDateCollection.contains(addDate)) {
              if (isSpecificDateRange) {
                if ((addDate.isAfter(specificStartDate) ||
                        addDate == specificStartDate) &&
                    (addDate.isBefore(specificEndDate) ||
                        addDate == specificEndDate)) {
                  recDateCollection.add(addDate);
                }

                if (addDate.isAfter(specificEndDate)) {
                  break;
                }
              } else {
                recDateCollection.add(addDate);
              }
            }
          } else {
            addDate = monthStart;
          }

          tempcount++;
        }
      }
    }
  }

  return recDateCollection;
}

RecurrenceProperties _parseRRule(String rRule, DateTime recStartDate) {
  final DateTime recurrenceStartDate = recStartDate;
  final RecurrenceProperties recProp = RecurrenceProperties();

  recProp.startDate = recStartDate;
  final List<String> ruleSeparator = <String>['=', ';', ','];
  const String weeklySeparator = ';';
  final List<String> ruleArray = _splitRule(rRule, ruleSeparator);
  final List<String> weeklyRule = rRule.split(weeklySeparator);
//string count, reccount, daily, weekly, monthly, yearly, interval, intervalCount, until, untilValue, weeklyByDay, bySetPos, bySetPosCount, byDay, byDayValue, byMonthDay, byMonthDayCount, byMonth, byMonthCount;
  int weeklyByDayPos;
  int recCount = 0;
  final List<String> resultList = _findKeyIndex(ruleArray);
  final String reccount = resultList[0];
  final String daily = resultList[1];
  final String weekly = resultList[2];
  final String monthly = resultList[3];
  final String yearly = resultList[4];
  //final String bySetPos = resultList[5];
  final String bySetPosCount = resultList[6];
  final String interval = resultList[7];
  final String intervalCount = resultList[8];
  //final String until = resultList[9];
  final String untilValue = resultList[10];
  //final String count = resultList[11];
  final String byDay = resultList[12];
  final String byDayValue = resultList[13];
  final String byMonthDay = resultList[14];
  final String byMonthDayCount = resultList[15];
  //final String byMonth = resultList[16];
  final String byMonthCount = resultList[17];
  //String weeklyByDay = resultList[18];
  //final int byMonthDayPosition = int.parse(resultList[19]);
  final int byDayPosition = int.parse(resultList[20]);
  final List<String> weeklyRules = _findWeeklyRule(weeklyRule);
  if (weeklyRules.isNotEmpty) {
    //weeklyByDay = weeklyRules[0];
    weeklyByDayPos = int.parse(weeklyRules[1]);
  }

  if (ruleArray.isNotEmpty && (rRule != null || rRule != '')) {
    DateTime addDate = recurrenceStartDate;
    if (reccount != null || reccount != '') {
      recCount = int.parse(reccount);
    }

    if (!rRule.contains('COUNT') && !rRule.contains('UNTIL')) {
      recProp.recurrenceRange = RecurrenceRange.noEndDate;
    } else if (rRule.contains('COUNT')) {
      recProp.recurrenceRange = RecurrenceRange.count;
      recProp.recurrenceCount = recCount;
    } else if (rRule.contains('UNTIL')) {
      recProp.recurrenceRange = RecurrenceRange.endDate;
      DateTime endDate = DateTime.parse(untilValue);
      endDate = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
      recProp.endDate = endDate;
    }

    if (daily == 'DAILY') {
      recProp.recurrenceType = RecurrenceType.daily;

      if (rRule.contains('COUNT')) {
        recProp.interval = int.parse(intervalCount);
      } else if (rRule.contains('BYDAY')) {
        recProp.interval = int.parse(intervalCount);
        recProp.weekDays = <WeekDays>[];
        recProp.weekDays.add(WeekDays.monday);
        recProp.weekDays.add(WeekDays.tuesday);
        recProp.weekDays.add(WeekDays.wednesday);
        recProp.weekDays.add(WeekDays.thursday);
        recProp.weekDays.add(WeekDays.friday);
      } else {
        recProp.interval = ruleArray.length > 4 && interval == 'INTERVAL'
            ? int.parse(intervalCount)
            : 1;
      }
    } else if (weekly == 'WEEKLY') {
      recProp.recurrenceType = RecurrenceType.weekly;
      recProp.interval = ruleArray.length > 4 && interval == 'INTERVAL'
          ? int.parse(intervalCount)
          : 1;
      final int wyWeekGap = recProp.interval;
      int i = 0;
      if (recProp.recurrenceRange == RecurrenceRange.noEndDate) {
        recCount = 7;
      }

      while (i < 7) {
        switch (addDate.weekday) {
          case DateTime.sunday:
            {
              if (weeklyRule[weeklyByDayPos].contains('SU')) {
                recProp.weekDays.add(WeekDays.sunday);
              }

              break;
            }

          case DateTime.monday:
            {
              if (weeklyRule[weeklyByDayPos].contains('MO')) {
                recProp.weekDays.add(WeekDays.monday);
              }

              break;
            }

          case DateTime.tuesday:
            {
              if (weeklyRule[weeklyByDayPos].contains('TU')) {
                recProp.weekDays.add(WeekDays.tuesday);
              }

              break;
            }

          case DateTime.wednesday:
            {
              if (weeklyRule[weeklyByDayPos].contains('WE')) {
                recProp.weekDays.add(WeekDays.wednesday);
              }

              break;
            }

          case DateTime.thursday:
            {
              if (weeklyRule[weeklyByDayPos].contains('TH')) {
                recProp.weekDays.add(WeekDays.thursday);
              }

              break;
            }

          case DateTime.friday:
            {
              if (weeklyRule[weeklyByDayPos].contains('FR')) {
                recProp.weekDays.add(WeekDays.friday);
              }

              break;
            }

          case DateTime.saturday:
            {
              if (weeklyRule[weeklyByDayPos].contains('SA')) {
                recProp.weekDays.add(WeekDays.saturday);
              }

              break;
            }
        }

        addDate = addDate.weekday == 7
            ? addDate.add(Duration(days: ((wyWeekGap - 1) * 7) + 1))
            : addDate.add(const Duration(days: 1));
        i = i + 1;
      }
    } else if (monthly == 'MONTHLY') {
      recProp.recurrenceType = RecurrenceType.monthly;
      if (!rRule.contains('COUNT')) {
        recProp.interval = ruleArray.length > 4 && interval == 'INTERVAL'
            ? int.parse(intervalCount)
            : 1;
        if (rRule.contains('BYMONTHDAY')) {
          recProp.week = -1;
          recProp.dayOfMonth = int.parse(byMonthDayCount);
        } else if (rRule.contains('BYDAY')) {
          recProp.week = int.parse(bySetPosCount);
          recProp.dayOfWeek = _getWeekDay(byDayValue);
        }
      } else {
        recProp.interval = ruleArray.length > 4 && interval == 'INTERVAL'
            ? int.parse(intervalCount)
            : 1;
        int position =
            ruleArray.length > 4 && interval == 'INTERVAL' ? 6 : byDayPosition;
        position = ruleArray.length == 4 ? 2 : position;
        if (byMonthDay == 'BYMONTHDAY') {
          recProp.week = -1;
          recProp.dayOfMonth = int.parse(byMonthDayCount);
        } else if (ruleArray[position] == 'BYDAY') {
          recProp.week = int.parse(bySetPosCount);
          recProp.dayOfWeek = _getWeekDay(byDayValue);
        }
      }
    } else if (yearly == 'YEARLY') {
      recProp.recurrenceType = RecurrenceType.yearly;
      if (!rRule.contains('COUNT')) {
        recProp.interval = ruleArray.length > 4 && interval == 'INTERVAL'
            ? int.parse(intervalCount)
            : 1;
        if (rRule.contains('BYMONTHDAY')) {
          recProp.month = int.parse(byMonthCount);
          recProp.dayOfWeek = int.parse(byMonthDayCount);
        } else if (rRule.contains('BYDAY')) {
          recProp.month = int.parse(byMonthCount);
          recProp.week = int.parse(bySetPosCount);
          recProp.dayOfWeek = _getWeekDay(byDayValue);
        }
      } else {
        recProp.interval = ruleArray.length > 4 && interval == 'INTERVAL'
            ? int.parse(intervalCount)
            : 1;
        if (byMonthDay == 'BYMONTHDAY') {
          recProp.month = int.parse(byMonthCount);
          recProp.dayOfMonth = int.parse(byMonthDayCount);
        } else if (byDay == 'BYDAY') {
          recProp.month = int.parse(byMonthCount);
          recProp.week = int.parse(bySetPosCount);
          recProp.dayOfWeek = _getWeekDay(byDayValue);
        }
      }
    }
  }

  return recProp;
}

String _generateRRule(RecurrenceProperties recurrenceProperties,
    DateTime appStartTime, DateTime appEndTime) {
  final DateTime recPropStartDate = recurrenceProperties.startDate;
  final DateTime recPropEndDate = recurrenceProperties.endDate;
  final DateTime startDate =
      appStartTime.isAfter(recPropStartDate) ? appStartTime : recPropStartDate;
  final DateTime endDate = recPropEndDate;
  final dynamic diffTimeSpan = appEndTime.difference(appStartTime);
  int recCount = 0;
  String rRule = '';
  DateTime prevDate = DateTime.utc(1);
  bool isValidRecurrence = true;

  recCount = recurrenceProperties.recurrenceCount;
  if (recurrenceProperties.recurrenceType == RecurrenceType.daily) {
    if ((recCount > 0 &&
            recurrenceProperties.recurrenceRange == RecurrenceRange.count) ||
        recurrenceProperties.recurrenceRange == RecurrenceRange.noEndDate ||
        ((startDate.isBefore(endDate) || startDate == endDate) &&
            recurrenceProperties.recurrenceRange == RecurrenceRange.endDate)) {
      rRule = 'FREQ=DAILY';

      if (recurrenceProperties.weekDays.contains(WeekDays.monday) &&
          recurrenceProperties.weekDays.contains(WeekDays.tuesday) &&
          recurrenceProperties.weekDays.contains(WeekDays.wednesday) &&
          recurrenceProperties.weekDays.contains(WeekDays.thursday) &&
          recurrenceProperties.weekDays.contains(WeekDays.friday)) {
        if (diffTimeSpan.inHours > 24) {
          isValidRecurrence = false;
        }

        rRule = rRule + ';BYDAY=MO,TU,WE,TH,FR';
      } else {
        if (diffTimeSpan.inHours >= recurrenceProperties.interval * 24) {
          isValidRecurrence = false;
        }

        if (recurrenceProperties.interval > 0) {
          rRule =
              rRule + ';INTERVAL=' + recurrenceProperties.interval.toString();
        }
      }

      if (recurrenceProperties.recurrenceRange == RecurrenceRange.count) {
        rRule = rRule + ';COUNT=' + recCount.toString();
      } else if (recurrenceProperties.recurrenceRange ==
          RecurrenceRange.endDate) {
        final DateFormat format = DateFormat('yyyyMMdd');
        rRule = rRule + ';UNTIL=' + format.format(endDate);
      }
    }
  } else if (recurrenceProperties.recurrenceType == RecurrenceType.weekly) {
    DateTime addDate = startDate;
    if ((recCount > 0 &&
            recurrenceProperties.recurrenceRange == RecurrenceRange.count) ||
        recurrenceProperties.recurrenceRange == RecurrenceRange.noEndDate ||
        ((startDate.isBefore(endDate) || startDate == endDate) &&
            recurrenceProperties.recurrenceRange == RecurrenceRange.endDate)) {
      rRule = 'FREQ=WEEKLY';
      String byDay = '';
      int su = 0, mo = 0, tu = 0, we = 0, th = 0, fr = 0, sa = 0;
      String dayKey = '';
      int dayCount = 0;
      rRule = rRule + ';BYDAY=';
      int count = 0;
      int i = 0;
      while ((count < recCount &&
              isValidRecurrence &&
              recurrenceProperties.weekDays != null &&
              recurrenceProperties.weekDays.isNotEmpty) ||
          (addDate.isBefore(endDate) || addDate == endDate) ||
          (recurrenceProperties.recurrenceRange == RecurrenceRange.noEndDate &&
              i < 7)) {
        switch (addDate.weekday) {
          case DateTime.sunday:
            {
              if (recurrenceProperties.weekDays.contains(WeekDays.sunday)) {
                dayKey = 'SU,';
                dayCount = su;
              }

              break;
            }

          case DateTime.monday:
            {
              if (recurrenceProperties.weekDays.contains(WeekDays.monday)) {
                dayKey = 'MO,';
                dayCount = mo;
              }

              break;
            }

          case DateTime.tuesday:
            {
              if (recurrenceProperties.weekDays.contains(WeekDays.tuesday)) {
                dayKey = 'TU,';
                dayCount = tu;
              }

              break;
            }

          case DateTime.wednesday:
            {
              if (recurrenceProperties.weekDays.contains(WeekDays.wednesday)) {
                dayKey = 'WE,';
                dayCount = we;
              }

              break;
            }

          case DateTime.thursday:
            {
              if (recurrenceProperties.weekDays.contains(WeekDays.thursday)) {
                dayKey = 'TH,';
                dayCount = th;
              }

              break;
            }

          case DateTime.friday:
            {
              if (recurrenceProperties.weekDays.contains(WeekDays.friday)) {
                dayKey = 'FR,';
                dayCount = fr;
              }

              break;
            }

          case DateTime.saturday:
            {
              if (recurrenceProperties.weekDays.contains(WeekDays.saturday)) {
                dayKey = 'SA';
                dayCount = sa;
              }

              break;
            }
        }

        if (dayKey != null && dayKey != '') {
          if (count != 0) {
            final dynamic tempTimeSpan = addDate.difference(prevDate);
            if (tempTimeSpan <= diffTimeSpan) {
              isValidRecurrence = false;
            } else {
              prevDate = addDate;
              if (dayCount == 1) {
                break;
              }

              if (addDate.weekday != DateTime.saturday) {
                byDay =
                    byDay.isNotEmpty && byDay.substring(byDay.length - 1) == 'A'
                        ? byDay + ',' + dayKey
                        : byDay + dayKey;
              } else {
                byDay = byDay + dayKey;
              }

              dayCount++;
            }
          } else {
            prevDate = addDate;
            count++;
            byDay = byDay.isNotEmpty && byDay.substring(byDay.length - 1) == 'A'
                ? byDay + ',' + dayKey
                : byDay + dayKey;
            dayCount++;
          }

          if (recurrenceProperties.recurrenceRange ==
              RecurrenceRange.noEndDate) {
            recCount++;
          }

          switch (addDate.weekday) {
            case DateTime.sunday:
              {
                su = dayCount;
                break;
              }

            case DateTime.monday:
              {
                mo = dayCount;
                break;
              }

            case DateTime.tuesday:
              {
                tu = dayCount;
                break;
              }

            case DateTime.wednesday:
              {
                we = dayCount;
                break;
              }

            case DateTime.thursday:
              {
                th = dayCount;
                break;
              }

            case DateTime.friday:
              {
                fr = dayCount;
                break;
              }

            case DateTime.saturday:
              {
                sa = dayCount;
                break;
              }
          }

          dayCount = 0;
          dayKey = '';
        }

        addDate = addDate.weekday == DateTime.saturday
            ? addDate.add(
                Duration(days: ((recurrenceProperties.interval - 1) * 7) + 1))
            : addDate.add(const Duration(days: 1));
        i = i + 1;
      }

      byDay = _sortByDay(byDay);
      rRule = rRule + byDay;

      if (recurrenceProperties.interval > 0) {
        rRule = rRule + ';INTERVAL=' + recurrenceProperties.interval.toString();
      }

      if (recurrenceProperties.recurrenceRange == RecurrenceRange.count) {
        rRule = rRule + ';COUNT=' + recCount.toString();
      } else if (recurrenceProperties.recurrenceRange ==
          RecurrenceRange.endDate) {
        final DateFormat format = DateFormat('yyyyMMdd');
        rRule = rRule + ';UNTIL=' + format.format(endDate);
      }
    }
  } else if (recurrenceProperties.recurrenceType == RecurrenceType.monthly) {
    if ((recCount > 0 &&
            recurrenceProperties.recurrenceRange == RecurrenceRange.count) ||
        recurrenceProperties.recurrenceRange == RecurrenceRange.noEndDate ||
        ((startDate.isBefore(endDate) || startDate == endDate) &&
            recurrenceProperties.recurrenceRange == RecurrenceRange.endDate)) {
      rRule = 'FREQ=MONTHLY';

      if (recurrenceProperties.week == -1) {
        rRule =
            rRule + ';BYMONTHDAY=' + recurrenceProperties.dayOfMonth.toString();
      } else {
        final DateTime firstDate =
            DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
        final dynamic dayNames =
            List<dynamic>.generate(7, (dynamic index) => index)
                .map((dynamic value) => DateFormat(DateFormat.ABBR_WEEKDAY)
                    .format(firstDate.add(Duration(days: value))))
                .toList();
        final String byDayString = dayNames[recurrenceProperties.dayOfWeek - 1];
        //AbbreviatedDayNames will return three digit char , as per the standard we need to retrun only fisrt two char for RRule so here have removed the last char.
        rRule = rRule +
            ';BYDAY=' +
            byDayString.substring(0, byDayString.length - 1).toUpperCase() +
            ';BYSETPOS=' +
            recurrenceProperties.week.toString();
      }

      if (recurrenceProperties.interval > 0) {
        rRule = rRule + ';INTERVAL=' + recurrenceProperties.interval.toString();
      }

      if (recurrenceProperties.recurrenceRange == RecurrenceRange.count) {
        rRule = rRule + ';COUNT=' + recCount.toString();
      } else if (recurrenceProperties.recurrenceRange ==
          RecurrenceRange.endDate) {
        final DateFormat format = DateFormat('yyyyMMdd');
        rRule = rRule + ';UNTIL=' + format.format(endDate);
      }

      if (DateTime(
                  startDate.year,
                  startDate.month + recurrenceProperties.interval,
                  startDate.day,
                  startDate.hour,
                  startDate.minute,
                  startDate.second)
              .difference(startDate) <
          diffTimeSpan) {
        isValidRecurrence = false;
      }
    }
  } else if (recurrenceProperties.recurrenceType == RecurrenceType.yearly) {
    if ((recCount > 0 &&
            recurrenceProperties.recurrenceRange == RecurrenceRange.count) ||
        recurrenceProperties.recurrenceRange == RecurrenceRange.noEndDate ||
        ((startDate.isBefore(endDate) || startDate == endDate) &&
            recurrenceProperties.recurrenceRange == RecurrenceRange.endDate)) {
      rRule = 'FREQ=YEARLY';

      if (recurrenceProperties.week == -1) {
        rRule = rRule +
            ';BYMONTHDAY=' +
            recurrenceProperties.dayOfMonth.toString() +
            ';BYMONTH=' +
            recurrenceProperties.month.toString();
      } else {
        final DateTime firstDate =
            DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
        final dynamic dayNames =
            List<dynamic>.generate(7, (dynamic index) => index)
                .map((dynamic value) => DateFormat(DateFormat.ABBR_WEEKDAY)
                    .format(firstDate.add(Duration(days: value))))
                .toList();
        final String byDayString = dayNames[recurrenceProperties.dayOfWeek - 1];
        //AbbreviatedDayNames will return three digit char , as per the standard we need to retrun only fisrt two char for RRule so here have removed the last char.
        rRule = rRule +
            ';BYDAY=' +
            byDayString.substring(0, byDayString.length - 1).toUpperCase() +
            ';BYMONTH=' +
            recurrenceProperties.month.toString() +
            ';BYSETPOS=' +
            recurrenceProperties.week.toString();
      }

      if (recurrenceProperties.interval > 0) {
        rRule = rRule + ';INTERVAL=' + recurrenceProperties.interval.toString();
      }

      if (recurrenceProperties.recurrenceRange == RecurrenceRange.count) {
        rRule = rRule + ';COUNT=' + recCount.toString();
      } else if (recurrenceProperties.recurrenceRange ==
          RecurrenceRange.endDate) {
        final DateFormat format = DateFormat('yyyyMMdd');
        rRule = rRule + ';UNTIL=' + format.format(endDate);
      }

      if (DateTime(
                  startDate.year + recurrenceProperties.interval,
                  startDate.month,
                  startDate.day,
                  startDate.hour,
                  startDate.minute,
                  startDate.second)
              .difference(startDate) <
          diffTimeSpan) {
        isValidRecurrence = false;
      }
    }
  }

  if (!isValidRecurrence) {
    rRule = '';
  }

  return rRule;
}

List<String> _findKeyIndex(List<String> ruleArray) {
  int byMonthDayPosition = 0;
  int byDayPosition = 0;
  String reccount = '';
  String daily = '';
  String weekly = '';
  String monthly = '';
  String yearly = '';
  String bySetPos = '';
  String bySetPosCount = '';
  String interval = '';
  String intervalCount = '';
  String count = '';
  String byDay = '';
  String byDayValue = '';
  String byMonthDay = '';
  String byMonthDayCount = '';
  String byMonth = '';
  String byMonthCount = '';
  const String weeklyByDay = '';
  String until = '';
  String untilValue = '';

  for (int i = 0; i < ruleArray.length; i++) {
    if (ruleArray[i] == 'COUNT') {
      count = ruleArray[i];
      reccount = ruleArray[i + 1];
      continue;
    }

    if (ruleArray[i] == 'DAILY') {
      daily = ruleArray[i];
      continue;
    }

    if (ruleArray[i] == 'WEEKLY') {
      weekly = ruleArray[i];
      continue;
    }

    if (ruleArray[i] == 'INTERVAL') {
      interval = ruleArray[i];
      intervalCount = ruleArray[i + 1];
      continue;
    }

    if (ruleArray[i] == 'UNTIL') {
      until = ruleArray[i];
      untilValue = ruleArray[i + 1];
      continue;
    }

    if (ruleArray[i] == 'MONTHLY') {
      monthly = ruleArray[i];
      continue;
    }

    if (ruleArray[i] == 'YEARLY') {
      yearly = ruleArray[i];
      continue;
    }

    if (ruleArray[i] == 'BYSETPOS') {
      bySetPos = ruleArray[i];
      bySetPosCount = ruleArray[i + 1];
      continue;
    }

    if (ruleArray[i] == 'BYDAY') {
      byDayPosition = i;
      byDay = ruleArray[i];
      byDayValue = ruleArray[i + 1];
      continue;
    }

    if (ruleArray[i] == 'BYMONTH') {
      byMonth = ruleArray[i];
      byMonthCount = ruleArray[i + 1];
      continue;
    }

    if (ruleArray[i] == 'BYMONTHDAY') {
      byMonthDayPosition = i;
      byMonthDay = ruleArray[i];
      byMonthDayCount = ruleArray[i + 1];
      continue;
    }
  }

  return <String>[
    reccount,
    daily,
    weekly,
    monthly,
    yearly,
    bySetPos,
    bySetPosCount,
    interval,
    intervalCount,
    until,
    untilValue,
    count,
    byDay,
    byDayValue,
    byMonthDay,
    byMonthDayCount,
    byMonth,
    byMonthCount,
    weeklyByDay,
    byMonthDayPosition.toString(),
    byDayPosition.toString()
  ];
}

List<String> _findWeeklyRule(List<String> weeklyRule) {
  final List<String> result = <String>[];
  for (int i = 0; i < weeklyRule.length; i++) {
    if (weeklyRule[i].contains('BYDAY')) {
      result.add(weeklyRule[i]);
      result.add(i.toString());
      break;
    }
  }

  return result;
}

int _getWeekDay(String weekDay) {
  int index = 1;
  final DateTime firstDate =
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
  final dynamic dayNames = List<dynamic>.generate(7, (dynamic index) => index)
      .map((dynamic value) => DateFormat(DateFormat.ABBR_WEEKDAY)
          .format(firstDate.add(Duration(days: value))))
      .toList();
  for (int i = 0; i < 7; i++) {
    final dynamic dayName = dayNames[i];
    //AbbreviatedDayNames will return three digit char , user may give 2 digit char also as per the standard so here have checked the char count.
    if (dayName.toUpperCase() == weekDay ||
        weekDay.length == 2 &&
            dayName.substring(0, dayName.length - 1).toUpperCase() == weekDay) {
      index = i;
    }
  }

  return index + 1;
}

List<String> _splitRule(String text, List<String> patterns) {
  final List<String> result = <String>[];
//  List<Object> splitedString = text.split(patterns[0]);
//  for (int i = 0; i < splitedString.length; i++) {
//    String string = splitedString[i];
//    bool isSplited = false;
//    for (int j = 0; j < patterns.length; j++) {
//      if (string.contains(patterns[j])) {
//        isSplited = true;
//        List<Object> recursiveString = string.split(patterns[j]);
//        for (int k = 0; k < recursiveString.length; k++) {
//          splitedString.add(recursiveString[k]);
//        }
//      }
//    }
//
//    if (isSplited) {
//      splitedString.removeAt(i);
//      i--;
//    }
//    else {
//      result.add(string);
//    }
//  }

  int startIndex = 0;
  for (int i = 0; i < text.length; i++) {
    final String charValue = text[i];
    for (int j = 0; j < patterns.length; j++) {
      if (charValue == patterns[j]) {
        result.add(text.substring(startIndex, i));
        startIndex = i + 1;
      }
    }
  }

  if (startIndex != text.length) {
    result.add(text.substring(startIndex, text.length));
  }

  return result;
}

bool _isRecurrenceDate(
    DateTime addDate, List<String> weeklyRule, int weeklyByDayPos) {
  bool isRecurrenceDate = false;
  switch (addDate.weekday) {
    case DateTime.sunday:
      {
        if (weeklyRule[weeklyByDayPos].contains('SU')) {
          isRecurrenceDate = true;
        }

        break;
      }

    case DateTime.monday:
      {
        if (weeklyRule[weeklyByDayPos].contains('MO')) {
          isRecurrenceDate = true;
        }

        break;
      }

    case DateTime.tuesday:
      {
        if (weeklyRule[weeklyByDayPos].contains('TU')) {
          isRecurrenceDate = true;
        }

        break;
      }

    case DateTime.wednesday:
      {
        if (weeklyRule[weeklyByDayPos].contains('WE')) {
          isRecurrenceDate = true;
        }

        break;
      }

    case DateTime.thursday:
      {
        if (weeklyRule[weeklyByDayPos].contains('TH')) {
          isRecurrenceDate = true;
        }

        break;
      }

    case DateTime.friday:
      {
        if (weeklyRule[weeklyByDayPos].contains('FR')) {
          isRecurrenceDate = true;
        }

        break;
      }

    case DateTime.saturday:
      {
        if (weeklyRule[weeklyByDayPos].contains('SA')) {
          isRecurrenceDate = true;
        }

        break;
      }
  }

  return isRecurrenceDate;
}

void _setWeeklyRecurrenceDate(DateTime addDate, List<String> weeklyRule,
    int weeklyByDayPos, List<DateTime> recDateCollection) {
  switch (addDate.weekday) {
    case DateTime.sunday:
      {
        if (weeklyRule[weeklyByDayPos].contains('SU')) {
          recDateCollection.add(addDate);
        }

        break;
      }

    case DateTime.monday:
      {
        if (weeklyRule[weeklyByDayPos].contains('MO')) {
          recDateCollection.add(addDate);
        }

        break;
      }

    case DateTime.tuesday:
      {
        if (weeklyRule[weeklyByDayPos].contains('TU')) {
          recDateCollection.add(addDate);
        }

        break;
      }

    case DateTime.wednesday:
      {
        if (weeklyRule[weeklyByDayPos].contains('WE')) {
          recDateCollection.add(addDate);
        }

        break;
      }

    case DateTime.thursday:
      {
        if (weeklyRule[weeklyByDayPos].contains('TH')) {
          recDateCollection.add(addDate);
        }

        break;
      }

    case DateTime.friday:
      {
        if (weeklyRule[weeklyByDayPos].contains('FR')) {
          recDateCollection.add(addDate);
        }

        break;
      }

    case DateTime.saturday:
      {
        if (weeklyRule[weeklyByDayPos].contains('SA')) {
          recDateCollection.add(addDate);
        }

        break;
      }
  }
}

String _sortByDay(String byDay) {
  final List<String> sortedDays = <String>[
    'SU',
    'MO',
    'TU',
    'WE',
    'TH',
    'FR',
    'SA'
  ];
  String weeklydaystring = '';
  int count = 0;
  for (int i = 0; i < sortedDays.length; i++) {
    if (!byDay.contains(sortedDays[i])) {
      continue;
    }

    count++;
    String day = sortedDays[i];
    if (count > 1) {
      day = ',' + day;
    }

    weeklydaystring = weeklydaystring + day;
  }

  return weeklydaystring;
}

_AppointmentView _getAppointmentView(
    Appointment appointment, _AppointmentPainter _appointmentPainter) {
  _AppointmentView appointmentRenderer;
  for (int i = 0; i < _appointmentPainter._appointmentCollection.length; i++) {
    final _AppointmentView view = _appointmentPainter._appointmentCollection[i];
    if (view.appointment == null) {
      appointmentRenderer = view;
      break;
    }
  }

  if (appointmentRenderer == null) {
    appointmentRenderer = _AppointmentView();
    appointmentRenderer.appointment = appointment;
    appointmentRenderer.canReuse = false;
    _appointmentPainter._appointmentCollection.add(appointmentRenderer);
  }

  appointmentRenderer.appointment = appointment;
  appointmentRenderer.canReuse = false;
  return appointmentRenderer;
}

void _createVisibleAppointments(_AppointmentPainter _appointmentPainter) {
  for (int i = 0; i < _appointmentPainter._appointmentCollection.length; i++) {
    final _AppointmentView appointmentView =
        _appointmentPainter._appointmentCollection[i];
    appointmentView.endIndex = -1;
    appointmentView.startIndex = -1;
    appointmentView.isSpanned = false;
    appointmentView.position = -1;
    appointmentView.maxPositions = 0;
    appointmentView.canReuse = true;
  }

  if (_appointmentPainter._visibleAppointments == null) {
    return;
  }

  for (int i = 0; i < _appointmentPainter._visibleAppointments.length; i++) {
    final Appointment appointment = _appointmentPainter._visibleAppointments[i];
    if (!appointment._isSpanned &&
        appointment._actualStartTime.day == appointment._actualEndTime.day &&
        appointment._actualStartTime.month ==
            appointment._actualEndTime.month) {
      final _AppointmentView appointmentView =
          _createAppointmentView(_appointmentPainter);
      appointmentView.appointment = appointment;
      appointmentView.canReuse = false;
      appointmentView.startIndex =
          _getDateIndex(appointment._actualStartTime, _appointmentPainter);
      if (appointmentView.startIndex == -1) {
        appointmentView.startIndex = 0;
      }

      appointmentView.endIndex =
          _getDateIndex(appointment._actualEndTime, _appointmentPainter);
      if (appointmentView.endIndex == -1) {
        appointmentView.endIndex = 41;
      }

      if (!_appointmentPainter._appointmentCollection
          .contains(appointmentView)) {
        _appointmentPainter._appointmentCollection.add(appointmentView);
      }
    } else {
      final _AppointmentView appointmentView =
          _createAppointmentView(_appointmentPainter);
      appointmentView.appointment = appointment;
      appointmentView.canReuse = false;
      appointmentView.startIndex =
          _getDateIndex(appointment._actualStartTime, _appointmentPainter);
      if (appointmentView.startIndex == -1) {
        appointmentView.startIndex = 0;
      }

      appointmentView.endIndex =
          _getDateIndex(appointment._actualEndTime, _appointmentPainter);
      if (appointmentView.endIndex == -1) {
        appointmentView.endIndex = 41;
      }

      _createAppointmentInfoForSpannedAppointment(
          appointmentView, _appointmentPainter);
    }
  }
}

void _createAppointmentInfoForSpannedAppointment(
    _AppointmentView appointmentView, _AppointmentPainter _appointmentPainter) {
  if (appointmentView.startIndex ~/ 7 != appointmentView.endIndex ~/ 7) {
    final int endIndex = appointmentView.endIndex;
    appointmentView.endIndex =
        ((((appointmentView.startIndex ~/ 7) + 1) * 7) - 1).toInt();
    appointmentView.isSpanned = true;
    if (_appointmentPainter._appointmentCollection != null &&
        !_appointmentPainter._appointmentCollection.contains(appointmentView)) {
      _appointmentPainter._appointmentCollection.add(appointmentView);
    }

    final _AppointmentView appointmentView1 =
        _createAppointmentView(_appointmentPainter);
    appointmentView1.appointment = appointmentView.appointment;
    appointmentView1.canReuse = false;
    appointmentView1.startIndex = appointmentView.endIndex + 1;
    appointmentView1.endIndex = endIndex;
    _createAppointmentInfoForSpannedAppointment(
        appointmentView1, _appointmentPainter);
  } else {
    appointmentView.isSpanned = true;
    if (!_appointmentPainter._appointmentCollection.contains(appointmentView)) {
      _appointmentPainter._appointmentCollection.add(appointmentView);
    }
  }
}

int _orderAppointmentViewBySpanned(
    _AppointmentView _appointmentView1, _AppointmentView _appointmentView2) {
  final int boolValue1 = _appointmentView1.isSpanned ? -1 : 1;
  final int boolValue2 = _appointmentView2.isSpanned ? -1 : 1;

  if (boolValue1 == boolValue2 &&
      _appointmentView2.startIndex == _appointmentView1.startIndex) {
    return (_appointmentView2.endIndex - _appointmentView2.startIndex)
        .compareTo(_appointmentView1.endIndex - _appointmentView1.startIndex);
  }

  return boolValue1.compareTo(boolValue2);
}

void _setAppointmentPosition(List<_AppointmentView> appointmentViewCollection,
    _AppointmentView appointmentView, int viewIndex) {
  for (int j = 0; j < appointmentViewCollection.length; j++) {
    if (j >= viewIndex) {
      break;
    }

    final _AppointmentView prevAppointmentView = appointmentViewCollection[j];
    if (!_isInterceptAppointments(appointmentView, prevAppointmentView)) {
      continue;
    }

    if (appointmentView.position == prevAppointmentView.position) {
      appointmentView.position = appointmentView.position + 1;
      appointmentView.maxPositions = appointmentView.position;
      prevAppointmentView.maxPositions = appointmentView.position;
      _setAppointmentPosition(
          appointmentViewCollection, appointmentView, viewIndex);
      break;
    }
  }
}

bool _isInterceptAppointments(
    _AppointmentView appointmentView1, _AppointmentView appointmentView2) {
  if (appointmentView1.startIndex <= appointmentView2.startIndex &&
          appointmentView1.endIndex >= appointmentView2.startIndex ||
      appointmentView2.startIndex <= appointmentView1.startIndex &&
          appointmentView2.endIndex >= appointmentView1.startIndex) {
    return true;
  }

  if (appointmentView1.startIndex <= appointmentView2.endIndex &&
          appointmentView1.endIndex >= appointmentView2.endIndex ||
      appointmentView2.startIndex <= appointmentView1.endIndex &&
          appointmentView2.endIndex >= appointmentView1.endIndex) {
    return true;
  }

  return false;
}

void _updateAppointmentPosition(_AppointmentPainter _appointmentPainter) {
  _appointmentPainter._appointmentCollection
      .sort((_AppointmentView app1, _AppointmentView app2) {
    if (app1.appointment?._actualStartTime != null &&
        app2.appointment?._actualStartTime != null) {
      return app1.appointment._actualStartTime
          .compareTo(app2.appointment._actualStartTime);
    }

    return 0;
  });
  _appointmentPainter._appointmentCollection.sort(
      (_AppointmentView app1, _AppointmentView app2) =>
          _orderAppointmentViewBySpanned(app1, app2));

  for (int j = 0; j < _appointmentPainter._appointmentCollection.length; j++) {
    final _AppointmentView appointmentView =
        _appointmentPainter._appointmentCollection[j];
    appointmentView.position = 1;
    appointmentView.maxPositions = 1;
    _setAppointmentPosition(
        _appointmentPainter._appointmentCollection, appointmentView, j);
  }
}

int _getDateIndex(DateTime date, _AppointmentPainter _appointmentPainter) {
  DateTime dateTime = _appointmentPainter
      ._visibleDates[_appointmentPainter._visibleDates.length - 7];
  int row = 0;
  for (int i = _appointmentPainter._visibleDates.length - 7; i >= 0; i -= 7) {
    DateTime currentDate = _appointmentPainter._visibleDates[i];
    currentDate = DateTime(currentDate.year, currentDate.month, currentDate.day,
        currentDate.hour, currentDate.minute, currentDate.second);
    if (currentDate.isBefore(date) ||
        (currentDate.day == date.day &&
            currentDate.month == date.month &&
            currentDate.year == date.year)) {
      dateTime = currentDate;
      row = i ~/ 7;
      break;
    }
  }

  final DateTime endDateTime = dateTime.add(const Duration(days: 6));
  int currentViewIndex = 0;
  while (dateTime.isBefore(endDateTime) ||
      (dateTime.day == endDateTime.day &&
          dateTime.month == endDateTime.month &&
          dateTime.year == endDateTime.year)) {
    if (dateTime.day == date.day &&
        dateTime.month == date.month &&
        dateTime.year == date.year) {
      return ((row * 7) + currentViewIndex).toInt();
    }

    currentViewIndex++;
    dateTime = dateTime.add(const Duration(days: 1));
  }

  return -1;
}

_AppointmentView _createAppointmentView(
    _AppointmentPainter _appointmentPainter) {
  _AppointmentView appointmentView;
  for (int i = 0; i < _appointmentPainter._appointmentCollection.length; i++) {
    final _AppointmentView view = _appointmentPainter._appointmentCollection[i];
    if (view.canReuse) {
      appointmentView = view;
      break;
    }
  }

  appointmentView = appointmentView ?? _AppointmentView();

  appointmentView.endIndex = -1;
  appointmentView.startIndex = -1;
  appointmentView.position = -1;
  appointmentView.maxPositions = 0;
  appointmentView.isSpanned = false;
  appointmentView.appointment = null;
  appointmentView.canReuse = true;
  return appointmentView;
}

void _updateAppointment(_AppointmentPainter _appointmentPainter) {
  _createVisibleAppointments(_appointmentPainter);
  if (_appointmentPainter._visibleAppointments != null &&
      _appointmentPainter._visibleAppointments.isNotEmpty) {
    _updateAppointmentPosition(_appointmentPainter);
  }
}

abstract class CalendarDataSource extends CalendarDataSourceChangeNotifier {
  List<dynamic> appointments;

  @protected
  DateTime getStartTime(int index) => null;

  @protected
  DateTime getEndTime(int index) => null;

  @protected
  String getSubject(int index) => '';

  @protected
  bool isAllDay(int index) => false;

  @protected
  Color getColor(int index) => Colors.lightBlue;

  @protected
  String getNotes(int index) => '';

  @protected
  String getLocation(int index) => '';

  @protected
  String getStartTimeZone(int index) => '';

  @protected
  String getEndTimeZone(int index) => '';

  @protected
  String getRecurrenceRule(int index) => '';

  @protected
  List<DateTime> getRecurrenceExceptionDates(int index) => null;
}

typedef CalendarDataSourceCallback = void Function(
    CalendarDataSourceAction, List<dynamic>);

class CalendarDataSourceChangeNotifier {
  List<CalendarDataSourceCallback> _listeners;

  void addListener(CalendarDataSourceCallback _listener) {
    _listeners ??= <CalendarDataSourceCallback>[];
    _listeners.add(_listener);
  }

  void removeListener(CalendarDataSourceCallback _listener) {
    if (_listeners == null) {
      return;
    }

    _listeners.remove(_listener);
  }

  void notifyListeners(CalendarDataSourceAction type, List<dynamic> data) {
    if (_listeners == null) {
      return;
    }

    for (CalendarDataSourceCallback listener in _listeners) {
      if (listener != null) {
        listener(type, data);
      }
    }
  }

  @mustCallSuper
  void dispose() {
    _listeners = null;
  }
}

DateTime _convertToStartTime(DateTime date) {
  return DateTime(date.year, date.month, date.day, 0, 0, 0);
}

DateTime _convertToEndTime(DateTime date) {
  return DateTime(date.year, date.month, date.day, 23, 59, 59);
}

bool _isCalendarAppointment(List<dynamic> dataSource) {
  if (dataSource == null ||
      dataSource.isEmpty ||
      dataSource[0].runtimeType.toString() == 'Appointment') {
    return true;
  }

  return false;
}

bool _isSpanned(Appointment appointment) {
  return !(appointment._actualEndTime.day == appointment._actualStartTime.day &&
          appointment._actualEndTime.month ==
              appointment._actualStartTime.month &&
          appointment._actualEndTime.year ==
              appointment._actualStartTime.year) &&
      appointment._actualEndTime
              .difference(appointment._actualStartTime)
              .inDays >
          0;
}

TextSpan _getRecurrenceIcon(Color color, double textSize) {
  return TextSpan(
      text: String.fromCharCode(59491),
      style: TextStyle(
        color: color,
        fontSize: textSize,
        fontFamily: 'MaterialIcons',
      ));
}

List<Appointment> _getSelectedDateAppointments(
    List<Appointment> appointments, String timeZone, DateTime date) {
  final List<Appointment> appointmentCollection = <Appointment>[];
  if (appointments == null || appointments.isEmpty || date == null) {
    return <Appointment>[];
  }

  final DateTime startDate = _convertToStartTime(date);
  final DateTime endDate = _convertToEndTime(date);
  int count = 0;
  if (appointments != null) {
    count = appointments.length;
  }

  for (int j = 0; j < count; j++) {
    final Appointment appointment = appointments[j];
    appointment._actualStartTime = _convertTimeToAppointmentTimeZone(
        appointment.startTime, appointment.startTimeZone, timeZone);
    appointment._actualEndTime = _convertTimeToAppointmentTimeZone(
        appointment.endTime, appointment.endTimeZone, timeZone);

    if (appointment.recurrenceRule == null ||
        appointment.recurrenceRule == '') {
      if (_isAppointmentWithinVisibleDateRange(
          appointment, startDate, endDate)) {
        appointmentCollection.add(appointment);
      }

      continue;
    }

    _getRecurrenceAppointments(
        appointment, appointmentCollection, startDate, endDate, timeZone);
  }

  return appointmentCollection;
}

Appointment _copy(Appointment appointment) {
  final Appointment _copyAppointment = Appointment();
  _copyAppointment.startTime = appointment.startTime;
  _copyAppointment.endTime = appointment.endTime;
  _copyAppointment.isAllDay = appointment.isAllDay;
  _copyAppointment.subject = appointment.subject;
  _copyAppointment.color = appointment.color;
  _copyAppointment._actualStartTime = appointment._actualStartTime;
  _copyAppointment._actualEndTime = appointment._actualEndTime;
  _copyAppointment.startTimeZone = appointment.startTimeZone;
  _copyAppointment.endTimeZone = appointment.endTimeZone;
  _copyAppointment.recurrenceRule = appointment.recurrenceRule;
  _copyAppointment.recurrenceExceptionDates =
      appointment.recurrenceExceptionDates;
  _copyAppointment.notes = appointment.notes;
  _copyAppointment.location = appointment.location;
  _copyAppointment._isSpanned = appointment._isSpanned;
  _copyAppointment._data = appointment._data;
  return _copyAppointment;
}

List<Appointment> _getVisibleSelectedDateAppointments(
    SfCalendar calendar, DateTime date, List<dynamic> _visibleAppointments) {
  final List<Appointment> appointmentCollection = <Appointment>[];
  if (date == null || _visibleAppointments == null) {
    return appointmentCollection;
  }

  final DateTime startDate = _convertToStartTime(date);
  final DateTime endDate = _convertToEndTime(date);

  for (int j = 0; j < _visibleAppointments.length; j++) {
    final Appointment appointment = _visibleAppointments[j];
    if (_isAppointmentWithinVisibleDateRange(appointment, startDate, endDate)) {
      appointmentCollection.add(appointment);
    }
  }

  return appointmentCollection;
}

bool _isAppointmentWithinVisibleDateRange(
    Appointment appointment, DateTime visibleStart, DateTime visibleEnd) {
  final DateTime appStartTime = appointment._actualStartTime;
  final DateTime appEndTime = appointment._actualEndTime;
  if (appStartTime.isAfter(visibleStart)) {
    if (appStartTime.isBefore(visibleEnd)) {
      return true;
    }
  } else if (appStartTime.day == visibleStart.day &&
      appStartTime.month == visibleStart.month &&
      appStartTime.year == visibleStart.year) {
    return true;
  } else if (appEndTime.isAfter(visibleStart)) {
    return true;
  }

  return false;
}

bool _isAppointmentInVisibleDateRange(
    Appointment appointment, DateTime visibleStart, DateTime visibleEnd) {
  final DateTime appStartTime = appointment._actualStartTime;
  final DateTime appEndTime = appointment._actualEndTime;
  if ((appStartTime.isAfter(visibleStart) ||
          (appStartTime.day == visibleStart.day &&
              appStartTime.month == visibleStart.month &&
              appStartTime.year == visibleStart.year)) &&
      (appStartTime.isBefore(visibleEnd) ||
          (appStartTime.day == visibleEnd.day &&
              appStartTime.month == visibleEnd.month &&
              appStartTime.year == visibleEnd.year)) &&
      (appEndTime.isAfter(visibleStart) ||
          (appEndTime.day == visibleStart.day &&
              appEndTime.month == visibleStart.month &&
              appEndTime.year == visibleStart.year)) &&
      (appEndTime.isBefore(visibleEnd) ||
          (appEndTime.day == visibleEnd.day &&
              appEndTime.month == visibleEnd.month &&
              appEndTime.year == visibleEnd.year))) {
    return true;
  }

  return false;
}

bool _isAppointmentStartDateWithinVisibleDateRange(
    DateTime appointmentStartDate, DateTime visibleStart, DateTime visibleEnd) {
  if (appointmentStartDate.isAfter(visibleStart)) {
    if (appointmentStartDate.isBefore(visibleEnd)) {
      return true;
    }
  } else if (appointmentStartDate.day == visibleStart.day &&
      appointmentStartDate.month == visibleStart.month &&
      appointmentStartDate.year == visibleStart.year) {
    return true;
  }

  return false;
}

bool _isAppointmentEndDateWithinVisibleDateRange(
    DateTime appointmentEndDate, DateTime visibleStart, DateTime visibleEnd) {
  if (appointmentEndDate.isAfter(visibleStart)) {
    if (appointmentEndDate.isBefore(visibleEnd)) {
      return true;
    }
  } else if (appointmentEndDate.day == visibleEnd.day &&
      appointmentEndDate.month == visibleEnd.month &&
      appointmentEndDate.year == visibleEnd.year) {
    return true;
  }

  return false;
}

Location _timeZoneInfoToOlsonTimeZone(String windowsTimeZoneId) {
  final Map<String, String> olsonWindowsTimes = <String, String>{};
  olsonWindowsTimes['AUS Central Standard Time'] = 'Australia/Darwin';
  olsonWindowsTimes['AUS Eastern Standard Time'] = 'Australia/Sydney';
  olsonWindowsTimes['Afghanistan Standard Time'] = 'Asia/Kabul';
  olsonWindowsTimes['Alaskan Standard Time'] = 'America/Anchorage';
  olsonWindowsTimes['Arab Standard Time'] = 'Asia/Riyadh';
  olsonWindowsTimes['Arabian Standard Time'] = 'Indian/Reunion';
  olsonWindowsTimes['Arabic Standard Time'] = 'Asia/Baghdad';
  olsonWindowsTimes['Argentina Standard Time'] =
      'America/Argentina/Buenos_Aires';
  olsonWindowsTimes['Atlantic Standard Time'] = 'America/Halifax';
  olsonWindowsTimes['Azerbaijan Standard Time'] = 'Asia/Baku';
  olsonWindowsTimes['Azores Standard Time'] = 'Atlantic/Azores';
  olsonWindowsTimes['Bahia Standard Time'] = 'America/Bahia';
  olsonWindowsTimes['Bangladesh Standard Time'] = 'Asia/Dhaka';
  olsonWindowsTimes['Belarus Standard Time'] = 'Europe/Minsk';
  olsonWindowsTimes['Canada Central Standard Time'] = 'America/Regina';
  olsonWindowsTimes['Cape Verde Standard Time'] = 'Atlantic/Cape_Verde';
  olsonWindowsTimes['Caucasus Standard Time'] = 'Asia/Yerevan';
  olsonWindowsTimes['Cen. Australia Standard Time'] = 'Australia/Adelaide';
  olsonWindowsTimes['Central America Standard Time'] = 'America/Guatemala';
  olsonWindowsTimes['Central Asia Standard Time'] = 'Asia/Almaty';
  olsonWindowsTimes['Central Brazilian Standard Time'] = 'America/Cuiaba';
  olsonWindowsTimes['Central Europe Standard Time'] = 'Europe/Budapest';
  olsonWindowsTimes['Central European Standard Time'] = 'Europe/Warsaw';
  olsonWindowsTimes['Central Pacific Standard Time'] = 'Pacific/Guadalcanal';
  olsonWindowsTimes['Central Standard Time'] = 'America/Chicago';
  olsonWindowsTimes['China Standard Time'] = 'Asia/Shanghai';
  olsonWindowsTimes['Dateline Standard Time'] = 'Etc/GMT+12';
  olsonWindowsTimes['E. Africa Standard Time'] = 'Africa/Nairobi';
  olsonWindowsTimes['E. Australia Standard Time'] = 'Australia/Brisbane';
  olsonWindowsTimes['E. South America Standard Time'] = 'America/Sao_Paulo';
  olsonWindowsTimes['Eastern Standard Time'] = 'America/New_York';
  olsonWindowsTimes['Egypt Standard Time'] = 'Africa/Cairo';
  olsonWindowsTimes['Ekaterinburg Standard Time'] = 'Asia/Yekaterinburg';
  olsonWindowsTimes['FLE Standard Time'] = 'Europe/Kiev';
  olsonWindowsTimes['Fiji Standard Time'] = 'Pacific/Fiji';
  olsonWindowsTimes['GMT Standard Time'] = 'Europe/London';
  olsonWindowsTimes['GTB Standard Time'] = 'Europe/Bucharest';
  olsonWindowsTimes['Georgian Standard Time'] = 'Asia/Tbilisi';
  olsonWindowsTimes['Greenland Standard Time'] = 'America/Godthab';
  olsonWindowsTimes['Greenwich Standard Time'] = 'Atlantic/Reykjavik';
  olsonWindowsTimes['Hawaiian Standard Time'] = 'Pacific/Honolulu';
  olsonWindowsTimes['India Standard Time'] = 'Asia/Kolkata';
  olsonWindowsTimes['Iran Standard Time'] = 'Asia/Tehran';
  olsonWindowsTimes['Israel Standard Time'] = 'Asia/Jerusalem';
  olsonWindowsTimes['Jordan Standard Time'] = 'Asia/Amman';
  olsonWindowsTimes['Kaliningrad Standard Time'] = 'Europe/Kaliningrad';
  olsonWindowsTimes['Korea Standard Time'] = 'Asia/Seoul';
  olsonWindowsTimes['Libya Standard Time'] = 'Africa/Tripoli';
  olsonWindowsTimes['Line Islands Standard Time'] = 'Pacific/Kiritimati';
  olsonWindowsTimes['Magadan Standard Time'] = 'Asia/Magadan';
  olsonWindowsTimes['Mauritius Standard Time'] = 'Indian/Mauritius';
  olsonWindowsTimes['Middle East Standard Time'] = 'Asia/Beirut';
  olsonWindowsTimes['Montevideo Standard Time'] = 'America/Montevideo';
  olsonWindowsTimes['Morocco Standard Time'] = 'Africa/Casablanca';
  olsonWindowsTimes['Mountain Standard Time'] = 'America/Denver';
  olsonWindowsTimes['Mountain Standard Time (Mexico)'] = 'America/Chihuahua';
  olsonWindowsTimes['Myanmar Standard Time'] = 'Asia/Rangoon';
  olsonWindowsTimes['N. Central Asia Standard Time'] = 'Asia/Novosibirsk';
  olsonWindowsTimes['Namibia Standard Time'] = 'Africa/Windhoek';
  olsonWindowsTimes['Nepal Standard Time'] = 'Asia/Kathmandu';
  olsonWindowsTimes['New Zealand Standard Time'] = 'Pacific/Auckland';
  olsonWindowsTimes['Newfoundland Standard Time'] = 'America/St_Johns';
  olsonWindowsTimes['North Asia East Standard Time'] = 'Asia/Irkutsk';
  olsonWindowsTimes['North Asia Standard Time'] = 'Asia/Krasnoyarsk';
  olsonWindowsTimes['Pacific SA Standard Time'] = 'America/Santiago';
  olsonWindowsTimes['Pacific Standard Time'] = 'America/Los_Angeles';
  olsonWindowsTimes['Pacific Standard Time (Mexico)'] = 'America/Santa_Isabel';
  olsonWindowsTimes['Pakistan Standard Time'] = 'Asia/Karachi';
  olsonWindowsTimes['Paraguay Standard Time'] = 'America/Asuncion';
  olsonWindowsTimes['Romance Standard Time'] = 'Europe/Paris';
  olsonWindowsTimes['Russia Time Zone 10'] = 'Asia/Srednekolymsk';
  olsonWindowsTimes['Russia Time Zone 11'] = 'Asia/Kamchatka';
  olsonWindowsTimes['Russia Time Zone 3'] = 'Europe/Samara';
  olsonWindowsTimes['Russian Standard Time'] = 'Europe/Moscow';
  olsonWindowsTimes['SA Eastern Standard Time'] = 'America/Cayenne';
  olsonWindowsTimes['SA Pacific Standard Time'] = 'America/Bogota';
  olsonWindowsTimes['SA Western Standard Time'] = 'America/La_Paz';
  olsonWindowsTimes['SE Asia Standard Time'] = 'Asia/Bangkok';
  olsonWindowsTimes['Samoa Standard Time'] = 'Pacific/Apia';
  olsonWindowsTimes['Singapore Standard Time'] = 'Asia/Singapore';
  olsonWindowsTimes['South Africa Standard Time'] = 'Africa/Johannesburg';
  olsonWindowsTimes['Sri Lanka Standard Time'] = 'Asia/Colombo';
  olsonWindowsTimes['Syria Standard Time'] = 'Asia/Damascus';
  olsonWindowsTimes['Taipei Standard Time'] = 'Asia/Taipei';
  olsonWindowsTimes['Tasmania Standard Time'] = 'Australia/Hobart';
  olsonWindowsTimes['Tokyo Standard Time'] = 'Asia/Tokyo';
  olsonWindowsTimes['Tonga Standard Time'] = 'Pacific/Tongatapu';
  olsonWindowsTimes['Turkey Standard Time'] = 'Europe/Istanbul';
  olsonWindowsTimes['US Eastern Standard Time'] =
      'America/Indiana/Indianapolis';
  olsonWindowsTimes['US Mountain Standard Time'] = 'America/Phoenix';
  olsonWindowsTimes['UTC'] = 'America/Danmarkshavn';
  olsonWindowsTimes['UTC+12'] = 'Pacific/Tarawa';
  olsonWindowsTimes['UTC-02'] = 'America/Noronha';
  olsonWindowsTimes['UTC-11'] = 'Pacific/Midway';
  olsonWindowsTimes['Ulaanbaatar Standard Time'] = 'Asia/Ulaanbaatar';
  olsonWindowsTimes['Venezuela Standard Time'] = 'America/Caracas';
  olsonWindowsTimes['Vladivostok Standard Time'] = 'Asia/Vladivostok';
  olsonWindowsTimes['W. Australia Standard Time'] = 'Australia/Perth';
  olsonWindowsTimes['W. Central Africa Standard Time'] = 'Africa/Lagos';
  olsonWindowsTimes['W. Europe Standard Time'] = 'Europe/Berlin';
  olsonWindowsTimes['West Asia Standard Time'] = 'Asia/Tashkent';
  olsonWindowsTimes['West Pacific Standard Time'] = 'Pacific/Port_Moresby';
  olsonWindowsTimes['Yakutsk Standard Time'] = 'Asia/Yakutsk';

  if (olsonWindowsTimes.containsKey(windowsTimeZoneId)) {
    final String timeZone = olsonWindowsTimes[windowsTimeZoneId];
    return getLocation(timeZone);
  } else {
    return null;
  }
}

bool _isDateTimeEqual(DateTime date1, DateTime date2) {
  if (date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day &&
      date1.hour == date2.hour &&
      date1.minute == date2.minute) {
    return true;
  }

  return false;
}

bool _isDateEqual(DateTime date1, DateTime date2) {
  if (date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day) {
    return true;
  }

  return false;
}

double _timeToPosition(
    SfCalendar calendar, DateTime date, double _timeIntervalHeight) {
  final double singleIntervalHeightForAnHour =
      ((60 / _getTimeInterval(calendar.timeSlotViewSettings)) *
              _timeIntervalHeight)
          .toDouble();
  final int hour = date.hour;
  final int minute = date.minute;
  final int seconds = date.second;
  double startHour = 0;
  if (calendar.timeSlotViewSettings != null) {
    startHour = calendar.timeSlotViewSettings.startHour;
  }

  return ((hour + (minute / 60).toDouble() + (seconds / 3600).toDouble()) *
          singleIntervalHeightForAnHour) -
      (startHour * singleIntervalHeightForAnHour).toDouble();
}

double _getAppointmentHeightFromDuration(
    Duration minimumDuration, SfCalendar calendar, double _timeIntervalHeight) {
  if (minimumDuration == null || minimumDuration.inMinutes <= 0) {
    return 0;
  }

  final double hourHeight =
      ((60 / _getTimeInterval(calendar.timeSlotViewSettings)) *
              _timeIntervalHeight)
          .toDouble();
  return minimumDuration.inMinutes * (hourHeight / 60);
}

double _getAppointmentMinHeight(
    SfCalendar calendar, _AppointmentView appView, double _timeIntervalHeight) {
  double minHeight;

  // Appointment Default Bottom Position without considering MinHeight
  final double defaultAppHeight = _timeToPosition(
          calendar, appView.appointment._actualEndTime, _timeIntervalHeight) -
      _timeToPosition(
          calendar, appView.appointment._actualStartTime, _timeIntervalHeight);

  minHeight = _getAppointmentHeightFromDuration(
      calendar.timeSlotViewSettings.minimumAppointmentDuration,
      calendar,
      _timeIntervalHeight);

  // Appointment Default Bottom Position - Default value as double.NaN
  if (minHeight == 0) {
    return defaultAppHeight;
  } else if ((minHeight < defaultAppHeight) ||
      (_timeIntervalHeight < defaultAppHeight)) {
    // Appointment Minimum Height is smaller than default Appointment Height
    // Appointment default Height is greater than TimeIntervalHeight
    return defaultAppHeight;
  } else if (minHeight > _timeIntervalHeight) {
    // Appointment Minimum Height is greater than Interval Height
    return _timeIntervalHeight;
  } else {
    // Appointment with proper MinHeight and within Interval
    return minHeight; //appView.Appointment.MinHeight;
  }
}

bool _isIntersectingAppointmentInDayView(
    SfCalendar calendar,
    Appointment currentApp,
    _AppointmentView appView,
    Appointment appointment,
    bool isAllDay,
    double _timeIntervalHeight) {
  if (currentApp == appointment) {
    return false;
  }

  if (currentApp._actualStartTime.isBefore(appointment._actualEndTime) &&
      currentApp._actualStartTime.isAfter(appointment._actualStartTime)) {
    return true;
  }

  if (currentApp._actualEndTime.isAfter(appointment._actualStartTime) &&
      currentApp._actualEndTime.isBefore(appointment._actualEndTime)) {
    return true;
  }

  if (currentApp._actualEndTime.isAfter(appointment._actualEndTime) &&
      currentApp._actualStartTime.isBefore(appointment._actualStartTime)) {
    return true;
  }

  if (_isDateTimeEqual(
          currentApp._actualStartTime, appointment._actualStartTime) ||
      _isDateTimeEqual(currentApp._actualEndTime, appointment._actualEndTime)) {
    return true;
  }

  if (isAllDay) {
    return false;
  }

  // Intersecting appointments by comparing appointments MinHeight instead of Start and EndTime
  if (calendar.timeSlotViewSettings.minimumAppointmentDuration != null &&
      calendar.timeSlotViewSettings.minimumAppointmentDuration.inMinutes > 0) {
    // Comparing appointments rendered in different dates
    if (!_isDateEqual(
        currentApp._actualStartTime, appointment._actualStartTime)) {
      return false;
    }

    // Comparing appointments rendered in the same date
    final double appTopPos = _timeToPosition(
        calendar, appointment._actualStartTime, _timeIntervalHeight);
    final double currentAppTopPos = _timeToPosition(
        calendar, currentApp._actualStartTime, _timeIntervalHeight);
    final double appHeight =
        _getAppointmentMinHeight(calendar, appView, _timeIntervalHeight);
    // Height difference between previous and current appointment from top position
    final double heightDiff = currentAppTopPos - appTopPos;
    if (appTopPos != currentAppTopPos && appHeight > heightDiff) {
      return true;
    }
  }

  return false;
}

_AppointmentView _getAppointmentOnPosition(
    _AppointmentView currentView, List<_AppointmentView> views) {
  if (currentView == null ||
      currentView.appointment == null ||
      views == null ||
      views.isEmpty) {
    return null;
  }

  for (_AppointmentView view in views) {
    if (view.position == currentView.position && view != currentView) {
      return view;
    }
  }

  return null;
}

bool _iterateAppointment(Appointment app, SfCalendar calendar, bool isAllDay) {
  final bool _isTimeline = _isTimelineView(calendar.view);
  if (isAllDay) {
    if (!_isTimeline && app.isAllDay) {
      app._actualEndTime = _convertToEndTime(app._actualEndTime);
      app._actualStartTime = _convertToStartTime(app._actualStartTime);
      return true;
    } else if (!_isTimeline && _isSpanned(app)) {
      return true;
    }

    return false;
  }

  if ((app.isAllDay || _isSpanned(app)) && !_isTimeline) {
    return false;
  }

  if (_isTimeline && app.isAllDay) {
    app._actualEndTime = _convertToEndTime(app._actualEndTime);
    app._actualStartTime = _convertToStartTime(app._actualStartTime);
  }

  return true;
}

int _orderAppointmentsDescending(bool value, bool value1) {
  int boolValue1 = -1;
  int boolValue2 = -1;
  if (value) {
    boolValue1 = 1;
  }

  if (value1) {
    boolValue2 = 1;
  }

  return boolValue1.compareTo(boolValue2);
}

int _orderAppointmentsAscending(bool value, bool value1) {
  int boolValue1 = 1;
  int boolValue2 = 1;
  if (value) {
    boolValue1 = -1;
  }

  if (value1) {
    boolValue2 = -1;
  }

  return boolValue1.compareTo(boolValue2);
}

void _setAppointmentPositionAndMaxPosition(
    Object parent,
    SfCalendar calendar,
    List<Appointment> visibleAppointments,
    bool isAllDay,
    double _timeIntervalHeight) {
  if (visibleAppointments == null) {
    return;
  }

  final List<Appointment> normalAppointments = visibleAppointments
      .where((Appointment app) => _iterateAppointment(app, calendar, isAllDay))
      .toList();
  normalAppointments.sort((Appointment app1, Appointment app2) =>
      app1._actualStartTime.compareTo(app2._actualStartTime));
  if (!_isTimelineView(calendar.view)) {
    normalAppointments.sort((Appointment app1, Appointment app2) =>
        _orderAppointmentsDescending(app1._isSpanned, app2._isSpanned));
    normalAppointments.sort((Appointment app1, Appointment app2) =>
        _orderAppointmentsDescending(app1.isAllDay, app2.isAllDay));
  } else {
    normalAppointments.sort((Appointment app1, Appointment app2) =>
        _orderAppointmentsAscending(app1._isSpanned, app2._isSpanned));
    normalAppointments.sort((Appointment app1, Appointment app2) =>
        _orderAppointmentsAscending(app1.isAllDay, app2.isAllDay));
  }

  final Map<int, List<_AppointmentView>> dict = <int, List<_AppointmentView>>{};
  final List<_AppointmentView> processedViews = <_AppointmentView>[];
  int maxColsCount = 1;

  for (int count = 0; count < normalAppointments.length; count++) {
    final Appointment currentAppointment = normalAppointments[count];
    //Where this condition was not needed to iOS, because we have get the appointment for specific date. In Android we pass the visible date range.
    if ((calendar.view == CalendarView.workWeek ||
            calendar.view == CalendarView.timelineWorkWeek) &&
        calendar.timeSlotViewSettings.nonWorkingDays
            .contains(currentAppointment._actualStartTime.weekday) &&
        calendar.timeSlotViewSettings.nonWorkingDays
            .contains(currentAppointment._actualEndTime.weekday)) {
      continue;
    }

    List<_AppointmentView> intersectingApps;
    _AppointmentView currentAppView;
    if (parent is _AppointmentPainter) {
      currentAppView = _getAppointmentView(currentAppointment, parent);
    } else {
      final _SfCalendarState state = parent;
      currentAppView = state._getAppointmentView(currentAppointment);
    }

    for (int position = 0; position < maxColsCount; position++) {
      bool isIntersecting = false;
      for (int j = 0; j < processedViews.length; j++) {
        final _AppointmentView previousApp = processedViews[j];

        if (previousApp.position != position) {
          continue;
        }

        if (_isIntersectingAppointmentInDayView(
            calendar,
            currentAppointment,
            previousApp,
            previousApp.appointment,
            isAllDay,
            _timeIntervalHeight)) {
          isIntersecting = true;

          if (intersectingApps == null) {
            final List<int> keyList = dict.keys.toList();
            for (int keyCount = 0; keyCount < keyList.length; keyCount++) {
              final int key = keyList[keyCount];
              if (dict[key].contains(previousApp)) {
                intersectingApps = dict[key];
                break;
              }
            }

            if (intersectingApps == null) {
              intersectingApps = <_AppointmentView>[];
              dict[dict.keys.length] = intersectingApps;
            }

            break;
          }
        }
      }

      if (!isIntersecting && currentAppView.position == -1) {
        currentAppView.position = position;
      }
    }

    processedViews.add(currentAppView);
    if (currentAppView.position == -1) {
      int position = 0;
      if (intersectingApps == null) {
        intersectingApps = <_AppointmentView>[];
        dict[dict.keys.length] = intersectingApps;
      } else if (intersectingApps.isNotEmpty) {
        position = intersectingApps
            .reduce((_AppointmentView currentAppview,
                    _AppointmentView nextAppview) =>
                currentAppview.maxPositions > nextAppview.maxPositions
                    ? currentAppview
                    : nextAppview)
            .maxPositions;
      }

      intersectingApps.add(currentAppView);
      for (int appin = 0; appin < intersectingApps.length; appin++) {
        intersectingApps[appin].maxPositions = position + 1;
      }

      currentAppView.position = position;
      if (maxColsCount <= position) {
        maxColsCount = position + 1;
      }
    } else {
      int maxPosition = 1;
      if (intersectingApps == null) {
        intersectingApps = <_AppointmentView>[];
        dict[dict.keys.length] = intersectingApps;
      } else if (intersectingApps.isNotEmpty) {
        maxPosition = intersectingApps
            .reduce((_AppointmentView currentAppview,
                    _AppointmentView nextAppview) =>
                currentAppview.maxPositions > nextAppview.maxPositions
                    ? currentAppview
                    : nextAppview)
            .maxPositions;

        if (currentAppView.position == maxPosition) {
          maxPosition++;
        }
      }

      intersectingApps.add(currentAppView);
      for (int appin = 0; appin < intersectingApps.length; appin++) {
        intersectingApps[appin].maxPositions = maxPosition;
      }

      if (maxColsCount <= maxPosition) {
        maxColsCount = maxPosition + 1;
      }
    }

    intersectingApps = null;
  }

  dict.clear();
}

DateTime _convertTimeToAppointmentTimeZone(
    DateTime date, String appTimeZoneId, String calendarTimeZoneId) {
  if ((appTimeZoneId == null || appTimeZoneId == '') &&
      (calendarTimeZoneId == null || calendarTimeZoneId == '')) {
    return date;
  }

  DateTime convertedDate = date;
  if (appTimeZoneId != null && appTimeZoneId != '') {
    if (appTimeZoneId == 'Dateline Standard Time') {
      convertedDate = (date.toUtc()).subtract(const Duration(hours: 12));
    } else {
      convertedDate =
          TZDateTime.from(date, _timeZoneInfoToOlsonTimeZone(appTimeZoneId));
    }

    convertedDate = DateTime(
        date.year - (convertedDate.year - date.year),
        date.month - (convertedDate.month - date.month),
        date.day - (convertedDate.day - date.day),
        date.hour - (convertedDate.hour - date.hour),
        date.minute - (convertedDate.minute - date.minute),
        date.second);
  }

  if (calendarTimeZoneId != null && calendarTimeZoneId != '') {
    convertedDate ??= date;

    DateTime actualConvertedDate;

    if (calendarTimeZoneId == 'Dateline Standard Time') {
      actualConvertedDate =
          (convertedDate.toUtc()).subtract(const Duration(hours: 12));
    } else {
      actualConvertedDate = TZDateTime.from(
          convertedDate, _timeZoneInfoToOlsonTimeZone(calendarTimeZoneId));
    }

    return DateTime(
        convertedDate.year + (actualConvertedDate.year - convertedDate.year),
        convertedDate.month + (actualConvertedDate.month - convertedDate.month),
        convertedDate.day + (actualConvertedDate.day - convertedDate.day),
        convertedDate.hour + (actualConvertedDate.hour - convertedDate.hour),
        convertedDate.minute +
            (actualConvertedDate.minute - convertedDate.minute),
        convertedDate.second);
  }

  return convertedDate;
}

List<Appointment> _getVisibleAppointments(
    DateTime visibleStartDate,
    DateTime visibleEndDate,
    List<Appointment> appointments,
    String calendarTimeZone,
    bool isTimelineView) {
  final List<Appointment> appointmentColl = <Appointment>[];
  if (visibleStartDate == null ||
      visibleEndDate == null ||
      appointments == null) {
    return appointmentColl;
  }

  final DateTime startDate = _convertToStartTime(visibleStartDate);
  final DateTime endDate = _convertToEndTime(visibleEndDate);
  int count = 0;
  if (appointments != null) {
    count = appointments.length;
  }

  for (int j = 0; j < count; j++) {
    final Appointment appointment = appointments[j];
    appointment._actualStartTime = _convertTimeToAppointmentTimeZone(
        appointment.startTime, appointment.startTimeZone, calendarTimeZone);
    appointment._actualEndTime = _convertTimeToAppointmentTimeZone(
        appointment.endTime, appointment.endTimeZone, calendarTimeZone);

    if (appointment.recurrenceRule == null ||
        appointment.recurrenceRule == '') {
      if (_isAppointmentWithinVisibleDateRange(
          appointment, startDate, endDate)) {
        final DateTime appStartTime = appointment._actualStartTime;
        final DateTime appEndTime = appointment._actualEndTime;

        if (!(appStartTime.day == appEndTime.day &&
                appStartTime.year == appEndTime.year &&
                appStartTime.month == appEndTime.month) &&
            appStartTime.isBefore(appEndTime) &&
            (appEndTime.difference(appStartTime)).inDays == 0 &&
            !appointment.isAllDay &&
            !isTimelineView) {
          for (int i = 0; i < 2; i++) {
            final Appointment spannedAppointment = _copy(appointment);
            if (i == 0) {
              spannedAppointment._actualEndTime = DateTime(appStartTime.year,
                  appStartTime.month, appStartTime.day, 23, 59, 59);
            } else {
              spannedAppointment._actualStartTime = DateTime(
                  appEndTime.year, appEndTime.month, appEndTime.day, 0, 0, 0);
            }

            spannedAppointment.startTime = spannedAppointment.isAllDay
                ? appointment._actualStartTime
                : _convertTimeToAppointmentTimeZone(
                    appointment._actualStartTime,
                    appointment.startTimeZone,
                    calendarTimeZone);
            spannedAppointment.endTime = spannedAppointment.isAllDay
                ? appointment._actualEndTime
                : _convertTimeToAppointmentTimeZone(appointment._actualEndTime,
                    appointment.endTimeZone, calendarTimeZone);

            // Adding Spanned Appointment only when the Appointment range within the VisibleDate
            if (_isAppointmentWithinVisibleDateRange(
                spannedAppointment, startDate, endDate)) {
              appointmentColl.add(spannedAppointment);
            }
          }
        } else if (!(appStartTime.day == appEndTime.day &&
                appStartTime.year == appEndTime.year &&
                appStartTime.month == appEndTime.month) &&
            appStartTime.isBefore(appEndTime) &&
            isTimelineView) {
          if (_isAppointmentInVisibleDateRange(
              appointment, startDate, endDate)) {
            appointment._isSpanned = _isSpanned(appointment);
            appointmentColl.add(appointment);
          } else if (_isAppointmentStartDateWithinVisibleDateRange(
              appointment._actualStartTime, startDate, endDate)) {
            for (int i = 0; i < 2; i++) {
              final Appointment spannedAppointment = _copy(appointment);
              if (i == 0) {
                spannedAppointment._actualEndTime = DateTime(
                    endDate.year, endDate.month, endDate.day, 23, 59, 59);
              } else {
                spannedAppointment._actualStartTime =
                    DateTime(endDate.year, endDate.month, endDate.day, 0, 0, 0);
              }

              spannedAppointment.startTime = spannedAppointment.isAllDay
                  ? appointment._actualStartTime
                  : _convertTimeToAppointmentTimeZone(
                      appointment._actualStartTime,
                      appointment.startTimeZone,
                      calendarTimeZone);
              spannedAppointment.endTime = spannedAppointment.isAllDay
                  ? appointment._actualEndTime
                  : _convertTimeToAppointmentTimeZone(
                      appointment._actualEndTime,
                      appointment.endTimeZone,
                      calendarTimeZone);

              // Adding Spanned Appointment only when the Appointment range within the VisibleDate
              if (_isAppointmentInVisibleDateRange(
                  spannedAppointment, startDate, endDate)) {
                spannedAppointment._isSpanned = _isSpanned(spannedAppointment);
                appointmentColl.add(spannedAppointment);
              }
            }
          } else if (_isAppointmentEndDateWithinVisibleDateRange(
              appointment._actualEndTime, startDate, endDate)) {
            for (int i = 0; i < 2; i++) {
              final Appointment spannedAppointment = _copy(appointment);
              if (i == 0) {
                spannedAppointment._actualStartTime =
                    appointment._actualStartTime;
                final DateTime date = startDate.add(const Duration(days: -1));
                spannedAppointment._actualEndTime =
                    DateTime(date.year, date.month, date.day, 23, 59, 59);
              } else {
                spannedAppointment._actualStartTime = DateTime(
                    startDate.year, startDate.month, startDate.day, 0, 0, 0);
              }

              spannedAppointment.startTime = spannedAppointment.isAllDay
                  ? appointment._actualStartTime
                  : _convertTimeToAppointmentTimeZone(
                      appointment._actualStartTime,
                      appointment.startTimeZone,
                      calendarTimeZone);
              spannedAppointment.endTime = spannedAppointment.isAllDay
                  ? appointment._actualEndTime
                  : _convertTimeToAppointmentTimeZone(
                      appointment._actualEndTime,
                      appointment.endTimeZone,
                      calendarTimeZone);

              // Adding Spanned Appointment only when the Appointment range within the VisibleDate
              if (_isAppointmentInVisibleDateRange(
                  spannedAppointment, startDate, endDate)) {
                spannedAppointment._isSpanned = _isSpanned(spannedAppointment);
                appointmentColl.add(spannedAppointment);
              }
            }
          } else if (!_isAppointmentEndDateWithinVisibleDateRange(
                  appointment._actualEndTime, startDate, endDate) &&
              !_isAppointmentStartDateWithinVisibleDateRange(
                  appointment._actualStartTime, startDate, endDate)) {
            for (int i = 0; i < 3; i++) {
              final Appointment spannedAppointment = _copy(appointment);
              if (i == 0) {
                final DateTime date = startDate.add(const Duration(days: -1));
                spannedAppointment._actualEndTime =
                    DateTime(date.year, date.month, date.day, 23, 59, 59);
              } else if (i == 1) {
                spannedAppointment._actualStartTime = DateTime(
                    startDate.year, startDate.month, startDate.day, 0, 0, 0);
                spannedAppointment._actualEndTime = DateTime(
                    endDate.year, endDate.month, endDate.day, 23, 59, 59);
              } else {
                final DateTime date = endDate.add(const Duration(days: 1));
                spannedAppointment._actualStartTime =
                    DateTime(date.year, date.month, date.day, 0, 0, 0);
              }

              spannedAppointment.startTime = spannedAppointment.isAllDay
                  ? appointment._actualStartTime
                  : _convertTimeToAppointmentTimeZone(
                      appointment._actualStartTime,
                      appointment.startTimeZone,
                      calendarTimeZone);
              spannedAppointment.endTime = spannedAppointment.isAllDay
                  ? appointment._actualEndTime
                  : _convertTimeToAppointmentTimeZone(
                      appointment._actualEndTime,
                      appointment.endTimeZone,
                      calendarTimeZone);

              // Adding Spanned Appointment only when the Appointment range within the VisibleDate
              if (_isAppointmentInVisibleDateRange(
                  spannedAppointment, startDate, endDate)) {
                spannedAppointment._isSpanned = _isSpanned(spannedAppointment);
                appointmentColl.add(spannedAppointment);
              }
            }
          } else {
            appointment._isSpanned = _isSpanned(appointment);
            appointmentColl.add(appointment);
          }
        } else {
          appointmentColl.add(appointment);
        }
      }

      continue;
    }

    _getRecurrenceAppointments(
        appointment, appointmentColl, startDate, endDate, calendarTimeZone);
  }

  return appointmentColl;
}

Appointment _cloneRecurrenceAppointment(Appointment appointment,
    int recurrenceIndex, DateTime recursiveDate, String calendarTimeZone) {
  final Appointment occurrenceAppointment = _copy(appointment);

  occurrenceAppointment._actualStartTime = recursiveDate;
  occurrenceAppointment.startTime = occurrenceAppointment.isAllDay
      ? occurrenceAppointment._actualStartTime
      : _convertTimeToAppointmentTimeZone(
          occurrenceAppointment._actualStartTime,
          occurrenceAppointment.startTimeZone,
          calendarTimeZone);

  final int minutes = appointment._actualEndTime
      .difference(appointment._actualStartTime)
      .inMinutes;
  occurrenceAppointment._actualEndTime =
      occurrenceAppointment._actualStartTime.add(Duration(minutes: minutes));
  occurrenceAppointment.endTime = occurrenceAppointment.isAllDay
      ? occurrenceAppointment._actualEndTime
      : _convertTimeToAppointmentTimeZone(occurrenceAppointment._actualEndTime,
          occurrenceAppointment.endTimeZone, calendarTimeZone);
  occurrenceAppointment._isSpanned = _isSpanned(occurrenceAppointment) &&
      (occurrenceAppointment.endTime
              .difference(occurrenceAppointment.startTime)
              .inDays >
          0);

  return occurrenceAppointment;
}

List<Appointment> _generateCalendarAppointments(
    CalendarDataSource calendarData, SfCalendar calendar,
    [List<dynamic> appointments]) {
  if (calendarData == null) {
    return null;
  }

  final List<dynamic> dataSource = appointments ?? calendarData.appointments;
  if (dataSource == null) {
    return null;
  }

  final List<Appointment> calendarAppointmentCollection = <Appointment>[];
  if (dataSource.isNotEmpty &&
      dataSource[0].runtimeType.toString() == 'Appointment') {
    for (int i = 0; i < dataSource.length; i++) {
      final Appointment item = dataSource[i];
      final DateTime appStartTime = item.startTime;
      final DateTime appEndTime = item.endTime;
      item._data = item;
      item._actualStartTime = !item.isAllDay
          ? _convertTimeToAppointmentTimeZone(
              item.startTime, item.startTimeZone, calendar.timeZone)
          : item.startTime;
      item._actualEndTime = !item.isAllDay
          ? _convertTimeToAppointmentTimeZone(
              item.endTime, item.endTimeZone, calendar.timeZone)
          : item.endTime;
      _updateTimeForInvalidEndTime(item, calendar.timeZone);
      calendarAppointmentCollection.add(item);

      item._isSpanned =
          _isSpanned(item) && (appEndTime.difference(appStartTime).inDays > 0);
    }
  } else {
    for (int i = 0; i < dataSource.length; i++) {
      final dynamic item = dataSource[i];
      final Appointment app = _createAppointment(item, calendar);

      final DateTime appStartTime = app.startTime;
      final DateTime appEndTime = app.endTime;
      app._isSpanned =
          _isSpanned(app) && (appEndTime.difference(appStartTime).inDays > 0);
      calendarAppointmentCollection.add(app);
    }
  }

  return calendarAppointmentCollection;
}

Appointment _createAppointment(Object appointmentObject, SfCalendar calendar) {
  final Appointment app = Appointment();
  final int index = calendar.dataSource.appointments.indexOf(appointmentObject);
  app.startTime = calendar.dataSource.getStartTime(index);
  app.endTime = calendar.dataSource.getEndTime(index);
  app.subject = calendar.dataSource.getSubject(index);
  app.isAllDay = calendar.dataSource.isAllDay(index);
  app.color = calendar.dataSource.getColor(index);
  app.notes = calendar.dataSource.getNotes(index);
  app.location = calendar.dataSource.getLocation(index);
  app.startTimeZone = calendar.dataSource.getStartTimeZone(index);
  app.endTimeZone = calendar.dataSource.getEndTimeZone(index);
  app.recurrenceRule = calendar.dataSource.getRecurrenceRule(index);
  app.recurrenceExceptionDates =
      calendar.dataSource.getRecurrenceExceptionDates(index);
  app._data = appointmentObject;
  app._actualStartTime = !app.isAllDay
      ? _convertTimeToAppointmentTimeZone(
          app.startTime, app.startTimeZone, calendar.timeZone)
      : app.startTime;
  app._actualEndTime = !app.isAllDay
      ? _convertTimeToAppointmentTimeZone(
          app.endTime, app.endTimeZone, calendar.timeZone)
      : app.endTime;
  _updateTimeForInvalidEndTime(app, calendar.timeZone);
  return app;
}

void _updateTimeForInvalidEndTime(
    Appointment appointment, String scheduleTimeZone) {
  if (appointment._actualEndTime.isBefore(appointment._actualStartTime) &&
      !appointment.isAllDay) {
    appointment.endTime = _convertTimeToAppointmentTimeZone(
        appointment._actualStartTime.add(const Duration(minutes: 30)),
        appointment.endTimeZone,
        scheduleTimeZone);
    appointment._actualEndTime = !appointment.isAllDay
        ? _convertTimeToAppointmentTimeZone(
            appointment.endTime, appointment.endTimeZone, scheduleTimeZone)
        : appointment.endTime;
  }
}

void _getRecurrenceAppointments(
    Appointment appointment,
    List<Appointment> appointments,
    DateTime visibleStartDate,
    DateTime visibleEndDate,
    String scheduleTimeZone) {
  final DateTime appStartTime = appointment._actualStartTime;
  dynamic recurrenceIndex = 0;
  if (appStartTime.isAfter(visibleEndDate)) {
    return;
  }

  String rule = appointment.recurrenceRule;
  if (!rule.contains('COUNT') && !rule.contains('UNTIL')) {
    final DateFormat formatter = DateFormat('yyyyMMdd');
    final String newSubString = ';UNTIL=' + formatter.format(visibleEndDate);
    rule = rule + newSubString;
  }

  List<DateTime> recursiveDates;
  DateTime endDate;
  final dynamic ruleSeparator = <String>['=', ';', ','];
  final List<String> rrule =
      _splitRule(appointment.recurrenceRule, ruleSeparator);
  if (appointment.recurrenceRule.contains('UNTIL')) {
    final dynamic untilValue = rrule[rrule.indexOf('UNTIL') + 1];
    //DateFormat formatter = DateFormat("yyyyMMdd");
    // endDate = DateTime.ParseExact(untilValue, "yyyyMMdd", CultureInfo.CurrentCulture);
    endDate = DateTime.parse(untilValue);
    endDate = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
  } else if (appointment.recurrenceRule.contains('COUNT')) {
    recursiveDates = _getRecurrenceDateTimeCollection(
        appointment.recurrenceRule, appointment._actualStartTime);
    endDate = recursiveDates.last;

    endDate = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
  }

  if ((appointment.recurrenceRule.contains('UNTIL') ||
          appointment.recurrenceRule.contains('COUNT')) &&
      !(appStartTime.isBefore(visibleEndDate) &&
          visibleStartDate.isBefore(endDate))) {
    return;
  }

  recursiveDates = _getRecurrenceDateTimeCollection(
      rule, appointment._actualStartTime,
      specificStartDate: visibleStartDate, specificEndDate: visibleEndDate);

  for (int j = 0; j < recursiveDates.length; j++) {
    final DateTime recursiveDate = recursiveDates[j];
    if (appointment.recurrenceExceptionDates != null) {
      bool isDateContains = false;
      for (int i = 0; i < appointment.recurrenceExceptionDates.length; i++) {
        final DateTime date = _convertTimeToAppointmentTimeZone(
            appointment.recurrenceExceptionDates[i], '', scheduleTimeZone);
        if (date.year == recursiveDate.year &&
            date.month == recursiveDate.month &&
            date.day == recursiveDate.day) {
          isDateContains = true;
          break;
        }
      }
      if (isDateContains) {
        continue;
      }
    }

    final Appointment occurrenceAppointment = _cloneRecurrenceAppointment(
        appointment, recurrenceIndex, recursiveDate, scheduleTimeZone);
    recurrenceIndex++;
    appointments.add(occurrenceAppointment);
  }
}

class Appointment {
  Appointment({
    this.startTimeZone,
    this.endTimeZone,
    this.recurrenceRule,
    this.isAllDay = false,
    this.notes,
    this.location,
    DateTime startTime,
    DateTime endTime,
    String subject,
    Color color,
    List<DateTime> recurrenceExceptionDates,
  })  : startTime = startTime ?? DateTime.now(),
        endTime = endTime ?? DateTime.now(),
        subject = subject == null ? '' : subject,
        _actualStartTime = startTime,
        _actualEndTime = endTime,
        color = color ?? Colors.lightBlue,
        recurrenceExceptionDates = recurrenceExceptionDates ?? <DateTime>[],
        _isSpanned = false;

  DateTime startTime;

  DateTime endTime;

  bool isAllDay = false;

  String subject;

  Color color;

  String startTimeZone;

  String endTimeZone;

  String recurrenceRule;

  List<DateTime> recurrenceExceptionDates;

  String notes;

  String location;

  //Used for referring items in ItemsSource of Schedule.
  Object _data;

  // ignore: prefer_final_fields
  DateTime _actualStartTime;

  // ignore: prefer_final_fields
  DateTime _actualEndTime;

  // ignore: prefer_final_fields
  bool _isSpanned = false;
}

class RecurrenceProperties {
  RecurrenceProperties(
      {RecurrenceType recurrenceType,
      int recurrenceCount,
      DateTime startDate,
      DateTime endDate,
      int interval,
      RecurrenceRange recurrenceRange,
      List<WeekDays> weekDays,
      int week,
      int dayOfMonth,
      int dayOfWeek,
      int month})
      : recurrenceType = recurrenceType ?? RecurrenceType.daily,
        recurrenceCount = recurrenceCount ?? 1,
        startDate = startDate ?? DateTime.now(),
        endDate = endDate ?? DateTime.now().add(const Duration(days: 1)),
        interval = interval ?? 1,
        recurrenceRange = recurrenceRange ?? RecurrenceRange.noEndDate,
        weekDays = weekDays ?? <WeekDays>[],
        week = week ?? -1,
        dayOfMonth = dayOfMonth ?? 1,
        dayOfWeek = dayOfWeek ?? 1,
        month = month ?? 1;

  RecurrenceType recurrenceType;

  int recurrenceCount;

  DateTime startDate;

  DateTime endDate;

  int interval;

  RecurrenceRange recurrenceRange;

  List<WeekDays> weekDays;

  int week;

  int dayOfMonth;

  int dayOfWeek;

  int month;
}

class _AgendaViewPainter extends CustomPainter {
  _AgendaViewPainter(this._monthViewSettings, this._selectedDate,
      this._timeZone, this._appointments);

  final MonthViewSettings _monthViewSettings;
  final DateTime _selectedDate;
  final String _timeZone;
  final List<Appointment> _appointments;
  Paint _rectPainter;
  TextPainter _textPainter;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    _rectPainter = _rectPainter ?? Paint();
    _rectPainter.isAntiAlias = true;
    double yPosition = 5;
    const double xPosition = 5;
    const int padding = 5;
    List<Appointment> agendaAppointments;
    if (_selectedDate != null) {
      agendaAppointments =
          _getSelectedDateAppointments(_appointments, _timeZone, _selectedDate);
    }

    if (_selectedDate == null ||
        agendaAppointments == null ||
        agendaAppointments.isEmpty) {
      final TextSpan span = TextSpan(
        text: _selectedDate == null ? 'No selected date' : 'No events',
        style:
            TextStyle(color: Colors.grey, fontSize: 15, fontFamily: 'Roboto'),
      );
      _textPainter = _textPainter ?? TextPainter();
      _textPainter.text = span;
      _textPainter.maxLines = 1;
      _textPainter.textDirection = TextDirection.ltr;
      _textPainter.textAlign = TextAlign.left;
      _textPainter.textWidthBasis = TextWidthBasis.longestLine;

      _textPainter.layout(minWidth: 0, maxWidth: size.width - 10);
      _textPainter.paint(canvas, Offset(xPosition, yPosition + padding));
      return;
    }

    agendaAppointments.sort((Appointment app1, Appointment app2) =>
        app1._actualStartTime.compareTo(app2._actualStartTime));
    agendaAppointments.sort((Appointment app1, Appointment app2) =>
        _orderAppointmentsAscending(app1.isAllDay, app2.isAllDay));
    TextStyle appointmentTextStyle =
        _monthViewSettings.agendaStyle.appointmentTextStyle;
    appointmentTextStyle ??=
        TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'Roboto');

    for (int i = 0; i < agendaAppointments.length; i++) {
      final Appointment _appointment = agendaAppointments[i];
      _rectPainter.color = _appointment.color;
      final double appointmentHeight = _appointment.isAllDay
          ? _monthViewSettings.agendaItemHeight / 2
          : _monthViewSettings.agendaItemHeight;
      final Rect rect = Rect.fromLTWH(xPosition, yPosition,
          size.width - xPosition - padding, appointmentHeight);
      final Radius cornerRadius = Radius.circular(
          (appointmentHeight * 0.1) > 5 ? 5 : (appointmentHeight * 0.1));
      canvas.drawRRect(
          RRect.fromRectAndRadius(rect, cornerRadius), _rectPainter);

      TextSpan span =
          TextSpan(text: _appointment.subject, style: appointmentTextStyle);
      final TextPainter painter = TextPainter(
          text: span,
          maxLines: 1,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left,
          textWidthBasis: TextWidthBasis.longestLine);

      if (!_appointment.isAllDay) {
        painter.layout(
            minWidth: 0, maxWidth: size.width - (2 * padding) - xPosition);
        painter.paint(
            canvas,
            Offset(xPosition + padding,
                yPosition + (appointmentHeight / 2) - painter.height));

        final String format = _isSameDate(
                _appointment._actualStartTime, _appointment._actualEndTime)
            ? 'hh:mm a'
            : 'MMM dd, hh:mm a';
        span = TextSpan(
            text: DateFormat(format).format(_appointment._actualStartTime) +
                ' - ' +
                DateFormat(format).format(_appointment._actualEndTime),
            style: appointmentTextStyle);
        painter.text = span;

        painter.layout(
            minWidth: 0, maxWidth: size.width - (2 * padding) - xPosition);
        painter.paint(canvas,
            Offset(xPosition + padding, yPosition + (appointmentHeight / 2)));
      } else {
        painter.layout(minWidth: 0, maxWidth: size.width - 10 - xPosition);
        painter.paint(
            canvas,
            Offset(xPosition + 5,
                yPosition + ((appointmentHeight - painter.height) / 2)));
      }

      if (_appointment.recurrenceRule != null &&
          _appointment.recurrenceRule.isNotEmpty) {
        double textSize = appointmentTextStyle.fontSize;
        if (rect.width < textSize || rect.height < textSize) {
          textSize = rect.width > rect.height ? rect.height : rect.width;
        }

        final TextSpan icon =
            _getRecurrenceIcon(appointmentTextStyle.color, textSize);
        painter.text = icon;
        painter.layout(
            minWidth: 0, maxWidth: size.width - (2 * padding) - xPosition);
        canvas.drawRRect(
            RRect.fromRectAndRadius(
                Rect.fromLTRB(rect.right - textSize - 8, rect.top, rect.right,
                    rect.bottom),
                cornerRadius),
            _rectPainter);
        // Value 8 added as a right side padding for the recurrence icon in the agenda view
        painter.paint(
            canvas,
            Offset(rect.right - textSize - 8,
                rect.top + (rect.height - painter.height) / 2));
      }

      yPosition += appointmentHeight + padding;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class _AgendaDateTimePainter extends CustomPainter {
  _AgendaDateTimePainter(this._selectedDate, this._monthViewSettings,
      this._isDark, this._todayHighlightColor);

  final DateTime _selectedDate;
  final MonthViewSettings _monthViewSettings;
  final bool _isDark;
  final Color _todayHighlightColor;
  Paint _linePainter;
  TextPainter _textPainter;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    _linePainter = _linePainter ?? Paint();
    _linePainter.isAntiAlias = true;
    const double padding = 5;
    if (_selectedDate == null) {
      return;
    }

    final bool isToday = _isSameDate(_selectedDate, DateTime.now());
    TextStyle dayTextStyle = _monthViewSettings.agendaStyle.dayTextStyle;
    TextStyle dateTextStyle = _monthViewSettings.agendaStyle.dateTextStyle;
    final Color selectedDayTextColor = isToday
        ? _todayHighlightColor
        : dayTextStyle != null
            ? dayTextStyle.color
            : _isDark ? Colors.white70 : Colors.black54;
    final Color selectedDateTextColor = isToday
        ? Colors.white
        : dateTextStyle != null
            ? dateTextStyle.color
            : _isDark ? Colors.white : Colors.black;
    dayTextStyle = dayTextStyle != null
        ? dayTextStyle.copyWith(color: selectedDayTextColor)
        : TextStyle(
            color: selectedDayTextColor,
            fontWeight: FontWeight.w500,
            fontSize: 10,
            fontFamily: 'Roboto');
    dateTextStyle = dateTextStyle != null
        ? dateTextStyle.copyWith(color: selectedDateTextColor)
        : TextStyle(
            color: selectedDateTextColor,
            fontSize: 20,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.normal);

    TextSpan span = TextSpan(
        text: DateFormat('EEE').format(_selectedDate).toUpperCase().toString(),
        style: dayTextStyle);
    _textPainter = _textPainter ?? TextPainter();
    _textPainter.text = span;
    _textPainter.maxLines = 1;
    _textPainter.textDirection = TextDirection.ltr;
    _textPainter.textAlign = TextAlign.left;
    _textPainter.textWidthBasis = TextWidthBasis.parent;

    _textPainter.layout(minWidth: 0, maxWidth: size.width);
    _textPainter.paint(
        canvas,
        Offset(
            padding + ((size.width - (2 * padding) - _textPainter.width) / 2),
            padding));

    final double weekDayHeight = padding + _textPainter.height;

    span = TextSpan(text: _selectedDate.day.toString(), style: dateTextStyle);
    _textPainter = _textPainter ?? TextPainter();
    _textPainter.text = span;
    _textPainter.maxLines = 1;
    _textPainter.textDirection = TextDirection.ltr;
    _textPainter.textAlign = TextAlign.left;
    _textPainter.textWidthBasis = TextWidthBasis.parent;

    _textPainter.layout(minWidth: 0, maxWidth: size.width);
    final double xPosition =
        padding + ((size.width - (2 * padding) - _textPainter.width) / 2);
    double yPosition = weekDayHeight;
    if (isToday) {
      yPosition = weekDayHeight + padding;
      _linePainter.color = _todayHighlightColor;
      canvas.drawCircle(
          Offset(xPosition + (_textPainter.width / 2),
              yPosition + (_textPainter.height / 2)),
          _textPainter.width > _textPainter.height
              ? (_textPainter.width / 2) + padding
              : (_textPainter.height / 2) + padding,
          _linePainter);
    }

    _textPainter.paint(canvas, Offset(xPosition, yPosition));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class _AppointmentView {
  bool canReuse;
  int startIndex = -1;
  int endIndex = -1;
  Appointment appointment;
  int position = -1;
  int maxPositions = -1;
  bool isSpanned = false;
  RRect appointmentRect;
}

class _AppointmentPainter extends CustomPainter {
  _AppointmentPainter(
      this._calendar,
      this._visibleDates,
      this._visibleAppointments,
      this._timeIntervalHeight,
      this._repaintNotifier,
      {this.updateCalendarState})
      : super(repaint: _repaintNotifier);

  // ignore: prefer_final_fields
  SfCalendar _calendar;
  final List<DateTime> _visibleDates;
  final double _timeIntervalHeight;
  final _UpdateCalendarState updateCalendarState;

  List<Appointment> _visibleAppointments;
  List<_AppointmentView> _appointmentCollection;
  final ValueNotifier<bool> _repaintNotifier;
  Paint _appointmentPainter;
  TextPainter _textPainter;
  final _UpdateCalendarStateDetails _updateCalendarStateDetails =
      _UpdateCalendarStateDetails();

  @override
  void paint(Canvas canvas, Size size) {
    _updateCalendarStateDetails._currentViewVisibleDates = null;
    _updateCalendarStateDetails._visibleAppointments = null;
    updateCalendarState(_updateCalendarStateDetails);
    _visibleAppointments = _updateCalendarStateDetails._visibleAppointments;
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    _appointmentPainter = _appointmentPainter ?? Paint();
    _appointmentPainter.isAntiAlias = true;
    _appointmentCollection = _appointmentCollection ?? <_AppointmentView>[];

    for (int i = 0; i < _appointmentCollection.length; i++) {
      final dynamic obj = _appointmentCollection[i];
      obj.canReuse = true;
      obj.appointment = null;
      obj.position = -1;
      obj.startIndex = -1;
      obj.endIndex = -1;
      obj.appointmentRect = null;
    }

    if (_visibleDates != _updateCalendarStateDetails._currentViewVisibleDates) {
      return;
    }

    if (_calendar.view == CalendarView.month) {
      _drawMonthAppointment(canvas, size, _appointmentPainter);
    } else if (!_isTimelineView(_calendar.view)) {
      _drawDayAppointments(canvas, size, _appointmentPainter);
    } else {
      _drawTimelineAppointments(canvas, size, _appointmentPainter);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final _AppointmentPainter oldWidget = oldDelegate;
    if (oldWidget._visibleDates != _visibleDates ||
        oldWidget._visibleAppointments != _visibleAppointments) {
      return true;
    }

    _appointmentCollection = oldWidget._appointmentCollection;
    return false;
  }

  void _drawMonthAppointment(Canvas canvas, Size size, Paint paint) {
    final double cellWidth = size.width / 7;
    final double cellHeight =
        size.height / _calendar.monthViewSettings.numberOfWeeksInView;
    double xPosition = 0;
    double yPosition = 0;
    if (_calendar.monthViewSettings.appointmentDisplayMode ==
        MonthAppointmentDisplayMode.none) {
      return;
    } else if (_calendar.monthViewSettings.appointmentDisplayMode ==
        MonthAppointmentDisplayMode.appointment) {
      _updateAppointment(this);
      const String text = '31';
      _textPainter = _textPainter ?? TextPainter();
      _textPainter.textDirection = TextDirection.ltr;
      _textPainter.textAlign = TextAlign.center;
      _textPainter.textWidthBasis = TextWidthBasis.longestLine;

      final TextSpan spanText = TextSpan(
        text: text,
        style: _calendar.monthViewSettings.monthCellStyle.textStyle,
      );

      _textPainter.text = spanText;

      _textPainter.layout(minWidth: 0, maxWidth: cellWidth - 2);
      final double fontSize =
          _calendar.monthViewSettings.monthCellStyle.todayTextStyle.fontSize;

      const double cellTopPadding = 6;
      final double startPosition =
          cellTopPadding + fontSize * 0.6 + fontSize * 0.75;
      final int maximumDisplayCount =
          _calendar.monthViewSettings.appointmentDisplayCount ?? 3;
      final double _appointmentHeight =
          (cellHeight - startPosition) / maximumDisplayCount;
      double textSize = -1;
      for (int i = 0; i < _appointmentCollection.length; i++) {
        final _AppointmentView _appointmentView = _appointmentCollection[i];
        if (_appointmentView.canReuse || _appointmentView.appointment == null) {
          continue;
        }

        xPosition = (_appointmentView.startIndex % 7) * cellWidth;
        yPosition = (_appointmentView.startIndex ~/ 7) * cellHeight;
        if (_appointmentView.position <= maximumDisplayCount) {
          yPosition = yPosition +
              startPosition +
              (_appointmentHeight * (_appointmentView.position - 1));
        } else {
          yPosition = yPosition +
              startPosition +
              (_appointmentHeight * (maximumDisplayCount - 1));
        }

        final double _appointmentWidth =
            (_appointmentView.endIndex - _appointmentView.startIndex + 1) *
                cellWidth;

        if (_appointmentView.position == maximumDisplayCount) {
          paint.color = Colors.grey[600];
          const double padding = 2;
          const double startPadding = 5;
          double startXPosition = xPosition + startPadding;
          double radius = _appointmentHeight * 0.12;
          if (radius > 3) {
            radius = 3;
          }

          for (int count = _appointmentView.startIndex;
              count <= _appointmentView.endIndex;
              count++) {
            for (int j = 0; j < 3; j++) {
              canvas.drawCircle(
                  Offset(startXPosition, yPosition + (_appointmentHeight / 2)),
                  radius,
                  paint);
              startXPosition += padding + (2 * radius);
            }

            xPosition += cellWidth;
            startXPosition = xPosition + startPadding;
          }
        } else if (_appointmentView.position < maximumDisplayCount) {
          final Appointment _appointment = _appointmentView.appointment;
          paint.color = _appointment.color;

          TextStyle style = _calendar.appointmentTextStyle;
          TextSpan span = TextSpan(text: _appointment.subject, style: style);
          TextPainter painter = TextPainter(
              text: span,
              maxLines: 1,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.left,
              textWidthBasis: TextWidthBasis.parent);

          if (textSize == -1) {
            for (double j = style.fontSize - 1; j > 0; j--) {
              painter.layout(
                  minWidth: 0,
                  maxWidth:
                      _appointmentWidth - 2 > 0 ? _appointmentWidth - 2 : 0);
              if (painter.height >= _appointmentHeight - 1) {
                style = style.copyWith(fontSize: j);
                span = TextSpan(text: _appointment.subject, style: style);
                painter = TextPainter(
                    text: span,
                    maxLines: 1,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.left,
                    textWidthBasis: TextWidthBasis.parent);
              } else {
                textSize = j + 1;
                break;
              }
            }
          } else {
            span = TextSpan(
                text: _appointment.subject,
                style: style.copyWith(fontSize: textSize));
            painter = TextPainter(
                text: span,
                maxLines: 1,
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.left,
                textWidthBasis: TextWidthBasis.parent);
          }

          final Radius cornerRadius = Radius.circular(
              (_appointmentHeight * 0.1) > 2 ? 2 : (_appointmentHeight * 0.1));

          // right side padding to add a padding on the right side of the appointment
          // in month view
          const int rightSidePadding = 4;
          final RRect rect = RRect.fromRectAndRadius(
              Rect.fromLTWH(
                  xPosition,
                  yPosition,
                  _appointmentWidth - rightSidePadding > 0
                      ? _appointmentWidth - rightSidePadding
                      : 0,
                  _appointmentHeight - 1),
              cornerRadius);
          _appointmentView.appointmentRect = rect;
          canvas.drawRRect(rect, paint);

          painter.layout(
              minWidth: 0,
              maxWidth: _appointmentWidth - rightSidePadding + 1 > 0
                  ? _appointmentWidth - rightSidePadding + 1
                  : 0);
          yPosition =
              yPosition + ((_appointmentHeight - 1 - painter.height) / 2);
          painter.paint(canvas, Offset(xPosition + 2, yPosition));

          if (_appointment.recurrenceRule != null &&
              _appointment.recurrenceRule.isNotEmpty) {
            final TextSpan icon = _getRecurrenceIcon(style.color, textSize);
            painter.text = icon;
            painter.layout(
                minWidth: 0,
                maxWidth: _appointmentWidth - rightSidePadding + 1 > 0
                    ? _appointmentWidth - rightSidePadding + 1
                    : 0);
            yPosition = rect.top + ((rect.height - painter.height) / 2);
            canvas.drawRRect(
                RRect.fromRectAndRadius(
                    Rect.fromLTRB(rect.right - textSize, yPosition, rect.right,
                        rect.bottom),
                    cornerRadius),
                paint);
            painter.paint(canvas, Offset(rect.right - textSize, yPosition));
          }
        }
      }
    } else {
      const double radius = 2.5;
      const double diameter = radius * 2;
      final double bottomPadding =
          cellHeight * 0.2 < radius ? radius : cellHeight * 0.2;
      for (int i = 0; i < _visibleDates.length; i++) {
        final List<Appointment> appointmentLists =
            _getVisibleSelectedDateAppointments(
                _calendar, _visibleDates[i], _visibleAppointments);
        appointmentLists.sort((Appointment app1, Appointment app2) =>
            app1._actualStartTime.compareTo(app2._actualStartTime));
        appointmentLists.sort((Appointment app1, Appointment app2) =>
            _orderAppointmentsAscending(app1.isAllDay, app2.isAllDay));
        final int count = appointmentLists.length <=
                _calendar.monthViewSettings.appointmentDisplayCount
            ? appointmentLists.length
            : _calendar.monthViewSettings.appointmentDisplayCount;
        const double indicatorPadding = 2;
        final double indicatorWidth =
            count * diameter + (count - 1) * indicatorPadding;
        if (indicatorWidth > cellWidth) {
          xPosition = indicatorPadding + radius;
        } else {
          final dynamic differnce = cellWidth - indicatorWidth;
          xPosition = (differnce / 2) + radius;
        }

        final double startXPosition = ((i % 7).toInt()) * cellWidth;
        xPosition += startXPosition;
        yPosition = (((i / 7) + 1).toInt()) * cellHeight;
        for (int j = 0; j < count; j++) {
          paint.color = appointmentLists[j].color;
          canvas.drawCircle(
              Offset(xPosition, yPosition - bottomPadding), radius, paint);
          xPosition += diameter + indicatorPadding;
          if (startXPosition + cellWidth < xPosition + diameter) {
            break;
          }
        }
      }
    }
  }

  void _drawDayAppointments(Canvas canvas, Size size, Paint paint) {
    final double _timeLabelWidth = _getTimeLabelWidth(
        _calendar.timeSlotViewSettings.timeRulerSize, _calendar.view);
    final double _width = size.width - _timeLabelWidth;
    _setAppointmentPositionAndMaxPosition(
        this, _calendar, _visibleAppointments, false, _timeIntervalHeight);
    final double cellWidth = _width / _visibleDates.length;
    final double cellHeight = _timeIntervalHeight;
    double xPosition = _timeLabelWidth;
    double yPosition = 0;
    const double textPadding = 3;

    for (int i = 0; i < _appointmentCollection.length; i++) {
      final _AppointmentView _appointmentView = _appointmentCollection[i];
      if (_appointmentView.canReuse) {
        continue;
      }

      final Appointment _appointment = _appointmentView.appointment;
      int _column = -1;
      final int count = _visibleDates.length;

      int datesCount = 0;
      for (int j = 0; j < count; j++) {
        final DateTime _date = _visibleDates[j];
        if (_date != null &&
            _date.day == _appointment._actualStartTime.day &&
            _date.month == _appointment._actualStartTime.month &&
            _date.year == _appointment._actualStartTime.year) {
          _column = datesCount;
          break;
        } else if (_date != null) {
          datesCount++;
        }
      }

      if (_column == -1 ||
          _appointment._isSpanned ||
          (_appointment.endTime.difference(_appointment.startTime).inDays >
              0) ||
          _appointment.isAllDay) {
        continue;
      }

      final int totalHours = _appointment._actualStartTime.hour -
          _calendar.timeSlotViewSettings.startHour.toInt();
      final double mins = _appointment._actualStartTime.minute -
          (_calendar.timeSlotViewSettings.startHour -
              _calendar.timeSlotViewSettings.startHour.toInt());
      final int totalMins = (totalHours * 60 + mins).toInt();
      final dynamic _row =
          totalMins ~/ _getTimeInterval(_calendar.timeSlotViewSettings);

      final double appointmentWidth = cellWidth / _appointmentView.maxPositions;
      xPosition = _column * cellWidth +
          (_appointmentView.position * appointmentWidth) +
          _timeLabelWidth;

      yPosition = _row * cellHeight;

      Duration difference =
          _appointment._actualEndTime.difference(_appointment._actualStartTime);
      final double minuteHeight =
          cellHeight / _getTimeInterval(_calendar.timeSlotViewSettings);
      yPosition += ((_appointment._actualStartTime.hour * 60 +
                  _appointment._actualStartTime.minute) %
              _getTimeInterval(_calendar.timeSlotViewSettings)) *
          minuteHeight;

      double height = difference.inMinutes * minuteHeight;
      if (_calendar.timeSlotViewSettings.minimumAppointmentDuration != null &&
          _calendar.timeSlotViewSettings.minimumAppointmentDuration.inMinutes >
              0) {
        if (difference <
                _calendar.timeSlotViewSettings.minimumAppointmentDuration &&
            difference.inMinutes * minuteHeight <
                _calendar.timeSlotViewSettings.timeIntervalHeight) {
          difference =
              _calendar.timeSlotViewSettings.minimumAppointmentDuration;
          height = difference.inMinutes * minuteHeight;

          if (height > _calendar.timeSlotViewSettings.timeIntervalHeight) {
            height = _calendar.timeSlotViewSettings.timeIntervalHeight;
          }
        }
      }

      final Radius cornerRadius =
          Radius.circular((height * 0.1) > 2 ? 2 : (height * 0.1));
      paint.color = _appointment.color;
      final RRect rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(xPosition, yPosition, appointmentWidth - 1, height - 1),
          cornerRadius);
      _appointmentView.appointmentRect = rect;
      canvas.drawRRect(rect, paint);

      final TextSpan span = TextSpan(
        text: _appointment.subject,
        style: _calendar.appointmentTextStyle,
      );
      final TextPainter painter = TextPainter(
          text: span,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left,
          textWidthBasis: TextWidthBasis.longestLine);

      for (int j = 2; j < 10; j++) {
        painter.maxLines = j;

        painter.layout(
            minWidth: 0, maxWidth: appointmentWidth - textPadding - 2);
        if ((painter.height) > height - textPadding - 2) {
          painter.maxLines = j - 1;
          break;
        }
      }

      painter.layout(minWidth: 0, maxWidth: appointmentWidth - textPadding - 2);
      if (painter.maxLines == 1 && painter.height > height - textPadding) {
        continue;
      }

      painter.paint(
          canvas, Offset(xPosition + textPadding, yPosition + textPadding));
      if (_appointment.recurrenceRule != null &&
          _appointment.recurrenceRule.isNotEmpty) {
        double textSize = _calendar.appointmentTextStyle.fontSize;
        if (rect.width < textSize || rect.height < textSize) {
          textSize = rect.width > rect.height ? rect.height : rect.width;
        }

        final TextSpan icon =
            _getRecurrenceIcon(_calendar.appointmentTextStyle.color, textSize);
        painter.text = icon;
        painter.layout(
            minWidth: 0, maxWidth: appointmentWidth - textPadding - 2);
        canvas.drawRRect(
            RRect.fromRectAndRadius(
                Rect.fromLTRB(rect.right - textSize - 1,
                    rect.bottom - 2 - textSize, rect.right, rect.bottom),
                cornerRadius),
            paint);
        painter.paint(canvas,
            Offset(rect.right - textSize - 1, rect.bottom - 2 - textSize));
      }
    }
  }

  void _drawTimelineAppointments(Canvas canvas, Size size, Paint paint) {
    _setAppointmentPositionAndMaxPosition(
        this, _calendar, _visibleAppointments, false, _timeIntervalHeight);
    final double viewWidth = size.width / _visibleDates.length;
    final double cellWidth = _timeIntervalHeight;
    double xPosition = 0;
    double yPosition = 0;
    final double topPosition = _getTimeLabelWidth(
        _calendar.timeSlotViewSettings.timeRulerSize, _calendar.view);
    const int textPadding = 3;
    _AppointmentView _appointmentView;
    Appointment _appointment;
    final int count = _visibleDates.length;
    for (int i = 0; i < _appointmentCollection.length; i++) {
      _appointmentView = _appointmentCollection[i];
      if (_appointmentView.canReuse) {
        continue;
      }

      _appointment = _appointmentView.appointment;
      int _column = -1;

      DateTime startTime = _appointment._actualStartTime;
      int datesCount = 0;
      for (int j = 0; j < count; j++) {
        final DateTime _date = _visibleDates[j];
        if (_date != null &&
            _date.day == startTime.day &&
            _date.month == startTime.month &&
            _date.year == startTime.year) {
          _column = datesCount;
          break;
        } else if (startTime.isBefore(_date)) {
          _column = datesCount;
          startTime = DateTime(_date.year, _date.month, _date.day, 0, 0, 0);
          break;
        } else if (_date != null) {
          datesCount++;
        }
      }

      if (_column == -1 &&
          _appointment._actualStartTime.isBefore(_visibleDates[0])) {
        _column = 0;
      }

      DateTime endTime = _appointment._actualEndTime;
      int _endColumn = 0;
      if (_calendar.view == CalendarView.timelineWorkWeek) {
        _endColumn = -1;
        datesCount = 0;
        for (int j = 0; j < count; j++) {
          DateTime _date = _visibleDates[j];
          if (_date != null &&
              _date.day == endTime.day &&
              _date.month == endTime.month &&
              _date.year == endTime.year) {
            _endColumn = datesCount;
            break;
          } else if (endTime.isBefore(_date)) {
            _endColumn = datesCount - 1;
            if (_endColumn != -1) {
              _date = _visibleDates[_endColumn];
              endTime = DateTime(_date.year, _date.month, _date.day, 59, 59, 0);
            }
            break;
          } else if (_date != null) {
            datesCount++;
          }
        }

        if (_endColumn == -1 &&
            _appointment._actualEndTime
                .isAfter(_visibleDates[_visibleDates.length - 1])) {
          _endColumn = _visibleDates.length - 1;
        }
      }

      if (_column == -1 || _endColumn == -1) {
        continue;
      }

      int totalHours =
          startTime.hour - _calendar.timeSlotViewSettings.startHour.toInt();
      double mins = startTime.minute -
          (_calendar.timeSlotViewSettings.startHour -
              _calendar.timeSlotViewSettings.startHour.toInt());
      int totalMins = (totalHours * 60 + mins).toInt();
      int _row = totalMins ~/ _getTimeInterval(_calendar.timeSlotViewSettings);
      final double minuteHeight =
          cellWidth / _getTimeInterval(_calendar.timeSlotViewSettings);

      double appointmentHeight =
          _calendar.timeSlotViewSettings.timelineAppointmentHeight;
      if (appointmentHeight * _appointmentView.maxPositions >
          size.height - topPosition) {
        appointmentHeight =
            (size.height - topPosition) / _appointmentView.maxPositions;
      }

      xPosition = (_column * viewWidth) + (_row * cellWidth);
      yPosition = topPosition + (appointmentHeight * _appointmentView.position);
      xPosition += ((startTime.hour * 60 + startTime.minute) %
              _getTimeInterval(_calendar.timeSlotViewSettings)) *
          minuteHeight;

      paint.color = _appointment.color;
      double width = 0;
      if (_calendar.view == CalendarView.timelineWorkWeek) {
        totalHours =
            endTime.hour - _calendar.timeSlotViewSettings.startHour.toInt();
        mins = endTime.minute -
            (_calendar.timeSlotViewSettings.startHour -
                _calendar.timeSlotViewSettings.startHour.toInt());
        totalMins = (totalHours * 60 + mins).toInt();
        _row = totalMins ~/ _getTimeInterval(_calendar.timeSlotViewSettings);
        final double endXPosition = (_endColumn * viewWidth) +
            (_row * cellWidth) +
            ((endTime.hour * 60 + endTime.minute) %
                    _getTimeInterval(_calendar.timeSlotViewSettings)) *
                minuteHeight;
        width = endXPosition - xPosition;
      } else {
        final Duration difference = endTime.difference(startTime);
        width = difference.inMinutes * minuteHeight;
      }

      if (_calendar.timeSlotViewSettings.minimumAppointmentDuration != null &&
          _calendar.timeSlotViewSettings.minimumAppointmentDuration.inMinutes >
              0) {
        final double minWidth = _getAppointmentHeightFromDuration(
            _calendar.timeSlotViewSettings.minimumAppointmentDuration,
            _calendar,
            _timeIntervalHeight);
        width = width > minWidth ? width : minWidth;
      }

      final Radius cornerRadius = Radius.circular(
          (appointmentHeight * 0.1) > 2 ? 2 : (appointmentHeight * 0.1));
      final RRect rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(xPosition, yPosition, width - 1, appointmentHeight - 1),
          cornerRadius);
      _appointmentView.appointmentRect = rect;
      canvas.drawRRect(rect, paint);
      final TextSpan span = TextSpan(
        text: _appointment.subject,
        style: _calendar.appointmentTextStyle,
      );
      final TextPainter painter = TextPainter(
          text: span,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left,
          textWidthBasis: TextWidthBasis.longestLine);

      for (int j = 2; j < 10; j++) {
        painter.maxLines = j;

        painter.layout(minWidth: 0, maxWidth: width - textPadding - 2);
        if ((painter.height) > appointmentHeight - textPadding - 2) {
          painter.maxLines = j - 1;
          break;
        }
      }

      painter.layout(minWidth: 0, maxWidth: width - textPadding - 2);
      if (painter.maxLines == 1 &&
          painter.height > appointmentHeight - textPadding - 2) {
        continue;
      }

      painter.paint(
          canvas, Offset(xPosition + textPadding, yPosition + textPadding));
      if (_appointment.recurrenceRule != null &&
          _appointment.recurrenceRule.isNotEmpty) {
        double textSize = _calendar.appointmentTextStyle.fontSize;
        if (rect.width < textSize || rect.height < textSize) {
          textSize = rect.width > rect.height ? rect.height : rect.width;
        }

        final TextSpan icon =
            _getRecurrenceIcon(_calendar.appointmentTextStyle.color, textSize);
        painter.text = icon;
        painter.layout(minWidth: 0, maxWidth: width - textPadding - 2);
        canvas.drawRRect(
            RRect.fromRectAndRadius(
                Rect.fromLTRB(rect.right - textSize - 1,
                    rect.bottom - 2 - textSize, rect.right, rect.bottom),
                cornerRadius),
            paint);
        painter.paint(canvas,
            Offset(rect.right - textSize - 1, rect.bottom - 2 - textSize));
      }
    }
  }
}

class _AllDayAppointmentPainter extends CustomPainter {
  _AllDayAppointmentPainter(
      this._calendar,
      this._visibleDates,
      this._visibleAppointment,
      this._timeLabelWidth,
      this._allDayPainterHeight,
      this._isExpandable,
      this._isExpanding,
      this._isDark,
      this._repaintNotifier,
      {this.updateCalendarState})
      : super(repaint: _repaintNotifier);

  final SfCalendar _calendar;
  final List<DateTime> _visibleDates;
  final List<Appointment> _visibleAppointment;
  final ValueNotifier<_AppointmentView> _repaintNotifier;
  final _UpdateCalendarState updateCalendarState;
  final double _timeLabelWidth;
  final double _allDayPainterHeight;
  final bool _isDark;

  final bool _isExpandable;

  final bool _isExpanding;
  double cellWidth, cellHeight;
  Paint _rectPainter;
  TextPainter _textPainter;
  Paint _linePainter;
  TextPainter _expanderTextPainter;
  BoxPainter _boxPainter;
  final _UpdateCalendarStateDetails _updateCalendarStateDetails =
      _UpdateCalendarStateDetails();

  @override
  void paint(Canvas canvas, Size size) {
    _updateCalendarStateDetails._allDayAppointmentViewCollection = null;
    _updateCalendarStateDetails._currentViewVisibleDates = null;
    updateCalendarState(_updateCalendarStateDetails);
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    _rectPainter = _rectPainter ?? Paint();
    _updateCalendarStateDetails._allDayAppointmentViewCollection =
        _updateCalendarStateDetails._allDayAppointmentViewCollection ??
            <_AppointmentView>[];

    if (_calendar.view == CalendarView.day) {
      _linePainter ??= Paint();
      _linePainter.strokeWidth = 0.5;
      _linePainter.strokeCap = StrokeCap.round;
      _linePainter.color = _calendar.cellBorderColor != null
          ? _calendar.cellBorderColor
          : _isDark ? Colors.white70 : Colors.black.withOpacity(0.16);

      canvas.drawLine(Offset(_timeLabelWidth - 0.5, 0),
          Offset(_timeLabelWidth - 0.5, size.height), _linePainter);
    }

    if (_visibleDates != _updateCalendarStateDetails._currentViewVisibleDates) {
      return;
    }

    _rectPainter.isAntiAlias = true;
    cellWidth = (size.width - _timeLabelWidth) / _visibleDates.length;
    cellHeight = size.height;
    const double textPadding = 3;
    int maxPosition = 0;
    if (_updateCalendarStateDetails
        ._allDayAppointmentViewCollection.isNotEmpty) {
      maxPosition = _updateCalendarStateDetails._allDayAppointmentViewCollection
          .reduce(
              (_AppointmentView currentAppview, _AppointmentView nextAppview) =>
                  currentAppview.maxPositions > nextAppview.maxPositions
                      ? currentAppview
                      : nextAppview)
          .maxPositions;
    }

    if (maxPosition == -1) {
      maxPosition = 0;
    }

    final int _position = _allDayPainterHeight ~/ _kAllDayAppointmentHeight;
    for (int i = 0;
        i < _updateCalendarStateDetails._allDayAppointmentViewCollection.length;
        i++) {
      final _AppointmentView _appointmentView =
          _updateCalendarStateDetails._allDayAppointmentViewCollection[i];
      if (_appointmentView.canReuse) {
        continue;
      }

      final Appointment _appointment = _appointmentView.appointment;
      final RRect rect = RRect.fromRectAndRadius(
          Rect.fromLTRB(
              _timeLabelWidth + (_appointmentView.startIndex * cellWidth),
              (_kAllDayAppointmentHeight * _appointmentView.position)
                  .toDouble(),
              (_appointmentView.endIndex * cellWidth) +
                  _timeLabelWidth -
                  textPadding,
              ((_kAllDayAppointmentHeight * _appointmentView.position) +
                      _kAllDayAppointmentHeight -
                      1)
                  .toDouble()),
          const Radius.circular((_kAllDayAppointmentHeight * 0.1) > 2
              ? 2
              : (_kAllDayAppointmentHeight * 0.1)));

      _appointmentView.appointmentRect = rect;
      if (rect.left < _timeLabelWidth - 1 ||
          rect.right > size.width + 1 ||
          (rect.bottom > _allDayPainterHeight - _kAllDayAppointmentHeight &&
              maxPosition > _position)) {
        continue;
      }

      _rectPainter.color = _appointment.color;
      canvas.drawRRect(rect, _rectPainter);
      final TextSpan span = TextSpan(
        text: _appointment.subject,
        style: _calendar.appointmentTextStyle,
      );
      _textPainter = _textPainter ??
          TextPainter(
              textDirection: TextDirection.ltr,
              maxLines: 1,
              textAlign: TextAlign.left,
              textWidthBasis: TextWidthBasis.longestLine);
      _textPainter.text = span;

      _textPainter.layout(
          minWidth: 0,
          maxWidth:
              rect.width - textPadding >= 0 ? rect.width - textPadding : 0);
      if (_textPainter.maxLines == 1 && _textPainter.height > rect.height) {
        continue;
      }

      _textPainter.paint(
          canvas,
          Offset(rect.left + textPadding,
              rect.top + (rect.height - _textPainter.height) / 2));
      if (_appointment.recurrenceRule != null &&
          _appointment.recurrenceRule.isNotEmpty) {
        double textSize = _calendar.appointmentTextStyle.fontSize;
        if (rect.width < textSize || rect.height < textSize) {
          textSize = rect.width > rect.height ? rect.height : rect.width;
        }

        final TextSpan icon =
            _getRecurrenceIcon(_calendar.appointmentTextStyle.color, textSize);
        _textPainter.text = icon;
        _textPainter.layout(
            minWidth: 0,
            maxWidth:
                rect.width - textPadding >= 0 ? rect.width - textPadding : 0);
        canvas.drawRRect(
            RRect.fromRectAndRadius(
                Rect.fromLTRB(
                    rect.right - textSize, rect.top, rect.right, rect.bottom),
                rect.brRadius),
            _rectPainter);
        _textPainter.paint(
            canvas,
            Offset(rect.right - textSize - 1,
                rect.top + (rect.height - _textPainter.height) / 2));
      }

      if (_repaintNotifier.value != null &&
          _repaintNotifier.value.appointment != null &&
          _repaintNotifier.value.appointment == _appointmentView.appointment) {
        Decoration _selectionDecoration = _calendar.selectionDecoration;
        _selectionDecoration ??= BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
              color: const Color.fromARGB(255, 68, 140, 255), width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(1)),
          shape: BoxShape.rectangle,
        );

        Rect rect = _appointmentView.appointmentRect.outerRect;
        rect = Rect.fromLTRB(rect.left, rect.top, rect.right, rect.bottom);
        _boxPainter = _selectionDecoration.createBoxPainter();
        _boxPainter.paint(canvas, Offset(rect.left, rect.top),
            ImageConfiguration(size: rect.size));
      }
    }

    if (_isExpandable && maxPosition > _position && !_isExpanding) {
      TextStyle textStyle = _calendar.viewHeaderStyle.dayTextStyle;
      textStyle ??= TextStyle(
          color: _isDark ? Colors.white : Colors.black87,
          fontSize: 11,
          fontWeight: FontWeight.w400,
          fontFamily: 'Roboto');
      _textPainter = _textPainter ??
          TextPainter(
              textDirection: TextDirection.ltr,
              maxLines: 1,
              textAlign: TextAlign.left,
              textWidthBasis: TextWidthBasis.longestLine);

      double startXPosition = _timeLabelWidth;
      double endXPosition = _timeLabelWidth + cellWidth;
      final double endYPosition =
          _allDayPainterHeight - _kAllDayAppointmentHeight;
      for (int i = 0; i < _visibleDates.length; i++) {
        int count = 0;
        final int leftPosition = startXPosition.toInt();
        final int rightPostion = endXPosition.toInt();
        for (_AppointmentView view
            in _updateCalendarStateDetails._allDayAppointmentViewCollection) {
          if (view.appointment == null) {
            continue;
          }

          final int rectLeftPosition = view.appointmentRect.left.toInt();
          final int rectRightPosition = view.appointmentRect.right.toInt();
          if (((rectLeftPosition >= leftPosition &&
                      rectLeftPosition < rightPostion) ||
                  (rectRightPosition > leftPosition &&
                      rectRightPosition < rightPostion) ||
                  (rectLeftPosition <= leftPosition &&
                      rectRightPosition > rightPostion)) &&
              view.appointmentRect.top >= endYPosition) {
            count++;
          }
        }

        if (count == 0) {
          startXPosition += cellWidth;
          endXPosition += cellWidth;
          continue;
        }

        final TextSpan span = TextSpan(
          text: '+ ' + count.toString(),
          style: textStyle,
        );
        _textPainter.text = span;
        _textPainter.layout(
            minWidth: 0,
            maxWidth:
                cellWidth - textPadding >= 0 ? cellWidth - textPadding : 0);

        _textPainter.paint(
            canvas,
            Offset(
                _timeLabelWidth + (i * cellWidth) + textPadding,
                endYPosition +
                    ((_kAllDayAppointmentHeight - _textPainter.height) / 2)));
        startXPosition += cellWidth;
        endXPosition += cellWidth;
      }
    }

    if (_isExpandable) {
      final TextSpan icon = TextSpan(
          text: String.fromCharCode(maxPosition <= _position ? 0xe5ce : 0xe5cf),
          style: TextStyle(
            color: _calendar.viewHeaderStyle != null &&
                    _calendar.viewHeaderStyle.dayTextStyle != null &&
                    _calendar.viewHeaderStyle.dayTextStyle.color != null
                ? _calendar.viewHeaderStyle.dayTextStyle.color
                : _isDark ? Colors.white70 : Colors.black54,
            fontSize: _calendar.viewHeaderStyle != null &&
                    _calendar.viewHeaderStyle.dayTextStyle != null &&
                    _calendar.viewHeaderStyle.dayTextStyle.fontSize != null
                ? _calendar.viewHeaderStyle.dayTextStyle.fontSize * 2
                : _kAllDayAppointmentHeight + 5,
            fontFamily: 'MaterialIcons',
          ));
      _expanderTextPainter ??= TextPainter(
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left,
          maxLines: 1);
      _expanderTextPainter.text = icon;
      _expanderTextPainter.layout(minWidth: 0, maxWidth: _timeLabelWidth);
      _expanderTextPainter.paint(
          canvas,
          Offset(
              (_timeLabelWidth - _expanderTextPainter.width) / 2,
              _allDayPainterHeight -
                  _kAllDayAppointmentHeight +
                  (_kAllDayAppointmentHeight - _expanderTextPainter.height) /
                      2));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final _AllDayAppointmentPainter oldWidget = oldDelegate;
    return oldWidget._visibleDates != _visibleDates ||
        oldWidget._allDayPainterHeight != _allDayPainterHeight ||
        oldWidget._visibleAppointment != _visibleAppointment ||
        oldWidget._calendar.cellBorderColor != _calendar.cellBorderColor ||
        oldWidget._isDark != _isDark;
  }
}

enum MonthNavigationDirection { vertical, horizontal }

enum CalendarView {
  day,
  week,
  workWeek,
  month,
  timelineDay,
  timelineWeek,
  timelineWorkWeek
}

enum MonthAppointmentDisplayMode { indicator, appointment, none }

enum RecurrenceType {
  daily,
  weekly,
  monthly,
  yearly,
}

enum RecurrenceRange { endDate, noEndDate, count }

enum WeekDays { sunday, monday, tuesday, wednesday, thursday, friday, saturday }

enum CalendarElement { header, viewHeader, calendarCell, appointment, agenda }

enum CalendarDataSourceAction { add, remove, reset }

List<DateTime> _getVisibleDates(DateTime date, List<int> nonWorkingDays,
    int firstDayOfWeek, int visibleDatesCount) {
  final List<DateTime> datesCollection = <DateTime>[];
  DateTime currentDate = date;
  if (firstDayOfWeek != null) {
    currentDate =
        _getDateOnFirstDayOfWeek(visibleDatesCount, date, firstDayOfWeek);
  }

  for (int i = 0; i < visibleDatesCount; i++) {
    final DateTime visibleDate = currentDate.add(Duration(days: i));
    if (nonWorkingDays != null &&
        nonWorkingDays.contains(visibleDate.weekday)) {
      continue;
    }

    datesCollection.add(visibleDate);
  }

  return datesCollection;
}

DateTime _getDateOnFirstDayOfWeek(
    int visibleDatesCount, DateTime date, int firstDayOfWeek) {
  if (visibleDatesCount % 7 != 0) {
    return date;
  }

  const int numberOfWeekDays = 7;
  DateTime currentDate = date;
  if (visibleDatesCount == 42) {
    currentDate = DateTime(currentDate.year, currentDate.month, 1);
  }

  int value = -currentDate.weekday + firstDayOfWeek - numberOfWeekDays;
  if (value.abs() >= numberOfWeekDays) {
    value += numberOfWeekDays;
  }

  currentDate = currentDate.add(Duration(days: value));
  return currentDate;
}

int _getViewDatesCount(CalendarView _view, int numberOfWeeks, DateTime date) {
  if (_view == CalendarView.month) {
    return 7 * numberOfWeeks;
  } else if (_view == CalendarView.week ||
      _view == CalendarView.workWeek ||
      _view == CalendarView.timelineWorkWeek ||
      _view == CalendarView.timelineWeek) {
    return 7;
  } else {
    return 1;
  }
}

DateTime _getNextViewStartDate(
    CalendarView _view, DateTime date, int numberOfWeeks) {
  if (_view == CalendarView.month) {
    return numberOfWeeks == 6
        ? _getNextMonthDate(date)
        : date.add(Duration(days: numberOfWeeks * 7));
  } else if (_view == CalendarView.week ||
      _view == CalendarView.workWeek ||
      _view == CalendarView.timelineWorkWeek ||
      _view == CalendarView.timelineWeek) {
    return date.add(const Duration(days: 7));
  } else {
    return date.add(const Duration(days: 1));
  }
}

DateTime _getPreviousViewStartDate(
    CalendarView _view, DateTime date, int numberOfWeeks) {
  if (_view == CalendarView.month) {
    return numberOfWeeks == 6
        ? _getPreviousMonthDate(date)
        : date.add(Duration(days: -numberOfWeeks * 7));
  } else if (_view == CalendarView.week ||
      _view == CalendarView.workWeek ||
      _view == CalendarView.timelineWorkWeek ||
      _view == CalendarView.timelineWeek) {
    return date.add(const Duration(days: -7));
  } else {
    return date.add(const Duration(days: -1));
  }
}

DateTime _getPreviousMonthDate(DateTime date) {
  return date.month == 1
      ? DateTime(date.year - 1, 12, 1)
      : DateTime(date.year, date.month - 1, 1);
}

DateTime _getNextMonthDate(DateTime date) {
  return date.month == 12
      ? DateTime(date.year + 1, 1, 1)
      : DateTime(date.year, date.month + 1, 1);
}

DateTime _getCurrentDate(DateTime minDate, DateTime maxDate, DateTime date) {
  if (date.isAfter(minDate)) {
    if (date.isBefore(maxDate)) {
      return date;
    } else {
      return maxDate;
    }
  } else {
    return minDate;
  }
}

int _getIndex(List<DateTime> dates, DateTime date) {
  if (date.isBefore(dates[0])) {
    return 0;
  }

  if (date.isAfter(dates[dates.length - 1])) {
    return dates.length - 1;
  }

  for (int i = 0; i < dates.length; i++) {
    final DateTime visibleDate = dates[i];
    if (_isSameDate(visibleDate, date) || visibleDate.isAfter(date)) {
      return i;
    }
  }

  return -1;
}

bool _isDarkTheme(BuildContext context) {
  final ThemeData theme = Theme.of(context);
  return theme != null &&
      theme.brightness != null &&
      theme.brightness == Brightness.dark;
}

int _getTimeInterval(TimeSlotViewSettings settings) {
  double defaultLinesCount = 24;
  double totalMinutes = 0;

  if (settings.startHour >= 0 &&
      settings.endHour >= settings.startHour &&
      settings.endHour <= 24) {
    defaultLinesCount = settings.endHour - settings.startHour;
  }

  totalMinutes = defaultLinesCount * 60;

  if (settings.timeInterval.inMinutes >= 0 &&
      settings.timeInterval.inMinutes <= totalMinutes &&
      totalMinutes.round() % settings.timeInterval.inMinutes.round() == 0) {
    return settings.timeInterval.inMinutes;
  } else if (settings.timeInterval.inMinutes >= 0 &&
      settings.timeInterval.inMinutes <= totalMinutes) {
    return _getNearestValue(settings.timeInterval.inMinutes, totalMinutes);
  } else {
    return 60;
  }
}

double _getHorizontalLinesCount(TimeSlotViewSettings settings) {
  double defaultLinesCount = 24;
  double totalMinutes = 0;
  final int timeInterval = _getTimeInterval(settings);

  if (settings.startHour >= 0 &&
      settings.endHour >= settings.startHour &&
      settings.endHour <= 24) {
    defaultLinesCount = settings.endHour - settings.startHour;
  }

  totalMinutes = defaultLinesCount * 60;

  return totalMinutes / timeInterval;
}

int _getNearestValue(int timeInterval, double totalMinutes) {
  timeInterval++;
  if (totalMinutes.round() % timeInterval.round() == 0) {
    return timeInterval;
  }

  return _getNearestValue(timeInterval, totalMinutes);
}

bool _isWithInVisibleDateRange(
    List<DateTime> visibleDates, DateTime selectedDate) {
  final DateTime firstDate = visibleDates[0];
  final DateTime lastDate = visibleDates[visibleDates.length - 1];
  if (selectedDate != null) {
    assert(firstDate != null && lastDate != null);
    {
      if (_isSameDate(firstDate, selectedDate) ||
          _isSameDate(lastDate, selectedDate))
        return true;
      else
        return selectedDate.isAfter(firstDate) &&
            selectedDate.isBefore(lastDate);
    }
  } else
    return false;
}

bool _isSameDate(DateTime date1, DateTime date2) {
  if (date1 == null || date2 == null) {
    return false;
  }

  return date1.month == date2.month &&
      date1.year == date2.year &&
      date1.day == date2.day;
}

// returns the single view width from the time line view for time line
double _getSingleViewWidthForTimeLineView(_CalendarViewState viewState) {
  return (viewState._scrollController.position.maxScrollExtent +
          viewState._scrollController.position.viewportDimension) /
      viewState.widget._visibleDates.length;
}

double _getTimeLabelWidth(double _timeLabelViewWidth, CalendarView _view) {
  if (_timeLabelViewWidth != -1) {
    return _timeLabelViewWidth;
  }

  if (_isTimelineView(_view)) {
    return 30;
  } else if (_view != CalendarView.month) {
    return 50;
  }

  return 0;
}

double _getViewHeaderHeight(double _viewHeaderHeight, CalendarView _view) {
  if (_viewHeaderHeight != -1) {
    return _viewHeaderHeight;
  }

  final bool _isTimeline = _isTimelineView(_view);
  if (_view != CalendarView.month && !_isTimeline) {
    if (_view == CalendarView.day) {
      return 60;
    }

    return 55;
  } else if (_isTimeline) {
    return 30;
  } else {
    return 25;
  }
}

bool _shouldRaiseViewChangedCallback(ViewChangedCallback _onViewChanged) {
  return _onViewChanged != null;
}

bool _shouldRaiseCalendarTapCallback(CalendarTapCallback onTap) {
  return onTap != null;
}

// method that raise the calendar tapped call back with the given parameters
void _raiseCalendarTapCallback(SfCalendar calendar,
    {DateTime date, List<dynamic> appointments, CalendarElement element}) {
  final CalendarTapDetails calendarTapDetails = CalendarTapDetails();
  calendarTapDetails.date = date;
  calendarTapDetails.appointments = appointments;
  calendarTapDetails.targetElement = element;
  calendar.onTap(calendarTapDetails);
}

// method that raises the visible dates changed call back with the given parameters
void _raiseViewChangedCallback(SfCalendar calendar,
    {List<DateTime> visibleDates}) {
  final ViewChangedDetails viewChangedDetails = ViewChangedDetails();
  viewChangedDetails.visibleDates = visibleDates;
  calendar.onViewChanged(viewChangedDetails);
}

bool _isAutoTimeIntervalHeight(SfCalendar calendar) {
  return calendar.timeSlotViewSettings.timeIntervalHeight == -1;
}

double _getTimeIntervalHeight(SfCalendar calendar, double _width,
    double _height, int _visibleDatesCount, double _allDayHeight) {
  double _timeIntervalHeight = calendar.timeSlotViewSettings.timeIntervalHeight;
  double _viewHeaderHeight =
      _getViewHeaderHeight(calendar.viewHeaderHeight, calendar.view);

  if (calendar.view == CalendarView.day) {
    _allDayHeight = _kAllDayLayoutHeight;
    _viewHeaderHeight = 0;
  } else {
    _allDayHeight = _allDayHeight > _kAllDayLayoutHeight
        ? _kAllDayLayoutHeight
        : _allDayHeight;
  }

  if (!_isTimelineView(calendar.view)) {
    if (_isAutoTimeIntervalHeight(calendar)) {
      _timeIntervalHeight = (_height - _allDayHeight - _viewHeaderHeight) /
          _getHorizontalLinesCount(calendar.timeSlotViewSettings);
    }
  } else {
    if (_isAutoTimeIntervalHeight(calendar)) {
      if (calendar.view == CalendarView.day) {
        _timeIntervalHeight =
            _width / _getHorizontalLinesCount(calendar.timeSlotViewSettings);
      } else if (calendar.view != CalendarView.month) {
        final dynamic _horizontalLinesCount =
            _getHorizontalLinesCount(calendar.timeSlotViewSettings);
        _timeIntervalHeight =
            _width / (_horizontalLinesCount * _visibleDatesCount);
        if (!_isValidWidth(
            _width, calendar, _visibleDatesCount, _horizontalLinesCount)) {
          // we have used 40 as a default time interval height for time line view
          // if the time interval height set for auto time interval height
          _timeIntervalHeight = 40;
        }
      }
    }
  }

  return _timeIntervalHeight;
}

// checks whether the width can afford the line count or else creates a scrollable width
bool _isValidWidth(double _screenWidth, SfCalendar calendar,
    int _visibleDatesCount, double _horizontalLinesCount) {
  const dynamic offSetValue = 10;
  final dynamic tempWidth =
      _visibleDatesCount * offSetValue * _horizontalLinesCount;

  if (tempWidth < _screenWidth) {
    return true;
  }

  return false;
}

bool _isTimelineView(CalendarView view) {
  return view == CalendarView.timelineDay ||
      view == CalendarView.timelineWeek ||
      view == CalendarView.timelineWorkWeek;
}

// converts the given schedule appointment collection to their custom appointment collection
List<dynamic> _getCustomAppointments(List<Appointment> _appointments) {
  final List<dynamic> _customAppointments = <dynamic>[];
  if (_appointments != null) {
    for (int i = 0; i < _appointments.length; i++) {
      _customAppointments.add(_appointments[i]._data);
    }

    return _customAppointments;
  }

  return null;
}

/*bool _isSameTimeSlot(DateTime date1, DateTime date2) {
  if (date1 == null || date2 == null) {
    return false;
  }

  return date1.month == date2.month && date1.year == date2.year &&
      date1.day == date2.day && date1.hour == date2.hour &&
      date1.minute == date2.minute && date1.second == date2.second;
}*/

class ViewChangedDetails {
  List<DateTime> visibleDates;
}

class CalendarTapDetails {
  List<dynamic> appointments;
  DateTime date;
  CalendarElement targetElement;
}

class _UpdateCalendarStateDetails {
  DateTime _currentDate;
  List<DateTime> _currentViewVisibleDates;
  List<dynamic> _visibleAppointments;
  DateTime _selectedDate;
  double _allDayPanelHeight;
  List<_AppointmentView> _allDayAppointmentViewCollection;
  List<dynamic> _appointments;

  // ignore: prefer_final_fields
  bool _isAppointmentTapped = false;
}

class _CustomScrollView extends StatefulWidget {
  const _CustomScrollView(this._calendar, this._width, this._height,
      this._visibleAppointments, this._agendaSelectedDate,
      {this.updateCalendarState});

  final SfCalendar _calendar;
  final double _width;
  final double _height;
  final _UpdateCalendarState updateCalendarState;
  final ValueNotifier<DateTime> _agendaSelectedDate;
  final List<dynamic> _visibleAppointments;

  @override
  _CustomScrollViewState createState() => _CustomScrollViewState();
}

class _CustomScrollViewState extends State<_CustomScrollView>
    with TickerProviderStateMixin {
  // three views to arrange the view in vertical/horizontal direction and handle the swiping
  _CalendarView _currentView, _nextView, _previousView;

  // the three children which to be added into the layout
  List<_CalendarView> _children;

  // holds the index of the current displaying view
  int _currentChildIndex;

  // _scrollStartPosition contains the touch movement starting position
  // _position contains distance that the view swiped
  double _scrollStartPosition, _position;

  // animation controller to control the animation
  AnimationController _animationController;

  // animation handled for the view swiping
  Animation<double> _animation;

  // tween animation to handle the animation
  Tween<double> _tween;

  // three visible dates for the three views, the dates will updated based on the swiping in the swipe end
  // _currentViewVisibleDates which stores the visible dates of the current displaying view
  List<DateTime> _visibleDates,
      _previousViewVisibleDates,
      _nextViewVisibleDates,
      _currentViewVisibleDates;

  dynamic _previousViewKey, _currentViewKey, _nextViewKey;

  _UpdateCalendarStateDetails _updateCalendarStateDetails;

  @override
  void initState() {
    _previousViewKey = GlobalKey<_CalendarViewState>();
    _currentViewKey = GlobalKey<_CalendarViewState>();
    _nextViewKey = GlobalKey<_CalendarViewState>();
    _updateCalendarStateDetails = _UpdateCalendarStateDetails();
    _currentChildIndex = 1;
    _updateVisibleDates();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 250),
        vsync: this,
        animationBehavior: AnimationBehavior.normal);
    _tween = Tween<double>(begin: 0.0, end: 0.1);
    _animation = _tween.animate(_animationController)
      ..addListener(animationListener);

    super.initState();
  }

  void _updateVisibleDates() {
    _updateCalendarStateDetails._currentDate = null;
    widget.updateCalendarState(_updateCalendarStateDetails);
    final DateTime currentDate = _updateCalendarStateDetails._currentDate;
    final DateTime prevDate = _getPreviousViewStartDate(
        widget._calendar.view,
        _updateCalendarStateDetails._currentDate,
        widget._calendar.monthViewSettings.numberOfWeeksInView);
    final DateTime nextDate = _getNextViewStartDate(
        widget._calendar.view,
        _updateCalendarStateDetails._currentDate,
        widget._calendar.monthViewSettings.numberOfWeeksInView);
    final List<int> _nonWorkingDays =
        (widget._calendar.view == CalendarView.workWeek ||
                widget._calendar.view == CalendarView.timelineWorkWeek)
            ? widget._calendar.timeSlotViewSettings.nonWorkingDays
            : null;

    _visibleDates = _getVisibleDates(
        currentDate,
        _nonWorkingDays,
        widget._calendar.firstDayOfWeek,
        _getViewDatesCount(
            widget._calendar.view,
            widget._calendar.monthViewSettings.numberOfWeeksInView,
            currentDate));
    _previousViewVisibleDates = _getVisibleDates(
        prevDate,
        _nonWorkingDays,
        widget._calendar.firstDayOfWeek,
        _getViewDatesCount(widget._calendar.view,
            widget._calendar.monthViewSettings.numberOfWeeksInView, prevDate));
    _nextViewVisibleDates = _getVisibleDates(
        nextDate,
        _nonWorkingDays,
        widget._calendar.firstDayOfWeek,
        _getViewDatesCount(widget._calendar.view,
            widget._calendar.monthViewSettings.numberOfWeeksInView, nextDate));

    _currentViewVisibleDates = _visibleDates;
    _updateCalendarStateDetails._currentViewVisibleDates =
        _currentViewVisibleDates;
    widget.updateCalendarState(_updateCalendarStateDetails);

    if (_currentChildIndex == 0) {
      _visibleDates = _nextViewVisibleDates;
      _nextViewVisibleDates = _previousViewVisibleDates;
      _previousViewVisibleDates = _currentViewVisibleDates;
    } else if (_currentChildIndex == 1) {
      _visibleDates = _currentViewVisibleDates;
    } else if (_currentChildIndex == 2) {
      _visibleDates = _previousViewVisibleDates;
      _previousViewVisibleDates = _nextViewVisibleDates;
      _nextViewVisibleDates = _currentViewVisibleDates;
    }
  }

  void _updateNextViewVisibleDates() {
    DateTime _currentViewDate = _currentViewVisibleDates[0];
    if (widget._calendar.view == CalendarView.month &&
        widget._calendar.monthViewSettings.numberOfWeeksInView == 6) {
      _currentViewDate = _currentViewVisibleDates[
          (_currentViewVisibleDates.length / 2).truncate()];
    }

    _currentViewDate = _getNextViewStartDate(
        widget._calendar.view,
        _currentViewDate,
        widget._calendar.monthViewSettings.numberOfWeeksInView);
    final List<DateTime> _dates = _getVisibleDates(
        _currentViewDate,
        widget._calendar.view == CalendarView.workWeek ||
                widget._calendar.view == CalendarView.timelineWorkWeek
            ? widget._calendar.timeSlotViewSettings.nonWorkingDays
            : null,
        widget._calendar.firstDayOfWeek,
        _getViewDatesCount(
            widget._calendar.view,
            widget._calendar.monthViewSettings.numberOfWeeksInView,
            _currentViewDate));

    if (_currentChildIndex == 0) {
      _nextViewVisibleDates = _dates;
    } else if (_currentChildIndex == 1) {
      _previousViewVisibleDates = _dates;
    } else {
      _visibleDates = _dates;
    }
  }

  void _updatePreviousViewVisibleDates() {
    DateTime _currentViewDate = _currentViewVisibleDates[0];
    if (widget._calendar.view == CalendarView.month &&
        widget._calendar.monthViewSettings.numberOfWeeksInView == 6) {
      _currentViewDate = _currentViewVisibleDates[
          (_currentViewVisibleDates.length / 2).truncate()];
    }

    _currentViewDate = _getPreviousViewStartDate(
        widget._calendar.view,
        _currentViewDate,
        widget._calendar.monthViewSettings.numberOfWeeksInView);
    final List<DateTime> _dates = _getVisibleDates(
        _currentViewDate,
        widget._calendar.view == CalendarView.workWeek ||
                widget._calendar.view == CalendarView.timelineWorkWeek
            ? widget._calendar.timeSlotViewSettings.nonWorkingDays
            : null,
        widget._calendar.firstDayOfWeek,
        _getViewDatesCount(
            widget._calendar.view,
            widget._calendar.monthViewSettings.numberOfWeeksInView,
            _currentViewDate));

    if (_currentChildIndex == 0) {
      _visibleDates = _dates;
    } else if (_currentChildIndex == 1) {
      _nextViewVisibleDates = _dates;
    } else {
      _previousViewVisibleDates = _dates;
    }
  }

  void _updateCalendarViewStateDetails(_UpdateCalendarStateDetails details) {
    details._currentViewVisibleDates = _currentViewVisibleDates;
    details._visibleAppointments = widget._visibleAppointments;
    _updateCalendarStateDetails._currentDate = null;
    widget.updateCalendarState(_updateCalendarStateDetails);
    details._currentDate = _updateCalendarStateDetails._currentDate;
    if (details._selectedDate == null && !details._isAppointmentTapped) {
      details._selectedDate = _updateCalendarStateDetails._selectedDate;
    } else if (details._selectedDate != null) {
      _updateCalendarStateDetails._selectedDate = details._selectedDate;
      widget.updateCalendarState(_updateCalendarStateDetails);
    }

    if (details._allDayAppointmentViewCollection == null ||
        details._allDayPanelHeight == null ||
        details._allDayPanelHeight !=
            _updateCalendarStateDetails._allDayPanelHeight ||
        details._allDayAppointmentViewCollection !=
            _updateCalendarStateDetails._allDayAppointmentViewCollection) {
      details._allDayPanelHeight =
          _updateCalendarStateDetails._allDayPanelHeight;
      details._allDayAppointmentViewCollection =
          _updateCalendarStateDetails._allDayAppointmentViewCollection;
    }

    if (details._appointments == null ||
        details._appointments != _updateCalendarStateDetails._appointments) {
      details._appointments = _updateCalendarStateDetails._appointments;
    }
  }

  List<Widget> _addViews() {
    _children = _children ?? <_CalendarView>[];

    if (_children != null && _children.isEmpty) {
      _previousView = _CalendarView(
        widget._calendar,
        _previousViewVisibleDates,
        widget._width,
        widget._height,
        widget._agendaSelectedDate,
        key: _previousViewKey,
        updateCalendarState: (_UpdateCalendarStateDetails details) {
          _updateCalendarViewStateDetails(details);
        },
      );
      _currentView = _CalendarView(
        widget._calendar,
        _visibleDates,
        widget._width,
        widget._height,
        widget._agendaSelectedDate,
        key: _currentViewKey,
        updateCalendarState: (_UpdateCalendarStateDetails details) {
          _updateCalendarViewStateDetails(details);
        },
      );
      _nextView = _CalendarView(
        widget._calendar,
        _nextViewVisibleDates,
        widget._width,
        widget._height,
        widget._agendaSelectedDate,
        key: _nextViewKey,
        updateCalendarState: (_UpdateCalendarStateDetails details) {
          _updateCalendarViewStateDetails(details);
        },
      );

      _children.add(_previousView);
      _children.add(_currentView);
      _children.add(_nextView);
      return _children;
    }

    final dynamic previousView = _updateViews(
        _previousView, _previousViewKey, _previousViewVisibleDates);
    final dynamic currentView =
        _updateViews(_currentView, _currentViewKey, _visibleDates);
    final dynamic nextView =
        _updateViews(_nextView, _nextViewKey, _nextViewVisibleDates);

    if (_previousView != previousView) {
      _previousView = previousView;
    }
    if (_currentView != currentView) {
      _currentView = currentView;
    }
    if (_nextView != nextView) {
      _nextView = nextView;
    }

    return _children;
  }

  // method to check and update the views and appointments on the swiping end
  _CalendarView _updateViews(_CalendarView view,
      GlobalKey<_CalendarViewState> _viewKey, List<DateTime> _visibleDates) {
    final int index = _children.indexOf(view);
    // update the view with the visible dates on swiping end.
    if (view._visibleDates != _visibleDates) {
      view = _CalendarView(
        widget._calendar,
        _visibleDates,
        widget._width,
        widget._height,
        widget._agendaSelectedDate,
        key: _viewKey,
        updateCalendarState: (_UpdateCalendarStateDetails details) {
          _updateCalendarViewStateDetails(details);
        },
      );
      _children[index] = view;
    } // check and update the visible appointments in the view
    else if (_viewKey.currentState._appointmentPainter != null &&
        _viewKey.currentState._appointmentPainter._visibleAppointments !=
            widget._visibleAppointments) {
      if (widget._calendar.view != CalendarView.month &&
          !_isTimelineView(widget._calendar.view)) {
        view = _CalendarView(
          widget._calendar,
          _visibleDates,
          widget._width,
          widget._height,
          widget._agendaSelectedDate,
          key: _viewKey,
          updateCalendarState: (_UpdateCalendarStateDetails details) {
            _updateCalendarViewStateDetails(details);
          },
        );
        _children[index] = view;
      } else if (view._visibleDates == _currentViewVisibleDates) {
        _viewKey.currentState._appointmentPainter._visibleAppointments =
            widget._visibleAppointments;
        _viewKey.currentState._appointmentPainter._calendar = widget._calendar;
        _viewKey.currentState._appointmentPainter._repaintNotifier.value =
            !_viewKey.currentState._appointmentPainter._repaintNotifier.value;
      }
    }

    return view;
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  void animationListener() {
    setState(() {
      _position = _animation.value;
    });
  }

  @override
  void didUpdateWidget(_CustomScrollView oldWidget) {
    if ((widget._calendar.monthViewSettings.navigationDirection !=
            oldWidget._calendar.monthViewSettings.navigationDirection) ||
        widget._width != oldWidget._width ||
        widget._height != oldWidget._height) {
      _position = null;
      _children.clear();
    }

    if (oldWidget._calendar.timeSlotViewSettings !=
            widget._calendar.timeSlotViewSettings ||
        oldWidget._calendar.monthViewSettings !=
            widget._calendar.monthViewSettings ||
        oldWidget._calendar.viewHeaderStyle !=
            widget._calendar.viewHeaderStyle ||
        oldWidget._calendar.viewHeaderHeight !=
            widget._calendar.viewHeaderHeight ||
        oldWidget._calendar.todayHighlightColor !=
            widget._calendar.todayHighlightColor ||
        oldWidget._calendar.cellBorderColor !=
            widget._calendar.cellBorderColor ||
        oldWidget._calendar.selectionDecoration !=
            widget._calendar.selectionDecoration) {
      _children.clear();
      _position = 0;
    }

    if (widget._calendar.monthViewSettings.numberOfWeeksInView !=
            oldWidget._calendar.monthViewSettings.numberOfWeeksInView ||
        widget._calendar.timeSlotViewSettings.nonWorkingDays !=
            oldWidget._calendar.timeSlotViewSettings.nonWorkingDays ||
        widget._calendar.view != oldWidget._calendar.view ||
        widget._calendar.firstDayOfWeek != oldWidget._calendar.firstDayOfWeek) {
      _updateVisibleDates();
      _position = 0;
    }

    if (_isTimelineView(widget._calendar.view) !=
        _isTimelineView(oldWidget._calendar.view)) {
      _children.clear();
    }

    if (_isTimelineView(widget._calendar.view) &&
        (oldWidget._calendar.backgroundColor !=
                widget._calendar.backgroundColor ||
            oldWidget._calendar.headerStyle != widget._calendar.headerStyle) &&
        _position != null) {
      _position = 0;
    }

    if (oldWidget._calendar.initialDisplayDate !=
            widget._calendar.initialDisplayDate &&
        widget._calendar.initialDisplayDate != null) {
      _updateCalendarStateDetails._currentDate =
          widget._calendar.initialDisplayDate;
      _updateVisibleDates();
      _updateMoveToDate();
    }

    if (oldWidget._calendar.initialSelectedDate !=
        widget._calendar.initialSelectedDate) {
      _updateCalendarStateDetails._selectedDate =
          widget._calendar.initialSelectedDate;
      _updateSelection();
      _position = 0;
    }

    super.didUpdateWidget(oldWidget);
  }

  void _updateSelection() {
    widget.updateCalendarState(_updateCalendarStateDetails);
    final _CalendarViewState previousViewState = _previousViewKey.currentState;
    final _CalendarViewState currentViewState = _currentViewKey.currentState;
    final _CalendarViewState nextViewState = _nextViewKey.currentState;
    previousViewState._allDaySelectionNotifier?.value = null;
    currentViewState._allDaySelectionNotifier?.value = null;
    nextViewState._allDaySelectionNotifier?.value = null;
    previousViewState._selectionPainter._selectedDate =
        _updateCalendarStateDetails._selectedDate;
    nextViewState._selectionPainter._selectedDate =
        _updateCalendarStateDetails._selectedDate;
    currentViewState._selectionPainter._selectedDate =
        _updateCalendarStateDetails._selectedDate;
    previousViewState._selectionPainter._appointmentView = null;
    nextViewState._selectionPainter._appointmentView = null;
    currentViewState._selectionPainter._appointmentView = null;
    previousViewState._selectionPainter._repaintNotifier.value =
        !previousViewState._selectionPainter._repaintNotifier.value;
    currentViewState._selectionPainter._repaintNotifier.value =
        !currentViewState._selectionPainter._repaintNotifier.value;
    nextViewState._selectionPainter._repaintNotifier.value =
        !nextViewState._selectionPainter._repaintNotifier.value;
  }

  void _updateMoveToDate() {
    if (widget._calendar.view != CalendarView.month) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (_currentChildIndex == 0) {
          _previousViewKey.currentState._scrollToPosition();
        } else if (_currentChildIndex == 1) {
          _currentViewKey.currentState._scrollToPosition();
        } else if (_currentChildIndex == 2) {
          _nextViewKey.currentState._scrollToPosition();
        }
      });
    }
  }

  void _updateCurrentViewVisibleDates({bool isNextView = false}) {
    if (isNextView) {
      if (_currentChildIndex == 0) {
        _currentViewVisibleDates = _visibleDates;
      } else if (_currentChildIndex == 1) {
        _currentViewVisibleDates = _nextViewVisibleDates;
      } else {
        _currentViewVisibleDates = _previousViewVisibleDates;
      }
    } else {
      if (_currentChildIndex == 0) {
        _currentViewVisibleDates = _nextViewVisibleDates;
      } else if (_currentChildIndex == 1) {
        _currentViewVisibleDates = _previousViewVisibleDates;
      } else {
        _currentViewVisibleDates = _visibleDates;
      }
    }

    _updateCalendarStateDetails._currentViewVisibleDates =
        _currentViewVisibleDates;
    _updateCalendarStateDetails._currentDate =
        _currentViewVisibleDates[_currentViewVisibleDates.length ~/ 2];
    widget.updateCalendarState(_updateCalendarStateDetails);
  }

  dynamic _updateNextView() {
    if (!_animationController.isCompleted) {
      return;
    }

    _updateSelection();
    _updateNextViewVisibleDates();

    if (_currentChildIndex == 0) {
      _currentChildIndex = 1;
    } else if (_currentChildIndex == 1) {
      _currentChildIndex = 2;
    } else if (_currentChildIndex == 2) {
      _currentChildIndex = 0;
    }

    _resetPosition();
    _updateAppointmentPainter();
  }

  dynamic _updatePreviousView() {
    if (!_animationController.isCompleted) {
      return;
    }

    _updateSelection();
    _updatePreviousViewVisibleDates();

    if (_currentChildIndex == 0) {
      _currentChildIndex = 2;
    } else if (_currentChildIndex == 1) {
      _currentChildIndex = 0;
    } else if (_currentChildIndex == 2) {
      _currentChildIndex = 1;
    }

    _resetPosition();
    _updateAppointmentPainter();
  }

  // resets position to zero on the swipe end to avoid the unwanted date updates.
  void _resetPosition() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_position.abs() == widget._width ||
          _position.abs() == widget._height) {
        _position = 0;
      }
    });
  }

  void _updateScrollPosition() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_previousView == null ||
          _currentView == null ||
          _nextView == null ||
          _previousViewKey.currentState == null ||
          _currentViewKey.currentState == null ||
          _nextViewKey.currentState == null ||
          _previousViewKey.currentState._scrollController == null ||
          _currentViewKey.currentState._scrollController == null ||
          _nextViewKey.currentState._scrollController == null ||
          !_previousViewKey.currentState._scrollController.hasClients ||
          !_currentViewKey.currentState._scrollController.hasClients ||
          !_nextViewKey.currentState._scrollController.hasClients) {
        return;
      }

      double scrolledPosition = 0;
      if (_currentChildIndex == 0) {
        scrolledPosition =
            _previousViewKey.currentState._scrollController.offset;
      } else if (_currentChildIndex == 1) {
        scrolledPosition =
            _currentViewKey.currentState._scrollController.offset;
      } else if (_currentChildIndex == 2) {
        scrolledPosition = _nextViewKey.currentState._scrollController.offset;
      }

      if (_previousViewKey.currentState._scrollController.offset !=
              scrolledPosition &&
          _previousViewKey
                  .currentState._scrollController.position.maxScrollExtent >=
              scrolledPosition) {
        _previousViewKey.currentState._scrollController
            .jumpTo(scrolledPosition);
      }

      if (_currentViewKey.currentState._scrollController.offset !=
              scrolledPosition &&
          _currentViewKey
                  .currentState._scrollController.position.maxScrollExtent >=
              scrolledPosition) {
        _currentViewKey.currentState._scrollController.jumpTo(scrolledPosition);
      }

      if (_nextViewKey.currentState._scrollController.offset !=
              scrolledPosition &&
          _nextViewKey
                  .currentState._scrollController.position.maxScrollExtent >=
              scrolledPosition) {
        _nextViewKey.currentState._scrollController.jumpTo(scrolledPosition);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isTimelineView(widget._calendar.view) &&
        widget._calendar.view != CalendarView.month) {
      _updateScrollPosition();
    }

    double _leftPosition, _rightPosition, _topPosition, _bottomPosition;
    if (widget._calendar.monthViewSettings.navigationDirection ==
            MonthNavigationDirection.horizontal ||
        widget._calendar.view != CalendarView.month) {
      _leftPosition = _leftPosition ?? -widget._width;
      _rightPosition = _rightPosition ?? -widget._width;
      _topPosition = 0;
      _bottomPosition = 0;
    } else {
      _leftPosition = 0;
      _rightPosition = 0;
      _topPosition = _topPosition ?? -widget._height;
      _bottomPosition = _bottomPosition ?? -widget._height;
    }

    final bool _isTimeline = _isTimelineView(widget._calendar.view);
    return Stack(
      children: <Widget>[
        Positioned(
          left: _leftPosition,
          right: _rightPosition,
          bottom: _bottomPosition,
          top: _topPosition,
          child: GestureDetector(
            child: _CustomScrollViewerLayout(
                _addViews(), widget._calendar, _position, _currentChildIndex),
            onHorizontalDragStart: (DragStartDetails details) {
              _onHorizontalStart(details);
            },
            onHorizontalDragUpdate: (DragUpdateDetails details) {
              _onHorizontalUpdate(details);
            },
            onHorizontalDragEnd: (DragEndDetails details) {
              _onHorizontalEnd(details);
            },
            onVerticalDragStart: (DragStartDetails details) {
              if (widget._calendar.view == CalendarView.month && !_isTimeline)
                _onVerticalStart(details);
            },
            onVerticalDragUpdate: (DragUpdateDetails details) {
              if (widget._calendar.view == CalendarView.month && !_isTimeline)
                _onVerticalUpdate(details);
            },
            onVerticalDragEnd: (DragEndDetails details) {
              if (widget._calendar.view == CalendarView.month && !_isTimeline)
                _onVerticalEnd(details);
            },
          ),
        )
      ],
    );
  }

  void _onHorizontalStart(DragStartDetails dragStartDetails) {
    if (widget._calendar.monthViewSettings.navigationDirection ==
            MonthNavigationDirection.horizontal ||
        widget._calendar.view != CalendarView.month) {
      _scrollStartPosition = dragStartDetails.globalPosition.dx;
    }

    // Handled for time line view, to move the previous and next view to it's start and end position accordingly
    if (_isTimelineView(widget._calendar.view)) {
      final _CalendarViewState _previousViewState =
          _previousViewKey.currentState;
      final _CalendarViewState _currentViewState = _currentViewKey.currentState;
      final _CalendarViewState _nextViewState = _nextViewKey.currentState;
      if (_currentChildIndex == 0) {
        _nextViewState._scrollController
            .jumpTo(_nextViewState._scrollController.position.maxScrollExtent);
        _currentViewState._scrollController.jumpTo(0);
      } else if (_currentChildIndex == 1) {
        _previousViewState._scrollController.jumpTo(
            _previousViewState._scrollController.position.maxScrollExtent);
        _nextViewState._scrollController.jumpTo(0);
      } else if (_currentChildIndex == 2) {
        _currentViewState._scrollController.jumpTo(
            _currentViewState._scrollController.position.maxScrollExtent);
        _previousViewState._scrollController.jumpTo(0);
      }
    }
  }

  void _onHorizontalUpdate(DragUpdateDetails dragUpdateDetails) {
    // Handled for time line view to manually update the scroll position of the scroll view of time line view while pass the touch to the scroll view
    if (_isTimelineView(widget._calendar.view)) {
      _position = dragUpdateDetails.globalPosition.dx - _scrollStartPosition;
      for (int i = 0; i < _children.length; i++) {
        if (_children[i]._visibleDates == _currentViewVisibleDates) {
          final GlobalKey<_CalendarViewState> viewKey = _children[i].key;
          if (viewKey.currentState._isUpdateTimelineViewScroll(
              _scrollStartPosition, dragUpdateDetails.globalPosition.dx))
            return;
          break;
        }
      }
    }

    if (widget._calendar.monthViewSettings.navigationDirection ==
            MonthNavigationDirection.horizontal ||
        widget._calendar.view != CalendarView.month) {
      _position = dragUpdateDetails.globalPosition.dx - _scrollStartPosition;
    }

    _clearSelection();

    setState(() {});
  }

  void _onHorizontalEnd(DragEndDetails dragEndDetails) {
    // Handled for time line view to manually update the scroll position of the scroll view of time line view while pass the touch to the scroll view
    if (_isTimelineView(widget._calendar.view)) {
      for (int i = 0; i < _children.length; i++) {
        if (_children[i]._visibleDates == _currentViewVisibleDates) {
          final GlobalKey<_CalendarViewState> viewKey = _children[i].key;
          if (viewKey.currentState._isAnimateTimelineViewScroll(
              _position, dragEndDetails.primaryVelocity)) {
            return;
          }
          break;
        }
      }
    }

    if (widget._calendar.monthViewSettings.navigationDirection ==
            MonthNavigationDirection.horizontal ||
        widget._calendar.view != CalendarView.month) {
      // condition to check and update the right to left swiping
      if (-_position >= widget._width / 2) {
        _tween.begin = _position;
        _tween.end = -widget._width;

        // Resets the controller to forward it again, the animation will forward only from the dismissed state
        if (_animationController.isCompleted && _position != _tween.end) {
          _animationController.reset();
        }

        _animationController
            .forward()
            .then<dynamic>((dynamic value) => _updateNextView());

        _updateCurrentViewVisibleDates(isNextView: true);
      }
      // fling the view from right to left
      else if (-dragEndDetails.velocity.pixelsPerSecond.dx > widget._width) {
        _tween.begin = _position;
        _tween.end = -widget._width;

        // Resets the controller to forward it again, the animation will forward only from the dismissed state
        if (_animationController.isCompleted && _position != _tween.end)
          _animationController.reset();

        _animationController
            .fling(velocity: 5.0, animationBehavior: AnimationBehavior.normal)
            .then<dynamic>((dynamic value) => _updateNextView());

        _updateCurrentViewVisibleDates(isNextView: true);
      }
      // condition to check and update the left to right swiping
      else if (_position >= widget._width / 2) {
        _tween.begin = _position;
        _tween.end = widget._width;

        // Resets the controller to forward it again, the animation will forward only from the dismissed state
        if (_animationController.isCompleted || _position != _tween.end) {
          _animationController.reset();
        }

        _animationController
            .forward()
            .then<dynamic>((dynamic value) => _updatePreviousView());

        _updateCurrentViewVisibleDates();
      }
      // fling the view from left to right
      else if (dragEndDetails.velocity.pixelsPerSecond.dx > widget._width) {
        _tween.begin = _position;
        _tween.end = widget._width;

        // Resets the controller to forward it again, the animation will forward only from the dismissed state
        if (_animationController.isCompleted && _position != _tween.end)
          _animationController.reset();

        _animationController
            .fling(velocity: 5.0, animationBehavior: AnimationBehavior.normal)
            .then<dynamic>((dynamic value) => _updatePreviousView());

        _updateCurrentViewVisibleDates();
      }
      // condition to check and revert the right to left swiping
      else if (_position.abs() <= widget._width / 2) {
        _tween.begin = _position;
        _tween.end = 0.0;

        // Resets the controller to forward it again, the animation will forward only from the dismissed state
        if (_animationController.isCompleted && _position != _tween.end) {
          _animationController.reset();
        }

        _animationController.forward();
      }
    }
  }

  void _onVerticalStart(DragStartDetails dragStartDetails) {
    if (widget._calendar.monthViewSettings.navigationDirection ==
            MonthNavigationDirection.vertical &&
        !_isTimelineView(widget._calendar.view)) {
      _scrollStartPosition = dragStartDetails.globalPosition.dy;
    }
  }

  void _onVerticalUpdate(DragUpdateDetails dragUpdateDetails) {
    if (widget._calendar.monthViewSettings.navigationDirection ==
            MonthNavigationDirection.vertical &&
        !_isTimelineView(widget._calendar.view)) {
      _position = dragUpdateDetails.globalPosition.dy - _scrollStartPosition;
      setState(() {});
    }
  }

  void _onVerticalEnd(DragEndDetails dragEndDetails) {
    if (widget._calendar.monthViewSettings.navigationDirection ==
            MonthNavigationDirection.vertical &&
        !_isTimelineView(widget._calendar.view)) {
      // condition to check and update the bottom to top swiping
      if (-_position >= widget._height / 2) {
        _tween.begin = _position;
        _tween.end = -widget._height;

        // Resets the controller to forward it again, the animation will forward only from the dismissed state
        if (_animationController.isCompleted || _position != _tween.end) {
          _animationController.reset();
        }

        _animationController
            .forward()
            .then<dynamic>((dynamic value) => _updateNextView());

        _updateCurrentViewVisibleDates(isNextView: true);
      }
      // fling the view to bottom to top
      else if (-dragEndDetails.velocity.pixelsPerSecond.dy > widget._height) {
        _tween.begin = _position;
        _tween.end = -widget._height;

        // Resets the controller to forward it again, the animation will forward only from the dismissed state
        if (_animationController.isCompleted || _position != _tween.end) {
          _animationController.reset();
        }

        _animationController
            .fling(velocity: 5.0, animationBehavior: AnimationBehavior.normal)
            .then<dynamic>((dynamic value) => _updateNextView());

        _updateCurrentViewVisibleDates(isNextView: true);
      }
      // condition to check and update the top to bottom swiping
      else if (_position >= widget._height / 2) {
        _tween.begin = _position;
        _tween.end = widget._height;

        // Resets the controller to forward it again, the animation will forward only from the dismissed state
        if (_animationController.isCompleted || _position != _tween.end) {
          _animationController.reset();
        }

        _animationController
            .forward()
            .then<dynamic>((dynamic value) => _updatePreviousView());

        _updateCurrentViewVisibleDates();
      }
      // fling the view to top to bottom
      else if (dragEndDetails.velocity.pixelsPerSecond.dy > widget._height) {
        _tween.begin = _position;
        _tween.end = widget._height;

        // Resets the controller to forward it again, the animation will forward only from the dismissed state
        if (_animationController.isCompleted || _position != _tween.end) {
          _animationController.reset();
        }

        _animationController
            .fling(velocity: 5.0, animationBehavior: AnimationBehavior.normal)
            .then<dynamic>((dynamic value) => _updatePreviousView());

        _updateCurrentViewVisibleDates();
      }
      // condition to check and revert the bottom to top swiping
      else if (_position.abs() <= widget._height / 2) {
        _tween.begin = _position;
        _tween.end = 0.0;

        // Resets the controller to forward it again, the animation will forward only from the dismissed state
        if (_animationController.isCompleted || _position != _tween.end)
          _animationController.reset();
        _animationController.forward();
      }
    }
  }

  void _clearSelection() {
    widget.updateCalendarState(_updateCalendarStateDetails);
    for (int i = 0; i < _children.length; i++) {
      final GlobalKey<_CalendarViewState> viewKey = _children[i].key;
      if (viewKey.currentState._selectionPainter._selectedDate !=
          _updateCalendarStateDetails._selectedDate) {
        viewKey.currentState._selectionPainter._selectedDate =
            _updateCalendarStateDetails._selectedDate;
        viewKey.currentState._selectionPainter._repaintNotifier.value =
            !viewKey.currentState._selectionPainter._repaintNotifier.value;
      }
    }
  }

  void _updateAppointmentPainter() {
    for (int i = 0; i < _children.length; i++) {
      final GlobalKey<_CalendarViewState> viewKey = _children[i].key;
      viewKey.currentState._appointmentPainter._repaintNotifier.value =
          !viewKey.currentState._appointmentPainter._repaintNotifier.value;
    }
  }
}

class _CustomScrollViewerLayout extends MultiChildRenderObjectWidget {
  _CustomScrollViewerLayout(List<Widget> children, this._calendar,
      this._position, this._currentChildIndex)
      : super(children: children);
  final SfCalendar _calendar;
  final double _position;
  final int _currentChildIndex;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _CustomScrollViewLayout(_calendar, _position, _currentChildIndex);
  }

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    final _CustomScrollViewLayout panel = context.findRenderObject();
    if (panel._calendar.monthViewSettings.navigationDirection !=
            _calendar.monthViewSettings.navigationDirection ||
        panel._calendar.view != _calendar.view) {
      panel._calendar = _calendar;
    }

    if (panel._position != null && _position == null) {
      panel._position = null;
      panel.markNeedsLayout();
    }

    if (panel._currentChildIndex != _currentChildIndex) {
      panel._currentChildIndex = _currentChildIndex;
      panel.markNeedsLayout();
    }

    if (panel._position != _position) {
      panel._position = _position;
      panel.markNeedsLayout();
    }
  }
}

class _CustomScrollViewLayout extends RenderWrap {
  _CustomScrollViewLayout(
      this._calendar, this._position, this._currentChildIndex);

  SfCalendar _calendar;

  // holds the index of the current displaying view
  int _currentChildIndex;

  // _position contains distance that the view swiped
  double _position;

  // used to position the children on the panel on swiping.
  dynamic _currentChild, _firstChild, _lastChild;

  @override
  void performLayout() {
    double currentChildXPos,
        firstChildXPos = 0,
        lastChildXPos,
        currentChildYPos,
        firstChildYPos = 0,
        lastChildYPos;
    WrapParentData currentChildParentData,
        firstChildParentData,
        lastChildParentData;

    double width = constraints.maxWidth;
    double height = constraints.maxHeight;

    final dynamic children = getChildrenAsList();
    _firstChild = _firstChild ?? firstChild;
    _lastChild = _lastChild ?? lastChild;
    _currentChild = _currentChild ?? childAfter(firstChild);

    if (_calendar.monthViewSettings.navigationDirection ==
            MonthNavigationDirection.horizontal ||
        _calendar.view != CalendarView.month) {
      width = width / 3;
      firstChildXPos = 0;
      currentChildYPos = 0;
      lastChildYPos = 0;
    } else if (_calendar.view == CalendarView.month &&
        _calendar.monthViewSettings.navigationDirection ==
            MonthNavigationDirection.vertical) {
      height = height / 3;
      firstChildYPos = 0;
      currentChildXPos = 0;
      lastChildXPos = 0;
    }

    if (_position == width || _position == -width) {
      if (_currentChild.parentData.offset.dx == width) {
        _position = 0;
      }
    } else if (_position == height || _position == -height) {
      if (_currentChild.parentData.offset.dy == height) {
        _position = 0;
      }
    }

    firstChildParentData = _firstChild.parentData;
    lastChildParentData = _lastChild.parentData;
    currentChildParentData = _currentChild.parentData;
    if (_calendar.monthViewSettings.navigationDirection ==
            MonthNavigationDirection.horizontal ||
        _calendar.view != CalendarView.month) {
      currentChildXPos = width;
      lastChildXPos = width * 2;
      if (_position != null) {
        firstChildXPos += _position;
        currentChildXPos += _position;
        lastChildXPos += _position;

        if (firstChildXPos.round() == -width.round()) {
          firstChildXPos = width * 2;
          _updateChild();
        } else if (lastChildXPos.round() == (width * 3).round()) {
          lastChildXPos = 0;
          _updateChild();
        }
      }
    } else if (_calendar.view == CalendarView.month &&
        _calendar.monthViewSettings.navigationDirection ==
            MonthNavigationDirection.vertical) {
      currentChildYPos = height;
      lastChildYPos = height * 2;
      if (_position != null) {
        firstChildYPos += _position;
        currentChildYPos += _position;
        lastChildYPos += _position;

        if (firstChildYPos.round() == -height.round()) {
          firstChildYPos = height * 2;
          _updateChild();
        } else if (lastChildYPos.round() == (height * 3).round()) {
          lastChildYPos = 0;
          _updateChild();
        }
      }
    }

    firstChildParentData.offset = Offset(firstChildXPos, firstChildYPos);
    currentChildParentData.offset = Offset(currentChildXPos, currentChildYPos);
    lastChildParentData.offset = Offset(lastChildXPos, lastChildYPos);

    children.forEach((dynamic child) => child.layout(
        BoxConstraints(
          minWidth: 0,
          minHeight: 0,
          maxWidth: width,
          maxHeight: height,
        ),
        parentUsesSize: true));

    size = Size(constraints.maxWidth, constraints.maxHeight);
  }

  void _updateChild() {
    final dynamic children = getChildrenAsList();
    if (_currentChildIndex == 0) {
      _currentChild = children[_currentChildIndex];
      _firstChild = children[2];
      _lastChild = children[1];
    } else if (_currentChildIndex == 1) {
      _currentChild = children[_currentChildIndex];
      _firstChild = children[0];
      _lastChild = children[2];
    } else if (_currentChildIndex == 2) {
      _currentChild = children[_currentChildIndex];
      _firstChild = children[1];
      _lastChild = children[0];
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
  }
}

class CalendarHeaderStyle {
  CalendarHeaderStyle(
      {this.textAlign = TextAlign.left,
      this.backgroundColor = Colors.transparent,
      this.textStyle});

  final TextStyle textStyle;

  final TextAlign textAlign;

  final Color backgroundColor;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CalendarHeaderStyle otherStyle = other;
    return otherStyle.textStyle == textStyle &&
        otherStyle.textAlign == textAlign &&
        otherStyle.backgroundColor == backgroundColor;
  }

  @override
  int get hashCode {
    return hashValues(
      textStyle,
      textAlign,
      backgroundColor,
    );
  }
}

class ViewHeaderStyle {
  ViewHeaderStyle(
      {this.backgroundColor = Colors.transparent,
      this.dateTextStyle,
      this.dayTextStyle});

  final Color backgroundColor;

  final TextStyle dateTextStyle;

  final TextStyle dayTextStyle;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ViewHeaderStyle otherStyle = other;
    return otherStyle.backgroundColor == backgroundColor &&
        otherStyle.dayTextStyle == dayTextStyle &&
        otherStyle.dateTextStyle == dateTextStyle;
  }

  @override
  int get hashCode {
    return hashValues(
      backgroundColor,
      dayTextStyle,
      dateTextStyle,
    );
  }
}

const double _kAllDayLayoutHeight = 60;

const double _kAllDayAppointmentHeight = 20;

class TimeSlotViewSettings {
  TimeSlotViewSettings(
      {this.startHour = 0,
      this.endHour = 24,
      this.nonWorkingDays = const <int>[DateTime.saturday, DateTime.sunday],
      this.timeFormat = 'h a',
      this.timeInterval = const Duration(minutes: 60),
      this.timeIntervalHeight = 40,
      this.timelineAppointmentHeight = 60,
      this.minimumAppointmentDuration,
      this.dateFormat = 'd',
      this.dayFormat = 'EEE',
      this.timeRulerSize = -1,
      this.timeTextStyle});

  final double startHour;

  final double endHour;

  final List<int> nonWorkingDays;

  final Duration timeInterval;

  final double timeIntervalHeight;

  final String timeFormat;

  final double timelineAppointmentHeight;

  final Duration minimumAppointmentDuration;

  final String dateFormat;

  final String dayFormat;

  final double timeRulerSize;

  final TextStyle timeTextStyle;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final TimeSlotViewSettings otherStyle = other;
    return otherStyle.startHour == startHour &&
        otherStyle.endHour == endHour &&
        otherStyle.nonWorkingDays == nonWorkingDays &&
        otherStyle.timeInterval == timeInterval &&
        otherStyle.timeIntervalHeight == timeIntervalHeight &&
        otherStyle.timeFormat == timeFormat &&
        otherStyle.timelineAppointmentHeight == timelineAppointmentHeight &&
        otherStyle.minimumAppointmentDuration == minimumAppointmentDuration &&
        otherStyle.dateFormat == dateFormat &&
        otherStyle.dayFormat == dayFormat &&
        otherStyle.timeRulerSize == timeRulerSize &&
        otherStyle.timeTextStyle == timeTextStyle;
  }

  @override
  int get hashCode {
    return hashValues(
        startHour,
        endHour,
        nonWorkingDays,
        timeInterval,
        timeIntervalHeight,
        timeFormat,
        timelineAppointmentHeight,
        minimumAppointmentDuration,
        dateFormat,
        dayFormat,
        timeRulerSize,
        timeTextStyle);
  }
}

class MonthViewSettings {
  MonthViewSettings(
      {this.appointmentDisplayCount = 4,
      this.numberOfWeeksInView = 6,
      this.appointmentDisplayMode = MonthAppointmentDisplayMode.indicator,
      this.showAgenda = false,
      this.navigationDirection = MonthNavigationDirection.horizontal,
      this.dayFormat = 'EE',
      this.agendaItemHeight = 50,
      double agendaViewHeight,
      MonthCellStyle monthCellStyle,
      AgendaStyle agendaStyle})
      : monthCellStyle = monthCellStyle ?? MonthCellStyle(),
        agendaStyle = agendaStyle ?? AgendaStyle(),
        agendaViewHeight = agendaViewHeight ?? -1;

  final String dayFormat;

  final double agendaItemHeight;

  final MonthCellStyle monthCellStyle;

  final AgendaStyle agendaStyle;

  final int numberOfWeeksInView;

  final int appointmentDisplayCount;

  final MonthAppointmentDisplayMode appointmentDisplayMode;

  final bool showAgenda;

  final double agendaViewHeight;

  final MonthNavigationDirection navigationDirection;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final MonthViewSettings otherStyle = other;
    return otherStyle.dayFormat == dayFormat &&
        otherStyle.monthCellStyle == monthCellStyle &&
        otherStyle.agendaStyle == agendaStyle &&
        otherStyle.numberOfWeeksInView == numberOfWeeksInView &&
        otherStyle.appointmentDisplayCount == appointmentDisplayCount &&
        otherStyle.appointmentDisplayMode == appointmentDisplayMode &&
        otherStyle.agendaItemHeight == agendaItemHeight &&
        otherStyle.showAgenda == showAgenda &&
        otherStyle.agendaViewHeight == agendaViewHeight &&
        otherStyle.navigationDirection == navigationDirection;
  }

  @override
  int get hashCode {
    return hashValues(
      dayFormat,
      monthCellStyle,
      agendaStyle,
      numberOfWeeksInView,
      appointmentDisplayCount,
      appointmentDisplayMode,
      showAgenda,
      agendaViewHeight,
      agendaItemHeight,
      navigationDirection,
    );
  }
}

class AgendaStyle {
  AgendaStyle(
      {this.appointmentTextStyle,
      this.dayTextStyle,
      this.dateTextStyle,
      this.backgroundColor = Colors.transparent});

  final TextStyle appointmentTextStyle;

  final TextStyle dayTextStyle;

  final TextStyle dateTextStyle;

  final Color backgroundColor;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final AgendaStyle otherStyle = other;
    return otherStyle.appointmentTextStyle == appointmentTextStyle &&
        otherStyle.dayTextStyle == dayTextStyle &&
        otherStyle.dateTextStyle == dateTextStyle &&
        otherStyle.backgroundColor == backgroundColor;
  }

  @override
  int get hashCode {
    return hashValues(
      appointmentTextStyle,
      dayTextStyle,
      dateTextStyle,
      backgroundColor,
    );
  }
}

class MonthCellStyle {
  MonthCellStyle({
    this.backgroundColor = Colors.transparent,
    this.todayBackgroundColor = Colors.transparent,
    this.trailingDatesBackgroundColor = Colors.transparent,
    this.leadingDatesBackgroundColor = Colors.transparent,
    this.textStyle,
    TextStyle todayTextStyle,
    this.trailingDatesTextStyle,
    this.leadingDatesTextStyle,
  }) : todayTextStyle = todayTextStyle ??
            const TextStyle(
                fontSize: 13,
                fontFamily: 'Roboto',
                color: Color.fromARGB(255, 255, 255, 255));

  final TextStyle textStyle;

  final TextStyle todayTextStyle;

  final TextStyle trailingDatesTextStyle;

  final TextStyle leadingDatesTextStyle;

  final Color backgroundColor;

  final Color todayBackgroundColor;

  final Color trailingDatesBackgroundColor;

  final Color leadingDatesBackgroundColor;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final MonthCellStyle otherStyle = other;
    return otherStyle.textStyle == textStyle &&
        otherStyle.todayTextStyle == todayTextStyle &&
        otherStyle.trailingDatesTextStyle == trailingDatesTextStyle &&
        otherStyle.leadingDatesTextStyle == leadingDatesTextStyle &&
        otherStyle.backgroundColor == backgroundColor &&
        otherStyle.todayBackgroundColor == todayBackgroundColor &&
        otherStyle.trailingDatesBackgroundColor ==
            trailingDatesBackgroundColor &&
        otherStyle.leadingDatesBackgroundColor == leadingDatesBackgroundColor;
  }

  @override
  int get hashCode {
    return hashValues(
      textStyle,
      todayTextStyle,
      trailingDatesTextStyle,
      leadingDatesTextStyle,
      backgroundColor,
      todayBackgroundColor,
      trailingDatesBackgroundColor,
      leadingDatesBackgroundColor,
    );
  }
}

class _HeaderViewPainter extends CustomPainter {
  _HeaderViewPainter(this._visibleDates, this._headerStyle, this._currentDate,
      this._view, this._numberOfWeeksInView, this._isDark);

  final List<DateTime> _visibleDates;
  final CalendarHeaderStyle _headerStyle;
  final DateTime _currentDate;
  final CalendarView _view;
  final int _numberOfWeeksInView;
  final bool _isDark;
  String _headerText;
  TextPainter _textPainter;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    double _xPosition = 5.0;
    _textPainter = _textPainter ?? TextPainter();
    _textPainter.textDirection = TextDirection.ltr;
    _textPainter.textWidthBasis = TextWidthBasis.longestLine;

    if (_view == CalendarView.month &&
        _numberOfWeeksInView != 6 &&
        _visibleDates[0].month !=
            _visibleDates[_visibleDates.length - 1].month) {
      _headerText = DateFormat('MMM yyyy').format(_visibleDates[0]).toString() +
          ' - ' +
          DateFormat('MMM yyyy')
              .format(_visibleDates[_visibleDates.length - 1])
              .toString();
    } else if (!_isTimelineView(_view)) {
      _headerText = DateFormat('MMMM yyyy').format(_currentDate).toString();
    } else {
      String format = 'd MMM';
      if (_view == CalendarView.timelineDay) {
        format = 'MMM yyyy';
      }

      final DateTime startDate = _visibleDates[0];
      final DateTime endDate = _visibleDates[_visibleDates.length - 1];
      String startText = '';
      String endText = '';
      startText = DateFormat(format).format(startDate).toString();
      if (_view != CalendarView.timelineDay) {
        startText = startText + ' - ';
        format = 'd MMM yyyy';
        endText = DateFormat(format).format(endDate).toString();
      }

      _headerText = startText + endText;
    }

    TextStyle style = _headerStyle.textStyle;
    style ??= TextStyle(
        color: _isDark ? Colors.white : Colors.black87,
        fontSize: 18,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto');

    final TextSpan span = TextSpan(text: _headerText, style: style);
    _textPainter.text = span;

    if (_headerStyle.textAlign == TextAlign.justify) {
      _textPainter.textAlign = _headerStyle.textAlign;
    }

    _textPainter.layout(minWidth: 0, maxWidth: size.width - _xPosition);

    if (_headerStyle.textAlign == TextAlign.right ||
        _headerStyle.textAlign == TextAlign.end) {
      _xPosition = size.width - _textPainter.width;
    } else if (_headerStyle.textAlign == TextAlign.center) {
      _xPosition = size.width / 2 - _textPainter.width / 2;
    }

    _textPainter.paint(
        canvas, Offset(_xPosition, size.height / 2 - _textPainter.height / 2));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final _HeaderViewPainter oldWidget = oldDelegate;
    return oldWidget._visibleDates != _visibleDates ||
        oldWidget._headerStyle != _headerStyle ||
        oldWidget._currentDate != _currentDate ||
        oldWidget._isDark != _isDark;
  }
}

class _TimeSlotView extends CustomPainter {
  _TimeSlotView(
      this._visibleDates,
      this._horizontalLinesCount,
      this._timeIntervalHeight,
      this._timeLabelWidth,
      this._cellBorderColor,
      this._isDark);

  final List<DateTime> _visibleDates;
  final double _horizontalLinesCount;
  final double _timeIntervalHeight;
  final double _timeLabelWidth;
  final Color _cellBorderColor;
  final bool _isDark;
  double _cellWidth;
  Paint _linePainter;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final double _width = size.width - _timeLabelWidth;
    double x, y;
    y = _timeIntervalHeight;
    _linePainter = _linePainter ?? Paint();
    _linePainter.strokeWidth = 0.5;
    _linePainter.strokeCap = StrokeCap.round;
    _linePainter.color = _cellBorderColor != null
        ? _cellBorderColor
        : _isDark ? Colors.white70 : Colors.black.withOpacity(0.16);

    for (int i = 1; i <= _horizontalLinesCount; i++) {
      final Offset _start = Offset(_timeLabelWidth, y);
      final Offset _end = Offset(size.width, y);
      canvas.drawLine(_start, _end, _linePainter);

      y += _timeIntervalHeight;
      if (y == size.height) {
        break;
      }
    }

    _cellWidth = _width / _visibleDates.length;
    x = _timeLabelWidth + _cellWidth;
    for (int i = 0; i < _visibleDates.length - 1; i++) {
      final Offset _start = Offset(x, 0);
      final Offset _end = Offset(x, size.height);
      canvas.drawLine(_start, _end, _linePainter);
      x += _cellWidth;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final _TimeSlotView oldWidget = oldDelegate;
    return oldWidget._visibleDates != _visibleDates ||
        oldWidget._timeIntervalHeight != _timeIntervalHeight ||
        oldWidget._timeLabelWidth != _timeLabelWidth ||
        oldWidget._cellBorderColor != _cellBorderColor ||
        oldWidget._horizontalLinesCount != _horizontalLinesCount ||
        oldWidget._isDark != _isDark;
  }
}

class _CalendarView extends StatefulWidget {
  const _CalendarView(this._calendar, this._visibleDates, this._width,
      this._height, this._agendaSelectedDate,
      {Key key, this.updateCalendarState})
      : super(key: key);

  final List<DateTime> _visibleDates;
  final SfCalendar _calendar;
  final double _width;
  final double _height;
  final ValueNotifier<DateTime> _agendaSelectedDate;
  final _UpdateCalendarState updateCalendarState;

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<_CalendarView>
    with TickerProviderStateMixin {
  // line count is the total time slot lines to be drawn in the view
  // line count per view is for time line view which contains the time slot count for per view
  double _horizontalLinesCount;

  ScrollController _scrollController, _timelineViewHeaderScrollController;

  // scroll physics to handle the scrolling for time line view
  ScrollPhysics _scrollPhysics;
  _AppointmentPainter _appointmentPainter;
  AnimationController _timelineViewAnimationController;
  Animation<double> _timelineViewAnimation;
  Tween<double> _timelineViewTween;

  _TimelineViewHeaderView _timelineViewHeader;
  _SelectionPainter _selectionPainter;
  double _allDayHeight = 0;
  int numberOfDaysInWeek;
  double _timeIntervalHeight;
  _UpdateCalendarStateDetails _updateCalendarStateDetails;
  ValueNotifier<_AppointmentView> _allDaySelectionNotifier;

  bool isExpanded = false;
  AnimationController _animationController;
  Animation<double> _heightAnimation;
  Animation<double> _allDayExpanderAnimation;
  AnimationController _expanderAnimationController;

  @override
  void initState() {
    isExpanded = false;
    _allDaySelectionNotifier = ValueNotifier<_AppointmentView>(null);
    if (!_isTimelineView(widget._calendar.view) &&
        widget._calendar.view != CalendarView.month) {
      _animationController = AnimationController(
          duration: const Duration(milliseconds: 200), vsync: this);
      _heightAnimation =
          CurveTween(curve: Curves.easeIn).animate(_animationController)
            ..addListener(() {
              setState(() {});
            });

      _expanderAnimationController = AnimationController(
          duration: const Duration(milliseconds: 100), vsync: this);
      _allDayExpanderAnimation =
          CurveTween(curve: Curves.easeIn).animate(_expanderAnimationController)
            ..addListener(() {
              setState(() {});
            });
    }

    _updateCalendarStateDetails = _UpdateCalendarStateDetails();
    numberOfDaysInWeek = 7;
    _timeIntervalHeight = _getTimeIntervalHeight(
        widget._calendar,
        widget._width,
        widget._height,
        widget._visibleDates.length,
        _allDayHeight);
    if (widget._calendar.view != CalendarView.month) {
      _horizontalLinesCount =
          _getHorizontalLinesCount(widget._calendar.timeSlotViewSettings);
      _scrollController =
          ScrollController(initialScrollOffset: 0, keepScrollOffset: true)
            ..addListener(_scrollListener);
      if (_isTimelineView(widget._calendar.view)) {
        _scrollPhysics = const NeverScrollableScrollPhysics();
        _timelineViewHeaderScrollController =
            ScrollController(initialScrollOffset: 0, keepScrollOffset: true);
        _timelineViewAnimationController = AnimationController(
            duration: const Duration(milliseconds: 300),
            vsync: this,
            animationBehavior: AnimationBehavior.normal);
        _timelineViewTween = Tween<double>(begin: 0.0, end: 0.1);
        _timelineViewAnimation = _timelineViewTween
            .animate(_timelineViewAnimationController)
              ..addListener(_scrollAnimationListener);
      }
    }

    if (widget._calendar.view != CalendarView.month) {
      _scrollToPosition();
    }

    super.initState();
  }

  void _scrollAnimationListener() {
    _scrollController.jumpTo(_timelineViewAnimation.value);
  }

  void _scrollToPosition() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (widget._calendar.view == CalendarView.month) {
        return;
      }
      _updateCalendarStateDetails._currentDate = null;
      widget.updateCalendarState(_updateCalendarStateDetails);
      double timeToPosition = 0;
      if (_isWithInVisibleDateRange(
          widget._visibleDates, _updateCalendarStateDetails._currentDate)) {
        if (!_isTimelineView(widget._calendar.view)) {
          timeToPosition = _timeToPosition(widget._calendar,
              _updateCalendarStateDetails._currentDate, _timeIntervalHeight);
        } else {
          for (int i = 0; i < widget._visibleDates.length; i++) {
            if (_isSameDate(_updateCalendarStateDetails._currentDate,
                widget._visibleDates[i])) {
              timeToPosition = (_getSingleViewWidthForTimeLineView(this) * i) +
                  _timeToPosition(
                      widget._calendar,
                      _updateCalendarStateDetails._currentDate,
                      _timeIntervalHeight);
              break;
            }
          }
        }

        if (timeToPosition > _scrollController.position.maxScrollExtent)
          timeToPosition = _scrollController.position.maxScrollExtent;
        else if (timeToPosition < _scrollController.position.minScrollExtent)
          timeToPosition = _scrollController.position.minScrollExtent;

        _scrollController.jumpTo(timeToPosition);
      }
      _updateCalendarStateDetails._currentDate = null;
    });
  }

  void _expandOrCollapseAllDay() {
    isExpanded = !isExpanded;
    if (isExpanded) {
      _expanderAnimationController.forward();
    } else {
      _expanderAnimationController.reverse();
    }
  }

  @override
  void dispose() {
    if (_isTimelineView(widget._calendar.view) &&
        _timelineViewAnimationController != null)
      _timelineViewAnimationController.dispose();
    if (_scrollController != null) {
      _scrollController.dispose();
    }
    if (_timelineViewHeaderScrollController != null)
      _timelineViewHeaderScrollController.dispose();
    if (_animationController != null) {
      _animationController.dispose();
      _animationController = null;
    }

    if (_expanderAnimationController != null) {
      _expanderAnimationController.dispose();
      _expanderAnimationController = null;
    }

    super.dispose();
  }

  void _scrollListener() {
    if (_isTimelineView(widget._calendar.view)) {
      _updateCalendarStateDetails._currentViewVisibleDates = null;
      widget.updateCalendarState(_updateCalendarStateDetails);
      if (_scrollController.position.atEdge &&
          _updateCalendarStateDetails._currentViewVisibleDates ==
              widget._visibleDates) {
        setState(() {
          _scrollPhysics = const NeverScrollableScrollPhysics();
        });
      } else if ((!_scrollController.position.atEdge) &&
          _scrollPhysics.toString() == 'NeverScrollableScrollPhysics' &&
          _updateCalendarStateDetails._currentViewVisibleDates ==
              widget._visibleDates) {
        setState(() {
          _scrollPhysics = const ClampingScrollPhysics();
        });
      }

      if (_timelineViewHeader != null) {
        _timelineViewHeader._repaintNotifier.value =
            !_timelineViewHeader._repaintNotifier.value;
      }

      _timelineViewHeaderScrollController.jumpTo(_scrollController.offset);
    }
  }

  bool _isUpdateTimelineViewScroll(double _initial, double _dx) {
    if (_scrollController.position.maxScrollExtent == 0) {
      return false;
    }

    double _scrollToPosition = 0;

    if (_scrollController.offset < _scrollController.position.maxScrollExtent &&
        _scrollController.offset <=
            _scrollController.position.viewportDimension &&
        _initial > _dx) {
      setState(() {
        _scrollPhysics = const ClampingScrollPhysics();
      });

      _scrollToPosition =
          _initial - _dx <= _scrollController.position.maxScrollExtent
              ? _initial - _dx
              : _scrollController.position.maxScrollExtent;

      _scrollController.jumpTo(_scrollToPosition);
      return true;
    } else if (_scrollController.offset >
            _scrollController.position.minScrollExtent &&
        _scrollController.offset != 0 &&
        _initial < _dx) {
      setState(() {
        _scrollPhysics = const ClampingScrollPhysics();
      });
      _scrollToPosition =
          _scrollController.position.maxScrollExtent - (_dx - _initial);
      _scrollToPosition =
          _scrollToPosition >= _scrollController.position.minScrollExtent
              ? _scrollToPosition
              : _scrollController.position.minScrollExtent;
      _scrollController.jumpTo(
          _scrollController.position.maxScrollExtent - (_dx - _initial));
      return true;
    }

    return false;
  }

  bool _isAnimateTimelineViewScroll(double _position, double _velocity) {
    if (_scrollController.position.maxScrollExtent == 0) {
      return false;
    }

    _velocity =
        _velocity == 0 ? _position.abs() : _velocity / window.devicePixelRatio;
    if (_scrollController.offset < _scrollController.position.maxScrollExtent &&
        _scrollController.offset <=
            _scrollController.position.viewportDimension &&
        _position < 0) {
      setState(() {
        _scrollPhysics = const ClampingScrollPhysics();
      });

      // animation to animate the scroll view manually in time line view
      _timelineViewTween.begin = _scrollController.offset;
      _timelineViewTween.end =
          _velocity.abs() > _scrollController.position.maxScrollExtent
              ? _scrollController.position.maxScrollExtent
              : _velocity.abs();

      if (_timelineViewAnimationController.isCompleted &&
          _scrollController.offset != _timelineViewTween.end)
        _timelineViewAnimationController.reset();

      _timelineViewAnimationController.forward();
      return true;
    } else if (_scrollController.offset >
            _scrollController.position.minScrollExtent &&
        _scrollController.offset != 0 &&
        _position > 0) {
      setState(() {
        _scrollPhysics = const ClampingScrollPhysics();
      });

      // animation to animate the scroll view manually in time line view
      _timelineViewTween.begin = _scrollController.offset;
      _timelineViewTween.end =
          _scrollController.position.maxScrollExtent - _velocity.abs() <
                  _scrollController.position.minScrollExtent
              ? _scrollController.position.minScrollExtent
              : _scrollController.position.maxScrollExtent - _velocity.abs();

      if (_timelineViewAnimationController.isCompleted &&
          _scrollController.offset != _timelineViewTween.end)
        _timelineViewAnimationController.reset();

      _timelineViewAnimationController.forward();
      return true;
    }

    return false;
  }

  @override
  void didUpdateWidget(_CalendarView oldWidget) {
    if (widget._calendar.view != CalendarView.month) {
      isExpanded = false;
      _allDaySelectionNotifier = ValueNotifier<_AppointmentView>(null);
      if (!_isTimelineView(widget._calendar.view)) {
        _animationController ??= AnimationController(
            duration: const Duration(milliseconds: 200), vsync: this);
        _heightAnimation ??=
            CurveTween(curve: Curves.easeIn).animate(_animationController)
              ..addListener(() {
                setState(() {});
              });

        _updateCalendarStateDetails = _UpdateCalendarStateDetails();
        _expanderAnimationController ??= AnimationController(
            duration: const Duration(milliseconds: 100), vsync: this);
        _allDayExpanderAnimation ??= CurveTween(curve: Curves.easeIn)
            .animate(_expanderAnimationController)
              ..addListener(() {
                setState(() {});
              });

        if (_expanderAnimationController.status == AnimationStatus.completed) {
          _expanderAnimationController.reset();
        }

        if (widget._calendar.view != CalendarView.day && _allDayHeight == 0) {
          if (_animationController.status == AnimationStatus.completed) {
            _animationController.reset();
          }

          _animationController.forward();
        }
      }

      if (widget._calendar.timeSlotViewSettings.startHour !=
              oldWidget._calendar.timeSlotViewSettings.startHour ||
          widget._calendar.timeSlotViewSettings.endHour !=
              oldWidget._calendar.timeSlotViewSettings.endHour ||
          _getTimeInterval(widget._calendar.timeSlotViewSettings) !=
              _getTimeInterval(oldWidget._calendar.timeSlotViewSettings))
        _horizontalLinesCount =
            _getHorizontalLinesCount(widget._calendar.timeSlotViewSettings);
      else if (oldWidget._calendar.view == CalendarView.month)
        _horizontalLinesCount =
            _getHorizontalLinesCount(widget._calendar.timeSlotViewSettings);
      else
        _horizontalLinesCount = _horizontalLinesCount ??
            _getHorizontalLinesCount(widget._calendar.timeSlotViewSettings);

      _scrollController = _scrollController ??
          ScrollController(initialScrollOffset: 0, keepScrollOffset: true)
        ..addListener(_scrollListener);

      if (_isTimelineView(widget._calendar.view)) {
        _scrollPhysics = const NeverScrollableScrollPhysics();

        _timelineViewAnimationController = _timelineViewAnimationController ??
            AnimationController(
                duration: const Duration(milliseconds: 300),
                vsync: this,
                animationBehavior: AnimationBehavior.normal);
        _timelineViewTween =
            _timelineViewTween ?? Tween<double>(begin: 0.0, end: 0.1);

        _timelineViewAnimation = _timelineViewAnimation ??
            _timelineViewTween.animate(_timelineViewAnimationController)
          ..addListener(_scrollAnimationListener);

        _timelineViewHeaderScrollController =
            _timelineViewHeaderScrollController ??
                ScrollController(
                    initialScrollOffset: 0, keepScrollOffset: true);
      }
    }

    if (oldWidget._calendar.view == CalendarView.month ||
        !_isTimelineView(oldWidget._calendar.view) &&
            _isTimelineView(widget._calendar.view) &&
            widget._calendar.view != CalendarView.month) {
      _scrollToPosition();
    }

    _timeIntervalHeight = _getTimeIntervalHeight(
        widget._calendar,
        widget._width,
        widget._height,
        widget._visibleDates.length,
        _allDayHeight);

    super.didUpdateWidget(oldWidget);
  }

  dynamic _updatePainterProperties(_UpdateCalendarStateDetails details) {
    _updateCalendarStateDetails._allDayAppointmentViewCollection = null;
    _updateCalendarStateDetails._currentViewVisibleDates = null;
    _updateCalendarStateDetails._visibleAppointments = null;
    _updateCalendarStateDetails._selectedDate = null;
    widget.updateCalendarState(_updateCalendarStateDetails);

    details._allDayAppointmentViewCollection =
        _updateCalendarStateDetails._allDayAppointmentViewCollection;
    details._currentViewVisibleDates =
        _updateCalendarStateDetails._currentViewVisibleDates;
    details._visibleAppointments =
        _updateCalendarStateDetails._visibleAppointments;
    details._selectedDate = _updateCalendarStateDetails._selectedDate;
  }

  Widget _addAllDayAppointmentPanel(bool _isDark) {
    _updateCalendarStateDetails._currentViewVisibleDates = null;
    _updateCalendarStateDetails._visibleAppointments = null;
    _updateCalendarStateDetails._allDayPanelHeight = null;
    _updateCalendarStateDetails._allDayAppointmentViewCollection = null;
    widget.updateCalendarState(_updateCalendarStateDetails);
    final Color borderColor = widget._calendar.cellBorderColor != null
        ? widget._calendar.cellBorderColor
        : _isDark ? Colors.white : Colors.grey;
    final Material _shadowView = Material(
      color: borderColor.withOpacity(0.5),
      shadowColor: borderColor.withOpacity(0.5),
      elevation: 2.0,
    );

    final double timeLabelWidth = _getTimeLabelWidth(
        widget._calendar.timeSlotViewSettings.timeRulerSize,
        widget._calendar.view);
    double topPosition = _getViewHeaderHeight(
        widget._calendar.viewHeaderHeight, widget._calendar.view);
    if (widget._calendar.view == CalendarView.day) {
      topPosition = _allDayHeight;
    }

    if (_allDayHeight == 0 ||
        widget._visibleDates !=
            _updateCalendarStateDetails._currentViewVisibleDates) {
      return Positioned(
          left: 0, right: 0, top: topPosition, height: 1, child: _shadowView);
    }

    double _leftPosition = timeLabelWidth;
    if (widget._calendar.view == CalendarView.day) {
      _leftPosition = _leftPosition < 50 ? 50 : _leftPosition;
      topPosition = 0;
    }

    double _panelHeight =
        _updateCalendarStateDetails._allDayPanelHeight - _allDayHeight;
    if (_panelHeight < 0) {
      _panelHeight = 0;
    }

    _allDaySelectionNotifier?.value = null;
    final double _alldayExpanderHeight =
        _allDayHeight + (_panelHeight * _allDayExpanderAnimation.value);
    return Positioned(
      left: 0,
      top: topPosition,
      right: 0,
      height: _alldayExpanderHeight,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            height: isExpanded ? _alldayExpanderHeight : _allDayHeight,
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(0.0),
              children: <Widget>[
                CustomPaint(
                  painter: _AllDayAppointmentPainter(
                      widget._calendar,
                      widget._visibleDates,
                      widget._visibleDates ==
                              _updateCalendarStateDetails
                                  ._currentViewVisibleDates
                          ? _updateCalendarStateDetails._visibleAppointments
                          : null,
                      timeLabelWidth,
                      _alldayExpanderHeight,
                      _updateCalendarStateDetails._allDayPanelHeight !=
                              _allDayHeight &&
                          (_heightAnimation.value == 1 ||
                              widget._calendar.view == CalendarView.day),
                      _allDayExpanderAnimation.value != 0.0 &&
                          _allDayExpanderAnimation.value != 1,
                      _isDark,
                      _allDaySelectionNotifier, updateCalendarState:
                          (_UpdateCalendarStateDetails details) {
                    _updatePainterProperties(details);
                  }),
                  size: Size(widget._width,
                      _updateCalendarStateDetails._allDayPanelHeight),
                ),
              ],
            ),
          ),
          Positioned(
              left: 0,
              top: _alldayExpanderHeight - 1,
              right: 0,
              height: 1,
              child: _shadowView),
        ],
      ),
    );
  }

  _AppointmentPainter _addAppointmentPainter() {
    _updateCalendarStateDetails._currentViewVisibleDates = null;
    _updateCalendarStateDetails._visibleAppointments = null;
    widget.updateCalendarState(_updateCalendarStateDetails);
    _appointmentPainter = _AppointmentPainter(
        widget._calendar,
        widget._visibleDates,
        widget._visibleDates ==
                _updateCalendarStateDetails._currentViewVisibleDates
            ? _updateCalendarStateDetails._visibleAppointments
            : null,
        _timeIntervalHeight,
        ValueNotifier<bool>(false),
        updateCalendarState: (_UpdateCalendarStateDetails details) {
      _updatePainterProperties(details);
    });

    return _appointmentPainter;
  }

  // Returns the month view  as a child for the calendar view.
  Widget _addMonthView(bool _isDark) {
    final double viewHeaderHeight = _getViewHeaderHeight(
        widget._calendar.viewHeaderHeight, widget._calendar.view);
    final double height = widget._height - viewHeaderHeight;
    return Stack(
      children: <Widget>[
        Positioned(
          left: 0,
          top: 0,
          right: 0,
          height: viewHeaderHeight,
          child: Container(
            color: widget._calendar.viewHeaderStyle.backgroundColor,
            child: RepaintBoundary(
              child: CustomPaint(
                painter: _ViewHeaderViewPainter(
                    widget._visibleDates,
                    widget._calendar.view,
                    widget._calendar.viewHeaderStyle,
                    widget._calendar.timeSlotViewSettings,
                    _getTimeLabelWidth(
                        widget._calendar.timeSlotViewSettings.timeRulerSize,
                        widget._calendar.view),
                    _getViewHeaderHeight(widget._calendar.viewHeaderHeight,
                        widget._calendar.view),
                    widget._calendar.monthViewSettings,
                    _isDark,
                    widget._calendar.todayHighlightColor,
                    widget._calendar.cellBorderColor),
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: viewHeaderHeight,
          right: 0,
          bottom: 0,
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _MonthCellPainter(
                  widget._visibleDates,
                  widget._calendar.monthViewSettings.numberOfWeeksInView,
                  widget._calendar.monthViewSettings.monthCellStyle,
                  _isDark,
                  widget._calendar.todayHighlightColor,
                  widget._calendar.cellBorderColor),
              size: Size(widget._width, height),
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: viewHeaderHeight,
          right: 0,
          bottom: 0,
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _addAppointmentPainter(),
              size: Size(widget._width, height),
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: viewHeaderHeight,
          right: 0,
          bottom: 0,
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _addSelectionView(),
              size: Size(widget._width, height),
            ),
          ),
        ),
      ],
    );
  }

  // Returns the day view as a child for the calendar view.
  Widget _addDayView(double width, double height, bool _isDark) {
    double viewHeaderWidth = widget._width;
    double viewHeaderHeight = _getViewHeaderHeight(
        widget._calendar.viewHeaderHeight, widget._calendar.view);
    final double timeLabelWidth = _getTimeLabelWidth(
        widget._calendar.timeSlotViewSettings.timeRulerSize,
        widget._calendar.view);
    if (widget._calendar.view == null ||
        widget._calendar.view == CalendarView.day) {
      viewHeaderWidth = timeLabelWidth < 50 ? 50 : timeLabelWidth;
      viewHeaderHeight =
          _allDayHeight > viewHeaderHeight ? _allDayHeight : viewHeaderHeight;
    }

    double _panelHeight =
        _updateCalendarStateDetails._allDayPanelHeight - _allDayHeight;
    if (_panelHeight < 0) {
      _panelHeight = 0;
    }

    final double _alldayExpanderHeight =
        _panelHeight * _allDayExpanderAnimation.value;
    return Stack(
      children: <Widget>[
        Positioned(
          left: 0,
          top: 0,
          width: viewHeaderWidth,
          height: _getViewHeaderHeight(
              widget._calendar.viewHeaderHeight, widget._calendar.view),
          child: Container(
            color: widget._calendar.viewHeaderStyle.backgroundColor,
            child: RepaintBoundary(
              child: CustomPaint(
                painter: _ViewHeaderViewPainter(
                    widget._visibleDates,
                    widget._calendar.view,
                    widget._calendar.viewHeaderStyle,
                    widget._calendar.timeSlotViewSettings,
                    _getTimeLabelWidth(
                        widget._calendar.timeSlotViewSettings.timeRulerSize,
                        widget._calendar.view),
                    _getViewHeaderHeight(widget._calendar.viewHeaderHeight,
                        widget._calendar.view),
                    widget._calendar.monthViewSettings,
                    _isDark,
                    widget._calendar.todayHighlightColor,
                    widget._calendar.cellBorderColor),
              ),
            ),
          ),
        ),
        _addAllDayAppointmentPanel(_isDark),
        Positioned(
          top: (widget._calendar.view == CalendarView.day)
              ? viewHeaderHeight + _alldayExpanderHeight
              : viewHeaderHeight + _allDayHeight + _alldayExpanderHeight,
          left: 0,
          right: 0,
          bottom: 0,
          child: ListView(
              padding: const EdgeInsets.all(0.0),
              controller: _scrollController,
              scrollDirection: Axis.vertical,
              physics: const ClampingScrollPhysics(),
              children: <Widget>[
                Stack(children: <Widget>[
                  RepaintBoundary(
                    child: CustomPaint(
                      painter: _TimeSlotView(
                          widget._visibleDates,
                          _horizontalLinesCount,
                          _timeIntervalHeight,
                          timeLabelWidth,
                          widget._calendar.cellBorderColor,
                          _isDark),
                      size: Size(width, height),
                    ),
                  ),
                  RepaintBoundary(
                    child: CustomPaint(
                      painter: _TimeRulerView(
                          _horizontalLinesCount,
                          _timeIntervalHeight,
                          widget._calendar.timeSlotViewSettings,
                          widget._calendar.cellBorderColor,
                          _isDark),
                      size: Size(timeLabelWidth, height),
                    ),
                  ),
                  RepaintBoundary(
                    child: CustomPaint(
                      painter: _addAppointmentPainter(),
                      size: Size(width, height),
                    ),
                  ),
                  RepaintBoundary(
                    child: CustomPaint(
                      painter: _addSelectionView(),
                      size: Size(width, height),
                    ),
                  ),
                ])
              ]),
        ),
      ],
    );
  }

  // Returns the timeline view  as a child for the calendar view.
  Widget _addTimelineView(double width, double height, bool _isDark) {
    return Stack(children: <Widget>[
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        height: _getViewHeaderHeight(
            widget._calendar.viewHeaderHeight, widget._calendar.view),
        child: Container(
          color: widget._calendar.viewHeaderStyle.backgroundColor,
          child: _getTimelineViewHeader(
              width,
              _getViewHeaderHeight(
                  widget._calendar.viewHeaderHeight, widget._calendar.view),
              _isDark),
        ),
      ),
      Positioned(
        top: _getViewHeaderHeight(
            widget._calendar.viewHeaderHeight, widget._calendar.view),
        left: 0,
        right: 0,
        bottom: 0,
        child: ListView(
            padding: const EdgeInsets.all(0.0),
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: _scrollPhysics,
            children: <Widget>[
              Stack(children: <Widget>[
                RepaintBoundary(
                  child: CustomPaint(
                    painter: _TimelineView(
                        _horizontalLinesCount,
                        widget._visibleDates,
                        _getTimeLabelWidth(
                            widget._calendar.timeSlotViewSettings.timeRulerSize,
                            widget._calendar.view),
                        widget._calendar.timeSlotViewSettings,
                        _timeIntervalHeight,
                        widget._calendar.cellBorderColor,
                        _isDark),
                    size: Size(width, height),
                  ),
                ),
                RepaintBoundary(
                  child: CustomPaint(
                    painter: _addAppointmentPainter(),
                    size: Size(width, height),
                  ),
                ),
                RepaintBoundary(
                  child: CustomPaint(
                    painter: _addSelectionView(),
                    size: Size(width, height),
                  ),
                ),
              ]),
            ]),
      ),
    ]);
  }

  void _updateCalendarTapCallback(TapUpDetails details) {
    final double _viewHeaderHeight = _getViewHeaderHeight(
        widget._calendar.viewHeaderHeight, widget._calendar.view);
    if (details.localPosition.dy < _viewHeaderHeight) {
      if (!_isTimelineView(widget._calendar.view) &&
          widget._calendar.view != CalendarView.month) {
        _updateCalendarTapCallbackForCalendarCells(details);
      } else if (_shouldRaiseCalendarTapCallback(widget._calendar.onTap)) {
        _updateCalendarTapCallbackForViewHeader(details, widget._width);
      }
    } else if (details.localPosition.dy > _viewHeaderHeight) {
      _updateCalendarTapCallbackForCalendarCells(details);
    }
  }

  // method to update the selection and raise the calendar tapped call back for calendar cells
  void _updateCalendarTapCallbackForCalendarCells(TapUpDetails details) {
    double xPosition = details.localPosition.dx;
    double yPosition = details.localPosition.dy;
    if (widget._calendar.view != CalendarView.month &&
        !_isTimelineView(widget._calendar.view)) {
      xPosition = details.localPosition.dx;
      yPosition = details.localPosition.dy;
    } else {
      yPosition = details.localPosition.dy -
          _getViewHeaderHeight(
              widget._calendar.viewHeaderHeight, widget._calendar.view);
    }
    _handleTouch(Offset(xPosition, yPosition), details);
  }

  // method to update the calendar tapped call back for the view header view
  void _updateCalendarTapCallbackForViewHeader(
      TapUpDetails details, double _width) {
    int index = 0;
    DateTime selectedDate;
    final double _timeLabelViewWidth = _getTimeLabelWidth(
        widget._calendar.timeSlotViewSettings.timeRulerSize,
        widget._calendar.view);
    if (!_isTimelineView(widget._calendar.view)) {
      double cellWidth = 0;
      if (widget._calendar.view != CalendarView.month) {
        cellWidth =
            (_width - _timeLabelViewWidth) / widget._visibleDates.length;
        index = ((details.localPosition.dx - _timeLabelViewWidth) / cellWidth)
            .truncate();
      } else {
        // 7 represents the number of days in week.
        cellWidth = _width / 7;
        index = (details.localPosition.dx / cellWidth).truncate();
      }

      selectedDate = widget._visibleDates[index];
    } else {
      index = ((_scrollController.offset + details.localPosition.dx) /
              _getSingleViewWidthForTimeLineView(this))
          .truncate();

      selectedDate = widget._visibleDates[index];
    }

    _raiseCalendarTapCallback(widget._calendar,
        date: selectedDate, element: CalendarElement.viewHeader);
  }

  @override
  Widget build(BuildContext context) {
    final bool _isDark = _isDarkTheme(context);
    _updateCalendarStateDetails._currentViewVisibleDates = null;
    _updateCalendarStateDetails._allDayPanelHeight = null;
    _updateCalendarStateDetails._selectedDate = null;
    _updateCalendarStateDetails._currentDate = null;
    widget.updateCalendarState(_updateCalendarStateDetails);
    if (widget._calendar.view == CalendarView.month) {
      return GestureDetector(
        child: _addMonthView(_isDark),
        onTapUp: (TapUpDetails details) {
          _updateCalendarTapCallback(details);
        },
      );
    } else if (!_isTimelineView(widget._calendar.view) &&
        widget._calendar.view != CalendarView.month) {
      _allDayHeight = 0;

      if (widget._calendar.view == CalendarView.day) {
        final double viewHeaderHeight = _getViewHeaderHeight(
            widget._calendar.viewHeaderHeight, widget._calendar.view);
        if (widget._visibleDates ==
            _updateCalendarStateDetails._currentViewVisibleDates) {
          _allDayHeight = _kAllDayLayoutHeight > viewHeaderHeight &&
                  _updateCalendarStateDetails._allDayPanelHeight >
                      viewHeaderHeight
              ? _updateCalendarStateDetails._allDayPanelHeight >
                      _kAllDayLayoutHeight
                  ? _kAllDayLayoutHeight
                  : _updateCalendarStateDetails._allDayPanelHeight
              : viewHeaderHeight;
          if (_allDayHeight < _updateCalendarStateDetails._allDayPanelHeight) {
            _allDayHeight += _kAllDayAppointmentHeight;
          }
        } else {
          _allDayHeight = viewHeaderHeight;
        }
      }

      if (widget._calendar.view != CalendarView.day &&
          widget._visibleDates ==
              _updateCalendarStateDetails._currentViewVisibleDates) {
        _allDayHeight = _updateCalendarStateDetails._allDayPanelHeight >
                _kAllDayLayoutHeight
            ? _kAllDayLayoutHeight
            : _updateCalendarStateDetails._allDayPanelHeight;
        _allDayHeight = _allDayHeight * _heightAnimation.value;
      }

      return GestureDetector(
        child: _addDayView(widget._width,
            _timeIntervalHeight * _horizontalLinesCount, _isDark),
        onTapUp: (TapUpDetails details) {
          _updateCalendarTapCallback(details);
        },
      );
    } else {
      if ((_scrollController.hasClients &&
              !_scrollController.position.atEdge) &&
          _scrollPhysics.toString() == 'NeverScrollableScrollPhysics' &&
          _updateCalendarStateDetails._currentViewVisibleDates ==
              widget._visibleDates) {
        _scrollPhysics = const ClampingScrollPhysics();
      }

      return GestureDetector(
        child: _addTimelineView(
            _timeIntervalHeight *
                (_horizontalLinesCount * widget._visibleDates.length),
            widget._height,
            _isDark),
        onTapUp: (TapUpDetails details) {
          _updateCalendarTapCallback(details);
        },
      );
    }
  }

  _AppointmentView _getAppointmentOnPoint(
      List<_AppointmentView> _appointmentCollection, double x, double y) {
    if (_appointmentCollection == null) {
      return null;
    }

    _AppointmentView _appointmentView;
    for (int i = 0; i < _appointmentCollection.length; i++) {
      _appointmentView = _appointmentCollection[i];
      if (_appointmentView.appointment != null &&
          _appointmentView.appointmentRect != null &&
          _appointmentView.appointmentRect.left <= x &&
          _appointmentView.appointmentRect.right >= x &&
          _appointmentView.appointmentRect.top <= y &&
          _appointmentView.appointmentRect.bottom >= y) {
        return _appointmentView;
      }
    }

    return null;
  }

  void _handleTouch(Offset details, TapUpDetails tapUpDetails) {
    _updateCalendarStateDetails._selectedDate = null;
    _updateCalendarStateDetails._currentViewVisibleDates = null;
    _updateCalendarStateDetails._allDayAppointmentViewCollection = null;
    widget.updateCalendarState(_updateCalendarStateDetails);
    dynamic _selectedAppointment;
    List<dynamic> _selectedAppointments;
    DateTime _selectedDate = _updateCalendarStateDetails._selectedDate;
    double _timeLabelWidth = 0;

    if (widget._calendar.view != CalendarView.month &&
        !_isTimelineView(widget._calendar.view)) {
      _timeLabelWidth = _getTimeLabelWidth(
          widget._calendar.timeSlotViewSettings.timeRulerSize,
          widget._calendar.view);
      final double _viewHeaderHeight = widget._calendar.view == CalendarView.day
          ? 0
          : _getViewHeaderHeight(
              widget._calendar.viewHeaderHeight, widget._calendar.view);
      final double allDayHeight = isExpanded
          ? _updateCalendarStateDetails._allDayPanelHeight
          : _allDayHeight;
      if (details.dx <= _timeLabelWidth &&
          details.dy > _viewHeaderHeight + allDayHeight) {
        return;
      }

      if (details.dy < _viewHeaderHeight) {
        if (details.dx > _timeLabelWidth) {
          if (_shouldRaiseCalendarTapCallback(widget._calendar.onTap)) {
            _updateCalendarTapCallbackForViewHeader(
                tapUpDetails, widget._width);
          }

          return;
        } else {
          return;
        }
      } else if (details.dy < _viewHeaderHeight + allDayHeight) {
        if (widget._calendar.view == CalendarView.day &&
            _timeLabelWidth >= details.dx &&
            details.dy <
                _getViewHeaderHeight(
                    widget._calendar.viewHeaderHeight, widget._calendar.view)) {
          if (_shouldRaiseCalendarTapCallback(widget._calendar.onTap)) {
            _updateCalendarTapCallbackForViewHeader(
                tapUpDetails, widget._width);
          }
          return;
        } else if (_timeLabelWidth >= details.dx) {
          _expandOrCollapseAllDay();
          return;
        }

        final double yPosition = details.dy - _viewHeaderHeight;
        final _AppointmentView _appointmentView = _getAppointmentOnPoint(
            _updateCalendarStateDetails._allDayAppointmentViewCollection,
            details.dx,
            yPosition);
        if (_appointmentView != null &&
            (yPosition < allDayHeight - _kAllDayAppointmentHeight ||
                _updateCalendarStateDetails._allDayPanelHeight <=
                    allDayHeight)) {
          if (_selectedDate != null) {
            _selectedDate = null;
            _selectionPainter._selectedDate = _selectedDate;
            _updateCalendarStateDetails._selectedDate = _selectedDate;
            _updateCalendarStateDetails._isAppointmentTapped = true;
          }

          _selectionPainter._appointmentView = null;
          _selectionPainter._repaintNotifier.value =
              !_selectionPainter._repaintNotifier.value;
          _selectedAppointment = _appointmentView.appointment;
          _selectedAppointments = null;
          _allDaySelectionNotifier?.value = _appointmentView;
        } else if (_updateCalendarStateDetails._allDayPanelHeight >
                allDayHeight &&
            yPosition > allDayHeight - _kAllDayAppointmentHeight) {
          _expandOrCollapseAllDay();
          return;
        }
      } else {
        final double yPosition = details.dy -
            _viewHeaderHeight -
            allDayHeight +
            _scrollController.offset;
        final _AppointmentView _appointmentView = _getAppointmentOnPoint(
            _appointmentPainter._appointmentCollection, details.dx, yPosition);
        _allDaySelectionNotifier?.value = null;
        if (_appointmentView == null) {
          _drawSelection(details.dx - _timeLabelWidth,
              details.dy - _viewHeaderHeight - allDayHeight, _timeLabelWidth);
        } else {
          if (_selectedDate != null) {
            _selectedDate = null;
            _selectionPainter._selectedDate = _selectedDate;
            _updateCalendarStateDetails._selectedDate = _selectedDate;
            _updateCalendarStateDetails._isAppointmentTapped = true;
          }

          _selectionPainter._appointmentView = _appointmentView;
          _selectionPainter._repaintNotifier.value =
              !_selectionPainter._repaintNotifier.value;
          _selectedAppointment = _appointmentView.appointment;
        }
      }
    } else if (widget._calendar.view == CalendarView.month) {
      _drawSelection(details.dx, details.dy, _timeLabelWidth);
    } else {
      if (details.dy <
          _getTimeLabelWidth(
              widget._calendar.timeSlotViewSettings.timeRulerSize,
              widget._calendar.view)) {
        return;
      }

      final double yPosition = details.dy;
      final double xPosition = _scrollController.offset + details.dx;
      final _AppointmentView _appointmentView = _getAppointmentOnPoint(
          _appointmentPainter._appointmentCollection, xPosition, yPosition);
      if (_appointmentView == null) {
        _drawSelection(
            details.dx,
            details.dy -
                _getViewHeaderHeight(
                    widget._calendar.viewHeaderHeight, widget._calendar.view),
            _timeLabelWidth);
      } else {
        if (_selectedDate != null) {
          _selectedDate = null;
          _selectionPainter._selectedDate = _selectedDate;
          _updateCalendarStateDetails._selectedDate = _selectedDate;
          _updateCalendarStateDetails._isAppointmentTapped = true;
        }

        _selectionPainter._appointmentView = _appointmentView;
        _selectionPainter._repaintNotifier.value =
            !_selectionPainter._repaintNotifier.value;
        _selectedAppointment = _appointmentView.appointment;
      }
    }

    _updateCalendarStateDetails._appointments = null;
    widget.updateCalendarState(_updateCalendarStateDetails);
    if (_shouldRaiseCalendarTapCallback(widget._calendar.onTap)) {
      if (_selectionPainter._selectedDate != null) {
        _selectedAppointments = null;
        if (widget._calendar.view == CalendarView.month &&
            !_isTimelineView(widget._calendar.view)) {
          _selectedAppointments = (widget._calendar.dataSource != null &&
                  !_isCalendarAppointment(
                      widget._calendar.dataSource.appointments))
              ? _getCustomAppointments(_getSelectedDateAppointments(
                  _updateCalendarStateDetails._appointments,
                  widget._calendar.timeZone,
                  _selectionPainter._selectedDate))
              : (_getSelectedDateAppointments(
                  _updateCalendarStateDetails._appointments,
                  widget._calendar.timeZone,
                  _selectionPainter._selectedDate));
        }
        _raiseCalendarTapCallback(widget._calendar,
            date: _selectionPainter._selectedDate,
            appointments: _selectedAppointments,
            element: CalendarElement.calendarCell);
      } else if (_selectedAppointment != null) {
        _selectedAppointments = <dynamic>[
          _selectedAppointment._data ?? _selectedAppointment
        ];
        _raiseCalendarTapCallback(widget._calendar,
            date: _selectedAppointment.startTime,
            appointments: _selectedAppointments,
            element: CalendarElement.appointment);
      }
    }
  }

  void _drawSelection(double x, double y, double _timeLabelWidth) {
    int rowIndex, columnIndex;
    double cellWidth = 0;
    double cellHeight = 0;
    int index = 0;
    final double _width = widget._width - _timeLabelWidth;
    DateTime _selectedDate = _updateCalendarStateDetails._selectedDate;
    if (widget._calendar.view == CalendarView.month) {
      cellWidth = _width / numberOfDaysInWeek;
      cellHeight = (widget._height -
              _getViewHeaderHeight(
                  widget._calendar.viewHeaderHeight, widget._calendar.view)) /
          widget._calendar.monthViewSettings.numberOfWeeksInView;
      rowIndex = (x / cellWidth).truncate();
      columnIndex = (y / cellHeight).truncate();
      index = (columnIndex * numberOfDaysInWeek) + rowIndex;
      _selectedDate = widget._visibleDates[index];
      _updateCalendarStateDetails._selectedDate = _selectedDate;
      _updateCalendarStateDetails._isAppointmentTapped = false;
      widget._agendaSelectedDate.value = _selectedDate;
    } else if (widget._calendar.view == CalendarView.day) {
      if (y >= _timeIntervalHeight * _horizontalLinesCount) {
        return;
      }
      cellWidth = _width;
      cellHeight = _timeIntervalHeight;
      columnIndex = ((_scrollController.offset + y) / cellHeight).truncate();
      final dynamic time =
          ((_getTimeInterval(widget._calendar.timeSlotViewSettings) / 60) *
                  columnIndex) +
              widget._calendar.timeSlotViewSettings.startHour;
      final int hour = time.toInt();
      final dynamic minute = ((time - hour) * 60).round();
      _selectedDate = DateTime(
          widget._visibleDates[0].year,
          widget._visibleDates[0].month,
          widget._visibleDates[0].day,
          hour,
          minute);
      _updateCalendarStateDetails._selectedDate = _selectedDate;
      _updateCalendarStateDetails._isAppointmentTapped = false;
    } else if (widget._calendar.view == CalendarView.workWeek ||
        widget._calendar.view == CalendarView.week) {
      if (y >= _timeIntervalHeight * _horizontalLinesCount) {
        return;
      }
      cellWidth = _width / widget._visibleDates.length;
      cellHeight = _timeIntervalHeight;
      columnIndex = ((_scrollController.offset + y) / cellHeight).truncate();
      final dynamic time =
          ((_getTimeInterval(widget._calendar.timeSlotViewSettings) / 60) *
                  columnIndex) +
              widget._calendar.timeSlotViewSettings.startHour;
      final int hour = time.toInt();
      final dynamic minute = ((time - hour) * 60).round();
      rowIndex = (x / cellWidth).truncate();
      final DateTime date = widget._visibleDates[rowIndex];

      _selectedDate = DateTime(date.year, date.month, date.day, hour, minute);

      _updateCalendarStateDetails._selectedDate = _selectedDate;
      _updateCalendarStateDetails._isAppointmentTapped = false;
    } else {
      if (x >=
          _timeIntervalHeight *
              (_horizontalLinesCount * widget._visibleDates.length)) {
        return;
      }
      cellWidth = _timeIntervalHeight;
      cellHeight = widget._height;
      rowIndex = (((_scrollController.offset %
                      _getSingleViewWidthForTimeLineView(this)) +
                  x) /
              cellWidth)
          .truncate();
      columnIndex =
          (_scrollController.offset / _getSingleViewWidthForTimeLineView(this))
              .truncate();
      if (rowIndex >= _horizontalLinesCount) {
        columnIndex += rowIndex ~/ _horizontalLinesCount;
        rowIndex = (rowIndex % _horizontalLinesCount).toInt();
      }
      final dynamic time =
          ((_getTimeInterval(widget._calendar.timeSlotViewSettings) / 60) *
                  rowIndex) +
              widget._calendar.timeSlotViewSettings.startHour;
      final int hour = time.toInt();
      final dynamic minute = ((time - hour) * 60).round();
      final DateTime date = widget._visibleDates[columnIndex];

      _selectedDate = DateTime(date.year, date.month, date.day, hour, minute);

      _updateCalendarStateDetails._selectedDate = _selectedDate;
      _updateCalendarStateDetails._isAppointmentTapped = false;
    }

    _selectionPainter._selectedDate = _selectedDate;
    _selectionPainter._appointmentView = null;
    _selectionPainter._repaintNotifier.value =
        !_selectionPainter._repaintNotifier.value;
  }

  _SelectionPainter _addSelectionView() {
    _updateCalendarStateDetails._selectedDate = null;
    _updateCalendarStateDetails._currentViewVisibleDates = null;
    widget.updateCalendarState(_updateCalendarStateDetails);
    _selectionPainter = _SelectionPainter(
        widget._calendar,
        widget._visibleDates,
        _updateCalendarStateDetails._selectedDate,
        widget._calendar.selectionDecoration,
        _timeIntervalHeight,
        ValueNotifier<bool>(false),
        updateCalendarState: (_UpdateCalendarStateDetails details) {
      _updatePainterProperties(details);
    });

    return _selectionPainter;
  }

  Widget _getTimelineViewHeader(double width, double height, bool _isDark) {
    _timelineViewHeader = _TimelineViewHeaderView(
        widget._visibleDates,
        this,
        ValueNotifier<bool>(false),
        widget._calendar.viewHeaderStyle,
        widget._calendar.timeSlotViewSettings,
        _getViewHeaderHeight(
            widget._calendar.viewHeaderHeight, widget._calendar.view),
        _isDark,
        widget._calendar.todayHighlightColor);
    return ListView(
        padding: const EdgeInsets.all(0.0),
        controller: _timelineViewHeaderScrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          CustomPaint(
            painter: _timelineViewHeader,
            size: Size(width, height),
          )
        ]);
  }
}

class _ViewHeaderViewPainter extends CustomPainter {
  _ViewHeaderViewPainter(
      this._visibleDates,
      this._view,
      this._viewHeaderStyle,
      this._timeSlotViewSettings,
      this._timeLabelWidth,
      this._viewHeaderHeight,
      this._monthViewSettings,
      this._isDark,
      this._todayHighlightColor,
      this._cellBorderColor);

  final CalendarView _view;
  final ViewHeaderStyle _viewHeaderStyle;
  final TimeSlotViewSettings _timeSlotViewSettings;
  final MonthViewSettings _monthViewSettings;
  final List<DateTime> _visibleDates;
  final double _timeLabelWidth;
  final double _viewHeaderHeight;
  final bool _isDark;
  final Color _todayHighlightColor;
  final Color _cellBorderColor;
  DateTime _currentDate;
  String _dayText, _dateText;
  double _xPosition, _yPosition;
  Paint _circlePainter;
  Paint _linePainter;
  TextPainter _dayTextPainter, _dateTextPainter;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    double _width = size.width;
    _width = _getViewHeaderWidth(_width);

    TextStyle _viewHeaderDayStyle = _viewHeaderStyle.dayTextStyle;
    TextStyle _viewHeaderDateStyle = _viewHeaderStyle.dateTextStyle;

    _viewHeaderDayStyle ??= TextStyle(
        color: _isDark ? Colors.white : Colors.black87,
        fontSize: 11,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto');
    _viewHeaderDateStyle ??= TextStyle(
        color: _isDark ? Colors.white : Colors.black87,
        fontSize: 18,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto');

    final DateTime today = DateTime.now();
    final double _labelWidth = _view == CalendarView.day && _timeLabelWidth < 50
        ? 50
        : _timeLabelWidth;
    TextStyle dayTextStyle = _viewHeaderDayStyle;
    TextStyle dateTextStyle = _viewHeaderDateStyle;
    if (_view != CalendarView.month) {
      const double topPadding = 5;
      if (_view == CalendarView.day) {
        _width = _labelWidth;
        _linePainter ??= Paint();
        _linePainter.strokeWidth = 0.5;
        _linePainter.strokeCap = StrokeCap.round;
        _linePainter.color = _cellBorderColor != null
            ? _cellBorderColor
            : _isDark ? Colors.white70 : Colors.black.withOpacity(0.16);

        if (_timeLabelWidth == _labelWidth) {
          canvas.drawLine(Offset(_labelWidth - 0.5, 0),
              Offset(_labelWidth - 0.5, size.height), _linePainter);
        }
      }

      _xPosition = _view == CalendarView.day ? 0 : _timeLabelWidth;
      _yPosition = 2;
      final double cellWidth = _width / _visibleDates.length;
      for (int i = 0; i < _visibleDates.length; i++) {
        _currentDate = _visibleDates[i];
        _dayText = DateFormat(_timeSlotViewSettings.dayFormat)
            .format(_currentDate)
            .toString()
            .toUpperCase();

        _updateViewHeaderFormat();

        _dateText = DateFormat(_timeSlotViewSettings.dateFormat)
            .format(_currentDate)
            .toString();
        final bool _isToday = _isSameDate(_currentDate, today);
        if (_isToday) {
          dayTextStyle =
              _viewHeaderDayStyle.copyWith(color: _todayHighlightColor);
          dateTextStyle = _viewHeaderDateStyle.copyWith(color: Colors.white);
        } else {
          dayTextStyle = _viewHeaderDayStyle;
          dateTextStyle = _viewHeaderDateStyle;
        }

        _updateDayTextPainter(dayTextStyle, _width);

        final TextSpan dateTextSpan = TextSpan(
          text: _dateText,
          style: dateTextStyle,
        );

        _dateTextPainter = _dateTextPainter ?? TextPainter();
        _dateTextPainter.text = dateTextSpan;
        _dateTextPainter.textDirection = TextDirection.ltr;
        _dateTextPainter.textAlign = TextAlign.left;
        _dateTextPainter.textWidthBasis = TextWidthBasis.longestLine;

        _dateTextPainter.layout(minWidth: 0, maxWidth: _width);

        final double dayXPosition = (cellWidth - _dayTextPainter.width) / 2;

        final double dateXPosition = (cellWidth - _dateTextPainter.width) / 2;

        _yPosition = size.height / 2 -
            (_dayTextPainter.height + topPadding + _dateTextPainter.height) / 2;

        _dayTextPainter.paint(
            canvas, Offset(_xPosition + dayXPosition, _yPosition));
        if (_isToday) {
          _drawTodayCircle(
              canvas,
              _xPosition + dateXPosition,
              _yPosition + topPadding + _dayTextPainter.height,
              _dateTextPainter);
        }

        _dateTextPainter.paint(
            canvas,
            Offset(_xPosition + dateXPosition,
                _yPosition + topPadding + _dayTextPainter.height));

        _xPosition += cellWidth;
      }
    } else {
      _xPosition = 0;
      _yPosition = 0;
      bool _hasToday = false;
      for (int i = 0; i < 7; i++) {
        _currentDate = _visibleDates[i];
        _dayText = DateFormat(_monthViewSettings.dayFormat)
            .format(_currentDate)
            .toString()
            .toUpperCase();

        _updateViewHeaderFormat();

        _hasToday = _monthViewSettings.numberOfWeeksInView > 0 &&
                _monthViewSettings.numberOfWeeksInView < 6
            ? true
            : _visibleDates[_visibleDates.length ~/ 2].month == today.month
                ? true
                : false;

        if (_hasToday &&
            _isWithInVisibleDateRange(_visibleDates, today) &&
            _currentDate.weekday == today.weekday) {
          dayTextStyle =
              _viewHeaderDayStyle.copyWith(color: _todayHighlightColor);
        } else {
          dayTextStyle = _viewHeaderDayStyle;
        }

        _updateDayTextPainter(dayTextStyle, _width);

        if (_yPosition == 0) {
          _yPosition = (_viewHeaderHeight - _dayTextPainter.height) / 2;
        }

        _dayTextPainter.paint(
            canvas,
            Offset(_xPosition + (_width / 2 - _dayTextPainter.width / 2),
                _yPosition));
        _xPosition += _width;
      }
    }
  }

  void _updateViewHeaderFormat() {
    if (_view != CalendarView.day && _view != CalendarView.month) {
      if (_timeSlotViewSettings.dayFormat == 'EE') {
        _dayText = _dayText[0];
      }
    } else if (_view == CalendarView.month) {
      if (_monthViewSettings.dayFormat == 'EE') {
        _dayText = _dayText[0];
      }
    }
  }

  void _updateDayTextPainter(TextStyle dayTextStyle, double _width) {
    final TextSpan dayTextSpan = TextSpan(
      text: _dayText,
      style: dayTextStyle,
    );

    _dayTextPainter = _dayTextPainter ?? TextPainter();
    _dayTextPainter.text = dayTextSpan;
    _dayTextPainter.textDirection = TextDirection.ltr;
    _dayTextPainter.textAlign = TextAlign.left;
    _dayTextPainter.textWidthBasis = TextWidthBasis.longestLine;

    _dayTextPainter.layout(minWidth: 0, maxWidth: _width);
  }

  double _getViewHeaderWidth(double _width) {
    if (_view != CalendarView.month) {
      if (_view == null || _view == CalendarView.day) {
        _width = _timeLabelWidth;
      } else {
        _width -= _timeLabelWidth;
      }
    } else {
      _width = _width / 7;
    }
    return _width;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final _ViewHeaderViewPainter oldWidget = oldDelegate;
    return oldWidget._visibleDates != _visibleDates ||
        oldWidget._viewHeaderStyle != _viewHeaderStyle ||
        oldWidget._viewHeaderHeight != _viewHeaderHeight ||
        oldWidget._todayHighlightColor != _todayHighlightColor ||
        oldWidget._timeSlotViewSettings != _timeSlotViewSettings ||
        oldWidget._monthViewSettings != _monthViewSettings ||
        oldWidget._cellBorderColor != _cellBorderColor ||
        oldWidget._isDark != _isDark;
  }

  void _drawTodayCircle(
      Canvas canvas, double x, double y, TextPainter dateTextPainter) {
    _circlePainter = _circlePainter ?? Paint();
    _circlePainter.color = _todayHighlightColor;
    const double _circlePadding = 3;
    final double painterWidth = dateTextPainter.width / 2;
    final double painterHeight = dateTextPainter.height / 2;
    final double radius =
        painterHeight > painterWidth ? painterHeight : painterWidth;
    canvas.drawCircle(Offset(x + painterWidth, y + painterHeight),
        radius + _circlePadding, _circlePainter);
  }
}

class _TimelineView extends CustomPainter {
  _TimelineView(
      this._horizontalLinesCountPerView,
      this._visibleDates,
      this._timeLabelWidth,
      this._timeSlotViewSettings,
      this._timeIntervalHeight,
      this._cellBorderColor,
      this._isDark);

  final double _horizontalLinesCountPerView;
  final List<DateTime> _visibleDates;
  final double _timeLabelWidth;
  final TimeSlotViewSettings _timeSlotViewSettings;
  final double _timeIntervalHeight;
  final Color _cellBorderColor;
  final bool _isDark;
  double _x1, _x2, _y1, _y2;
  Paint _linePainter;
  TextPainter _textPainter;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    _x1 = 0;
    _x2 = size.width;
    _y1 = _timeIntervalHeight;
    _y2 = _timeIntervalHeight;
    _linePainter = _linePainter ?? Paint();
    _linePainter.strokeWidth = 0.5;
    _linePainter.strokeCap = StrokeCap.round;
    _linePainter.color = _cellBorderColor != null
        ? _cellBorderColor
        : _isDark ? Colors.white70 : Colors.black.withOpacity(0.16);
    _x1 = 0;
    _x2 = size.width;
    _y1 = _timeLabelWidth;
    _y2 = _timeLabelWidth;

    final Offset _start = Offset(_x1, _y1);
    final Offset _end = Offset(_x2, _y2);
    canvas.drawLine(_start, _end, _linePainter);

    _x1 = 0;
    _x2 = 0;
    _y2 = size.height;
    final List<Offset> points = <Offset>[];
    for (int i = 0;
        i < _horizontalLinesCountPerView * _visibleDates.length;
        i++) {
      _y1 = _timeLabelWidth;
      if (i % _horizontalLinesCountPerView == 0) {
        _y1 = 0;
        _drawTimeLabels(canvas, size, _x1);
      }
      points.add(Offset(_x1, _y1));
      points.add(Offset(_x2, _y2));

      _x1 += _timeIntervalHeight;
      _x2 += _timeIntervalHeight;
    }

    canvas.drawPoints(PointMode.lines, points, _linePainter);
  }

  void _drawTimeLabels(Canvas canvas, Size size, double xPosition) {
    final double _startHour = _timeSlotViewSettings.startHour;
    final int _timeInterval = _getTimeInterval(_timeSlotViewSettings);
    final String _timeFormat = _timeSlotViewSettings.timeFormat;

    _textPainter = _textPainter ?? TextPainter();
    _textPainter.textDirection = TextDirection.ltr;
    _textPainter.textAlign = TextAlign.left;
    _textPainter.textWidthBasis = TextWidthBasis.parent;
    TextStyle timeTextStyle = _timeSlotViewSettings.timeTextStyle;
    timeTextStyle ??= TextStyle(
        color: _isDark ? Colors.white38 : Colors.black54,
        fontWeight: FontWeight.w500,
        fontSize: 10);

    DateTime date = DateTime.now();
    for (int i = 0; i < _horizontalLinesCountPerView; i++) {
      final dynamic hour = (_startHour - _startHour.toInt()) * 60;
      final dynamic minute = (i * _timeInterval) + hour;
      date = DateTime(
          date.day, date.month, date.year, _startHour.toInt(), minute.toInt());
      final dynamic _time = DateFormat(_timeFormat).format(date).toString();
      final TextSpan span = TextSpan(
        text: _time,
        style: timeTextStyle,
      );

      _textPainter.text = span;
      _textPainter.layout(minWidth: 0, maxWidth: _timeIntervalHeight);
      if (_textPainter.height > _timeLabelWidth) {
        return;
      }

      _textPainter.paint(canvas,
          Offset(xPosition, _timeLabelWidth / 2 - _textPainter.height / 2));
      xPosition += _timeIntervalHeight;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final _TimelineView oldWidget = oldDelegate;
    return oldWidget._horizontalLinesCountPerView !=
            _horizontalLinesCountPerView ||
        oldWidget._timeLabelWidth != _timeLabelWidth ||
        oldWidget._visibleDates != _visibleDates ||
        oldWidget._cellBorderColor != _cellBorderColor ||
        oldWidget._timeSlotViewSettings != _timeSlotViewSettings ||
        oldWidget._isDark != _isDark;
  }
}

class _TimelineViewHeaderView extends CustomPainter {
  _TimelineViewHeaderView(
      this._visibleDates,
      this._calendarViewState,
      this._repaintNotifier,
      this._viewHeaderStyle,
      this._timeSlotViewSettings,
      this._viewHeaderHeight,
      this._isDark,
      this._todayHighlightColor)
      : super(repaint: _repaintNotifier);

  final List<DateTime> _visibleDates;
  final ViewHeaderStyle _viewHeaderStyle;
  final TimeSlotViewSettings _timeSlotViewSettings;
  final double _viewHeaderHeight;
  final Color _todayHighlightColor;
  final double _padding = 5;
  final ValueNotifier<bool> _repaintNotifier;
  final _CalendarViewState _calendarViewState;
  final bool _isDark;
  double _xPosition = 0;
  TextPainter dayTextPainter, dateTextPainter;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final DateTime _today = DateTime.now();
    final double childWidth = size.width / _visibleDates.length;
    final double scrolledPosition =
        _calendarViewState._timelineViewHeaderScrollController.offset;
    final int index = scrolledPosition ~/ childWidth;
    _xPosition = scrolledPosition;

    TextStyle _viewHeaderDayStyle = _viewHeaderStyle.dayTextStyle;
    TextStyle _viewHeaderDateStyle = _viewHeaderStyle.dateTextStyle;
    _viewHeaderDayStyle ??= TextStyle(
        color: _isDark ? Colors.white : Colors.black87,
        fontSize: 18,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto');
    _viewHeaderDateStyle ??= TextStyle(
        color: _isDark ? Colors.white : Colors.black87,
        fontSize: 18,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto');

    TextStyle _dayTextStyle = _viewHeaderDayStyle;
    TextStyle _dateTextStyle = _viewHeaderDateStyle;
    for (int i = 0; i < _visibleDates.length; i++) {
      if (i < index) {
        continue;
      }

      final DateTime _currentDate = _visibleDates[i];
      String dayFormat = 'EE';
      dayFormat = dayFormat == _timeSlotViewSettings.dayFormat
          ? 'EEEE'
          : _timeSlotViewSettings.dayFormat;

      final String dayText =
          DateFormat(dayFormat).format(_currentDate).toString();
      final String dateText = DateFormat(_timeSlotViewSettings.dateFormat)
          .format(_currentDate)
          .toString();

      if (_isSameDate(_currentDate, _today)) {
        _dayTextStyle =
            _viewHeaderDayStyle.copyWith(color: _todayHighlightColor);
        _dateTextStyle =
            _viewHeaderDateStyle.copyWith(color: _todayHighlightColor);
      } else {
        _dateTextStyle = _viewHeaderDateStyle;
        _dayTextStyle = _viewHeaderDayStyle;
      }

      final TextSpan dayTextSpan =
          TextSpan(text: dayText, style: _dayTextStyle);

      dayTextPainter = dayTextPainter ?? TextPainter();
      dayTextPainter.text = dayTextSpan;
      dayTextPainter.textDirection = TextDirection.ltr;
      dayTextPainter.textAlign = TextAlign.left;
      dayTextPainter.textWidthBasis = TextWidthBasis.longestLine;

      final TextSpan dateTextSpan =
          TextSpan(text: dateText, style: _dateTextStyle);

      dateTextPainter = dateTextPainter ?? TextPainter();
      dateTextPainter.text = dateTextSpan;
      dateTextPainter.textDirection = TextDirection.ltr;
      dateTextPainter.textAlign = TextAlign.left;
      dateTextPainter.textWidthBasis = TextWidthBasis.longestLine;

      dayTextPainter.layout(minWidth: 0, maxWidth: childWidth);
      dateTextPainter.layout(minWidth: 0, maxWidth: childWidth);
      if (dateTextPainter.width +
              _xPosition +
              (_padding * 2) +
              dayTextPainter.width >
          (i + 1) * childWidth) {
        _xPosition = ((i + 1) * childWidth) -
            (dateTextPainter.width + (_padding * 2) + dayTextPainter.width);
      }

      dateTextPainter.paint(
          canvas,
          Offset(_padding + _xPosition,
              _viewHeaderHeight / 2 - dateTextPainter.height / 2));
      dayTextPainter.paint(
          canvas,
          Offset(dateTextPainter.width + _xPosition + (_padding * 2),
              _viewHeaderHeight / 2 - dayTextPainter.height / 2));
      if (index == i) {
        _xPosition = (i + 1) * childWidth;
      } else {
        _xPosition += childWidth;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final _TimelineViewHeaderView oldWidget = oldDelegate;
    return oldWidget._visibleDates != _visibleDates ||
        oldWidget._xPosition != _xPosition ||
        oldWidget._viewHeaderStyle != _viewHeaderStyle ||
        oldWidget._timeSlotViewSettings != _timeSlotViewSettings ||
        oldWidget._viewHeaderHeight != _viewHeaderHeight ||
        oldWidget._todayHighlightColor != _todayHighlightColor ||
        oldWidget._isDark != _isDark;
  }
}

class _TimeRulerView extends CustomPainter {
  _TimeRulerView(this._horizontalLinesCount, this._timeIntervalHeight,
      this._timeSlotViewSettings, this._cellBorderColor, this._isDark);

  final double _horizontalLinesCount;
  final double _timeIntervalHeight;
  final TimeSlotViewSettings _timeSlotViewSettings;
  final bool _isDark;
  final Color _cellBorderColor;
  Paint _linePainter;
  TextPainter _textPainter;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final double _width = size.width;
    const double offset = 0.5;
    double y;
    DateTime date = DateTime.now();
    y = _timeIntervalHeight;
    _linePainter = _linePainter ?? Paint();
    _linePainter.strokeWidth = 0.5;
    _linePainter.strokeCap = StrokeCap.round;
    _linePainter.color = _cellBorderColor != null
        ? _cellBorderColor
        : _isDark ? Colors.white70 : Colors.black.withOpacity(0.16);

    canvas.drawLine(Offset(_width - offset, 0),
        Offset(_width - offset, size.height), _linePainter);
    _textPainter = _textPainter ?? TextPainter();
    _textPainter.textDirection = TextDirection.ltr;
    _textPainter.textWidthBasis = TextWidthBasis.longestLine;

    TextStyle timeTextStyle = _timeSlotViewSettings.timeTextStyle;
    timeTextStyle ??= TextStyle(
        color: _isDark ? Colors.white38 : Colors.black54,
        fontWeight: FontWeight.w500,
        fontSize: 10);

    final dynamic hour = (_timeSlotViewSettings.startHour -
            _timeSlotViewSettings.startHour.toInt()) *
        60;
    double timeLabelPadding = 0;
    for (int i = 1; i <= _horizontalLinesCount; i++) {
      final dynamic minute =
          (i * _getTimeInterval(_timeSlotViewSettings)) + hour;
      date = DateTime(date.day, date.month, date.year,
          _timeSlotViewSettings.startHour.toInt(), minute.toInt());
      final dynamic _time =
          DateFormat(_timeSlotViewSettings.timeFormat).format(date).toString();
      final TextSpan span = TextSpan(
        text: _time,
        style: timeTextStyle,
      );

      _textPainter.text = span;
      _textPainter.layout(minWidth: 0, maxWidth: _width);
      timeLabelPadding = (_width - _textPainter.width) / 2;
      if (timeLabelPadding < 0) {
        timeLabelPadding = 0;
      }

      _textPainter.paint(
          canvas, Offset(timeLabelPadding, y - (_textPainter.height / 2)));

      final Offset _start = Offset(size.width - (timeLabelPadding / 2), y);
      final Offset _end = Offset(size.width, y);
      canvas.drawLine(_start, _end, _linePainter);

      y += _timeIntervalHeight;
      if (y == size.height) {
        break;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final _TimeRulerView oldWidget = oldDelegate;
    return oldWidget._timeSlotViewSettings != _timeSlotViewSettings ||
        oldWidget._cellBorderColor != _cellBorderColor ||
        oldWidget._isDark != _isDark;
  }
}

class _SelectionPainter extends CustomPainter {
  _SelectionPainter(
      this._calendar,
      this._visibleDates,
      this._selectedDate,
      this._selectionDecoration,
      this._timeIntervalHeight,
      this._repaintNotifier,
      {this.updateCalendarState})
      : super(repaint: _repaintNotifier);

  final SfCalendar _calendar;
  final List<DateTime> _visibleDates;
  Decoration _selectionDecoration;
  final double _timeIntervalHeight;
  final _UpdateCalendarState updateCalendarState;

  BoxPainter _boxPainter;
  DateTime _selectedDate;
  _AppointmentView _appointmentView;
  int _rowIndex, _columnIndex;
  double _cellWidth, _cellHeight, _xPosition, _yPosition;
  final int _numberOfDaysInWeek = 7;
  final ValueNotifier<bool> _repaintNotifier;
  final _UpdateCalendarStateDetails _updateCalendarStateDetails =
      _UpdateCalendarStateDetails();

  @override
  void paint(Canvas canvas, Size size) {
    _selectionDecoration ??= BoxDecoration(
      color: Colors.transparent,
      border:
          Border.all(color: const Color.fromARGB(255, 68, 140, 255), width: 2),
      borderRadius: const BorderRadius.all(Radius.circular(2)),
      shape: BoxShape.rectangle,
    );

    _updateCalendarStateDetails._currentViewVisibleDates = null;
    _updateCalendarStateDetails._selectedDate = null;
    updateCalendarState(_updateCalendarStateDetails);
    _selectedDate = _updateCalendarStateDetails._selectedDate;
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final double _timeLabelWidth = _getTimeLabelWidth(
        _calendar.timeSlotViewSettings.timeRulerSize, _calendar.view);
    double _width = size.width;
    final bool _isTimeline = _isTimelineView(_calendar.view);
    if (_calendar.view != CalendarView.month && !_isTimeline) {
      _width -= _timeLabelWidth;
    }
    if ((_selectedDate == null && _appointmentView == null) ||
        _visibleDates != _updateCalendarStateDetails._currentViewVisibleDates) {
      return;
    }

    if (!_isTimeline) {
      if (_calendar.view == CalendarView.month) {
        _cellWidth = _width / _numberOfDaysInWeek;
        _cellHeight =
            size.height / _calendar.monthViewSettings.numberOfWeeksInView;
      } else {
        _cellWidth = _width / _visibleDates.length;
        _cellHeight = _timeIntervalHeight;
      }
    } else {
      _cellWidth = _timeIntervalHeight;
      _cellHeight = size.height - _timeLabelWidth;
    }

    if (!_isTimeline) {
      if (_calendar.view == CalendarView.month) {
        if (_selectedDate != null) {
          if (_isWithInVisibleDateRange(_visibleDates, _selectedDate)) {
            for (int i = 0; i < _visibleDates.length; i++) {
              final DateTime date = _visibleDates[i];
              if (_isSameDate(date, _selectedDate)) {
                final int index = i;
                _columnIndex = (index / _numberOfDaysInWeek).truncate();
                _yPosition = _columnIndex * _cellHeight;
                _rowIndex = index % _numberOfDaysInWeek;
                _xPosition = _rowIndex * _cellWidth;
                _drawSlotSelection(_width, size.height, canvas);
                break;
              }
            }
          }
        }
      } else if (_calendar.view == CalendarView.day) {
        if (_appointmentView != null && _appointmentView.appointment != null) {
          _drawAppointmentSelection(canvas);
        } else if (_selectedDate != null) {
          if (_isSameDate(_visibleDates[0], _selectedDate)) {
            _xPosition = _timeLabelWidth;
            _yPosition =
                _timeToPosition(_calendar, _selectedDate, _timeIntervalHeight);
            _drawSlotSelection(_width + _timeLabelWidth, size.height, canvas);
          }
        }
      } else {
        if (_appointmentView != null && _appointmentView.appointment != null) {
          _drawAppointmentSelection(canvas);
        } else if (_selectedDate != null) {
          if (_isWithInVisibleDateRange(_visibleDates, _selectedDate)) {
            for (int i = 0; i < _visibleDates.length; i++) {
              if (_isSameDate(_selectedDate, _visibleDates[i])) {
                _rowIndex = i;
                _xPosition = _timeLabelWidth + _cellWidth * _rowIndex;
                _yPosition = _timeToPosition(
                    _calendar, _selectedDate, _timeIntervalHeight);
                _drawSlotSelection(
                    _width + _timeLabelWidth, size.height, canvas);
                break;
              }
            }
          }
        }
      }
    } else {
      if (_calendar.view == CalendarView.timelineDay) {
        if (_appointmentView != null && _appointmentView.appointment != null) {
          _drawAppointmentSelection(canvas);
        } else if (_selectedDate != null) {
          if (_isSameDate(_visibleDates[0], _selectedDate)) {
            _xPosition =
                _timeToPosition(_calendar, _selectedDate, _timeIntervalHeight);
            _yPosition = _getTimeLabelWidth(
                _calendar.timeSlotViewSettings.timeRulerSize, _calendar.view);
            _drawSlotSelection(_width, size.height, canvas);
          }
        }
      } else {
        if (_appointmentView != null && _appointmentView.appointment != null) {
          _drawAppointmentSelection(canvas);
        } else if (_selectedDate != null) {
          if (_isWithInVisibleDateRange(_visibleDates, _selectedDate)) {
            for (int i = 0; i < _visibleDates.length; i++) {
              if (_isSameDate(_selectedDate, _visibleDates[i])) {
                final double singleViewWidth = _width / _visibleDates.length;
                _rowIndex = i;
                _xPosition = (_rowIndex * singleViewWidth) +
                    _timeToPosition(
                        _calendar, _selectedDate, _timeIntervalHeight);
                _yPosition = _getTimeLabelWidth(
                    _calendar.timeSlotViewSettings.timeRulerSize,
                    _calendar.view);
                _drawSlotSelection(_width, size.height, canvas);
                break;
              }
            }
          }
        }
      }
    }
  }

  void _drawAppointmentSelection(Canvas canvas) {
    Rect rect = _appointmentView.appointmentRect.outerRect;
    rect = Rect.fromLTRB(rect.left, rect.top, rect.right, rect.bottom);
    _boxPainter = _selectionDecoration.createBoxPainter();
    _boxPainter.paint(canvas, Offset(rect.left, rect.top),
        ImageConfiguration(size: rect.size));
  }

  void _drawSlotSelection(double _width, double height, Canvas canvas) {
    const double padding = 0.5;
    final Rect rect = Rect.fromLTRB(
        _xPosition == 0 ? _xPosition + padding : _xPosition,
        _yPosition == 0 ? _yPosition + padding : _yPosition,
        _xPosition + _cellWidth == _width
            ? _xPosition + _cellWidth - padding
            : _xPosition + _cellWidth,
        _yPosition + _cellHeight == height
            ? _yPosition + _cellHeight - padding
            : _yPosition + _cellHeight);
    _boxPainter = _selectionDecoration.createBoxPainter();
    _boxPainter.paint(canvas, Offset(rect.left, rect.top),
        ImageConfiguration(size: rect.size, textDirection: TextDirection.ltr));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final _SelectionPainter oldWidget = oldDelegate;
    return oldWidget._selectionDecoration != _selectionDecoration ||
        oldWidget._selectedDate != _selectedDate ||
        oldWidget._calendar.view != _calendar.view ||
        oldWidget._visibleDates != _visibleDates;
  }
}

class _MonthCellPainter extends CustomPainter {
  _MonthCellPainter(this._visibleDates, this._rowCount, this._monthCellStyle,
      this._isDark, this._todayHighlightColor, this._cellBorderColor);

  final int _rowCount;
  final MonthCellStyle _monthCellStyle;
  final List<DateTime> _visibleDates;
  final bool _isDark;
  final Color _todayHighlightColor;
  final Color _cellBorderColor;
  String _date;
  Paint _linePainter, _circlePainter;
  TextPainter _textPainter;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    double cellWidth, xPosition, yPosition, cellHeight;
    const int numberOfDaysInWeek = 7;
    cellWidth = size.width / numberOfDaysInWeek;
    cellHeight = size.height / _rowCount;
    xPosition = 0;
    yPosition = 5;
    _textPainter = _textPainter ?? TextPainter();
    _textPainter.textDirection = TextDirection.ltr;
    _textPainter.textAlign = TextAlign.center;
    _textPainter.textWidthBasis = TextWidthBasis.longestLine;
    TextStyle _textStyle = _monthCellStyle.textStyle;
    final DateTime _currentDate =
        _visibleDates[(_visibleDates.length / 2).truncate()];
    final DateTime _nextMonthDate = _getNextMonthDate(_currentDate);
    final DateTime _previousMonthDate = _getPreviousMonthDate(_currentDate);
    final DateTime _today = DateTime.now();
    bool _isCurrentDate;

    _linePainter = _linePainter ?? Paint();
    _linePainter.isAntiAlias = true;
    TextStyle currentMonthTextStyle = _monthCellStyle.textStyle;
    TextStyle previousMonthTextStyle = _monthCellStyle.trailingDatesTextStyle;
    TextStyle nextMonthTextStyle = _monthCellStyle.leadingDatesTextStyle;
    currentMonthTextStyle ??= TextStyle(
        fontSize: 13,
        fontFamily: 'Roboto',
        color: _isDark ? Colors.white : Colors.black87);
    previousMonthTextStyle ??= TextStyle(
        fontSize: 13,
        fontFamily: 'Roboto',
        color: _isDark ? Colors.white70 : Colors.black54);
    nextMonthTextStyle ??= TextStyle(
        fontSize: 13,
        fontFamily: 'Roboto',
        color: _isDark ? Colors.white70 : Colors.black54);

    const double linePadding = 0.5;
    for (int i = 0; i < _visibleDates.length; i++) {
      _isCurrentDate = false;
      if (_visibleDates[i].month == _nextMonthDate.month) {
        _textStyle = nextMonthTextStyle;
        _linePainter.color = _monthCellStyle.leadingDatesBackgroundColor;
      } else if (_visibleDates[i].month == _previousMonthDate.month) {
        _textStyle = previousMonthTextStyle;
        _linePainter.color = _monthCellStyle.trailingDatesBackgroundColor;
      } else {
        _textStyle = currentMonthTextStyle;
        _linePainter.color = _monthCellStyle.backgroundColor;
      }

      if (_visibleDates[i].month == _today.month &&
          _visibleDates[i].day == _today.day &&
          _visibleDates[i].year == _today.year) {
        _linePainter.color = _monthCellStyle.todayBackgroundColor;
        _textStyle = _monthCellStyle.todayTextStyle;
        _isCurrentDate = true;
      }

      _date = _visibleDates[i].day.toString();
      final TextSpan span = TextSpan(
        text: _date,
        style: _textStyle,
      );

      _textPainter.text = span;

      _textPainter.layout(minWidth: 0, maxWidth: cellWidth);

      canvas.drawRect(
          Rect.fromLTWH(xPosition, yPosition - 5, cellWidth, cellHeight),
          _linePainter);

      if (_isCurrentDate) {
        _circlePainter = _circlePainter ?? Paint();

        _circlePainter.color = _todayHighlightColor;
        _circlePainter.isAntiAlias = true;

        canvas.drawCircle(
            Offset(xPosition + cellWidth / 2,
                yPosition + _textStyle.fontSize * 0.6),
            _textStyle.fontSize * 0.75,
            _circlePainter);
      }

      _textPainter.paint(canvas, Offset(xPosition, yPosition));
      xPosition += cellWidth;
      if (xPosition.round() >= size.width.round()) {
        xPosition = 0;
        yPosition += cellHeight;
      }
    }

    yPosition = cellHeight;
    _linePainter.strokeWidth = 0.5;
    _linePainter.color = _cellBorderColor != null
        ? _cellBorderColor
        : (_isDark ? Colors.white70 : Colors.black.withOpacity(0.16));
    canvas.drawLine(const Offset(0, linePadding),
        Offset(size.width, linePadding), _linePainter);
    for (int i = 0; i < _rowCount - 1; i++) {
      canvas.drawLine(
          Offset(0, yPosition), Offset(size.width, yPosition), _linePainter);
      yPosition += cellHeight;
    }

    canvas.drawLine(Offset(0, size.height - linePadding),
        Offset(size.width, size.height - linePadding), _linePainter);
    xPosition = cellWidth;
    canvas.drawLine(const Offset(linePadding, 0),
        Offset(linePadding, size.height), _linePainter);
    for (int i = 0; i < 6; i++) {
      canvas.drawLine(
          Offset(xPosition, 0), Offset(xPosition, size.height), _linePainter);
      xPosition += cellWidth;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final _MonthCellPainter oldWidget = oldDelegate;
    return oldWidget._visibleDates != _visibleDates ||
        oldWidget._rowCount != _rowCount ||
        oldWidget._todayHighlightColor != _todayHighlightColor ||
        oldWidget._monthCellStyle != _monthCellStyle ||
        oldWidget._cellBorderColor != _cellBorderColor ||
        oldWidget._isDark != _isDark;
  }
}

typedef ViewChangedCallback = void Function(
    ViewChangedDetails viewChangedDetails);

typedef CalendarTapCallback = void Function(
    CalendarTapDetails calendarTapDetails);

typedef _UpdateCalendarState = void Function(
    _UpdateCalendarStateDetails _updateCalendarStateDetails);

class SfCalendar extends StatefulWidget {
  SfCalendar({
    Key key,
    this.view = CalendarView.day,
    this.firstDayOfWeek = 7,
    this.headerHeight = 40,
    this.viewHeaderHeight = -1,
    this.todayHighlightColor = const Color.fromARGB(255, 0, 102, 255),
    this.cellBorderColor,
    this.backgroundColor = Colors.transparent,
    this.initialSelectedDate,
    this.dataSource,
    this.timeZone,
    this.selectionDecoration,
    this.onViewChanged,
    this.onTap,
    CalendarHeaderStyle headerStyle,
    ViewHeaderStyle viewHeaderStyle,
    TimeSlotViewSettings timeSlotViewSettings,
    MonthViewSettings monthViewSettings,
    DateTime initialDisplayDate,
    TextStyle appointmentTextStyle,
  })  : appointmentTextStyle = appointmentTextStyle ??
            TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto'),
        headerStyle = headerStyle ?? CalendarHeaderStyle(),
        viewHeaderStyle = viewHeaderStyle ?? ViewHeaderStyle(),
        timeSlotViewSettings = timeSlotViewSettings ?? TimeSlotViewSettings(),
        monthViewSettings = monthViewSettings ?? MonthViewSettings(),
        initialDisplayDate = initialDisplayDate ??
            DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day, 08, 45, 0),
        super(key: key);

  final CalendarView view;

  final int firstDayOfWeek;

  final Color cellBorderColor;

  final CalendarHeaderStyle headerStyle;

  final ViewHeaderStyle viewHeaderStyle;

  final double headerHeight;

  final TextStyle appointmentTextStyle;

  final double viewHeaderHeight;

  final Color todayHighlightColor;

  final Color backgroundColor;

  final TimeSlotViewSettings timeSlotViewSettings;

  final MonthViewSettings monthViewSettings;

  final Decoration selectionDecoration;

  final DateTime initialDisplayDate;

  final String timeZone;

  final DateTime initialSelectedDate;

  final ViewChangedCallback onViewChanged;

  final CalendarTapCallback onTap;

  final CalendarDataSource dataSource;

  static List<DateTime> getRecurrenceDateTimeCollection(
      String rRule, DateTime recurrenceStartDate,
      {DateTime specificStartDate, DateTime specificEndDate}) {
    return _getRecurrenceDateTimeCollection(rRule, recurrenceStartDate,
        specificStartDate: specificStartDate, specificEndDate: specificEndDate);
  }

  static RecurrenceProperties parseRRule(String rRule, DateTime recStartDate) {
    return _parseRRule(rRule, recStartDate);
  }

  static String generateRRule(RecurrenceProperties recurrenceProperties,
      DateTime appStartTime, DateTime appEndTime) {
    return _generateRRule(recurrenceProperties, appStartTime, appEndTime);
  }

  @override
  _SfCalendarState createState() => _SfCalendarState();
}

class _SfCalendarState extends State<SfCalendar> {
  List<DateTime> _currentViewVisibleDates;
  DateTime _currentDate, _selectedDate, _minDate, _maxDate;
  List<Appointment> _visibleAppointments;
  List<_AppointmentView> _allDayAppointmentViewCollection =
      <_AppointmentView>[];
  double _allDayPanelHeight = 0;
  ScrollController _agendaScrollController;
  ValueNotifier<DateTime> _agendaSelectedDate;
  double _minWidth, _minHeight, _topPadding;

  bool _timeZoneLoaded = false;
  List<Appointment> _appointments;

  Future<bool> _loadDataBase() async {
    final dynamic byteData =
        await rootBundle.load('packages/timezone/data/2019c.tzf');
    initializeDatabase(byteData.buffer.asUint8List());
    _timeZoneLoaded = true;
    return true;
  }

  void _getAppointment() {
    _appointments = _generateCalendarAppointments(widget.dataSource, widget);
    _updateVisibleAppointments();
  }

  // ignore: avoid_void_async
  void _updateVisibleAppointments() async {
    // ignore: await_only_futures
    _visibleAppointments = await _getVisibleAppointments(
        _currentViewVisibleDates[0],
        _currentViewVisibleDates[_currentViewVisibleDates.length - 1],
        _appointments,
        widget.timeZone,
        widget.view == CalendarView.month || _isTimelineView(widget.view));

    _updateAllDayAppointment();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    if (_agendaScrollController != null) {
      _agendaScrollController.dispose();
      _agendaScrollController = null;
    }

    super.dispose();
  }

  @override
  void initState() {
    _timeZoneLoaded = false;
    _loadDataBase().then((dynamic value) => _getAppointment());
    _minDate = DateTime(0001, 01, 01);
    _maxDate = DateTime(9999, 12, 31);
    _selectedDate = widget.initialSelectedDate;
    _agendaSelectedDate = ValueNotifier<DateTime>(widget.initialSelectedDate);
    _agendaSelectedDate.addListener(_agendaSelectedDateListener);
    _currentDate =
        _getCurrentDate(_minDate, _maxDate, widget.initialDisplayDate);
    _updateCurrentVisibleDates();
    widget.dataSource?.addListener(_dataSourceChangedListener);
    if (widget.view == CalendarView.month &&
        widget.monthViewSettings.showAgenda) {
      _agendaScrollController =
          ScrollController(initialScrollOffset: 0, keepScrollOffset: true);
    }

    super.initState();
  }

  void _updateCurrentVisibleDates() {
    final DateTime currentDate = _currentDate;
    final List<int> _nonWorkingDays = (widget.view == CalendarView.workWeek ||
            widget.view == CalendarView.timelineWorkWeek)
        ? widget.timeSlotViewSettings.nonWorkingDays
        : null;

    _currentViewVisibleDates = _getVisibleDates(
        currentDate,
        _nonWorkingDays,
        widget.firstDayOfWeek,
        _getViewDatesCount(widget.view,
            widget.monthViewSettings.numberOfWeeksInView, currentDate));
  }

  void _dataSourceChangedListener(
      CalendarDataSourceAction type, List<dynamic> data) {
    if (!_timeZoneLoaded) {
      return;
    }

    if (type == CalendarDataSourceAction.reset) {
      _getAppointment();
    } else {
      setState(() {
        final List<Appointment> visibleAppointmentCollection = <Appointment>[];

        if (_visibleAppointments != null) {
          for (int i = 0; i < _visibleAppointments.length; i++) {
            visibleAppointmentCollection.add(_visibleAppointments[i]);
          }
        }

        _appointments ??= <Appointment>[];
        if (type == CalendarDataSourceAction.add) {
          final List<Appointment> collection =
              _generateCalendarAppointments(widget.dataSource, widget, data);
          final List<Appointment> visibleCollection = _getVisibleAppointments(
              _currentViewVisibleDates[0],
              _currentViewVisibleDates[_currentViewVisibleDates.length - 1],
              collection,
              widget.timeZone,
              widget.view == CalendarView.month ||
                  _isTimelineView(widget.view));

          for (int i = 0; i < collection.length; i++) {
            _appointments.add(collection[i]);
          }

          for (int i = 0; i < visibleCollection.length; i++) {
            visibleAppointmentCollection.add(visibleCollection[i]);
          }
        } else if (type == CalendarDataSourceAction.remove) {
          for (int i = 0; i < data.length; i++) {
            final Object appointment = data[i];
            for (int j = 0; j < _appointments.length; j++) {
              if (_appointments[j]._data == appointment) {
                _appointments.removeAt(j);
                j--;
              }
            }
          }

          for (int i = 0; i < data.length; i++) {
            final Object appointment = data[i];
            for (int j = 0; j < visibleAppointmentCollection.length; j++) {
              if (visibleAppointmentCollection[j]._data == appointment) {
                visibleAppointmentCollection.removeAt(j);
                j--;
              }
            }
          }
        }

        _visibleAppointments = visibleAppointmentCollection;

        _updateAllDayAppointment();
      });
    }
  }

  void _agendaSelectedDateListener() {
    if (widget.view != CalendarView.month ||
        !widget.monthViewSettings.showAgenda) {
      return;
    }

    setState(() {});
  }

  @override
  void didUpdateWidget(SfCalendar oldWidget) {
    if (oldWidget.initialSelectedDate != widget.initialSelectedDate) {
      _selectedDate = widget.initialSelectedDate;
      _agendaSelectedDate.value = widget.initialSelectedDate;
    }

    if (_agendaSelectedDate.value != _selectedDate) {
      _agendaSelectedDate.value = _selectedDate;
    }

    if (oldWidget.timeZone != widget.timeZone) {
      _updateVisibleAppointments();
    }

    if (oldWidget.view != widget.view ||
        widget.monthViewSettings.numberOfWeeksInView !=
            oldWidget.monthViewSettings.numberOfWeeksInView) {
      _currentDate = _updateCurrentDate(oldWidget);
    }

    if (oldWidget.dataSource != widget.dataSource) {
      _getAppointment();
    }

    if (oldWidget.initialDisplayDate != widget.initialDisplayDate &&
        widget.initialDisplayDate != null) {
      _currentDate =
          _getCurrentDate(_minDate, _maxDate, widget.initialDisplayDate);
    }

    if (widget.view == CalendarView.month &&
        widget.monthViewSettings.showAgenda &&
        _agendaScrollController == null) {
      _agendaScrollController =
          ScrollController(initialScrollOffset: 0, keepScrollOffset: true);
    }

    super.didUpdateWidget(oldWidget);
  }

  DateTime _updateCurrentDate(SfCalendar _oldWidget) {
    // condition added to updated the current visible date while switching the calendar views
    // if any date selected in the current view then, while switching the view the view move based the selected date
    // if no date selected and the current view has the today date, then switching the view will move based on the today date
    // if no date selected and today date doesn't falls in current view, then switching the view will move based the first day of current view
    if (_selectedDate != null &&
        _isWithInVisibleDateRange(_currentViewVisibleDates, _selectedDate)) {
      if (_oldWidget.view == CalendarView.month) {
        return DateTime(
            _selectedDate.year,
            _selectedDate.month,
            _selectedDate.day,
            widget.initialDisplayDate.hour,
            widget.initialDisplayDate.minute,
            widget.initialDisplayDate.second);
      } else {
        return _selectedDate;
      }
    } else if (_currentDate.month == DateTime.now().month &&
        _currentDate.year == DateTime.now().year) {
      return DateTime.now();
    } else {
      if (_oldWidget.view == CalendarView.month) {
        if (widget.monthViewSettings.numberOfWeeksInView > 0 &&
            widget.monthViewSettings.numberOfWeeksInView < 6) {
          return _currentViewVisibleDates[0];
        }
        return DateTime(
            _currentDate.year,
            _currentDate.month,
            1,
            widget.initialDisplayDate.hour,
            widget.initialDisplayDate.minute,
            widget.initialDisplayDate.second);
      } else {
        return _currentViewVisibleDates[0];
      }
    }
  }

  _AppointmentView _getAppointmentView(Appointment appointment) {
    _AppointmentView appointmentRenderer;
    for (int i = 0; i < _allDayAppointmentViewCollection.length; i++) {
      final _AppointmentView view = _allDayAppointmentViewCollection[i];
      if (view.appointment == null) {
        appointmentRenderer = view;
        break;
      }
    }

    if (appointmentRenderer == null) {
      appointmentRenderer = _AppointmentView();
      appointmentRenderer.appointment = appointment;
      _allDayAppointmentViewCollection.add(appointmentRenderer);
    }

    appointmentRenderer.appointment = appointment;
    appointmentRenderer.canReuse = false;
    return appointmentRenderer;
  }

  @override
  void didChangeDependencies() {
    _topPadding = MediaQuery.of(context).padding.top;
    // default width value will be device width when the widget placed inside a infinity width widget
    _minWidth = MediaQuery.of(context).size.width;
    // default height for the widget when the widget placed inside a infinity height widget
    _minHeight = 300;
    super.didChangeDependencies();
  }

  void _updateAllDayAppointment() {
    _allDayPanelHeight = 0;
    if (widget.view != CalendarView.month &&
        !_isTimelineView(widget.view) &&
        _currentViewVisibleDates.length <= 7) {
      _allDayAppointmentViewCollection =
          _allDayAppointmentViewCollection ?? <_AppointmentView>[];

      for (int i = 0; i < _allDayAppointmentViewCollection.length; i++) {
        final _AppointmentView obj = _allDayAppointmentViewCollection[i];
        obj.canReuse = true;
        obj.appointment = null;
        obj.startIndex = -1;
        obj.endIndex = -1;
        obj.position = -1;
        obj.maxPositions = -1;
      }

      if (_visibleAppointments == null || _visibleAppointments.isEmpty) {
        return;
      }

      final List<Appointment> allDayAppointments = <Appointment>[];
      for (Appointment apppointment in _visibleAppointments) {
        if (apppointment.isAllDay ||
            apppointment._actualEndTime
                    .difference(apppointment._actualStartTime)
                    .inDays >
                0) {
          allDayAppointments.add(apppointment);
        }
      }

      for (int i = 0; i < allDayAppointments.length; i++) {
        _AppointmentView _appointmentView;
        if (_allDayAppointmentViewCollection.length > i) {
          _appointmentView = _allDayAppointmentViewCollection[i];
        } else {
          _appointmentView = _AppointmentView();
          _allDayAppointmentViewCollection.add(_appointmentView);
        }

        _appointmentView.appointment = allDayAppointments[i];
        _appointmentView.canReuse = false;
      }

      for (_AppointmentView _appointmentView
          in _allDayAppointmentViewCollection) {
        if (_appointmentView.appointment == null) {
          continue;
        }

        final int startIndex = _getIndex(_currentViewVisibleDates,
            _appointmentView.appointment._actualStartTime);
        final int endIndex = _getIndex(_currentViewVisibleDates,
                _appointmentView.appointment._actualEndTime) +
            1;
        if (startIndex == -1 && endIndex == 0) {
          _appointmentView.appointment = null;
          continue;
        }

        _appointmentView.startIndex = startIndex;
        _appointmentView.endIndex = endIndex;
      }

      _allDayAppointmentViewCollection
          .sort((_AppointmentView app1, _AppointmentView app2) {
        if (app1.appointment != null && app2.appointment != null) {
          return (app2.endIndex - app2.startIndex) >
                  (app1.endIndex - app1.startIndex)
              ? 1
              : 0;
        }

        return 0;
      });

      _allDayAppointmentViewCollection
          .sort((_AppointmentView app1, _AppointmentView app2) {
        if (app1.appointment != null && app2.appointment != null) {
          return app1.startIndex.compareTo(app2.startIndex);
        }

        return 0;
      });

      final List<List<_AppointmentView>> _allDayAppointmentView =
          <List<_AppointmentView>>[];

      for (int i = 0; i < _currentViewVisibleDates.length; i++) {
        final List<_AppointmentView> intersectingAppointments =
            <_AppointmentView>[];
        for (int j = 0; j < _allDayAppointmentViewCollection.length; j++) {
          final _AppointmentView _currentView =
              _allDayAppointmentViewCollection[j];
          if (_currentView.appointment == null) {
            continue;
          }

          if (_currentView.startIndex <= i && _currentView.endIndex >= i + 1) {
            intersectingAppointments.add(_currentView);
          }
        }

        _allDayAppointmentView.add(intersectingAppointments);
      }

      for (int i = 0; i < _allDayAppointmentView.length; i++) {
        final List<_AppointmentView> intersectingAppointments =
            _allDayAppointmentView[i];
        for (int j = 0; j < intersectingAppointments.length; j++) {
          final _AppointmentView _currentView = intersectingAppointments[j];
          if (_currentView.position == -1) {
            _currentView.position = 0;
            for (int k = 0; k < j; k++) {
              final _AppointmentView _intersectView = _getAppointmentOnPosition(
                  _currentView, intersectingAppointments);
              if (_intersectView != null) {
                _currentView.position++;
              } else {
                break;
              }
            }
          }
        }

        if (intersectingAppointments.isNotEmpty) {
          final int maxPosition = intersectingAppointments
              .reduce((_AppointmentView currentAppview,
                      _AppointmentView nextAppview) =>
                  currentAppview.position > nextAppview.position
                      ? currentAppview
                      : nextAppview)
              .position;
          for (int j = 0; j < intersectingAppointments.length; j++) {
            intersectingAppointments[j].maxPositions = maxPosition + 1;
          }
        }
      }

      int maxPosition = 0;
      if (_allDayAppointmentViewCollection.isNotEmpty) {
        maxPosition = _allDayAppointmentViewCollection
            .reduce((_AppointmentView currentAppview,
                    _AppointmentView nextAppview) =>
                currentAppview.maxPositions > nextAppview.maxPositions
                    ? currentAppview
                    : nextAppview)
            .maxPositions;
      }

      if (maxPosition == -1) {
        maxPosition = 0;
      }

      _allDayPanelHeight = (maxPosition * _kAllDayAppointmentHeight).toDouble();
    }
  }

  // method to check and update the calendar width and height.
  double _updateHeight(double _height) {
    return _height -= widget.headerHeight + _topPadding;
  }

  @override
  Widget build(BuildContext context) {
    // SyncfusionLicense.validateLicense(context);
    double _top = 0, _width, _height;
    final bool _isDark = _isDarkTheme(context);
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      _minWidth = constraints.maxWidth == double.infinity
          ? _minWidth
          : constraints.maxWidth;
      _minHeight = constraints.maxHeight == double.infinity
          ? _minHeight
          : constraints.maxHeight;

      _width = _minWidth;
      _height = _minHeight;

      _height = _updateHeight(_height);
      _top = _topPadding + widget.headerHeight;
      double agendaHeight = widget.view == CalendarView.month &&
              widget.monthViewSettings.showAgenda
          ? widget.monthViewSettings.agendaViewHeight
          : 0;
      if (agendaHeight == null || agendaHeight == -1) {
        agendaHeight = (_height +
                widget.headerHeight +
                _getViewHeaderHeight(widget.viewHeaderHeight, widget.view)) /
            3;
      }

      return Container(
        width: _minWidth,
        height: _minHeight,
        color: widget.backgroundColor,
        child: _addChildren(_top, agendaHeight, _height, _width, _isDark),
      );
    });
  }

  Widget _addChildren(double _top, double agendaHeight, double _height,
      double _width, bool _isDark) {
    final DateTime _currentViewDate = _currentViewVisibleDates[
        (_currentViewVisibleDates.length / 2).truncate()];
    return Stack(children: <Widget>[
      Positioned(
        top: _topPadding,
        right: 0,
        left: 0,
        height: widget.headerHeight,
        child: GestureDetector(
          child: Container(
            color: widget.headerStyle.backgroundColor,
            child: CustomPaint(
              // Returns the header view  as a child for the calendar.
              painter: _HeaderViewPainter(
                  _currentViewVisibleDates,
                  widget.headerStyle,
                  _currentViewDate,
                  widget.view,
                  widget.monthViewSettings.numberOfWeeksInView,
                  _isDark),
            ),
          ),
          onTapUp: (TapUpDetails details) {
            _updateCalendarTapCallbackForHeader();
          },
        ),
      ),
      Positioned(
        top: _top,
        left: 0,
        right: 0,
        height: _height - agendaHeight,
        child: _CustomScrollView(
          widget,
          _width,
          _height - agendaHeight,
          _visibleAppointments,
          _agendaSelectedDate,
          updateCalendarState: (_UpdateCalendarStateDetails details) {
            _updateCalendarState(details);
          },
        ),
      ),
      _addAgendaView(
          agendaHeight, _top + _height - agendaHeight, _width, _isDark),
    ]);
  }

  dynamic _updateCalendarState(_UpdateCalendarStateDetails details) {
    if (details._currentDate != null) {
      _currentDate = details._currentDate;
    }
    details._currentDate = details._currentDate ?? _currentDate;

    if (details._currentViewVisibleDates != null &&
        _currentViewVisibleDates != details._currentViewVisibleDates) {
      _currentViewVisibleDates = details._currentViewVisibleDates;
      _updateVisibleAppointments();
      if (_shouldRaiseViewChangedCallback(widget.onViewChanged)) {
        _raiseViewChangedCallback(widget,
            visibleDates: _currentViewVisibleDates);
      }
    }

    if (details._selectedDate == null) {
      details._selectedDate = _selectedDate;
    } else if (details._selectedDate != _selectedDate) {
      _selectedDate = details._selectedDate;
    }

    if (details._allDayPanelHeight == null ||
        details._allDayPanelHeight != _allDayPanelHeight) {
      details._allDayPanelHeight = _allDayPanelHeight;
    }

    if (details._allDayAppointmentViewCollection == null ||
        details._allDayAppointmentViewCollection !=
            _allDayAppointmentViewCollection) {
      details._allDayAppointmentViewCollection =
          _allDayAppointmentViewCollection;
    }

    if (details._appointments == null ||
        details._appointments != _appointments) {
      details._appointments = _appointments;
    }
  }

  // method to update the calendar tapped call back for the header view
  void _updateCalendarTapCallbackForHeader() {
    if (!_shouldRaiseCalendarTapCallback(widget.onTap)) {
      return;
    }

    DateTime selectedDate;
    if (widget.view == CalendarView.month) {
      selectedDate =
          DateTime(_currentDate.year, _currentDate.month, 01, 0, 0, 0);
    } else {
      selectedDate = DateTime(
          _currentViewVisibleDates[0].year,
          _currentViewVisibleDates[0].month,
          _currentViewVisibleDates[0].day,
          0,
          0,
          0);
    }

    _raiseCalendarTapCallback(widget,
        date: selectedDate, element: CalendarElement.header);
  }

  // method to update the calendar tapped call back for the agenda view
  void _updateCalendarTapCallbackForAgendaView(TapUpDetails details) {
    if (!_shouldRaiseCalendarTapCallback(widget.onTap)) {
      return;
    }

    List<Appointment> _agendaAppointments;
    if (_selectedDate != null) {
      _agendaAppointments = _getSelectedDateAppointments(
          _appointments, widget.timeZone, _selectedDate);

      final double dateTimeWidth = _minWidth * 0.15;
      if (details.localPosition.dx > dateTimeWidth &&
          _agendaAppointments != null &&
          _agendaAppointments.isNotEmpty) {
        _agendaAppointments.sort((dynamic app1, dynamic app2) =>
            app1._actualStartTime.compareTo(app2._actualStartTime));
        _agendaAppointments.sort((dynamic app1, dynamic app2) =>
            _orderAppointmentsAscending(app1.isAllDay, app2.isAllDay));

        int index = -1;

        const double padding = 5;
        double xPosition = 0;
        final double tappedYPosition =
            _agendaScrollController.offset + details.localPosition.dy;
        for (int i = 0; i < _agendaAppointments.length; i++) {
          final Appointment _appointment = _agendaAppointments[i];
          final double appointmentHeight = _appointment.isAllDay
              ? widget.monthViewSettings.agendaItemHeight / 2
              : widget.monthViewSettings.agendaItemHeight;
          if (tappedYPosition >= xPosition &&
              tappedYPosition < xPosition + appointmentHeight + padding) {
            index = i;
            break;
          }

          xPosition += appointmentHeight + padding;
        }

        if (index > _agendaAppointments.length || index == -1) {
          _agendaAppointments = null;
        } else {
          _agendaAppointments = <Appointment>[_agendaAppointments[index]];
        }
      } else {
        _agendaAppointments = null;
      }
    }

    List<Object> _selectedAppointments = <Object>[];
    if (_agendaAppointments != null && _agendaAppointments.isNotEmpty) {
      for (int i = 0; i < _agendaAppointments.length; i++) {
        _selectedAppointments.add(_agendaAppointments[i]);
      }
    }

    if (widget.dataSource != null &&
        !_isCalendarAppointment(widget.dataSource.appointments)) {
      _selectedAppointments = _getCustomAppointments(_agendaAppointments);
    }

    _raiseCalendarTapCallback(widget,
        date: _selectedDate,
        appointments: _selectedAppointments,
        element: CalendarElement.agenda);
  }

  // Returns the agenda view  as a child for the calendar.
  Widget _addAgendaView(
      double height, double startPosition, double _width, bool _isDark) {
    if (widget.view != CalendarView.month ||
        !widget.monthViewSettings.showAgenda) {
      return Positioned(
        left: 0,
        right: 0,
        top: 0,
        bottom: 0,
        child: Container(),
      );
    }

    List<Appointment> _agendaAppointments;
    if (_selectedDate != null) {
      _agendaAppointments = _getSelectedDateAppointments(
          _appointments, widget.timeZone, _selectedDate);
    }

    const double topPadding = 5;
    const double bottomPadding = 5;
    final double appointmentHeight = widget.monthViewSettings.agendaItemHeight;
    double painterHeight = height;
    if (_agendaAppointments != null && _agendaAppointments.isNotEmpty) {
      int count = 0;
      for (int i = 0; i < _agendaAppointments.length; i++) {
        if (_agendaAppointments[i].isAllDay) {
          count++;
        }
      }

      painterHeight = (((count * ((appointmentHeight / 2) + topPadding)) +
                  ((_agendaAppointments.length - count) *
                      (appointmentHeight + topPadding)))
              .toDouble()) +
          bottomPadding;
    }

    double dateTimeWidth = _width * 0.15;
    if (_selectedDate == null) {
      dateTimeWidth = 0;
    }

    return Positioned(
        top: startPosition,
        right: 0,
        left: 0,
        height: height,
        child: Container(
            color: widget.monthViewSettings.agendaStyle.backgroundColor,
            child: GestureDetector(
                child: Stack(
                  children: <Widget>[
                    CustomPaint(
                      painter: _AgendaDateTimePainter(
                          _selectedDate,
                          widget.monthViewSettings,
                          _isDark,
                          widget.todayHighlightColor),
                      size: Size(dateTimeWidth, height),
                    ),
                    Positioned(
                      top: 0,
                      left: dateTimeWidth,
                      right: 0,
                      bottom: 0,
                      child: ListView(
                        padding: const EdgeInsets.all(0.0),
                        controller: _agendaScrollController,
                        children: <Widget>[
                          CustomPaint(
                            painter: _AgendaViewPainter(
                                widget.monthViewSettings,
                                _selectedDate,
                                widget.timeZone,
                                _appointments),
                            size: Size(_width - dateTimeWidth, painterHeight),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                onTapUp: (TapUpDetails details) {
                  _updateCalendarTapCallbackForAgendaView(details);
                })));
  }
}

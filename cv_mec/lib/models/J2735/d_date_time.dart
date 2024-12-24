import 'dart:ffi';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/j2735/d_day.dart';
import 'package:cv_mec/models/j2735/d_hour.dart';
import 'package:cv_mec/models/j2735/d_minute.dart';
import 'package:cv_mec/models/j2735/d_month.dart';
import 'package:cv_mec/models/j2735/d_offset.dart';
import 'package:cv_mec/models/j2735/d_second.dart';
import 'package:cv_mec/models/j2735/d_year.dart';

class DDateTime {
  DYear? year;
  DMonth? month;
  DDay? day;
  DHour? hour;
  DMinute? minute;
  DSecond? second;
  DOffset? offset;

  DDateTime.fromC(C.DDateTime c_dDateTime) {
    if (c_dDateTime.year.address != 0) {
      year = DYear(c_dDateTime.year.value);
    }

    if (c_dDateTime.month.address != 0) {
      month = DMonth(c_dDateTime.month.value);
    }

    if (c_dDateTime.day.address != 0) {
      day = DDay(c_dDateTime.day.value);
    }

    if (c_dDateTime.hour.address != 0) {
      hour = DHour(c_dDateTime.hour.value);
    }

    if (c_dDateTime.minute.address != 0) {
      minute = DMinute(c_dDateTime.minute.value);
    }

    if (c_dDateTime.second.address != 0) {
      second = DSecond(c_dDateTime.second.value);
    }

    if (c_dDateTime.offset.address != 0) {
      offset = DOffset(c_dDateTime.offset.value);
    }
  }
}

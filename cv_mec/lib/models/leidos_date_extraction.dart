import 'package:cv_mec/models/j2735/descriptive_name.dart';
import 'package:cv_mec/models/j2735/map_data.dart';
import 'package:cv_mec/models/j2735/traveler_information.dart';

class LeidosDateExtraction {
  static DateTime? extractDateFromTim(TravelerInformation tim) {
    if (tim.dataFrames.travelerDataFrameList.isNotEmpty) {
      if (tim.dataFrames.travelerDataFrameList.first.regions.isNotEmpty) {
        DescriptiveName? name =
            tim.dataFrames.travelerDataFrameList.first.regions.first.name;
        if (name != null) {
          int? ms = int.tryParse(name.descriptiveName);
          if (ms != null) {
            return DateTime.fromMillisecondsSinceEpoch(ms);
          }
        }
      }
    }
    return null;
  }

  static DateTime? extractDateFromMap(MapData map) {
    if (map.intersections != null &&
        map.intersections!.intersectionGeometryList.isNotEmpty) {
      DescriptiveName? name =
          map.intersections!.intersectionGeometryList.first.name;
      if (name != null) {
        int? ms = int.tryParse(name.descriptiveName);
        if (ms != null) {
          return DateTime.fromMillisecondsSinceEpoch(ms);
        }
      }
    }
    return null;
  }
}

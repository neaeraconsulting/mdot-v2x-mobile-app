import 'package:cv_mec/models/GeometryDirection.dart';
import 'package:cv_mec/models/J2735/TravelerDataFrame.dart';

class DataFrameGeometry{
  late List<GeometryDirection> geometry;
  late TravelerDataFrame frame;
  bool active = false;
  bool shown = false;
  

  DataFrameGeometry(this.frame, this.geometry);
}
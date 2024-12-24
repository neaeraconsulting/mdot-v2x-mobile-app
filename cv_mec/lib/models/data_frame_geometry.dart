import 'package:cv_mec/models/geometry_direction.dart';
import 'package:cv_mec/models/j2735/traveler_data_frame.dart';

class DataFrameGeometry {
  late List<GeometryDirection> geometry;
  late TravelerDataFrame frame;
  bool active = false;
  bool shown = false;

  DataFrameGeometry(this.frame, this.geometry);
}

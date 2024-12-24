import 'package:cv_mec/models/protobuf_models/geo_routed_msg.pb.dart'
    as protobuf;
import 'package:fixnum/src/int64.dart';

class Utils {
  static protobuf.Timestamp dateTimeToTimestamp(DateTime dateTime) {
    protobuf.Timestamp time = protobuf.Timestamp();
    time.seconds = Int64(dateTime.millisecondsSinceEpoch ~/ 1000);
    time.nanos =
        (dateTime.millisecond * 1E6 + dateTime.microsecond * 1000).toInt();
    return time;
  }

  static DateTime timeStampToDateTime(protobuf.Timestamp timeStamp) {
    DateTime dt = DateTime.fromMicrosecondsSinceEpoch(
        (timeStamp.seconds.toInt() * 1E6).toInt() + timeStamp.nanos ~/ 1000);
    return dt;
  }
}

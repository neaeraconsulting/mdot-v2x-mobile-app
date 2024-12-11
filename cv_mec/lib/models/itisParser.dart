import 'dart:core';

import 'package:cv_mec/models/J2735/Choice_Content.dart';
import 'package:cv_mec/models/J2735/ExitService.dart';
import 'package:cv_mec/models/J2735/GenericSignage.dart';
import 'package:cv_mec/models/J2735/ITISPhrase.dart';
import 'package:cv_mec/models/J2735/ITIS_ITIScodesAndText.dart';
import 'package:cv_mec/models/J2735/ITIScodes.dart';
import 'package:cv_mec/models/J2735/SpeedLimit.dart';
import 'package:cv_mec/models/J2735/TravelerDataFrame.dart';
import 'package:cv_mec/models/J2735/WorkZone.dart';
import 'package:cv_mec/models/itisCode.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

import 'J2735/ITIStext.dart';

class ItisParser {
  final int SPEED_LIMIT = 268;
  final int ACCIDENT = 513;
  final int INCIDENT = 531;
  final int HAZARDOUS_MATERIAL_SPILL = 550;
  final int CLOSED = 770;
  final int LEFT_LANE_CLOSED_AHEAD = 771;
  final int CLOSED_FOR_THE_SEASON = 774;
  final int REDUCED_TO_ONE_LANE = 777;
  final int AVALANCHE_CONTROL_ACTIVITIES = 1042;
  final int ROAD_CONSTRUCTION = 1025;
  final int HERD_OF_ANIMALS_ON_ROADWAY = 1292;
  final int ROCKFALL = 1309;
  final int LANDSLIDE = 1310;
  final int DELAYS = 1537;
  final int WIDE_LOAD = 2050;
  final int NO_TRAILERS = 2568;
  final int WIDTH_LIMIT = 2573;
  final int HEIGHT_LIMIT = 2574;
  final int WILDFIRE = 3084;
  final int WEATHER_EMERGENCY = 3201;
  final int MAJOR_EVENT = 3841;
  final int NO_PARKING_SPACES_AVAILABLE = 4103;
  final int ONLY_A_FEW_PARKING_SPACES_AVAILABLE = 4104;
  final int SPACES_AVAILABLE = 4105;
  final int NO_PARKING_INFORMATION_AVAILABLE = 4223;
  final int SEVERE_WEATHER = 4865;
  final int SNOW = 4868;
  final int WINTER_STORM = 4871;
  final int RAIN = 4885;
  final int STRONG_WINDS = 5127;
  final int FOG = 5378;
  final int VISIBILITY_REDUCED = 5383;
  final int BLOWING_SNOW = 5385;
  final int BLACK_ICE = 5908;
  final int WET_PAVEMENT = 5895;
  final int ICE = 5906;
  final int ICY_PATCHES = 5907;
  final int SNOW_DRIFTS = 5927;
  final int GRAVEL_ROAD_SURFACE = 5933;
  final int DRY_PAVEMENT = 6011;
  final int DIRT_ROAD_SURFACE = 6016;
  final int MILLED_ROAD_SURFACE = 6017;
  final int SNOW_TIRES_OR_CHAINS_REQUIRED = 6156;
  final int LOOK_OUT_FOR_WORKERS = 6952;
  final int KEEP_TO_RIGHT = 7525;
  final int KEEP_TO_LEFT = 7426;
  final int REDUCE_YOUR_SPEED = 7443;
  final int DRIVE_CAREFULLY = 7169;
  final int DRIVE_WITH_EXTREME_CAUTION = 7170;
  final int INCREASE_NORMAL_FOLLOWING_DISTANCE = 7173;
  final int PREPARE_TO_STOP = 7186;
  final int STOP_AT_NEXT_SAFE_PLACE = 7188;
  final int ONLY_TRAVEL_IF_ABSOLUTELY_NECESSARY = 7189;
  final int RIGHT_LANE_CLOSED_AHEAD = 8196;
  final int PEDESTRIAN = 9486;
  final int FALLING_ROCKS = 12037;
  final int MAX_ITIS_SMALL_NUMBER = 12799;
  final int MIN_ITIS_SMALL_NUMBER = 12545;
  final int CROSSING = 13585;

  final String imageDirectory = "assets/images/ITIS";

  // Font Packs are Bitmap versions of .ttf fonts. They can be converted here: https://ttf2fnt.com/
  final String font_80_path = "assets/fonts/HighwayGothic_80.zip";
  final String font_72_path = "assets/fonts/HighwayGothic_72.zip";
  final String font_48_path = "assets/fonts/HighwayGothic_48.zip";
  final String font_40_path = "assets/fonts/HighwayGothic_40.zip";

  late final Map<int, ItisCode> BASIC_ADVISORY_CODE_MAP;
  late final Map<int, ItisCode> BASIC_WORK_ZONE_CODE_MAP;
  late final Map<int, ItisCode> BASIC_GENERIC_SIGNAGE_CODE_MAP;
  late final Map<int, ItisCode> BASIC_SPEED_LIMIT_CODE_MAP;
  late final Map<int, ItisCode> BASIC_EXIT_SERVICE_CODE_MAP;

  late final Map<int, ItisCode> speedAdvisoryMap;
  late final Map<int, ItisCode> speedAheadMap;
  late final Map<int, ItisCode> speedMap;

  ItisParser() {
    BASIC_ADVISORY_CODE_MAP = {
      ACCIDENT: ItisCode.withImage(
          ACCIDENT, "Accident", AssetImage("$imageDirectory/$ACCIDENT.png")),
      INCIDENT: ItisCode.withImage(
          INCIDENT, "Incident", AssetImage("$imageDirectory/$INCIDENT.png")),
      HAZARDOUS_MATERIAL_SPILL: ItisCode.withImage(
          HAZARDOUS_MATERIAL_SPILL,
          "Hazardous Material Spill",
          AssetImage("$imageDirectory/$HAZARDOUS_MATERIAL_SPILL.png")),
      CLOSED: ItisCode.withImage(
          CLOSED, "Closed", AssetImage("$imageDirectory/$CLOSED.png")),
      CLOSED_FOR_THE_SEASON: ItisCode.withImage(
          CLOSED_FOR_THE_SEASON,
          "Closed for the Season",
          AssetImage("$imageDirectory/$CLOSED_FOR_THE_SEASON.png")),
      AVALANCHE_CONTROL_ACTIVITIES: ItisCode.withImage(
          AVALANCHE_CONTROL_ACTIVITIES,
          "Avalanche Control Activities",
          AssetImage("$imageDirectory/$AVALANCHE_CONTROL_ACTIVITIES.png")),
      ACCIDENT: ItisCode.withImage(
          ACCIDENT, "Accident", AssetImage("$imageDirectory/$ACCIDENT.png")),
      HERD_OF_ANIMALS_ON_ROADWAY: ItisCode.withImage(
          HERD_OF_ANIMALS_ON_ROADWAY,
          "Herd of Animals on Roadway",
          AssetImage("$imageDirectory/$HERD_OF_ANIMALS_ON_ROADWAY.png")),
      ROCKFALL: ItisCode(ROCKFALL, "Rock Fall"),
      LANDSLIDE: ItisCode.withImage(
          LANDSLIDE, "Landslide", AssetImage("$imageDirectory/$LANDSLIDE.png")),
      WIDE_LOAD: ItisCode.withImage(
          WIDE_LOAD, "Wide Load", AssetImage("$imageDirectory/$WIDE_LOAD.png")),
      NO_TRAILERS: ItisCode.withImage(NO_TRAILERS, "Wide Load",
          AssetImage("$imageDirectory/$NO_TRAILERS.png")),
      WILDFIRE: ItisCode.withImage(
          WILDFIRE, "Wild Fire", AssetImage("$imageDirectory/$WILDFIRE.png")),
      WEATHER_EMERGENCY: ItisCode.withImage(WEATHER_EMERGENCY, "Wild Fire",
          AssetImage("$imageDirectory/$WEATHER_EMERGENCY.png")),
      MAJOR_EVENT: ItisCode.withImage(MAJOR_EVENT, "Major Event",
          AssetImage("$imageDirectory/$MAJOR_EVENT.png")),
      SEVERE_WEATHER: ItisCode.withImage(SEVERE_WEATHER, "Severe Weather",
          AssetImage("$imageDirectory/$SEVERE_WEATHER.png")),
      SNOW: ItisCode.withImage(
          SNOW, "Snow", AssetImage("$imageDirectory/$SNOW.png")),
      WINTER_STORM: ItisCode.withImage(WINTER_STORM, "Winter Storm",
          AssetImage("$imageDirectory/$WINTER_STORM.png")),
      RAIN: ItisCode.withImage(
          RAIN, "Rain", AssetImage("$imageDirectory/$RAIN.png")),
      STRONG_WINDS: ItisCode.withImage(STRONG_WINDS, "Strong Winds",
          AssetImage("$imageDirectory/$STRONG_WINDS.png")),
      FOG: ItisCode.withImage(
          FOG, "Fog", AssetImage("$imageDirectory/$FOG.png")),
      VISIBILITY_REDUCED: ItisCode.withImage(
          VISIBILITY_REDUCED,
          "Visibility Reduced",
          AssetImage("$imageDirectory/$VISIBILITY_REDUCED.png")),
      BLOWING_SNOW: ItisCode.withImage(BLOWING_SNOW, "Rain",
          AssetImage("$imageDirectory/$BLOWING_SNOW.png")),
      BLACK_ICE: ItisCode.withImage(
          BLACK_ICE, "Black Ice", AssetImage("$imageDirectory/$BLACK_ICE.png")),
      WET_PAVEMENT: ItisCode.withImage(WET_PAVEMENT, "Wet Pavement",
          AssetImage("$imageDirectory/$WET_PAVEMENT.png")),
      ICE: ItisCode.withImage(
          ICE, "Ice", AssetImage("$imageDirectory/$ICE.png")),
      ICY_PATCHES: ItisCode.withImage(ICY_PATCHES, "Icy Patches",
          AssetImage("$imageDirectory/$ICY_PATCHES.png")),
      SNOW_DRIFTS: ItisCode.withImage(SNOW_DRIFTS, "Snow Drifts",
          AssetImage("$imageDirectory/$SNOW_DRIFTS.png")),
      DRY_PAVEMENT: ItisCode.withImage(DRY_PAVEMENT, "Dry Pavement",
          AssetImage("$imageDirectory/$DRY_PAVEMENT.png")),
      DIRT_ROAD_SURFACE: ItisCode.withImage(
          DIRT_ROAD_SURFACE,
          "Dirt Road Surface",
          AssetImage("$imageDirectory/$DIRT_ROAD_SURFACE.png")),
      MILLED_ROAD_SURFACE: ItisCode.withImage(
          MILLED_ROAD_SURFACE,
          "Milled Road Surface",
          AssetImage("$imageDirectory/$MILLED_ROAD_SURFACE.png")),
      SNOW_TIRES_OR_CHAINS_REQUIRED: ItisCode.withImage(
          SNOW_TIRES_OR_CHAINS_REQUIRED,
          "Snow Tires or Chaines Required",
          AssetImage("$imageDirectory/$SNOW_TIRES_OR_CHAINS_REQUIRED.png")),
      ICY_PATCHES: ItisCode.withImage(ICY_PATCHES, "Icy Patches",
          AssetImage("$imageDirectory/$ICY_PATCHES.png")),
      DRIVE_CAREFULLY: ItisCode.withImage(DRIVE_CAREFULLY, "Drive Carefully",
          AssetImage("$imageDirectory/$DRIVE_CAREFULLY.png")),
      DRIVE_WITH_EXTREME_CAUTION: ItisCode.withImage(
          DRIVE_WITH_EXTREME_CAUTION,
          "Drive with Extreme Caution",
          AssetImage("$imageDirectory/$DRIVE_WITH_EXTREME_CAUTION.png")),
      INCREASE_NORMAL_FOLLOWING_DISTANCE: ItisCode.withImage(
          INCREASE_NORMAL_FOLLOWING_DISTANCE,
          "Increase Normal Following Distance",
          AssetImage(
              "$imageDirectory/$INCREASE_NORMAL_FOLLOWING_DISTANCE.png")),
      PREPARE_TO_STOP: ItisCode.withImage(PREPARE_TO_STOP, "Prepare to Stop",
          AssetImage("$imageDirectory/$PREPARE_TO_STOP.png")),
      STOP_AT_NEXT_SAFE_PLACE: ItisCode.withImage(
          STOP_AT_NEXT_SAFE_PLACE,
          "Stop at Next Safe Place",
          AssetImage("$imageDirectory/$STOP_AT_NEXT_SAFE_PLACE.png")),
      ONLY_TRAVEL_IF_ABSOLUTELY_NECESSARY: ItisCode.withImage(
          ONLY_TRAVEL_IF_ABSOLUTELY_NECESSARY,
          "Only travel if absolutely necessary",
          AssetImage(
              "$imageDirectory/$ONLY_TRAVEL_IF_ABSOLUTELY_NECESSARY.png")),
      FALLING_ROCKS: ItisCode.withImage(FALLING_ROCKS, "Falling Rocks",
          AssetImage("$imageDirectory/$FALLING_ROCKS.png")),
    };

    BASIC_WORK_ZONE_CODE_MAP = {
      REDUCED_TO_ONE_LANE: ItisCode.withImage(
          RIGHT_LANE_CLOSED_AHEAD,
          "Reduce to one Lane",
          AssetImage("$imageDirectory/$RIGHT_LANE_CLOSED_AHEAD.png")),
      ROAD_CONSTRUCTION: ItisCode.withImage(
          ROAD_CONSTRUCTION,
          "Road Construction",
          AssetImage("$imageDirectory/$ROAD_CONSTRUCTION.png")),
      GRAVEL_ROAD_SURFACE: ItisCode(GRAVEL_ROAD_SURFACE, "Gravel Road Surface"),
      LOOK_OUT_FOR_WORKERS:
          ItisCode(LOOK_OUT_FOR_WORKERS, "Look Out for Workers"),
      KEEP_TO_RIGHT: ItisCode.withImage(KEEP_TO_RIGHT, "Keep to Right",
          AssetImage("$imageDirectory/$KEEP_TO_RIGHT.png")),
      KEEP_TO_LEFT: ItisCode.withImage(KEEP_TO_LEFT, "Keep to Left",
          AssetImage("$imageDirectory/$KEEP_TO_LEFT.png")),
    };

    BASIC_GENERIC_SIGNAGE_CODE_MAP = {};

    BASIC_SPEED_LIMIT_CODE_MAP = {};

    BASIC_EXIT_SERVICE_CODE_MAP = {};

    speedAheadMap = {};
    speedAdvisoryMap = {};
    speedMap = {};
  }

  Future<ItisCode> getItisRepresentation(TravelerDataFrame frame) async {
    Choice_Content content = frame.content;
    if (content is WorkZone) {
      // Work Zone
      return parseItisAlertFromWorkZone(content);
    } else if (content is ExitService) {
      // Exit Service
      return parseItisAlertFromExitService(content);
    } else if (content is GenericSignage) {
      // Generic Signage
      return parseItisAlertFromGenericSignage(content);
    } else if (content is SpeedLimit) {
      // Speed Limit
      return parseItisAlertFromSpeedLimit(content);
    } else if (content is ITIS_ITIScodesAndText) {
      // Advisory
      return parseItisCodeFromITISCodesAndText(content);
    } else {
      return ItisCode.error(
          "Traveler Information Frame Content is not a Known Type");
    }
  }

  Future<ItisCode> parseItisCodeFromITISCodesAndText(
      ITIS_ITIScodesAndText itis) async {
    if (itis.item.isNotEmpty) {
      if (itis.item.first is ITIScodes) {
        int code = (itis.item.first as ITIScodes).itisCode;
        if (BASIC_ADVISORY_CODE_MAP.containsKey(code)) {
          return BASIC_ADVISORY_CODE_MAP[code]!;
        } else if (itis.item.length >= 2 &&
            (itis.item[0] as ITIScodes).itisCode == PEDESTRIAN &&
            (itis.item[1] as ITIScodes).itisCode == CROSSING) {
          return ItisCode.withImage(PEDESTRIAN, "Pedestrian Crossing",
              AssetImage("$imageDirectory/pedcrossing.png"));
        } else if (code == SPEED_LIMIT) {
          if (itis.item.length == 3) {
            // Basic Speed Limit
            int speed = getSpeedFromItis((itis.item[1] as ITIScodes).itisCode);
            if (speed != -1) {
              if (speedAdvisoryMap.containsKey(speed)) {
                return speedAdvisoryMap[speed]!;
              }

              ImageProvider? image = await getSpeedAdvisoryImage(speed);
              if (image != null) {
                ItisCode code =
                    ItisCode.withImage(SPEED_LIMIT, "Speed Limit", image);
                speedAdvisoryMap[speed] = code;
                return code;
              } else {
                return ItisCode(SPEED_LIMIT, "Speed Limit");
              }
            } else {
              return ItisCode.error(
                  "Received Itis Code 268 (Speed Limit), but included Speed is not a valid Speed");
            }
          } else {
            return ItisCode.error(
                "Received ITIS Code 268 (Speed Limit), but missing additional required arguments");
          }
        } else {
          return ItisCode.unknown(code);
        }
      } else if ((itis.item[0] as ITIStext).itisText.toString() ==
          "$PEDESTRIAN, $CROSSING") {
        return ItisCode.withImage(
            PEDESTRIAN,
            "Pedestrian Crossing",
            AssetImage(
                "$imageDirectory/pedcrossing.png")); //AssetImage("$imageDirectory/pedcrossing.png")
      } else if (itis.item.first is ITIStext) {
        return ItisCode(-1, (itis.item.first as ITIStext).itisText);
      } else {
        return ItisCode.error(
            "Received Advisory Tim Message with unknown Item type");
      }
    } else {
      return ItisCode.error("TIM message has no ITIS Codes");
    }
  }

  Future<ItisCode> parseItisAlertFromWorkZone(WorkZone wz) async {
    if (wz.item.isNotEmpty) {
      if (wz.item.first is ITIScodes) {
        int code = (wz.item.first as ITIScodes).itisCode;
        if (BASIC_WORK_ZONE_CODE_MAP.containsKey(code)) {
          return BASIC_WORK_ZONE_CODE_MAP[code]!;
        } else {
          if (code == 8196) {
            if (wz.item.length > 1 && wz.item[1] is ITIScodes) {
              if ((wz.item[1] as ITIScodes).itisCode == 771) {
                return ItisCode.withImage(771, "Right Lane Closed Ahead",
                    AssetImage("$imageDirectory/$RIGHT_LANE_CLOSED_AHEAD.png"));
              }
            }
          } else if (code == 8195) {
            if (wz.item.length > 1 && wz.item[1] is ITIScodes) {
              if ((wz.item[1] as ITIScodes).itisCode == 771) {
                return ItisCode.withImage(771, "Left Lane Closed Ahead",
                    AssetImage("$imageDirectory/$LEFT_LANE_CLOSED_AHEAD.png"));
              }
            }
          }

          return ItisCode.unknown(code);
        }
      } else if (wz.item is ITISPhrase) {
        return ItisCode(-1, (wz.item.first as ITIStext).itisText);
      } else {
        return ItisCode.error(
            "Received Advisory Tim Message with unknown Item type");
      }
    } else {
      return ItisCode.error("TIM message has no ITIS Codes");
    }
  }

  Future<ItisCode> parseItisAlertFromSpeedLimit(SpeedLimit sl) async {
    if (sl.item.isNotEmpty) {
      if (sl.item.first is ITIScodes) {
        int code = (sl.item.first as ITIScodes).itisCode;
        if (BASIC_SPEED_LIMIT_CODE_MAP.containsKey(code)) {
          return BASIC_SPEED_LIMIT_CODE_MAP[code]!;
        } else if (code == SPEED_LIMIT) {
          if (sl.item.length == 3) {
            // Basic Speed Limit
            int speed = getSpeedFromItis((sl.item[1] as ITIScodes).itisCode);
            if (speed != -1) {
              if (speedMap.containsKey(speed)) {
                return speedMap[speed]!;
              }

              ImageProvider? image = await getSpeedImage(speed);
              if (image != null) {
                ItisCode code =
                    ItisCode.withImage(SPEED_LIMIT, "Speed Limit", image);
                speedMap[speed] = code;
                return code;
              } else {
                return ItisCode(SPEED_LIMIT, "Speed Limit");
              }
            } else {
              return ItisCode.error(
                  "Received Itis Code 268 (Speed Limit), but included Speed is not a valid Speed");
            }
          } else if (sl.item.length == 5) {
            // Reduce Speed Ahead

            int speed = getSpeedFromItis((sl.item[2] as ITIScodes).itisCode);

            if (speedAheadMap.containsKey(speed)) {
              return speedAheadMap[speed]!;
            }

            ImageProvider? image = await getSpeedAheadImage(speed);
            if (image != null) {
              ItisCode code =
                  ItisCode.withImage(SPEED_LIMIT, "Reduce Speed Ahead", image);
              speedAheadMap[speed] = code;
              return code;
            } else {
              return ItisCode(SPEED_LIMIT, "Reduce Speed Ahead");
            }
          } else {
            return ItisCode.error(
                "Received ITIS Code 268 (Speed Limit), but missing additional required arguments");
          }
        } else {
          return ItisCode.unknown(code);
        }
      } else if (sl.item is ITISPhrase) {
        return ItisCode(-1, (sl.item.first as ITIStext).itisText);
      } else {
        return ItisCode.error(
            "Received Advisory Tim Message with unknown Item type");
      }
    } else {
      return ItisCode.error("TIM message has no ITIS Codes");
    }
  }

  Future<ItisCode> parseItisAlertFromGenericSignage(GenericSignage gs) async {
    if (gs.item.isNotEmpty) {
      if (gs.item.first is ITIScodes) {
        int code = (gs.item.first as ITIScodes).itisCode;
        if (BASIC_GENERIC_SIGNAGE_CODE_MAP.containsKey(code)) {
          return BASIC_GENERIC_SIGNAGE_CODE_MAP[code]!;
        } else {
          return ItisCode.unknown(code);
        }
      } else if (gs.item is ITISPhrase) {
        return ItisCode(-1, (gs.item.first as ITIStext).itisText);
      } else {
        return ItisCode.error(
            "Received Advisory Tim Message with unknown Item type");
      }
    } else {
      return ItisCode.error("TIM message has no ITIS Codes");
    }
  }

  Future<ItisCode> parseItisAlertFromExitService(ExitService es) async {
    if (es.item.isNotEmpty) {
      if (es.item.first is ITIScodes) {
        int code = (es.item.first as ITIScodes).itisCode;
        if (BASIC_EXIT_SERVICE_CODE_MAP.containsKey(code)) {
          return BASIC_EXIT_SERVICE_CODE_MAP[code]!;
        } else {
          return ItisCode.unknown(code);
        }
      } else if (es.item is ITISPhrase) {
        return ItisCode(-1, (es.item.first as ITIStext).itisText);
      } else {
        return ItisCode.error(
            "Received Advisory Tim Message with unknown Item type");
      }
    } else {
      return ItisCode.error("TIM message has no ITIS Codes");
    }
  }

  int getSpeedFromItis(int itis) {
    int speed = itis - MIN_ITIS_SMALL_NUMBER + 1;
    if (speed >= 0 && speed <= 255) {
      return speed;
    }
    return -1;
  }

  Future<ImageProvider?> getSpeedImage(int speedLimit) async {
    final ByteData assetImageByteData =
        await rootBundle.load('$imageDirectory/$SPEED_LIMIT.png');
    String assetPath = font_80_path;
    if (speedLimit >= 100) {
      assetPath = font_48_path;
    }
    final ByteData assetFontByteData = await rootBundle.load(assetPath);
    final font = img.readFontZip(assetFontByteData.buffer.asUint8List());
    img.Image? baseSizeImage =
        img.decodeImage(assetImageByteData.buffer.asUint8List());
    if (baseSizeImage != null) {
      img.drawString(baseSizeImage, "$speedLimit",
          font: font, color: img.ColorRgb8(0, 0, 0), y: 120);
      return MemoryImage(img.encodePng(baseSizeImage));
    }
    return null;
  }

  Future<ImageProvider?> getSpeedAheadImage(int speedLimit) async {
    final ByteData assetImageByteData =
        await rootBundle.load('$imageDirectory/$REDUCE_YOUR_SPEED.png');
    String assetPath = font_72_path;
    int yOffset = 200;
    if (speedLimit >= 100) {
      yOffset = 220;
      assetPath = font_40_path;
    }

    final ByteData assetFontByteData = await rootBundle.load(assetPath);
    final font = img.readFontZip(assetFontByteData.buffer.asUint8List());
    img.Image? baseSizeImage =
        img.decodeImage(assetImageByteData.buffer.asUint8List());
    if (baseSizeImage != null) {
      img.drawString(baseSizeImage, "$speedLimit",
          font: font, color: img.ColorRgb8(0, 0, 0), y: yOffset);
      return MemoryImage(img.encodePng(baseSizeImage));
    }
    return null;
  }

  Future<ImageProvider?> getSpeedAdvisoryImage(int speedLimit) async {
    final ByteData assetImageByteData =
        await rootBundle.load('$imageDirectory/268_Advisory.png');
    String assetPath = font_80_path;

    if (speedLimit >= 100) {
      assetPath = font_48_path;
    }
    final ByteData assetFontByteData = await rootBundle.load(assetPath);
    final font = img.readFontZip(assetFontByteData.buffer.asUint8List());
    img.Image? baseSizeImage =
        img.decodeImage(assetImageByteData.buffer.asUint8List());
    if (baseSizeImage != null) {
      img.drawString(baseSizeImage, "$speedLimit",
          font: font, color: img.ColorRgba8(0, 0, 0, 200), y: 30);
      return MemoryImage(img.encodePng(baseSizeImage));
    }
    return null;
  }
}

//
//  Generated code. Do not modify.
//  source: geoRoutedMsg.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use timestampDescriptor instead')
const Timestamp$json = {
  '1': 'Timestamp',
  '2': [
    {'1': 'seconds', '3': 1, '4': 1, '5': 3, '10': 'seconds'},
    {'1': 'nanos', '3': 2, '4': 1, '5': 5, '10': 'nanos'},
  ],
};

/// Descriptor for `Timestamp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List timestampDescriptor = $convert.base64Decode(
    'CglUaW1lc3RhbXASGAoHc2Vjb25kcxgBIAEoA1IHc2Vjb25kcxIUCgVuYW5vcxgCIAEoBVIFbm'
    'Fub3M=');

@$core.Deprecated('Use positionDescriptor instead')
const Position$json = {
  '1': 'Position',
  '2': [
    {'1': 'latitude', '3': 1, '4': 1, '5': 1, '10': 'latitude'},
    {'1': 'longitude', '3': 2, '4': 1, '5': 1, '10': 'longitude'},
  ],
};

/// Descriptor for `Position`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List positionDescriptor = $convert.base64Decode(
    'CghQb3NpdGlvbhIaCghsYXRpdHVkZRgBIAEoAVIIbGF0aXR1ZGUSHAoJbG9uZ2l0dWRlGAIgAS'
    'gBUglsb25naXR1ZGU=');

@$core.Deprecated('Use geoRoutedMsgDescriptor instead')
const GeoRoutedMsg$json = {
  '1': 'GeoRoutedMsg',
  '2': [
    {'1': 'msgBytes', '3': 1, '4': 1, '5': 12, '10': 'msgBytes'},
    {'1': 'time', '3': 2, '4': 1, '5': 11, '6': '.georoutedmsg.Timestamp', '10': 'time'},
    {'1': 'position', '3': 3, '4': 1, '5': 11, '6': '.georoutedmsg.Position', '9': 0, '10': 'position', '17': true},
  ],
  '8': [
    {'1': '_position'},
  ],
};

/// Descriptor for `GeoRoutedMsg`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List geoRoutedMsgDescriptor = $convert.base64Decode(
    'CgxHZW9Sb3V0ZWRNc2cSGgoIbXNnQnl0ZXMYASABKAxSCG1zZ0J5dGVzEisKBHRpbWUYAiABKA'
    'syFy5nZW9yb3V0ZWRtc2cuVGltZXN0YW1wUgR0aW1lEjcKCHBvc2l0aW9uGAMgASgLMhYuZ2Vv'
    'cm91dGVkbXNnLlBvc2l0aW9uSABSCHBvc2l0aW9uiAEBQgsKCV9wb3NpdGlvbg==');


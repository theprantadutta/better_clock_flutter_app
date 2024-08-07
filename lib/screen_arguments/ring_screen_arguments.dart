import 'dart:convert';

import 'package:alarm/alarm.dart';

class RingScreenArguments {
  final AlarmSettings alarmSettings;

  RingScreenArguments({required this.alarmSettings});

  Map<String, dynamic> toJson() => {
        'alarmSettings': alarmSettings.toJson(),
      };

  static RingScreenArguments fromJson(Map<String, dynamic> json) =>
      RingScreenArguments(
        alarmSettings: AlarmSettings.fromJson(json['alarmSettings']),
      );
}

/// A codec that can serialize [RingScreenArguments].
class MyExtraCodec extends Codec<Object?, Object?> {
  /// Create a codec.
  const MyExtraCodec();

  @override
  Converter<Object?, Object?> get decoder => const _MyExtraDecoder();

  @override
  Converter<Object?, Object?> get encoder => const _MyExtraEncoder();
}

class _MyExtraDecoder extends Converter<Object?, Object?> {
  const _MyExtraDecoder();

  @override
  Object? convert(Object? input) {
    if (input == null) {
      return null;
    }
    final List<Object?> inputAsList = input as List<Object?>;
    if (inputAsList[0] == 'RingScreenArguments') {
      return RingScreenArguments.fromJson(
          inputAsList[1]! as Map<String, dynamic>);
    }
    throw FormatException('Unable to parse input: $input');
  }
}

class _MyExtraEncoder extends Converter<Object?, Object?> {
  const _MyExtraEncoder();

  @override
  Object? convert(Object? input) {
    if (input == null) {
      return null;
    }
    if (input is RingScreenArguments) {
      return <Object?>['RingScreenArguments', input.toJson()];
    }
    throw FormatException('Cannot encode type ${input.runtimeType}');
  }
}

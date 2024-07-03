import 'package:isar/isar.dart';

part '../generated/entities/world_clock.g.dart';

@collection
class WorldClock {
  final int id;
  final String city;
  final String timeZone;
  final bool isCurrentTimeZone;

  WorldClock({
    required this.id,
    required this.city,
    required this.timeZone,
    required this.isCurrentTimeZone,
  });
}

import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:better_clock_flutter_app/components/common/cached_future_handler.dart';
import 'package:better_clock_flutter_app/entities/world_clock.dart';
import 'package:better_clock_flutter_app/packages/flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:better_clock_flutter_app/services/isar_service.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/timezone.dart';

import '../common/confirmation_dialog_box.dart';
import '../common/floating_add_button.dart';
import 'create_or_update_clock.dart';

List<WorldClock> initialClocks = [
  WorldClock(
      id: 1, city: 'Dhaka', timeZone: 'Asia/Dhaka', isCurrentTimeZone: true),
  WorldClock(
      id: 2,
      city: 'New York',
      timeZone: 'America/New_York',
      isCurrentTimeZone: false),
  WorldClock(
      id: 3,
      city: 'London',
      timeZone: 'Europe/London',
      isCurrentTimeZone: false),
];

class ClockLists extends StatelessWidget {
  const ClockLists({super.key});

  String compareDates(TZDateTime now) {
    // Local current date
    final localNow = DateTime.now();
    final localDate = DateTime(localNow.year, localNow.month, localNow.day);

    // Date part of the 'now' variable
    final nowDate = DateTime(now.year, now.month, now.day);

    if (nowDate.isAtSameMomentAs(localDate)) {
      return 'Today';
    } else if (nowDate
        .isAtSameMomentAs(localDate.subtract(const Duration(days: 1)))) {
      return 'Yesterday';
    } else if (nowDate
        .isAtSameMomentAs(localDate.add(const Duration(days: 1)))) {
      return 'Tomorrow';
    } else {
      return 'Neither Today, Tomorrow, nor Yesterday';
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultHeight = MediaQuery.sizeOf(context).height * 0.43;
    final kPrimaryColor = Theme.of(context).primaryColor;
    return SizedBox(
      height: defaultHeight,
      child: CachedFutureHandler(
        id: 'clock-list',
        defaultHeight: defaultHeight,
        future: IsarService().getInitialWorldClock,
        builder: (context, data, refetch) {
          return Stack(
            children: [
              ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final worldClock = data[index];
                  final city = tz.getLocation(worldClock.timeZone);
                  final now = tz.TZDateTime.now(city);
                  return FadeInUp(
                    duration: Duration(milliseconds: min(index + 1, 5) * 200),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      margin: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      height: MediaQuery.sizeOf(context).height * 0.12,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                worldClock.city,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                compareDates(now),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    '${now.hour > 12 ? (now.hour - 12) : now.hour}:${now.minute.toString().padLeft(2, '0')}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    now.hour > 12 ? "PM" : "AM",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () async {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return ConfirmationDialogBox(
                                        onYesPressed: () async {
                                          Loader.show(context);
                                          await IsarService().deleteAClock(
                                            worldClock.id,
                                          );
                                          await refetch();
                                          Loader.hide();
                                          // ignore: use_build_context_synchronously

                                          // Ensure the widget is still mounted before using context
                                          if (!context.mounted) return;

                                          // Check if the navigator can pop
                                          if (Navigator.canPop(context)) {
                                            Navigator.pop(context);
                                          }
                                        },
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.04,
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.18,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: kPrimaryColor.withOpacity(0.6),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              FloatingAddButton(
                iconData: Icons.add_outlined,
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return CreateOrUpdateClock(refetch: refetch);
                    },
                  );
                },
                title: 'Add Clock',
              ),
            ],
          );
        },
      ),
    );
  }
}

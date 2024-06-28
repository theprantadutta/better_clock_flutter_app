import 'package:alphabet_list_view/alphabet_list_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class CreateOrUpdateClock extends StatelessWidget {
  const CreateOrUpdateClock({super.key});

  String formatOffset(tz.Location location) {
    final now = tz.TZDateTime.now(location);
    final offset = now.timeZoneOffset;
    final hours = offset.inHours;
    final minutes = offset.inMinutes.remainder(60);
    final sign = hours >= 0 ? '+' : '-';
    return 'GMT$sign${hours.abs().toString().padLeft(2, '0')}:${minutes.abs().toString().padLeft(2, '0')}';
  }

  List<AlphabetListViewItemGroup> getAllTimeZones(BuildContext context) {
    final kPrimaryColor = Theme.of(context).primaryColor;

    tz.initializeTimeZones();
    var locations = tz.timeZoneDatabase.locations;

    // Create a map to group cities by the first letter of their name
    Map<String, List<tz.Location>> groupedCities = {};

    locations.forEach((key, location) {
      String cityName = location.name.split('/').last; // Extract city name
      String firstLetter = cityName[0].toUpperCase();
      if (!groupedCities.containsKey(firstLetter)) {
        groupedCities[firstLetter] = [];
      }
      groupedCities[firstLetter]!.add(location);
    });

    // Create the final list of AlphabetListViewItemGroup
    List<AlphabetListViewItemGroup> result = [];

    groupedCities.forEach((tag, cities) {
      result.add(
        AlphabetListViewItemGroup(
          tag: tag,
          children: cities.map((location) {
            String cityName = location.name.split('/').last;
            String offset = formatOffset(location);
            return Container(
              height: MediaQuery.sizeOf(context).height * 0.08,
              margin: const EdgeInsets.only(top: 5, right: 5),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    cityName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    offset,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      );
    });

    return result;
  }

  AlphabetListViewOptions _alphabetListViewOptions(BuildContext context) {
    final kPrimaryColor = Theme.of(context).primaryColor;
    return AlphabetListViewOptions(
      listOptions: ListOptions(
        listHeaderBuilder: (context, symbol) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.9),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              symbol,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      scrollbarOptions: ScrollbarOptions(
        symbolBuilder: (context, symbol, state) {
          final isSelected = state == AlphabetScrollbarItemState.active;
          return Center(
            child: Text(
              symbol,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w400,
                color: isSelected
                    ? kPrimaryColor
                    : Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          );
        },
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: kPrimaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      overlayOptions: OverlayOptions(
        showOverlay: true,
        overlayBuilder: (context, symbol) => Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: kPrimaryColor.withOpacity(0.8),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text(
              symbol,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final kPrimaryColor = Theme.of(context).primaryColor;
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.92,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.close_outlined),
                ),
                const Text(
                  'Add a Clock',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.check_outlined),
                ),
              ],
            ),
          ),
          TextField(
            onTapOutside: (event) {
              print('onTapOutside');
              FocusManager.instance.primaryFocus?.unfocus();
            },
            decoration: InputDecoration(
              hintText: 'Search City...',
              hintStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 20,
              ),
              // Remove border when the TextField is enabled but not focused
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: kPrimaryColor.withOpacity(0.3),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              // Remove border when the TextField is focused
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: kPrimaryColor.withOpacity(0.3),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              // Border when there is an error
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red.withOpacity(0.3), // Error color
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              // Border when the TextField is focused and there is an error
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red.withOpacity(0.3), // Error color
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Container(
            height: MediaQuery.sizeOf(context).height * 0.75,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: AlphabetListView(
              items: getAllTimeZones(context),
              options: _alphabetListViewOptions(context),
            ),
          ),
        ],
      ),
    );
  }
}
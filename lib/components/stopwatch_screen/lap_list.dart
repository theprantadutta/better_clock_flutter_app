import 'package:flutter/material.dart';

class LapList extends StatelessWidget {
  final List<Duration> laps;

  const LapList({super.key, required this.laps});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          const SizedBox(height: 10),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.395,
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  laps.length,
                  (index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: MediaQuery.sizeOf(context).width * 0.65,
                      child: Row(
                        children: [
                          const Icon(Icons.update_outlined),
                          const SizedBox(width: 20),
                          Text(
                            'Lap ${index + 1}:',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            ' ${laps[index].inSeconds} seconds',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

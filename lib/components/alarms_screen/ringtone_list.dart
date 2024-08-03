// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:go_router/go_router.dart';

class RingtoneList extends StatefulWidget {
  final String selectedRingtone;
  const RingtoneList({super.key, required this.selectedRingtone});

  @override
  State<RingtoneList> createState() => _RingtoneListState();
}

class _RingtoneListState extends State<RingtoneList> {
  List<String> ringtones = [];
  AudioPlayer audioPlayer = AudioPlayer();
  String? currentlyPlaying;
  String? currentlySelected;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    loadRingtones();
    setState(
      () => currentlySelected = widget.selectedRingtone,
    );
    audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() => duration = d);
    });
    audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() => position = p);
    });
    audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        currentlyPlaying = null;
        position = Duration.zero;
        duration = Duration.zero;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> loadRingtones() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    final ringtonePaths = manifestMap.keys
        .where((String key) => key.startsWith('assets/ringtones/'))
        .toList();

    setState(() {
      ringtones = ringtonePaths;
    });
  }

  void playPauseRingtone(String ringtoneName) async {
    if (currentlyPlaying == ringtoneName) {
      await audioPlayer.stop();
      setState(() {
        currentlyPlaying = null;
        position = Duration.zero;
        duration = Duration.zero;
      });
    } else {
      await audioPlayer.play(AssetSource('ringtones/$ringtoneName'));
      setState(() {
        currentlyPlaying = ringtoneName;
        currentlySelected = ringtoneName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.92,
      width: MediaQuery.sizeOf(context).width,
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
                  onPressed: () async {
                    await audioPlayer.stop();
                    context.pop(null);
                  },
                  icon: const Icon(Icons.close_outlined),
                ),
                const Text(
                  'Ringtone Selection',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await audioPlayer.stop();
                    context.pop(currentlySelected);
                  },
                  icon: const Icon(Icons.check_outlined),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: ringtones.length,
              itemBuilder: (context, index) {
                final ringtone = ringtones[index];
                final ringtoneName = ringtone.split('/').last;
                final isPlaying = currentlyPlaying == ringtoneName;
                final isSelected = currentlySelected == ringtoneName;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  margin: const EdgeInsets.symmetric(vertical: 3),
                  height: isSelected
                      ? MediaQuery.sizeOf(context).height * 0.09
                      : MediaQuery.sizeOf(context).height * 0.07,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).primaryColor.withOpacity(0.7)
                        : Theme.of(context).primaryColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: ListTile(
                      title: Text(ringtoneName),
                      subtitle: isSelected
                          ? const Text(
                              'Selected',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                      trailing: isPlaying
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: StreamBuilder<Duration>(
                                stream: audioPlayer.onPositionChanged,
                                builder: (context, snapshot) {
                                  final position =
                                      snapshot.data ?? Duration.zero;
                                  final progress = duration.inMilliseconds > 0
                                      ? position.inMilliseconds /
                                          duration.inMilliseconds
                                      : 0.0;
                                  return CircularProgressIndicator(
                                    value: progress,
                                    strokeWidth: 2.0,
                                    backgroundColor: isDarkTheme
                                        ? Colors.black87
                                        : Colors.white70,
                                  );
                                },
                              ),
                            )
                          : const Icon(Icons.play_arrow),
                      onTap: () => playPauseRingtone(ringtoneName),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

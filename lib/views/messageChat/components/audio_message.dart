import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../../constants/constant.dart';
import '../../../utilities/format_date.dart';

class AudioMessasge extends StatefulWidget {
  const AudioMessasge({Key? key, required this.urlAudio}) : super(key: key);

  final String urlAudio;

  @override
  State<AudioMessasge> createState() => _AudioMessasgeState();
}

class _AudioMessasgeState extends State<AudioMessasge> {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  Future setAudio() async {
    audioPlayer.setReleaseMode(ReleaseMode.loop);
    audioPlayer.setSourceUrl(widget.urlAudio);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      audioPlayer.setSourceUrl(widget.urlAudio);
    });
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: kPrimaryColor.withOpacity(
          0.5,
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              if (isPlaying) {
                await audioPlayer.pause();
              } else {
                await audioPlayer.play(
                  UrlSource(widget.urlAudio),
                );
              }
            },
            child: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: kPrimaryColor,
            ),
          ),
          Slider(
            min: 0,
            max: duration.inSeconds.toDouble(),
            value: position.inSeconds.toDouble(),
            onChanged: (value) async {
              final position = Duration(
                seconds: value.toInt(),
              );
              await audioPlayer.seek(position);
              await audioPlayer.resume();
            },
          ),
          Text(
            formatTime(duration - position),
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

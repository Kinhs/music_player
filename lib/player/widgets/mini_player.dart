import 'package:flutter/material.dart';

import 'package:flutter_sliding_box/flutter_sliding_box.dart';
import 'package:remix_icon_icons/remix_icon_icons.dart';
import 'package:audio_service/audio_service.dart';
import 'package:text_scroll/text_scroll.dart';

import 'package:music_app/player/ui/elements/ui_elements.dart';
import 'package:music_app/player/global_variables.dart';
import 'package:music_app/player/widgets/seekbar.dart';
import 'package:music_app/player/utilities/activity_handlers.dart';
import 'package:music_app/player/widgets/image_widgets.dart';

class MiniPlayer extends StatelessWidget {
  final BoxController boxController;
  const MiniPlayer({
    super.key,
    required this.boxController,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      theme: CardThemes().miniPlayerCardTheme,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<MediaItem?>(
          stream: currentPlaying(),
          builder: (context, snapshot) {
            MediaItem? currentTrack = snapshot.data;
            currentTrack ??= currentDefaultSong;
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (swipeGestures) {
                      if (details.primaryVelocity! > 100) {
                        previous();
                      } else if (details.primaryVelocity! < -100) {
                        next();
                      }
                    }
                  },
                  onVerticalDragEnd: (details) {
                    if (swipeGestures) {
                      if (details.primaryVelocity! < -200) {
                        boxController.openBox();
                      }
                    }
                  },
                  onTap: () {
                    boxController.openBox();
                  },
                  child: CustomCard(
                    theme: CardThemes().miniPlayerCardTheme,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: SizedBox(
                            height: 40,
                            child: getUriImage(currentTrack.artUri!),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextScroll(
                                currentTrack.title,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                                velocity: defaultTextScrollvelocity,
                                delayBefore: delayBeforeScroll,
                              ),
                              TextScroll(
                                currentTrack.artist as String,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                                velocity: defaultTextScrollvelocity,
                                delayBefore: delayBeforeScroll,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 10.0,
                            left: 5.0,
                          ),
                          child: StreamBuilder<PlaybackState>(
                              stream: currentPlaybackState(),
                              builder: (context, state) {
                                bool? playState = state.data?.playing;
                                playState ??= false;
                                return GestureDetector(
                                  onTap: () {
                                    playState! ? pause() : resume();
                                  },
                                  child: playState
                                      ? Icon(
                                          RemixIcon.pause,
                                          size: 40,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        )
                                      : Icon(
                                          RemixIcon.play,
                                          size: 40,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                );
                              }),
                        )
                      ],
                    ),
                  ),
                ),
                StreamBuilder<bool>(
                    stream: interactiveSeekbarStream.stream,
                    builder: (context, snapshot) {
                      bool seekbarIsInteractive =
                          snapshot.data ?? interactiveMiniPlayerSeekbar;
                      return seekbarIsInteractive
                          ? SeekBarBuilder(currentTrack: currentTrack)
                          : ProgressBarBuilder(currentTrack: currentTrack);
                    }),
              ],
            );
          },
        ),
      ),
    );
  }
}

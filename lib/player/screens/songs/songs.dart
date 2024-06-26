import 'package:music_app/player/utilities/file_handling/metadata.dart';
import 'package:music_app/player/utilities/file_handling/sort.dart';
import 'package:flutter/material.dart';
import 'package:text_scroll/text_scroll.dart';

import 'package:music_app/player/screens/songs/song.dart';
import 'package:music_app/player/global_variables.dart';
import 'package:music_app/player/widgets/list_header.dart';
import 'package:music_app/player/widgets/image_widgets.dart';
import 'package:music_app/player/utilities/file_handling/lists.dart';

class SongsList extends StatelessWidget {
  const SongsList({
    super.key,
  });

  final headerTitle = "Songs";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
          color: Theme.of(context).colorScheme.secondary,
          height: 1,
        ),
        ListHeader(
          headerTitle: headerTitle,
          listToCount: currentTrackListSort,
          listToShuffle: currentTrackListSort,
          sortList: "allTracks",
          availableSortTypes: trackListSortTypes,
        ),
        Divider(
          color: Theme.of(context).colorScheme.secondary,
          height: 1,
        ),
        Expanded(
          child: Scrollbar(
            interactive: true,
            thickness: 18,
            radius: const Radius.circular(5),
            child: StreamBuilder<List<Track>>(
              stream: allTracksStream.stream,
              builder: (context, snapshot) {
                final List<Track> allStreamTracks = snapshot.data ?? currentTrackListSort;
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  primary: true,
                  itemExtent: 100,
                  itemCount: allStreamTracks.length,
                  itemBuilder: (context, index) {
                    final Track thisTrack = allStreamTracks[index];
                    return SongItem(
                      title: TextScroll(
                        thisTrack.trackData!.trackName!,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        velocity: defaultTextScrollvelocity,
                        delayBefore: delayBeforeScroll,
                      ),
                      subtitle: TextScroll(
                        thisTrack.trackData!.trackArtistNames ?? "No Artist",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        velocity: defaultTextScrollvelocity,
                        delayBefore: delayBeforeScroll,
                      ),
                      leading: getUriImage(thisTrack.mediaItem!.artUri!),
                      track: thisTrack,
                      index: index,
                    );
                  },
                );
              }
            ),
          ),
        ),
      ],
    );
  }
}

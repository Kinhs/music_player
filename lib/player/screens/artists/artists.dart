/*

This Renders the screen for Album songs

*/

import 'package:music_app/player/utilities/file_handling/metadata.dart';
import 'package:music_app/player/utilities/file_handling/lists.dart';
import 'package:music_app/player/utilities/file_handling/sort.dart';
import 'package:flutter/material.dart';
import 'package:text_scroll/text_scroll.dart';

//Antiiq Packages
import 'package:music_app/player/screens/artists/artist.dart';
import 'package:music_app/player/global_variables.dart';
import 'package:music_app/player/widgets/list_header.dart';
import 'package:music_app/player/widgets/image_widgets.dart';

class ArtistsList extends StatelessWidget {
  const ArtistsList({
    super.key,
  });

  final headerTitle = "Artists";

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
          listToCount: currentArtistListSort,
          listToShuffle: const [],
          sortList: "allArtists",
          availableSortTypes: artistListSortTypes,
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
            child: StreamBuilder<List<Artist>>(
              stream: allArtistsStream.stream,
              builder: (context, snapshot) {
                final List<Artist> currentArtistStream = snapshot.data ?? currentArtistListSort;
                return ListView.builder(
                  itemExtent: 100,
                  physics: const BouncingScrollPhysics(),
                  primary: true,
                  itemCount: currentArtistStream.length,
                  itemBuilder: (context, index) {
                    final Artist thisArtist = currentArtistStream[index];
                    return ArtistItem(
                      title: TextScroll(
                        thisArtist.artistName!,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        velocity: defaultTextScrollvelocity,
                        delayBefore: delayBeforeScroll,
                      ),
                      subtitle: TextScroll(
                        "${thisArtist.artistTracks!.length} ${(thisArtist.artistTracks!.length > 1) ? "Songs" : "song"}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        velocity: defaultTextScrollvelocity,
                        delayBefore: delayBeforeScroll,
                      ),
                      leading: getUriImage(thisArtist.artistArt),
                      artist: thisArtist,
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

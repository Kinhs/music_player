//Flutter Packages
import 'package:music_app/player/screens/selection_actions.dart';
import 'package:music_app/player/utilities/file_handling/metadata.dart';
import 'package:music_app/player/utilities/playlisting/playlisting.dart';
import 'package:flutter/material.dart';
import 'package:remix_icon_icons/remix_icon_icons.dart';

//Antiiq Packages
import 'package:music_app/player/ui/elements/ui_elements.dart';
import 'package:music_app/player/utilities/activity_handlers.dart';
import 'package:music_app/player/widgets/song_cards/swiped_card.dart';

class PlaylistSong extends StatelessWidget {
  final Widget title;
  final Widget subtitle;
  final Widget leading;
  final Track track;
  final PlayList playlist;
  final Function setState;
  final Function mainPageStateSet;
  final int index;
  PlaylistSong({
    super.key,
    required this.title,
    required this.subtitle,
    required this.leading,
    required this.track,
    required this.playlist,
    required this.setState,
    required this.mainPageStateSet,
    required this.index,
  });

  final PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: PageView(
        controller: controller,
        children: [
          ReorderableDelayedDragStartListener(
            index: index,
            enabled: true,
            child: GestureDetector(
              onTap: () {
                playTrack(index, "album",
                    albumToPlay: playlist.playlistTracks!
                        .map((e) => e.mediaItem!)
                        .toList());
              },
              child: CustomCard(
                theme: CardThemes().albumSongsItemTheme,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: leading,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              title,
                              subtitle,
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        child: IconButton(
                          color: Theme.of(context).colorScheme.primary,
                          onPressed: () {
                            openSheetFromTrack(context, track);
                          },
                          icon: const Icon(RemixIcon.menu_4),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        child: IconButton(
                          color: Colors.red,
                          onPressed: () async {
                            await removeFromPlaylist(
                                playlist.playlistId!, index);
                            setState(() {});
                            mainPageStateSet(() {});
                          },
                          icon: const Icon(RemixIcon.delete_bin_2),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          SwipedCard(track: track, controller: controller, title: title)
        ],
      ),
    );
  }
}

import 'package:music_app/player/global_variables.dart';
import 'package:music_app/player/screens/selection_actions.dart';
import 'package:music_app/player/utilities/file_handling/metadata.dart';
import 'package:music_app/player/utilities/file_handling/sort.dart';
import 'package:flutter/material.dart';

import 'package:remix_icon_icons/remix_icon_icons.dart';
import 'package:music_app/player/utilities/activity_handlers.dart';

class ListHeader extends StatelessWidget {
  const ListHeader({
    super.key,
    required this.headerTitle,
    required this.listToCount,
    required this.listToShuffle,
    required this.sortList,
    required this.availableSortTypes,
    this.setState,
  });

  final String headerTitle;
  final dynamic listToCount;
  final List<Track> listToShuffle;
  final String sortList;
  final List<String> availableSortTypes;
  final Function? setState;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "$headerTitle: ${listToCount.length}",
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 15,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                StreamBuilder<List<Track>>(
                    stream: globalSelectionStream.stream,
                    builder: (context, snapshot) {
                      final List<Track> selectionSituation =
                          snapshot.data ?? globalSelection;
                      return selectionSituation.isNotEmpty
                          ? IconButton(
                              padding: EdgeInsets.zero,
                              color: Theme.of(context).colorScheme.secondary,
                              iconSize: 15,
                              onPressed: () {
                                doThingsWithAudioSheet(
                                  context,
                                  selectionSituation,
                                  thisGlobalSelection: true,
                                );
                              },
                              icon: const Icon(
                                RemixIcon.list_check_3,
                              ),
                            )
                          : Container();
                    }),
                listToShuffle.length > 1
                    ? IconButton(
                        padding: EdgeInsets.zero,
                        color: Theme.of(context).colorScheme.secondary,
                        iconSize: 15,
                        onPressed: () {
                          shuffleTracks(listToShuffle);
                        },
                        icon: const Icon(
                          RemixIcon.shuffle,
                        ),
                      )
                    : Container(),
                availableSortTypes.isNotEmpty
                    ? IconButton(
                        padding: EdgeInsets.zero,
                        color: Theme.of(context).colorScheme.secondary,
                        iconSize: 15,
                        onPressed: () {
                          showSortModal(context, sortList, availableSortTypes,
                              setState: setState);
                        },
                        icon: const Icon(RemixIcon.sort_asc),
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

showSortModal(context, String sortList, List<String> availableSortTypes,
    {setState}) {
  showModalBottomSheet(
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: bottomSheetShape,
    context: context,
    builder: (context) {
      commenceSort(sortType, sortDirection) {
        if (sortList == "allTracks") {
          beginSort(sortType, sortDirection, allTracks: true);
        } else if (sortList == "allAlbums") {
          beginSort(sortType, sortDirection, allAlbums: true);
        } else if (sortList == "allArtists") {
          beginSort(sortType, sortDirection, allArtists: true);
        } else if (sortList == "allGenres") {
          beginSort(sortType, sortDirection, allGenres: true);
        } else if (sortList == "allAlbumTracks") {
          beginSort(sortType, sortDirection, allAlbumTracks: true);
          setState(() {});
        } else if (sortList == "allArtistTracks") {
          beginSort(sortType, sortDirection, allArtistTracks: true);
          setState(() {});
        } else if (sortList == "allGenreTracks") {
          beginSort(sortType, sortDirection, allGenreTracks: true);
          setState(() {});
        }

        Navigator.of(context).pop();
      }

      late String currentDirection;
      late String currentSortType;
      if (sortList == "allTracks") {
        currentDirection = trackSort.currentDirection;
        currentSortType = trackSort.currentSort;
      } else if (sortList == "allAlbums") {
        currentDirection = albumSort.currentDirection;
        currentSortType = albumSort.currentSort;
      } else if (sortList == "allArtists") {
        currentDirection = artistSort.currentDirection;
        currentSortType = artistSort.currentSort;
      } else if (sortList == "allGenres") {
        currentDirection = genreSort.currentDirection;
        currentSortType = genreSort.currentSort;
      } else if (sortList == "allAlbumTracks") {
        currentDirection = albumTracksSort.currentDirection;
        currentSortType = albumTracksSort.currentSort;
      } else if (sortList == "allArtistTracks") {
        currentDirection = artistTracksSort.currentDirection;
        currentSortType = artistTracksSort.currentSort;
      } else if (sortList == "allGenreTracks") {
        currentDirection = genreTracksSort.currentDirection;
        currentSortType = genreTracksSort.currentSort;
      }

      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    "Sort by:",
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                for (String availableSortType in availableSortTypes)
                  GestureDetector(
                    onTap: () {
                      commenceSort(availableSortType, currentDirection);
                    },
                    child: Card(
                      color: Theme.of(context).colorScheme.surface,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              availableSortType,
                            ),
                            sortList == "allTracks"
                                ? Checkbox(
                                    value: trackSort.currentSort ==
                                        availableSortType,
                                    onChanged: null,
                                  )
                                : sortList == "allAlbums"
                                    ? Checkbox(
                                        value: albumSort.currentSort ==
                                            availableSortType,
                                        onChanged: null,
                                      )
                                    : sortList == "allArtists"
                                        ? Checkbox(
                                            value: artistSort.currentSort ==
                                                availableSortType,
                                            onChanged: null,
                                          )
                                        : sortList == "allGenres"
                                            ? Checkbox(
                                                value: genreSort.currentSort ==
                                                    availableSortType,
                                                onChanged: null,
                                              )
                                            : sortList == "allAlbumTracks"
                                                ? Checkbox(
                                                    value: albumTracksSort
                                                            .currentSort ==
                                                        availableSortType,
                                                    onChanged: null,
                                                  )
                                                : sortList == "allArtistTracks"
                                                    ? Checkbox(
                                                        value: artistTracksSort
                                                                .currentSort ==
                                                            availableSortType,
                                                        onChanged: null,
                                                      )
                                                    : sortList ==
                                                            "allGenreTracks"
                                                        ? Checkbox(
                                                            value: genreTracksSort
                                                                    .currentSort ==
                                                                availableSortType,
                                                            onChanged: null,
                                                          )
                                                        : Container(),
                          ],
                        ),
                      ),
                    ),
                  ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Theme.of(context).colorScheme.background,
                  ),
                  child: Row(
                    children: [
                      for (String key in sortDirections.keys)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (currentDirection != key) {
                                commenceSort(currentSortType, key);
                              }
                            },
                            child: Card(
                              color: currentDirection == key
                                  ? Theme.of(context).colorScheme.surface
                                  : Colors.transparent,
                              shadowColor: Colors.transparent,
                              surfaceTintColor: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    key,
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              ]),
        ),
      );
    },
  );
}

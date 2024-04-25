import 'package:music_app/player/screens/artists/artists.dart';
import 'package:music_app/player/screens/equalizer/equalizer.dart';
import 'package:music_app/player/screens/favourites/favourites.dart';
import 'package:music_app/player/screens/genres/genres.dart';
import 'package:music_app/player/screens/playlists/playlists.dart';
import 'package:music_app/player/screens/search/search.dart';
import 'package:music_app/player/screens/selection/selection.dart';
import 'package:flutter/material.dart';

//Antiiq Packages
import 'package:music_app/player/screens/dashboard/dashboard.dart';
import 'package:music_app/player/screens/songs/songs.dart';
import 'package:music_app/player/global_variables.dart';
import 'package:music_app/player/screens/albums/albums.dart';

Widget mainBackdrop() {
  return Padding(
    padding: const EdgeInsets.only(bottom: 35),
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: PageView(
        controller: mainPageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          Dashboard(),
          Equalizer(),
          Search(),
          SongsList(),
          AlbumsGrid(),
          ArtistsList(),
          GenresGrid(),
          Playlists(),
          FavouritesList(),
          SelectionList(),
        ],
      ),
    ),
  );
}

/*

Setup Song Library:
- Get all Songs, Albums, Artists and Genres and;
- Perform necessary conversions

*/

import 'package:music_app/player/utilities/file_handling/query_and_sort.dart';
import 'package:music_app/player/utilities/user_settings.dart';

//Path Provider
import 'package:path_provider/path_provider.dart';

//Hive
import 'package:hive_flutter/hive_flutter.dart';

import 'package:permission_handler/permission_handler.dart';

//Antiiq Packages
import 'package:music_app/player/global_variables.dart';
import 'package:music_app/player/utilities/file_handling/art_queries.dart';

class Boxes {
  String mainBox = "antiiqBox";
  String playlistBox = "playlists";
  String playlistNameBox = "playlistNames";
}

initialLoad() async {
  await checkAndRequestPermissions();
  await furtherPermissionRequest();
  await Hive.initFlutter();
  antiiqStore = await Hive.openBox(Boxes().mainBox);
  playlistStore = await Hive.openBox(Boxes().playlistBox);
  playlistNameStore = await Hive.openBox(Boxes().playlistNameBox);
  dataIsInitialized = await antiiqStore.get("dataInit", defaultValue: false);
  await initializeUserSettings();
  antiiqDirectory = await getApplicationDocumentsDirectory();
  await setDefaultArt();
}

loadLibrary() async {
  if (hasPermissions) {
    await queryAndSort();
  }
}

checkAndRequestPermissions({bool retry = false, stateSet}) async {
  // The param 'retryRequest' is false, by default.
  hasPermissions = await audioQuery.checkAndRequest(
    retryRequest: retry,
  );

  retry ? {loadLibrary(), stateSet()} : null;
}

furtherPermissionRequest() async {
  PermissionStatus status = await Permission.manageExternalStorage.status;

  if (!status.isGranted) {
    status = await Permission.manageExternalStorage.request();
  }
  furtherPermissionGranted = true;
}

import 'package:audio_service/audio_service.dart';

import 'package:music_app/player/global_variables.dart';
import 'package:music_app/player/utilities/file_handling/lists.dart';
import 'package:music_app/player/utilities/file_handling/metadata.dart';
import 'package:music_app/player/utilities/audio_preferences.dart';

playTrack(int index, String list, {albumToPlay}) async {
  if (list == "songs") {
    await playFromSongs(index);
  }
  if (list == "queue") {
    await playFromQueue(index);
  }

  if (list == "album") {
    await playFromAlbum(index, albumToPlay);
  }
}

playFromSongs(int index) async {
  await goToAudioService(
      index, currentTrackListSort.map((e) => e.mediaItem!).toList());
  await audioHandler.play();
}

playFromQueue(int index) async {
  await goToAudioService(index, activeQueue);
  await audioHandler.play();
}

playFromAlbum(int index, List<MediaItem> album) async {
  await goToAudioService(index, album);
  await audioHandler.play();
}

Future<void> goToAudioService(
    int indexOfSong, List<MediaItem> listToPlay) async {
  queueToLoad =
      listToPlay.sublist(indexOfSong) + listToPlay.sublist(0, indexOfSong);
  currentDefaultSong = queueToLoad[0];
  if (queueToLoad[0].duration == const Duration(milliseconds: 0)) {
    queueToLoad.removeAt(0);
  }
  await loadQueue(queueToLoad);
}

Future<void> loadQueue(List<MediaItem> queue) async {
  await audioHandler.updateQueue(queue);
}

resume() async {
  await audioHandler.play();
}

pause() async {
  await audioHandler.pause();
}

next() async {
  await audioHandler.skipToNext();
}

previous() async {
  await audioHandler.skipToPrevious();
}

forward() async {
  await audioHandler.fastForward();
}

rewind() async {
  await audioHandler.rewind();
}

playOnlyThis(MediaItem item) async {
  queueToLoad = [item];
  await loadQueue(queueToLoad);
  await audioHandler.play();
}

playTracks(List<Track> tracks) async {
  queueToLoad = tracks.map((track) => track.mediaItem!).toList();
  await loadQueue(queueToLoad);
  await audioHandler.play();
}

playTrackNext(MediaItem item) async {
  if (audioHandler.antiiqQueue.isNotEmpty) {
    await audioHandler.insertQueueItem(1, item);
  } else {
    await playOnlyThis(item);
  }
}

addToQueue(item) async {
  if (audioHandler.antiiqQueue.isNotEmpty) {
    await audioHandler.addQueueItem(item);
  } else {
    await playOnlyThis(item);
  }
}

shuffleList(List<MediaItem> list) async {
  await updateShuffleMode(true);
  await loadQueue(list);
  await next();
  await resume();
}

shuffleTracks(List<Track> list) async {
  List<MediaItem> itemList = list.map((e) => e.mediaItem!).toList();
  await shuffleList(itemList);
}

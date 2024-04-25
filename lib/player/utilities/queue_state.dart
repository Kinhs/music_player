import 'package:music_app/player/global_variables.dart';
import 'package:music_app/player/utilities/file_handling/lists.dart';
import 'package:music_app/player/utilities/file_handling/metadata.dart';
import 'package:music_app/player/utilities/user_settings.dart';
import 'package:audio_service/audio_service.dart';

saveQueueState() async {
  List<int> stateToSave =
      activeQueue.map((item) => item.extras!["id"]).toList().cast();
  await antiiqStore.put(BoxKeys().queueState, stateToSave);
}

initQueueState() async {
  List<MediaItem> queueToInit = [];
  List<int> stateToInit =
      await antiiqStore.get(BoxKeys().queueState, defaultValue: <int>[]);
  for (int id in stateToInit) {
    for (Track track in currentTrackListSort) {
      if (track.trackData!.trackId == id) {
        queueToInit.add(track.mediaItem!);
      }
    }
  }
  queueState = queueToInit;
}

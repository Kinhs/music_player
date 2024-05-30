import 'package:music_app/player/utilities/user_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:audio_service/audio_service.dart';

import 'package:music_app/player/utilities/audio_handler.dart';
import 'package:music_app/player/ui/elements/ui_colours.dart';
import 'package:music_app/player/screens/main_screen/main_box.dart';
import 'package:music_app/player/global_variables.dart';
import 'package:music_app/player/utilities/initialize.dart';

import 'package:dcdg/dcdg.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialLoad();
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  );
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: currentColorScheme.background,
    ),
  );

  audioHandler = await AudioService.init(
      builder: () => AntiiqAudioHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: "com.coleblvck.antiiq.channel.audio",
        androidNotificationChannelName: "Antiiq Player",
        androidNotificationIcon: "drawable/antiiq_icon",
      ));
  await initializeAudioPreferences();

  runApp(const MusicPlayer());
}

class MusicPlayer extends StatelessWidget {
  const MusicPlayer({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ColorScheme>(
        stream: themeStream.stream,
        builder: (context, snapshot) {
          return MaterialApp(
            title: 'Music_Player',
            theme: ThemeData(
              colorScheme: snapshot.data ?? getColorScheme(),
              useMaterial3: true,
            ),
            debugShowCheckedModeBanner: false,
            home: const MainBox(),
          );
        });
  }
}

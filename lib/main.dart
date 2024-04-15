import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/provider/songModelProvider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import 'Screens/Player.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => SongModelProvider(),
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Music Player'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();

  String _searchQuery = '';

  bool _hasPermission = false;
  bool _isSearchBarVisible = false;

  @override
  void initState() {
    super.initState();

    LogConfig logConfig = LogConfig(logType: LogType.DEBUG);
    _audioQuery.setLogConfig(logConfig);

    checkAndRequestPermissions();
  }

  checkAndRequestPermissions({bool retry = false}) async {
    _hasPermission = await _audioQuery.checkAndRequest(
      retryRequest: retry,
    );
    _hasPermission ? setState(() {}) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                  _isSearchBarVisible = !_isSearchBarVisible;
                });
              },
              icon: const Icon(Icons.search),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          if (_isSearchBarVisible) _buildSearchBar(),
          Expanded(
              child: Center(
                  child: !_hasPermission
                      ? noAccessToLibraryWidget()
                      : FutureBuilder<List<SongModel>>(
                      future: _audioQuery.querySongs(
                        sortType: null,
                        orderType: OrderType.ASC_OR_SMALLER,
                        uriType: UriType.EXTERNAL,
                        ignoreCase: true,
                      ),
                      builder: (context, item) {
                        if (item.hasError) {
                          return Text(item.error.toString());
                        }
                        if (item.data == null) {
                          return const CircularProgressIndicator();
                        }

                        if (item.data!.isEmpty) return const Text("Nothing found!");

                        List<SongModel>? songs = item.data;

                        if (_searchQuery.isNotEmpty) {
                          songs = songs
                              ?.where((song) => song.title
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase()))
                              .toList();
                        }

                        if (songs == null || songs.isEmpty) {
                          return const Text("Nothing found!");
                        }


                        return ListView.builder(
                          itemCount: songs.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(songs![index].title),
                              subtitle: Text(songs[index].artist ?? "Unknown"),
                              trailing: const Icon(Icons.arrow_forward_rounded),
                              leading: QueryArtworkWidget(
                                controller: _audioQuery,
                                id: songs[index].id,
                                type: ArtworkType.AUDIO,
                                nullArtworkWidget: const CircleAvatar(
                                    radius: 25,
                                    child: Icon(Icons.music_note)
                                ),
                              ),
                              onTap: () {
                                context.read<SongModelProvider>().setId(songs![index].id);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Player(songModels: songs!, audioPlayer: _audioPlayer, index: index,)));
                              },
                            );
                          },
                        );
                      }
                  )
              )
          )
        ],

      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        decoration: InputDecoration(
          hintText: 'Search...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.blueAccent)
          ),
        ),
        onChanged: (String value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget noAccessToLibraryWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.redAccent.withOpacity(0.5),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Application doesn't have access to the library"),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => checkAndRequestPermissions(retry: true),
            child: const Text("Allow"),
          ),
        ],
      ),
    );
  }
}


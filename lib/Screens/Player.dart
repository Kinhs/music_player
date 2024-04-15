import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../provider/songModelProvider.dart';

class Player extends StatefulWidget {
  const Player({super.key, required this.songModels, required this.audioPlayer, required this.index});
  final List<SongModel> songModels;
  final AudioPlayer audioPlayer;
  final index;

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  Duration _duration = const Duration();
  Duration _position = const Duration();

  List<AudioSource> SourceList = [];

  bool _isPlaying = false;

  int playIndex = 0;

  @override
  void initState() {
    super.initState();
    playSong();
  }

  void playSong() {
    try {
      for (var song in widget.songModels) {
        SourceList.add(
          AudioSource.uri(
            Uri.parse(song.uri!),
            tag: MediaItem(
              id: song.id.toString(),
              title: song.displayNameWOExt,
              album: song.album ?? "No Album",
              artUri: Uri.parse(song.id.toString()),
              artist: song.artist,
            )
          ),
        );
      }
      widget.audioPlayer.setAudioSource(
        ConcatenatingAudioSource(children: SourceList),
        initialIndex: widget.index,
      );
      widget.audioPlayer.play();
      _isPlaying = true;
    } on Exception {}

    widget.audioPlayer.durationStream.listen((d) {
      setState(() {
        _duration = d!;
      });
    });
    widget.audioPlayer.positionStream.listen((p) {
      setState(() {
        _position = p;
      });
    });
    listenToEvent();
    listenToSongIndex();
  }

  void listenToEvent() {
    widget.audioPlayer.playerStateStream.listen((state) {
      if (state.playing) {
        setState(() {
          _isPlaying = true;
        });
      } else {
        setState(() {
          _isPlaying = false;
        });
      }
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  void listenToSongIndex() {
    widget.audioPlayer.currentIndexStream.listen(
          (event) {
        setState(
              () {
            if (event != null) {
              playIndex = event;
              context.read<SongModelProvider>().setId(widget.songModels[playIndex].id);
            }
          },
        );
      },
    );
  }

  void skipNext() {
    if (widget.audioPlayer.hasNext) {
      widget.audioPlayer.seekToNext();
    }
  }

  void skipPrevious() {
    if (widget.audioPlayer.hasPrevious) {
      widget.audioPlayer.seekToPrevious();
    }
  }

  void changeToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    widget.audioPlayer.seek(duration);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new),
              ),
              const SizedBox(
                height: 40.0,
              ),
              Center(
                child: Column(
                  children: [
                    const ArtWorkWidget(),
                    const SizedBox(
                      height: 40.0,
                    ),
                    Text(
                      widget.songModels[playIndex].displayNameWOExt,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40.0,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      widget.songModels[playIndex].artist ?? "Unknown",
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Text(
                            _position.toString().split(".")[0]
                        ),
                        Expanded(
                            child: Slider(
                                min: Duration(microseconds: 0).inSeconds.toDouble(),
                                value: _position.inSeconds.toDouble(),
                                max: _duration.inSeconds.toDouble(),
                                onChanged: (value){
                                  setState(() {
                                    changeToSeconds(value.toInt());
                                    value = value;
                                  });
                                }
                            )
                        ),
                        Text(
                            _duration.toString().split(".")[0]
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            skipPrevious();
                          },
                          icon: const Icon(Icons.skip_previous, size: 50,),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if(_isPlaying) {
                                widget.audioPlayer.pause();
                              } else {
                                widget.audioPlayer.play();
                              }
                            });
                          },
                          icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, size: 50,),
                        ),
                        IconButton(
                          onPressed: () {
                            skipNext();
                          },
                          icon: const Icon(Icons.skip_next, size: 50,),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ArtWorkWidget extends StatelessWidget {
  const ArtWorkWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
      id: context.watch<SongModelProvider>().id,
      type: ArtworkType.AUDIO,
      artworkHeight: 250,
      artworkWidth: 250,
      nullArtworkWidget: const CircleAvatar (
        radius: 125,
        child: Icon(Icons.music_note, size: 100,),
      ),
      artworkFit: BoxFit.cover,
    );
  }
}
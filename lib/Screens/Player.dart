import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Player extends StatefulWidget {
  const Player({Key? key, required this.songModel}) : super(key: key);
  final SongModel songModel;

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {

  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    playSong();
  }

  void playSong() {
    try {
      _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(widget.songModel.uri!)));
      _audioPlayer.play();
      _isPlaying = true;
    } on Exception {}
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
                    CircleAvatar(
                      radius: 100.0,
                      child: Icon(Icons.music_note, size: 80),
                    ),
                    const SizedBox(
                      height: 40.0,
                    ),
                    Text(
                      widget.songModel.displayNameWOExt,
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40.0,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      widget.songModel.artist ?? "Unknown",
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Text("0.0"),
                        Expanded(child: Slider(value: 0.0, onChanged: (value){})),
                        Text("0.0"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(onPressed: () {}, icon: const Icon(Icons.skip_previous, size: 50,),),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if(_isPlaying) {
                                _audioPlayer.pause();
                              } else {
                                _audioPlayer.play();
                              }
                              _isPlaying = !_isPlaying;
                            });
                          },
                          icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, size: 50,),
                        ),
                        IconButton(onPressed: () {}, icon: const Icon(Icons.skip_next, size: 50,),),
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
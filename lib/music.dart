import 'dart:async';
import 'package:flutter_app/AlbumInfo.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/CardInfo.dart';
import 'package:flutter/services.dart';

typedef void OnError(Exception exception);
const kUrl = "google.com";

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, //top bar color
        statusBarIconBrightness: Brightness.dark, //top bar icons
        systemNavigationBarColor: Colors.white, //bottom bar color
        systemNavigationBarIconBrightness: Brightness.dark, //bottom bar icons
      )
  );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(new AudioApp()));
}

enum PlayerState { stopped, playing, paused }

class AudioApp extends StatefulWidget {
  @override
  _AudioAppState createState() => new _AudioAppState();
}

class _AudioAppState extends State<AudioApp> {
  String imgPath;
  ScrollController scrollController;
  List<Song> _songs;
  List<Song> _recentlyPlayed = [];
  Duration duration;
  Duration position;

  MusicFinder audioPlayer;

  String localFilePath;

  PlayerState playerState = PlayerState.stopped;

  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;

  get durationText =>
      duration != null ? duration.toString().split('.').first : '';
  get positionText =>
      position != null ? position.toString().split('.').first : '';

  bool isMuted = false;

  @override
  void initState() {
    super.initState();
    initAudioPlayer();
  }

  Future initAudioPlayer() async {
    audioPlayer = new MusicFinder();
    var songs  = await MusicFinder.allSongs();
    _songs = songs;
    setState(() {
      _songs = songs;
    });
  }

  Future play() async {
    final result = await audioPlayer.play(kUrl);
    if (result == 1)
      setState(() {
        print('_AudioAppState.play... PlayerState.playing');
        playerState = PlayerState.playing;
      });
  }

  Future _playLocal(String url) async {
    // ignore: unused_local_variable
    final result = await audioPlayer.play(url, isLocal: true);
  }

  Future pause() async {
    final result = await audioPlayer.pause();
    if (result == 1) setState(() => playerState = PlayerState.paused);
  }

  Future stop() async {
    final result = await audioPlayer.stop();
    if (result == 1)
      setState(() {
        playerState = PlayerState.stopped;
        position = new Duration();
      });
  }

  Future mute(bool muted) async {
    final result = await audioPlayer.mute(muted);
    if (result == 1)
      setState(() {
        isMuted = muted;
      });
  }

  void onComplete() {
    setState(() => playerState = PlayerState.stopped);
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.stop();
  }

//  Future<Uint8List> _loadFileBytes(String url, {OnError onError}) async {
//    Uint8List bytes;
//    try {
//      bytes = await readBytes(url);
//    } on ClientException {
//      rethrow;
//    }
//    return bytes;
//  }

  void addToRecent(Song song){
    if (_recentlyPlayed.indexOf(song) == -1){
      _recentlyPlayed.insert(0, song);
    }
    else{
      _recentlyPlayed.removeAt(_recentlyPlayed.indexOf(song));
      _recentlyPlayed.insert(0, song);
    }
    if (_recentlyPlayed.length == 6){
      _recentlyPlayed.removeLast();
    }
  }

  String noAlbumArt(List<Song> songs, int index){
    if (songs[index].albumArt == null){
      songs[index].albumArt = 'assets/images/nocoverart.jpg';
    }
    return songs[index].albumArt;
  }

  @override
  Widget build(BuildContext context) {
    Widget home () {
      return new Scaffold(
        body: NestedScrollView(
            headerSliverBuilder:(BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                new SliverAppBar(
                  floating: true,
                  elevation: 0,
                  actions: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          right: 24,
                          top: 1
                      ),
                      child: Icon(Icons.more_vert),
                    ),
                  ],
                ),
              ];
            },
            body: ListView(
              padding: const EdgeInsets.only(top:0),
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.only(left: 23.5),
                      child: Text(
                        'Recently played',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 23),
                      ),
                    ),
                    SizedBox(
                      height: 7.5,
                    ),
                    Container(
                      height: 191,
                      child: buildRecentlyPlayed(),
                    ),
                    allSong()
                  ],
                )
              ],
            )),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.pause),
                  onPressed: (){
                    pause();
                  }),
              IconButton(
                  icon: Icon(Icons.play_circle_outline),
                  onPressed: (){
                    play();
                  })
            ],
          )
        ),
      );
    }
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music',
      theme: ThemeData(
          canvasColor: Colors.white,
          backgroundColor: Colors.white,
          primaryColor: Colors.white,
          accentColor: Colors.white,
          fontFamily: 'Product Sans'
      ),
      home: home(),
    );
  }

  Widget allSong() {
    return new ListView.builder(
        itemCount: _songs.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, int index) {
          return new Container(
            width: MediaQuery.of(context).size.width,
            child: ListTile(
              contentPadding: EdgeInsetsDirectional.only(bottom: 5, start: 23.5, end: 23.5),
              leading: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                child: Image(
                  image: AssetImage(noAlbumArt(_songs, index)),
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(_songs[index].title, overflow: TextOverflow.fade,),
              onTap: () {
                stop();
                _playLocal(_songs[index].uri);
                addToRecent(_songs[index]);
                debugPrint(_recentlyPlayed.length.toString());
              },
            ),
          );
        }
    );
  }

  double startEdge(int index, int length){
    if (index == 0){
      return 21;
    }
    return 11.75;
  }
  double endEdge(int index, int length){
    if (index == length-1){
      return 21;
    }
    return 0;
  }

  Widget buildRecentlyPlayed() {
    return new ListView.builder(
      itemCount: _recentlyPlayed.length,
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            Expanded(
              child: Container(padding: EdgeInsetsDirectional.only(start: startEdge(index, _recentlyPlayed.length), bottom: 0 ,top: 8),
                  child: Card(
                    elevation: 0,
                    child: Container(
                      width: 155.0,
                      height: 155.0,
                      child: GestureDetector(
                        child: Hero(
                          tag: _recentlyPlayed[index].title+index.toString(),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            child: Image(
                              image: AssetImage(noAlbumArt(_recentlyPlayed, index)),
                            ),
                          ),
                        ),
                        onTap: (){
                          _generatePalette(context, _recentlyPlayed[index].albumArt).then((_palette){
                            Navigator.push(context, MaterialPageRoute(builder: (_) {
                              CardInfo c = CardInfo(_recentlyPlayed[index].title, AssetImage(_recentlyPlayed[index].albumArt), _recentlyPlayed[index].albumArt,false,['Chica','Young In Love', 'Call It Love', 'Flourishing', 'Snapping'],_recentlyPlayed[index].artist.toUpperCase(), false);
                              return AlbumInfo(c, index,_palette.lightVibrantColor?.color, _palette);
                            }
                            )
                            );
                          });
                        },
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0)),
                  )
              ),
            ),
            Container(
                padding: EdgeInsetsDirectional.only(start: startEdge(index, _recentlyPlayed.length)),
                width: 155.0,
                height: 20,
                alignment: Alignment.bottomCenter,
                child: Text(
                  _recentlyPlayed[index].title,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 14.5),
                )
            ),

          ],
        );
      },
    );
  }

  Future<PaletteGenerator> _generatePalette(context, String imagePath) async {
    PaletteGenerator _paletteGenerator = await PaletteGenerator.fromImageProvider(AssetImage(imagePath),
        size: Size(20,20));
    setState(() {
      imgPath = imagePath;
    });
    return _paletteGenerator;
  }
}
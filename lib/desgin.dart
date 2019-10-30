import 'package:flutter/material.dart';
import 'package:flutter_app/CardInfo.dart';
import 'package:flutter_app/AlbumInfo.dart';
import 'package:palette_generator/palette_generator.dart';

class Spotify extends StatefulWidget {
  @override
  createState() => new SpotifyState();
}

final String assetName = 'assets/images/home.svg';

class SpotifyState extends State<Spotify> {
  Color endOfListColor = Colors.black;
  double endOfListWidth = 155.0;
  int _currentIndex = 0;
  String imgPath;
  ScrollController scrollController;
  @override
  void initState(){
    super.initState();
    scrollController = new ScrollController();
  }

  var currentColor = Color.fromRGBO(231, 129, 109, 1.0);
  var cardsList = [
    CardInfo(
        "Gotto Go",
        AssetImage('assets/images/gottoGo.jpg'),
        'assets/images/gottoGoSD.jpg',false,['Gotto Go'], 'CHUNG HA',false),
    CardInfo("Birthday", AssetImage('assets/images/birthday.jpg'),
        'assets/images/birthdaySD.jpg', false,['Birthday', 'Outta My Head'], 'SOMI',false),
    CardInfo(
        "'The ReVe Festival' Day 1",
        AssetImage('assets/images/redVelvet.jpg'),
        'assets/images/redVelvetSD.jpg',false,['Zimzalabim', 'Sunny Side Up!','Milkshake', 'Bing Bing', 'Parade', 'LP'], 'RED VELVET',false),
    CardInfo("Forever Young", AssetImage('assets/images/squareUp.jpg'),
        'assets/images/squareUpSD.jpg',false,['DDU-DU DDU-DU', 'Forever Young', 'Really', 'See U Later'], 'BLACKPINK',false),
    CardInfo("Kill This Love", AssetImage('assets/images/killThisLove.jpg'),
        'assets/images/killThisLoveSD.jpg',false,['Kill This Love', 'Don\'t Know What To Do', 'Kick It', 'Hope Not'], 'BLACKPINK',false),
    CardInfo("Superhuman", AssetImage('assets/images/superHuman.jpg'),
        'assets/images/superHumanSD.jpg',false,['Superhuman'], 'NCT 127',false),
    CardInfo('', AssetImage('assets/images/white.png'),
        'assets/images/white.png', true,['Birthday', 'Outta My Head'],'',false),
  ];
  var heavyRotList = [
    CardInfo("K-pop", AssetImage('assets/images/kpop.jpg'), 'assets/images/kpopSD.jpg',false,[],'CREATED BY KENNY',true),
    CardInfo("Flourishing", AssetImage('assets/images/chungha.jpg'), 'assets/images/chunghaSD.jpg',false,['Chica','Young In Love', 'Call It Love', 'Flourishing', 'Snapping'],'CHUNG HA', false),
    CardInfo("English", AssetImage('assets/images/english.png'), 'assets/images/englishSD.jpg',false,[],'CREATED BY KENNY',true),
    CardInfo('', AssetImage('assets/images/white.png'),
        'assets/images/white.png', true),
  ];

  AnimationController animationController;
  ColorTween colorTween;
  CurvedAnimation curvedAnimation;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 7.5,
                  ),
                  Container(
                    height: 191,
                    child: _buildRecentlyPlayed(),
                  ),
                  SizedBox(
                    height: 25.5,
                  ),
                  new Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 23.5),
                    child: Text(
                      'Your heavy rotation',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 7.5,
                  ),
                  Container(
                    height: 191,
                    child: _buildHeavyRotation(),
                  ),
                  SizedBox(
                    height: 25.5,
                  ),
                  new Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 23.5),
                    child: Text(
                      'Last added',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 20),
                    ),
                  ),
                ],
              )
            ],
          )),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.greenAccent[400],
        currentIndex: _currentIndex,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: _currentIndex == 0
                  ? Image.asset('assets/images/home.png', scale: 3, color: Colors.greenAccent[400],): Image.asset('assets/images/home.png', scale: 3, color: Colors.grey,),
              title: Text('',)
          ),
          BottomNavigationBarItem(
              icon: _currentIndex == 1
                  ? Image.asset('assets/images/search.png', scale: 4, color: Colors.greenAccent[400],): Image.asset('assets/images/search.png', scale: 4, color: Colors.grey,),
              title: Text('',)
          ),
          BottomNavigationBarItem(
              icon: _currentIndex == 2
                  ? Image.asset('assets/images/book-open.png', scale: 3, color: Colors.greenAccent[400],): Image.asset('assets/images/book-open.png', scale: 3, color: Colors.grey,),
              title: Text('',)
          ),
        ],
      ),
    );

  }

  Future<PaletteGenerator> _generatePalette(context, String imagePath) async {
    PaletteGenerator _paletteGenerator = await PaletteGenerator.fromImageProvider(AssetImage(imagePath),
        size: Size(50,50));
    setState(() {
      imgPath = imagePath;
    });
    return _paletteGenerator;
  }
//  Future<PaletteGenerator> _generatePalette(String imagePath) async {
//    PaletteGenerator _paletteGenerator = await PaletteGenerator.
//    fromImageProvider(
//        AssetImage(imagePath),
//        size: Size(100, 100),
//        maximumColorCount: 20
//    );S
//    return _paletteGenerator;
//  }

  double widthOfCard(var list, int index) {
    if (list[index].endOfList == true) {
      endOfListColor = Colors.white;
      endOfListWidth = 15;
    } else {
      endOfListColor = Colors.grey[800];
      endOfListWidth = 155.0;
    }
    return endOfListWidth;
  }

//  Future<Color> _getColor(int index) async {
//    _generatePalette(cardsList[index].imagePath).then((PaletteGenerator p) {
//      cardsList[index].color = p.dominantColor?.color;
//    });
//    return cardsList[index].color;
//  }
  Widget _buildHeavyRotation() {
    return new ListView.builder(
      itemCount: heavyRotList.length,
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 10, top: 8),
                child: Transform.translate(
                  offset: Offset(21, 0),
                  child: Container(
                      child: GestureDetector(
                        child: Card(
                          elevation: 0,
                          child: Container(
                            height: widthOfCard(heavyRotList, index),
                            width: widthOfCard(heavyRotList, index),
                            child: Hero(
                              tag: heavyRotList[index].cardTitle+index.toString(),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                child: Image(
                                  image: heavyRotList[index].image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0)),
                        ),
                        onTap: (){
                          _generatePalette(context, heavyRotList[index].imagePath).then((_palette){
                            Navigator.push(context, MaterialPageRoute(builder: (_) {
                              return AlbumInfo(heavyRotList[index], index,_palette.lightVibrantColor?.color, _palette);
                            }
                            )
                            );
                          });
                        },
                      )
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Transform.translate(
                offset: Offset(21, 0),
                child: Text(
                  heavyRotList[index].cardTitle,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 14.5),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildRecentlyPlayed() {
    return new ListView.builder(
      itemCount: cardsList.length,
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 10, top: 8),
                child: Transform.translate(
                  offset: Offset(21, 0),
                  child: GestureDetector(
                    child: Container(
                      child: Card(
                        elevation: 0,
                        child: Container(
                          height: widthOfCard(cardsList, index),
                          width: widthOfCard(cardsList, index),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            child: Hero(
                                tag: cardsList[index].cardTitle+index.toString(),
                                child: Image(
                                  image: cardsList[index].image,
                                  fit: BoxFit.cover,
                                )
                            ),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0)),
                      ),
                    ),
                    onTap: (){
                      _generatePalette(context, cardsList[index].imagePath).then((_palette){
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return AlbumInfo(cardsList[index], index,_palette.lightVibrantColor?.color, _palette);
                        }
                        )
                        );
                      });
                    },
                  ),
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Transform.translate(
                  offset: Offset(21, 0),
                  child: Container(
                      width: widthOfCard(cardsList, index),
                      child: Text(
                        cardsList[index].cardTitle,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 14.5),
                      )
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}

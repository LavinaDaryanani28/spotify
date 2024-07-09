import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:spotify/Screens/Home/Home.dart';
import 'package:spotify/Screens/Library/Library.dart';
import 'package:spotify/Screens/Settings/Settings.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavigationbarState();
}

class _NavigationbarState extends State<NavBar> {
  final audioPlayer=AudioPlayer();
  bool _isPlaying = false;
  @override
  int _currentIndex = 0;
  Duration duration=Duration.zero;
  Duration position=Duration.zero;
  void initState() {
    super.initState();
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });

    // Listener for duration changes
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    // Listener for position changes
    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });

    // Load the audio file to get its duration - Changed by Abhay
    audioPlayer.setSource(AssetSource('audio/song.mp3'));
  }
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
  Widget miniPlayer(){
    return AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        color: Colors.blueGrey,
        width: double.infinity,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.network("https://i.scdn.co/image/ab67616d0000b273ba5db46f4b838ef6027e6f96",fit: BoxFit.cover,),
            Text("Song A",style: TextStyle(color: Colors.white),),
            IconButton(
              icon:Icon(_isPlaying?Icons.pause:Icons.play_arrow,color:Colors.white,size: 30,),
              onPressed: () async{
                if(_isPlaying){
                  await audioPlayer.pause();
                }
                else{
                  await audioPlayer.play(AssetSource('audio/song.mp3'));
                }
              },
            )
          ],
        ),
    );
  }
  final List<Widget> _screens = [
    Home(),
    Library(),
    Settings(),
  ];
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            miniPlayer(),
            BottomNavigationBar(
              unselectedLabelStyle: const TextStyle(color: Colors.white, fontSize: 14),
              fixedColor: Colors.white,
              unselectedItemColor: Colors.white,
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home,color: Colors.white,size: 30,),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.library_music_outlined,color: Colors.white,size: 30,),
                  label: 'Library',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person,color: Colors.white,size: 30,),
                  label: 'Profile',
                ),
              ],
              backgroundColor: Colors.black,
            ),
          ],
        ),

    );
  }

}

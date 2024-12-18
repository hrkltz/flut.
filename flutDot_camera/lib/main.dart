import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';

import 'package:flutdot_camera/view/a_view.dart';
import 'package:flutdot_camera/view/b_view.dart';
import 'package:flutdot_camera/view/c_view.dart';
import 'package:video_player/video_player.dart';


Future<void> main() async {
  runApp(
    WidgetsApp(
      debugShowCheckedModeBanner: false,
      color: const Color(0xFFFFFFFF,),
      builder: (context, child) {
        return child ?? const SizedBox.shrink();
      },
      pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) {
        return PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => builder(context,),
          transitionDuration: const Duration(seconds: 0,),
          reverseTransitionDuration: const Duration(seconds: 0,),
        );
      },
      home: Builder(
        builder: (context) {
          return Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 64.0, 10.0, 64.0,),
              child: Column(
              children: <Widget>[
                FlutDotTextField(title: 'flut.Camera', text: 'Welcome to the flut.Camera app, a part of the flutDot project! The flutDot project aims to provide simple, easy-to-follow examples for leveraging hardware devices and common software solutions using Flutter. Each example is designed to be as straightforward as possible, helping you grasp the concepts quickly and effectively.\n\nSource code: https://github.com/hrkltz/flutDot',),
                const SizedBox(height: 20.0,),
                FlutDotButton(text: 'A: Open The Camera', onTapped: () => Navigator.of(context).push(routeBuilder(view: const AView(),),),),
                const SizedBox(height: 20.0,),
                FlutDotButton(text: 'B: Shot A Picture', onTapped: () => Navigator.of(context).push(routeBuilder(view: const BView(),),),),
                const SizedBox(height: 20.0,),
                FlutDotButton(text: 'C: Take A Video', onTapped: () => Navigator.of(context).push(routeBuilder(view: const CView(),),),),
              ],
            ),
          );
        },
      ),
    ),
  );
}


PageRouteBuilder<T?> routeBuilder<T>({required Widget view}) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => view,
    transitionDuration: const Duration(seconds: 0,),
    reverseTransitionDuration: const Duration(seconds: 0,),
  );
}


class FlutDotTextField extends StatelessWidget {
  const FlutDotTextField({super.key, required this.title, required this.text,});


  final String title;
  final String text;


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0,),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 1,),
        borderRadius: BorderRadius.circular(10.0,),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Color.fromRGBO(0, 0, 0, 1,),),),
          const SizedBox(height: 10.0,),
          Text(text, style: const TextStyle(color: Color.fromRGBO(0, 0, 0, 1,),),),
        ],
      ),
    );
  }
}


class FlutDotButton extends StatelessWidget {
  const FlutDotButton({super.key, required this.text, required this.onTapped,});


  final String text;
  final VoidCallback onTapped;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapped,
      child: Container(
        height: 48.0,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 255, 255, 1,),
          borderRadius: BorderRadius.circular(24.0,),
        ),
        child: Center(child: Text(text, style: const TextStyle(color: Color.fromRGBO(0, 0, 0, 1,)),),),
      ),
    );
  }
}


//* FlutDotVideoPlayer - START
class FlutDotVideoPlayer extends StatefulWidget {
  const FlutDotVideoPlayer({super.key, required this.path,});


  final String path;


  @override
  _FlutDotVideoPlayerState createState() => _FlutDotVideoPlayerState();
}


class _FlutDotVideoPlayerState extends State<FlutDotVideoPlayer> {
  late VideoPlayerController _controller;


  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.path,),)
      ..initialize().then((_) {
        _controller.play();
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : Container(),
    );
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
//* FlutDotVideoPlayer - END


class OverlayUtil {
  static void show(BuildContext context, Widget child, {Duration duration = const Duration(seconds: 3)}) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Container(
        color: Color.fromRGBO(0, 0, 0, 0.75,),
        height: double.infinity,
        width: double.infinity,
        child: Center(child: child,),
      ),
    );

    // Insert the overlay
    overlay.insert(overlayEntry,);

    // Remove the overlay after the specified duration
    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }
}

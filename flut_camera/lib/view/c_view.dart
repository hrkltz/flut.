import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';

import 'package:flutdot_camera/main.dart';


class CView extends StatefulWidget {
  const CView({ super.key});


  @override
  CViewState createState() => CViewState();
}


class CViewState extends State<CView> {
  late CameraController _controller;
  bool _isReady = false;
  bool _isRecording = false;


  @override
  void initState() {
    super.initState();

    availableCameras().then((cameras) {
      _controller = CameraController(
        cameras.first,
        ResolutionPreset.medium,
      );

      _controller.initialize().then((state) {
        if (!mounted) {
          return;
        }
        
        setState(() {
          _isReady = true;
        });
      }).catchError((Object e) {
        if (e is CameraException) {
          if (!context.mounted) return;
          OverlayUtil.show(context, Text('Camera error: ${e.code}',),);
        }
      });
    });
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      return const Center(child: Text('Loading...'));
    }

    // Use a GestureDetector to detect a tap on the screen.
    return GestureDetector(
      onTap: () {
        if (!_isRecording) {
          // The camera is not recording, so start recording now.
          _controller.startVideoRecording().then((value) {
            if (!context.mounted) return;
            setState(() {
              _isRecording = true;
            });
          }).onError((error, stackTrace) {
            if (!context.mounted) return;
            OverlayUtil.show(context, Text('Error: $error',),);
          });
        } else {
          // The camera is recording, so stop recording now and show the video in an overlay. 
          _controller.stopVideoRecording().then((value) {
            if (!context.mounted) return;
            setState(() {
              _isRecording = false;
            });
            OverlayUtil.show(context, FlutDotVideoPlayer(path: value.path,),);
          }).onError((error, stackTrace) {
            if (!context.mounted) return;
            OverlayUtil.show(context, Text('Error: $error',),);
          });
        }
      },
      child: CameraPreview(_controller,),);
  }
}
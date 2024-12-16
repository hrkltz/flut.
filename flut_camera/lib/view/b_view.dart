import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';

import 'package:flut_camera/main.dart';


class BView extends StatefulWidget {
  const BView({ super.key});


  @override
  BViewState createState() => BViewState();
}


class BViewState extends State<BView> {
  late CameraController _controller;
  bool _isReady = false;


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
        // Take a picture and show it in an overlay.
        _controller.takePicture().then((image) {
          if (!context.mounted) return;
          OverlayUtil.show(context, Image.file(File(image.path,),),);
        }).onError((error, stackTrace) {
          if (!context.mounted) return;
          OverlayUtil.show(context, Text('Error: $error',),);
        });
      },
      child: CameraPreview(_controller,),);
  }
}
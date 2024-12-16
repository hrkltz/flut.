import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';

import 'package:flut_camera/main.dart';


class AView extends StatefulWidget {
  const AView({ super.key});


  @override
  AViewState createState() => AViewState();
}


class AViewState extends State<AView> {
  late CameraController _controller;
  bool _isReady = false;


  @override
  void initState() {
    super.initState();

    // As a first step obtain a list of all the available cameras on the device.
    availableCameras().then((cameras) {
      // And now you can create a CameraController to display the camera output.
      _controller = CameraController(
        // Use the first camera from the 'cameras' list object.
        cameras.first,
        // Set the desired resolution for the camera.
        ResolutionPreset.medium,
      );

      // Next, initialize the controller for the camera.
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
    // Dispose of the controller.
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // The connecting process can take some time, therefore it's needed to wait until the controller is initialized.
    if (!_isReady) {
      return const Center(child: Text('Loading...'));
    }

    // If the Future is complete, display the preview.
    return CameraPreview(_controller,);
  }
}
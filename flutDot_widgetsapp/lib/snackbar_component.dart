import 'package:flutter/widgets.dart';


class SnackbarComponent {
  static void show(BuildContext context, String message, {Duration duration = const Duration(seconds: 3)}) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 50.0,
        left: 20.0,
        right: 20.0,
        child: _SnackbarWidget(message: message),
      ),
    );

    // Insert the overlay
    overlay.insert(overlayEntry);

    // Remove the overlay after the specified duration
    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }
}


class _SnackbarWidget extends StatelessWidget {
  final String message;


  const _SnackbarWidget({Key? key, required this.message}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: const Color(0xDD333333), // Semi-transparent black
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: Color(0xFFFFFFFF), // White color
          fontSize: 16.0,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_colors.dart';
import 'package:midnightcity/constants/app_images.dart';
import 'package:velocity_x/velocity_x.dart';
import 'dart:math' as math;

// class LoadingShimmer extends StatelessWidget {
//   const LoadingShimmer({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     //
//     final linerHeight = (context.percentHeight * 8) * 0.17;
//     //
//     return Container(
//       child: VxBox(
//         child: VStack(
//           [
//             Align(
//                 alignment: Alignment.center,
//                 child: Image.asset(height: 80, AppImages.gif)),
//
//             /*( Container(
//               color: Colors.grey[400],
//             ).h(linerHeight), */
//           ],
//         ),
//       )
//           .height(context.percentHeight * 12)
//           .width(context.percentWidth * 100)
//           .clip(Clip.antiAlias)
//           .make(),
//     );
//   }
// }

// class LoadingShimmer extends StatefulWidget {
//   @override
//   _RotatingLogoState createState() => _RotatingLogoState();
// }
//
// class _RotatingLogoState extends State<LoadingShimmer>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     )..repeat(); // Makes the animation repeat indefinitely
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _controller,
//       child: Align(
//           alignment: Alignment.center,
//           child: Image.asset(AppImages.appLogo, width: 100, height: 100)),
//       builder: (context, child) {
//         return Transform.rotate(
//           angle: _controller.value * 2.0 * math.pi,
//           child: child,
//         );
//       },
//     );
//   }
// }
// class LoadingShimmer extends StatefulWidget {
//   @override
//   _FadeInLogoState createState() => _FadeInLogoState();
// }

class _FadeInLogoState extends State<LoadingShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize AnimationController and define duration for the animation.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Animation duration is 2 seconds
    );

    // Define the animation to go from 0 (invisible) to 1 (fully visible).
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    // Start the animation on app start.
    _controller.forward();
  }

  @override
  void dispose() {
    // Dispose the controller when not in use.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation, // Apply the animation to the opacity.
      child: Image.asset(
        AppImages.appLogo, // Your app logo here.
        width: 100, // Customize the width as needed.
        height: 100, // Customize the height as needed.
      ),
    );
  }
}

class LoadingShimmer extends StatefulWidget {
  @override
  _DissolveLogoState createState() => _DissolveLogoState();
}

class _DissolveLogoState extends State<LoadingShimmer>
    with SingleTickerProviderStateMixin {
  double _opacity = 1.0; // Initially the logo is fully visible.
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Create an animation controller that will control the dissolve timing.
    _controller = AnimationController(
      duration: const Duration(seconds: 3), // Animation duration is 3 seconds.
      vsync: this,
    );

    // Start the dissolve animation.
    _startDissolve();
  }

  // A function to trigger the dissolve effect.
  void _startDissolve() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        // Reduce opacity gradually.
        _opacity = 0.0;
      });

      // Start the controller.
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller
        .dispose(); // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity, // Use the updated opacity for the dissolve effect.
      duration: Duration(seconds: 2), // Set the dissolve duration to 2 seconds.
      child: Image.asset(
        AppImages.gif, // Path to the app logo.
        width: 100, // Customize size as needed.
        height: 100, // Customize size as needed.
      ),
    );
  }
}

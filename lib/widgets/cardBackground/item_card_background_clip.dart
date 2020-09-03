import 'package:flutter/cupertino.dart';

class ItemCardBackgroundClipper extends CustomClipper<Path>
{
  @override
  Path getClip(Size size) {
    Path clippedPath = Path();
    double curveDistance = 40;

    clippedPath.moveTo(0, size.height * 0.4);
    clippedPath.lineTo(0, size.height - curveDistance);
    clippedPath.quadraticBezierTo(1, size.height - 1, 0 + curveDistance, size.height);
    clippedPath.lineTo(size.width - curveDistance, size.height);
    clippedPath.quadraticBezierTo(
      size.width + 1,
     size.height -1,
      size.width,
       size.height - curveDistance
       );
       clippedPath.lineTo(size.width, 0 + curveDistance);
       clippedPath.quadraticBezierTo
       (
         size.width - 1,
          0,
           size.width - curveDistance - 5,
          0 + curveDistance /3);

          clippedPath.lineTo(curveDistance, size.height * 0.29);
          clippedPath.quadraticBezierTo(
            1,
             (size.height * 0.30) + 10,
              0,
            size.height * 0.4);


    return clippedPath;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
  
}


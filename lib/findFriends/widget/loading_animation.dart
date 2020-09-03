import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Shimmer.fromColors(
        baseColor: Colors.white12,
        highlightColor: Colors.white54,
        child: ListView
        .builder(
          itemCount: 6,
          itemBuilder: (context, index) {
          return Container
          (
            color: Colors.black,
            height: 300.0,
          );
        },
        )
        ),
    );
  }
}

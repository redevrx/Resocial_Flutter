import 'package:flutter/material.dart';
import 'package:socialapp/widgets/cardBackground/item_card_shaps.dart';

class _ItemsWidget extends StatelessWidget {
  final double screenWidth, screenHeight;

  const _ItemsWidget({Key key, this.screenWidth, this.screenHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight * 0.42,
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      child: PageView.builder(
        itemCount: 2,
        controller: PageController(viewportFraction: 0.7),
        itemBuilder: (context, i) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Stack(
              children: <Widget>[
                Material(
                  elevation: 10.0,
                  shape: ItemCardShape(screenWidth * 0.64, screenHeight * 0.38),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment(0, -0.1),
                    child: Image.asset(""),
                  ),
                ),
                Positioned(
                  bottom: 50.0,
                  left: 32.0,
                  right: 32.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Data",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.w800),
                      ),
                      Text(
                        "NEw",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
                Positioned(
                  right: 20.0,
                  top: 40.0,
                  child: Image.asset(
                    'assets/images/ps.png',
                    width: 50.0,
                    height: 50.0,
                    color: Colors.black.withOpacity(0.4),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

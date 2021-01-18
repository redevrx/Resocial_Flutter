import 'package:flutter/material.dart';
import 'package:socialapp/home/screen/home_page.dart';

class widgetAppBarPost extends StatelessWidget {
  final String message;
  final BoxConstraints constraints;
  const widgetAppBarPost({
    Key key,
    this.constraints,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: constraints.maxHeight * .16,
      decoration: BoxDecoration(
          color: Colors.blueAccent,
          boxShadow: [
            BoxShadow(
                color: Colors.lightBlueAccent,
                blurRadius: 18,
                offset: Offset(.5, .5),
                spreadRadius: .5)
          ],
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50.0))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 40.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  child: Icon(
                    Icons.arrow_back_ios_outlined,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => HomePage(
                            pageNumber: 0,
                          ),
                        ),
                        (route) => false);
                  },
                ),
                Text(
                  '${message}',
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      .copyWith(color: Colors.white),
                ),
                Opacity(
                  opacity: 0,
                  child: Icon(
                    Icons.search,
                    size: 30.0,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

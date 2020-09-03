import 'package:flutter/material.dart';


class widgetAppBarPost extends StatelessWidget {
  final String message;
  final BoxConstraints constraints;
  const widgetAppBarPost({
    Key key, this.constraints, this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: constraints.maxHeight * .16,
      decoration: BoxDecoration(
          color: Colors.blue.withOpacity(.15),
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
                    Icons.arrow_back_ios,
                    size: 30.0,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                Text(
                  '${message}',
                  style: Theme.of(context).textTheme.headline4,
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

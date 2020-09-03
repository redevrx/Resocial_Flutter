import 'package:flutter/material.dart';
import 'package:socialapp/findFriends/screens/show_lis_friends.dart';

class appBarSetting extends StatefulWidget {
  final bool changeSize;

  const appBarSetting({Key key, this.changeSize}) : super(key: key);
  @override
  _appBarSettingState createState() => _appBarSettingState();
}

class _appBarSettingState extends State<appBarSetting> {
  bool size;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    size = widget.changeSize;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 700),
        height: size ? 140.0 : 120.0,
        color: Color(0xFFF3EFF9),
        child: Material(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50.0)),
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
                        Icons.settings,
                        size: 30.0,
                      ),
                      onTap: () {
                        setState(() {
                          size = !size;
                        });
                      },
                    ),
                    Text(
                      'Setting App',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                   InkWell
                   (
                     child: Icon(Icons.search , size: 30.0,),
                     onTap: (){
                       Navigator.of(context).push(MaterialPageRoute(builder: (context) => AllUser(),));
                     },
                   )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

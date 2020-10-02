import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/edit_profile_bloc.dart';
import 'package:socialapp/Profile/EditPtofile/screen/user_profile.dart';
import 'package:socialapp/home/export/export_file.dart';
import 'package:socialapp/likes/bloc/likes_bloc.dart';
import 'package:socialapp/likes/export/export_like.dart';
import 'package:socialapp/textMore/bloc/text_more_bloc.dart';
import 'package:socialapp/userPost/bloc/post_bloc.dart';
import 'package:socialapp/userPost/repository/post_repository.dart';
import 'package:socialapp/widgets/bottonBar/animate_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:socialapp/settingApp/export/setting_export.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  final int pageNumber;

  const HomePage({Key key, this.pageNumber = 0}) : super(key: key);

  @override
  _fechPage createState() => _fechPage();
}

class _fechPage extends State<HomePage> {
  final List<BarItem> barIitems = [
    BarItem("Home", Icons.home, Color(0xFF498AEF)),
    BarItem("Notify", Icons.notifications_active, Colors.pinkAccent),
    //BarItem("Search", Icons.search, Colors.yellow.shade900),
    BarItem("Profile", Icons.person_outline, Colors.teal),
    BarItem("Setting", Icons.menu, Colors.black)
  ];
  int selectedBar = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedBar = widget.pageNumber;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: BlocProvider(
            create: (context) => MyFeedBloc(new FeedRepository()),
            child: BlocProvider(
                create: (context) => TextMoreBloc(),
                child: BlocProvider(
                    create: (context) => LikeBloc(new LikeRepository()),
                    child: BlocProvider(
                        create: (context) => PostBloc(new PostRepository()),
                        child: BlocProvider(
                            create: (context) => EditProfileBloc(),
                            child: IndexedStack(
                              index: selectedBar,
                              children: [
                                homePage(
                                  bodyColor: barIitems[selectedBar].color,
                                ),
                                homePage(
                                  bodyColor: barIitems[selectedBar].color,
                                ),
                                UserProfile(
                                  bodyColor: barIitems[selectedBar].color,
                                ),
                                SettingApp()
                              ],
                            )
                            // selectedBar == 0
                            //     ? homePage(
                            //         bodyColor: barIitems[selectedBar].color,
                            //       )
                            //     : selectedBar == 1
                            //         ? homePage(
                            //             bodyColor: barIitems[selectedBar].color,
                            //           )
                            //         : selectedBar == 2
                            //             ? UserProfile(
                            //                 bodyColor:
                            //                     barIitems[selectedBar].color,
                            //               ) //AllFriends()
                            //             : selectedBar == 3
                            //                 ? SettingApp()
                            //                 : Container(),
                            ))))),
        bottomNavigationBar: AnimationBottomBar(
            barItems: barIitems,
            animationDuration: const Duration(microseconds: 4000),
            barStyle: BarStyle(
                fointSize: 20.0, fontWeight: FontWeight.w400, iconSize: 30.0),
            onBarTab: (index) {
              setState(() {
                selectedBar = index;
                print('position selected page :$selectedBar');
                //chage color page use index bottom bar -> barItems[selectedBar]
              });
            }),
      ),
      onWillPop: () {
        // _onBackPressed();
        new Future(() => false);
      },
    );
  }

  Future<bool> _onBackPressed() async {
    // Your back press code here...
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            child: Text("data"),
          ),
        );
      },
    );
  }
}

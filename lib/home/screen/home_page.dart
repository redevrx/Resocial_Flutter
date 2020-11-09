import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/edit_profile_bloc.dart';
import 'package:socialapp/Profile/EditPtofile/screen/user_profile.dart';
import 'package:socialapp/home/bloc/bloc_pageChange.dart';
import 'package:socialapp/home/bloc/state_pageChange.dart';
import 'package:socialapp/home/export/export_file.dart';
import 'package:socialapp/likes/bloc/likes_bloc.dart';
import 'package:socialapp/likes/export/export_like.dart';
import 'package:socialapp/notifications/exportNotify.dart';
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
  //Bar Item use in bittin bar naviagator
  final List<BarItem> barIitems = [
    BarItem("Home", Icons.home, Color(0xFF498AEF)),
    BarItem("Notify", Icons.notifications_active, Colors.pinkAccent),
    //BarItem("Search", Icons.search, Colors.yellow.shade900),
    BarItem("Profile", Icons.person_outline, Colors.teal),
    BarItem("Setting", Icons.menu, Colors.black)
  ];

  PageNaviagtorChageBloc pageBloc;
  //initial value page
  //0 is home page
  int selectedBar = 0;
  //initial page object
  List<Widget> pageItem = [];

  //check user login
  Future<void> checkUserlogin() async {
    try {
      FirebaseAuth.instance.authStateChanges().listen((user) async {
        if (user == null) {
          Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false);
        } else {
          //
          final _pref = await SharedPreferences.getInstance();
          await _pref.setString("uid", user.uid.toString());
        }
      });
    } catch (e) {
      print("error from home page get User id :$e");
    }
  }

  @override
  void initState() {
    //new instance bloc page
    pageBloc = BlocProvider.of<PageNaviagtorChageBloc>(context);
    //check user login and
    //keep ui as shared pref
    checkUserlogin();

    //page value list
    pageItem = [
      homePage(
        bodyColor: barIitems[selectedBar].color,
      ),
      NotifyScreen(
        bodyColor: Colors.pinkAccent,
      ),
      UserProfile(
        bodyColor: barIitems[selectedBar].color,
      ),
      SettingApp()
    ];

    selectedBar = widget.pageNumber;

    super.initState();
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
                            child: BlocProvider(
                              create: (context) => NotifyBloc(NotifyLoading()),
                              child: BlocBuilder<PageNaviagtorChageBloc,
                                  PageChangeState>(
                                builder: (context, state) {
                                  if (state is onPageChangeState) {
                                    selectedBar = state.pageNumber;
                                    return IndexedStack(
                                      index: state.pageNumber,
                                      children: pageItem,
                                    );
                                  }
                                  return IndexedStack(
                                    index: 0,
                                    children: pageItem,
                                  );
                                },
                              ),
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
        bottomNavigationBar: BlocProvider(
          create: (context) => NotifyBloc(NotifyLoading()),
          child: AnimationBottomBar(
              pageBloc: pageBloc,
              barItems: barIitems,
              animationDuration: const Duration(milliseconds: 550),
              barStyle: BarStyle(
                  fointSize: 20.0, fontWeight: FontWeight.w400, iconSize: 30.0),
              onBarTab: (index) {
                // setState(() {
                // selectedBar = index;
                //   print('position selected page :$selectedBar');
                //   //chage color page use index bottom bar -> barItems[selectedBar]
                // });
              }),
        ),
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

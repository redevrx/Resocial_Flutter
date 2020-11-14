import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/findFriends/eport/export_friend.dart';
import 'dart:async';
import 'package:socialapp/findFriends/friendManagement/bloc/friend_manage_bloc.dart';
import 'package:socialapp/findFriends/friendManagement/repository/friensManagement_repository.dart';
import 'package:socialapp/showFriend/widget/widget_show_all_freind.dart';
import 'package:socialapp/showFriend/widget/widget_show_request.dart';

class ShowFriends extends StatelessWidget {
  final String wordSate;
  const ShowFriends({Key key, this.wordSate = "Please Connect Internet..."})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
      create: (context) => FriendManageBloc(new FriensManageRepo()),
      child: BlocProvider(
        create: (context) => FriendBloc(new FriendRepository()),
        child: widgetShowState(
          wordSate: wordSate,
        ),
      ),
    ));
  }
}

class widgetShowState extends StatelessWidget {
  final String wordSate;

  const widgetShowState({Key key, this.wordSate}) : super(key: key);

  void checkStateWork(FriendBloc friendBloc) {
    if (wordSate == "All Friends") {
      // request friends data and show
      friendBloc.add(onLoadFriendUserClick());
    }

    if (wordSate == "Request Friends") {
      // request friends data and show
      friendBloc.add(onLoadRequestFriendUserClick());
    }
  }

  @override
  Widget build(BuildContext context) {
    final friendBloc = BlocProvider.of<FriendBloc>(context);
    final friendManagerBloc = BlocProvider.of<FriendManageBloc>(context);

    checkStateWork(friendBloc);
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              children: <Widget>[
                //app bar

                Container(
                  height: constraints.maxHeight * .15,
                  padding:
                      const EdgeInsets.only(top: 32.0, left: 0.0, right: 0.0),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.blue,
                          offset: Offset(.5, .5),
                          blurRadius: 18.0,
                          spreadRadius: 1.0)
                    ],
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50.0),
                        bottomRight: Radius.circular(50.0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_outlined,
                            size: 30.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          "${wordSate}",
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              .apply(color: Colors.white),
                        ),
                      ),
                      Opacity(
                        opacity: 0.0,
                        child: Container(),
                      )
                    ],
                  ),
                ),
                // add bloc check status
                BlocBuilder<FriendBloc, FriendState>(
                  builder: (context, state) {
                    if (state is onLoadFriendUserSuccessfully) {
                      // event load friend of current user
                      // print("Item Count :${state.list.length}");
                      return widgetShowAllfreind(
                        constraints: constraints,
                        list: state.list,
                      );
                    }
                    if (state is onLoadRequestFriendUserSuccessfully) {
                      return widgetShowRequest(
                        constraints: constraints,
                        list: state.list,
                        friendManagerBloc: friendManagerBloc,
                        friendBloc: friendBloc,
                      );
                    }
                    // return  loading page and show status cinnect internet
                    // or error
                    return Container();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

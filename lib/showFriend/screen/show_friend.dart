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

class widgetShowState extends StatefulWidget {
  final String wordSate;

  const widgetShowState({Key key, this.wordSate}) : super(key: key);
  @override
  _widgetShowStateState createState() => _widgetShowStateState();
}

class _widgetShowStateState extends State<widgetShowState> {
  Future<void> checkStateWork(FriendBloc friendBloc) async {
    if (widget.wordSate == "All Friends") {
      // request friends data and show
      friendBloc.add(onLoadFriendUserClick());
    }

     if (widget.wordSate == "Request Friends") {
      // request friends data and show
      friendBloc.add(onLoadRequestFriendUserClick());
    }
  }

  @override
  Widget build(BuildContext context) {
    final FriendBloc friendBloc = BlocProvider.of<FriendBloc>(context);
     final FriendManageBloc friendManagerBloc = BlocProvider.of<FriendManageBloc>(context);

    checkStateWork(friendBloc);
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              children: <Widget>[
                Container(
                  height: constraints.maxHeight * .15,
                  padding: const EdgeInsets.only(top: 32.0),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(.30),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50.0),
                        bottomRight: Radius.circular(50.0)),
                  ),
                  child: Center(
                    child: Text(
                      "${widget.wordSate}",
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .apply(color: Color(0xFF498AEF)),
                    ),
                  ),
                ),
                // add bloc check status
                BlocBuilder<FriendBloc, FriendState>(
                  builder: (context, state) {
                    if (state is onLoadFriendUserSuccessfully) {
                      // event load friend of current user
                      // print("Item Count :${state.list.length}");
                      return widgetShowAllfreind(constraints: constraints,list: state.list,);
                    }
                    if(state is onLoadRequestFriendUserSuccessfully)
                    {
                      return widgetShowRequest(constraints: constraints,list: state.list,);
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

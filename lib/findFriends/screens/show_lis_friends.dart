import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/utils/utils.dart';
import '../eport/export_friend.dart';

class AllUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FriendRepository frindRepository = FriendRepository();

    return Scaffold(
      body: BlocProvider(
        create: (context) => FriendBloc(frindRepository),
        child: allFriends(),
      ),
    );
  }
}

class allFriends extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final friendsBloc = BlocProvider.of<FriendBloc>(context);
    friendsBloc.add(onLoadFriendsClick());

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: ScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Container(
              child: Column(
                children: <Widget>[
                  BlocBuilder<FriendBloc, FriendState>(
                    builder: (context, state) {
                      if (state is onLoadFriendsSuccessfully) {
                        //if laod success if send data as
                        //ResultFindFriend page
                        //event this will work when
                        //page loading and call onLoadFriendsClick()
                        //and will search friend in SearchFriends page
                        return SearchFriends(
                          constraints: constraints,
                          friendBloc: friendsBloc,
                          list: state.list,
                        );
                      }
                      if (state is onShowLoadingWidget) {
                        return CircularProgressIndicator(); //LoadingAnimation();
                      }
                      if (state is onFindFriendResult) {
                        //if laod success if send data as
                        //Result FindFriend page
                        //event this is result of search friend in
                        //firestore
                        // ResultFindFriend() not use
                        return SearchFriends(
                          constraints: constraints,
                          list: state.list,
                          friendBloc: friendsBloc,
                        );
                      }
                      if (state is onLoadFrindFailed) {
                        //if onLoadFrindFailed
                        //if load new friend
                        friendsBloc.add(onLoadFriendsClick());
                        return Center(
                            child: Container(child: Text(state.data)));
                      }
                      return Container();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

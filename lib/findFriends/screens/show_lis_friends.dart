import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/findFriends/widget/result_find_friend.dart';
import '../eport/export_friend.dart';

class AllUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FriendRepository frindRepository = FriendRepository();

    return Scaffold
    (
      body: BlocProvider(
      create: (context) => FriendBloc(frindRepository),
      child: allFriends(),
    ),
    );
  }
}

class allFriends extends StatefulWidget {
  @override
  _allFriendsState createState() => _allFriendsState();
}

class _allFriendsState extends State<allFriends> {
  @override
  Widget build(BuildContext context) {
    final friendsBloc = BlocProvider.of<FriendBloc>(context);

    setState(() {
        friendsBloc.add(onLoadFriendsClick());
    });
   
    return LayoutBuilder(
      builder: (context, constraints) {
      return SingleChildScrollView
      (
        physics: ScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: ConstrainedBox(
          constraints: BoxConstraints
        (
          minHeight: constraints.maxHeight
        ),
        child: Container(
          child: Column
          (
            children: <Widget>[
           BlocBuilder<FriendBloc, FriendState>(
             builder: (context, state) {
               if(state is onLoadFriendsSuccessfully)
               {
                  return SearchFriends(constraints: constraints,friendBloc: friendsBloc,list: state.list,);
               }
              if(state is onShowLoadingWidget)
               {
                 return  Container();//LoadingAnimation();
               }
                if (state is onFindFriendResult) 
                {
                  return ResultFindFriend(constraints: constraints,list: state.list,friendBloc: friendsBloc,);
                }
               if(state is onLoadFrindFailed)
               {
                 return Center(child: Container(child: Text(state.data)));
               }
               return Container();
             },
           )
            ],
          ),
        ),
        ),
      );
    },);
  }
}

import 'package:flutter/material.dart';
import 'package:material_buttonx/materialButtonX.dart';
import 'package:socialapp/findFriends/eport/export_friend.dart';
import 'dart:async';

class widgetShowAllfreind extends StatelessWidget {
  const widgetShowAllfreind({
    Key key,
    this.constraints,
    this.list,
    this.friendManageBloc,
    this.friendBloc,
  }) : super(key: key);

  final BoxConstraints constraints;
  final List<FrindsModel> list;
  final FriendManageBloc friendManageBloc;
  final FriendBloc friendBloc;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        friendBloc.add(onLoadFriendUserClick());
      },
      child: Container(
        height: constraints.maxHeight * .85,
        child: list.length == 0
            ? Center(
                child: Text("You not have freinds"),
              )
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, i) {
                  //friendManagerBloc.add(onCheckStatusFrinds(uid: state.list[i].uid));
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RequestFriend(
                          userId: list[i].uid,
                        ),
                      ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            ClipOval(
                              child: Image.network(
                                "${list[i].imageProfile}",
                                fit: BoxFit.cover,
                                width: 90.0,
                                height: 90.0,
                              ),
                            ),
                            SizedBox(
                              width: 16.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "${list[i].userName}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      decorationThickness: 4.0,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w400),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Tooltip(
                                        message: "Remove Freind",
                                        padding: EdgeInsets.all(20),
                                        margin: EdgeInsets.all(20),
                                        showDuration: Duration(seconds: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.withOpacity(0.9),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(4)),
                                        ),
                                        textStyle:
                                            TextStyle(color: Colors.black12),
                                        preferBelow: true,
                                        verticalOffset: 20,
                                        child: MaterialButtonX(
                                          message: "R",
                                          width: 80.0,
                                          height: 32.0,
                                          color:
                                              Colors.redAccent.withOpacity(.89),
                                          icon: Icons.remove_circle_outline,
                                          iconSize: 22.0,
                                          radius: 32.0,
                                          onClick: () async {
                                            // request friends data and show

                                            await _showRemoveFreindDialog(
                                                context,
                                                friendManageBloc,
                                                list[i].uid);

                                            friendBloc
                                                .add(onLoadFriendUserClick());
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 32.0,
                                      ),
                                      Tooltip(
                                        message: "Block Freind",
                                        padding: EdgeInsets.all(20),
                                        margin: EdgeInsets.all(20),
                                        showDuration: Duration(seconds: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.withOpacity(0.9),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(4)),
                                        ),
                                        textStyle:
                                            TextStyle(color: Colors.black12),
                                        preferBelow: true,
                                        verticalOffset: 20,
                                        child: MaterialButtonX(
                                          message: "B",
                                          width: 80.0,
                                          height: 32.0,
                                          color: Colors.red.withOpacity(.89),
                                          icon: Icons.block_rounded,
                                          iconSize: 22.0,
                                          radius: 32.0,
                                          onClick: () async {
                                            await _showBlockFreindDialog(
                                                context);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

Future<void> _showRemoveFreindDialog(
    BuildContext context, FriendManageBloc friendManageBloc, String uid) {
  bool _from = false;
  return showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: "remove freind sure ?",
    context: context,
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
          child: child,
          position: Tween(begin: Offset(0, _from ? -1 : 1), end: Offset.zero)
              .animate(animation));
    },
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 900),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Align(
        alignment: _from ? Alignment.topCenter : Alignment.bottomCenter,
        child: Container(
            height: 180.0,
            width: double.infinity,
            margin: EdgeInsets.only(top: 90, left: 12, right: 12, bottom: 90),
            padding: EdgeInsets.only(right: 6.0),
            decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(18.0)),
            child: Stack(
              children: [
                Positioned(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                    height: 180.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    child: SizedBox.expand(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 12.0,
                          ),
                          Text(
                            "Are you sure Remove this freind ?",
                            style: TextStyle(
                                fontSize: 22.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                decorationColor: Colors.white),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 32.0, horizontal: 32.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Material(
                                  child: MaterialButtonX(
                                    message: "Yes",
                                    width: 110.0,
                                    height: 38.0,
                                    color: Colors.green,
                                    icon: Icons.cached_outlined,
                                    iconSize: 22.0,
                                    radius: 30.0,
                                    onClick: () {
                                      friendManageBloc.add(onRemoveFriendClick(
                                        data: uid,
                                      ));
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                                Material(
                                  child: MaterialButtonX(
                                    message: "Cancel",
                                    width: 110.0,
                                    height: 38.0,
                                    color: Colors.red.withOpacity(.89),
                                    icon: Icons.cancel_outlined,
                                    iconSize: 22.0,
                                    radius: 30.0,
                                    onClick: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )),
      );
    },
  );
}

Future<void> _showBlockFreindDialog(BuildContext context) {
  bool _from = false;
  return showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: "bloc freind sure ?",
    context: context,
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
          child: child,
          position: Tween(begin: Offset(0, _from ? -1 : 1), end: Offset.zero)
              .animate(animation));
    },
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 900),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Align(
        alignment: _from ? Alignment.topCenter : Alignment.bottomCenter,
        child: Container(
            height: 180.0,
            width: double.infinity,
            margin: EdgeInsets.only(top: 90, left: 12, right: 12, bottom: 90),
            padding: EdgeInsets.only(right: 6.0),
            decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(18.0)),
            child: Stack(
              children: [
                Positioned(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                    height: 180.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    child: SizedBox.expand(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 12.0,
                          ),
                          Text(
                            "Are you sure bloc this freind ?",
                            style: TextStyle(
                                fontSize: 22.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                decorationColor: Colors.white),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 32.0, horizontal: 32.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Material(
                                  child: MaterialButtonX(
                                    message: "Yes",
                                    width: 110.0,
                                    height: 38.0,
                                    color: Colors.green,
                                    icon: Icons.cached_outlined,
                                    iconSize: 22.0,
                                    radius: 30.0,
                                    onClick: () {},
                                  ),
                                ),
                                Material(
                                  child: MaterialButtonX(
                                    message: "Cancel",
                                    width: 110.0,
                                    height: 38.0,
                                    color: Colors.red.withOpacity(.89),
                                    icon: Icons.cancel_outlined,
                                    iconSize: 22.0,
                                    radius: 30.0,
                                    onClick: () {},
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )),
      );
    },
  );
}

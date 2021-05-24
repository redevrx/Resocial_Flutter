import 'package:flutter/material.dart';
import 'package:material_buttonx/materialButtonX.dart';
import 'package:socialapp/findFriends/eport/export_friend.dart';
import 'package:socialapp/findFriends/models/findFriendResult_model.dart';
import 'dart:async';

class widgetShowRequest extends StatelessWidget {
  const widgetShowRequest({
    Key key,
    this.constraints,
    this.list,
    this.friendManagerBloc,
    this.friendBloc,
  }) : super(key: key);

  final BoxConstraints constraints;
  final List<FindFreindResultModel> list;
  final FriendManageBloc friendManagerBloc;
  final FriendBloc friendBloc;

  @override
  Widget build(BuildContext context) {
    //call find freind status
    // friendManagerBloc.add(onFindFreindStatus(freindList: list));

    return Container(
      height: constraints.maxHeight * .85,
      child: list.length == 0
          ? Center(
              child: Text("Not Request"),
            )
          : ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, i) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
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
                              SizedBox(
                                height: 12.0,
                              ),
                              (list[i].result == "send")
                                  ? //make ui cancel friend

                                  _buildRowAccept(i)
                                  // widget_accept_friend(
                                  //     friendManageBloc: friendManagerBloc,
                                  //     uid: list[i].uid,
                                  //     type: "request page",
                                  //     i: i,
                                  //   )
                                  : (list[i].result == "success")
                                      ? Text("Success")
                                      :
                                      //make ui accept friend
                                      _buildRowCancel(i),
                              // widget_request_friend(
                              //     friendManageBloc: friendManagerBloc,
                              //     uid: list[i].uid,
                              //     type: "request page",
                              //     i: i,
                              //   ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Row _buildRowCancel(int i) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        MaterialButtonX(
          message: "Cencel",
          height: 36.0,
          width: 110.0,
          color: Colors.red,
          icon: Icons.cancel_outlined,
          iconSize: 18.0,
          radius: 42.0,
          onClick: () {
            print("cancel $i ");
            //item in list that press cancel
            //give item == success
            list[i].result = list[i].result = "success";

            friendManagerBloc.add(onUnRequestFriendClick(data: list[i].uid));

            //relaod ferind status list
            friendBloc.add(onRelaodAllFreindStatsu(model: list));
          },
        ),
      ],
    );
  }

  Row _buildRowAccept(int i) {
    return Row(
      children: [
        MaterialButtonX(
          message: "Accept",
          height: 36.0,
          width: 110.0,
          color: Colors.green,
          icon: Icons.check,
          iconSize: 18.0,
          radius: 42.0,
          onClick: () {
            print("accept $i ");
            //item in list that press cancel
            //give item == success
            list[i].result = list[i].result = "success";

            friendManagerBloc.add(onAcceptFriendClick(data: list[i].uid));

            //relaod ferind status list
            friendBloc.add(onRelaodAllFreindStatsu(model: list));
          },
        ),
        SizedBox(
          width: 16.0,
        ),
        MaterialButtonX(
          message: "Cancel",
          height: 36.0,
          width: 110.0,
          color: Colors.red,
          icon: Icons.cancel_outlined,
          iconSize: 18.0,
          radius: 42.0,
          onClick: () {
            print("cancel $i ");
            //item in list that press cancel
            //give item == success
            list[i].result = list[i].result = "success";

            friendManagerBloc.add(onUnRequestFriendClick(data: list[i].uid));

            //relaod ferind status list
            friendBloc.add(onRelaodAllFreindStatsu(model: list));
          },
        ),
      ],
    );
  }

  CircularProgressIndicator buildStatusFriend(BuildContext context, int i) {
    //call find freind status

    return CircularProgressIndicator();
    //  Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   children: <Widget>[
    //     RaisedButton(
    //       onPressed: () {},
    //       elevation: 8.0,
    //       shape:
    //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    //       color: Colors.blueAccent,
    //       child: Text(
    //         "Cancel",
    //         style: TextStyle(color: Colors.white.withOpacity(.90)),
    //       ),
    //     ),
    //     SizedBox(
    //       width: 32.0,
    //     ),
    //     RaisedButton(
    //       onPressed: () {},
    //       elevation: 8.0,
    //       shape:
    //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    //       color: Colors.grey,
    //       child: Text(
    //         "Block",
    //         style: TextStyle(color: Colors.white.withOpacity(.90)),
    //       ),
    //     ),
    //   ],
    // );
  }
}

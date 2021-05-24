import 'package:flutter/material.dart';
import 'package:socialapp/Profile/EditPtofile/screen/user_profile.dart';
import 'package:socialapp/findFriends/eport/export_friend.dart';
import 'dart:async';

import 'package:socialapp/utils/utils.dart';

//create search box
class SearchFriends extends StatelessWidget {
  final BoxConstraints constraints;
  final List<FrindsModel> list;
  final FriendBloc friendBloc;

  const SearchFriends({Key key, this.constraints, this.list, this.friendBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          //
          _buildContainerSearch(),

          //make list user profile
          buildContainerListProfile()
        ],
      ),
    );
  }

//make list of profile user
//if check user click profile
//if uid of profile == uid thay login
// if not action else go to RequestFriend
  Container buildContainerListProfile() {
    return Container(
      height: constraints.maxHeight * 0.82,
      child: ListView.builder(
        itemCount: list.length,
        physics: ScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemBuilder: (context, i) {
          return Column(
            children: <Widget>[
              Material(
                  child: InkWell(
                onTap: () async {
                  //user click icon profile
                  //that show now

                  //case user click myself profile
                  if (list[i].uid == uid) {
                    print("current user");
                    // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                    // UserProfile(
                    //   bodyColor: Colors.teal,
                    // ),)
                    // );
                  } else {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RequestFriend(
                              userId: list[i].uid,
                            )));
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            height: 55.0,
                            width: 55.0,
                            decoration: BoxDecoration(
                                color: list[i].imageProfile != null
                                    ? Colors.black.withOpacity(.1)
                                    : Colors.black.withOpacity(.15),
                                borderRadius: BorderRadius.circular(50.0),
                                image: DecorationImage(
                                  image: list[i].imageProfile == null ||
                                          list[i].imageProfile.isEmpty
                                      ? NetworkImage(PersonURL)
                                      : NetworkImage("${list[i].imageProfile}"),
                                  fit: BoxFit.cover,
                                )),
                          ),
                          SizedBox(
                            width: 12.0,
                          ),
                          Text(
                            "${list[i].userName}",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      Icon(Icons.more_horiz)
                    ],
                  ),
                ),
              )),
              SizedBox(
                height: 18.0,
              )
            ],
          );
        },
      ),
    );
  }

//build text search
  Container _buildContainerSearch() {
    return Container(
      height: 130.0,
      decoration: BoxDecoration(
          color: Colors.yellow.shade900.withOpacity(.25),
          borderRadius: BorderRadius.only(
            // topLeft: Radius.circular(75.0),
            bottomLeft: Radius.circular(75.0),
          )),
      child: Row(
        children: <Widget>[
          Padding(
              padding:
                  const EdgeInsets.only(top: 28.0, right: 16.0, left: 16.0),
              child: Container(
                height: 40,
                width: constraints.maxWidth * 0.9,
                child: TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    prefixIcon:
                        Icon(Icons.search, color: Colors.yellow.shade900),
                    labelText: "Search",
                    labelStyle: TextStyle(
                        fontSize: 22.0, color: Colors.yellow.shade900),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide(color: Colors.yellow.shade900)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide(color: Colors.yellow.shade900)),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide(color: Colors.yellow.shade900)),
                  ),
                  //if user press submit
                  //if send text search onSearchFriendsClick(data)
                  //and update ui AllUser and AllUser
                  //will send data to this page
                  //for update retult
                  onSubmitted: (value) {
                    var keyWord = value;

                    if (keyWord.isNotEmpty) {
                      print(value);
                      friendBloc.add(onSearchFriendsClick(data: keyWord));
                    } else {
                      print("refesh");
                      friendBloc.add(onLoadRefreshClick());
                    }
                  },
                ),
              )),
        ],
      ),
    );
  }
}

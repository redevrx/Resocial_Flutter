import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialapp/findFriends/eport/export_friend.dart';
import 'dart:async';

class SearchFriends extends StatefulWidget {
  final BoxConstraints constraints;
  final List<FrindsModel> list;
  final FriendBloc friendBloc;

  const SearchFriends({Key key, this.constraints, this.list, this.friendBloc})
      : super(key: key);
  @override
  _SearchFriendsState createState() => _SearchFriendsState();
}

class _SearchFriendsState extends State<SearchFriends> {
  final txtSearchFriends = TextEditingController();

  Future<String> getUserID() async {
    final _mAuth = await FirebaseAuth.instance.currentUser;

    return await _mAuth.uid.toString();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    txtSearchFriends.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
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
                    padding: const EdgeInsets.only(
                        top: 28.0, right: 16.0, left: 16.0),
                    child: Container(
                      height: 40,
                      width: widget.constraints.maxWidth * 0.9,
                      child: TextField(
                        controller: txtSearchFriends,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          prefixIcon:
                              Icon(Icons.search, color: Colors.yellow.shade900),
                          labelText: "Search",
                          labelStyle: TextStyle(
                              fontSize: 22.0, color: Colors.yellow.shade900),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide:
                                  BorderSide(color: Colors.yellow.shade900)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide:
                                  BorderSide(color: Colors.yellow.shade900)),
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide:
                                  BorderSide(color: Colors.yellow.shade900)),
                        ),
                        onEditingComplete: () {
                          var keyWord = txtSearchFriends.text;

                          if (keyWord.isNotEmpty) {
                            print(keyWord);
                            widget.friendBloc
                                .add(onSearchFriendsClick(data: keyWord));
                          } else {
                            print("refesh");
                            widget.friendBloc.add(onLoadRefreshClick());
                          }
                        },
                        onSubmitted: (value) {
                          var keyWord = value;

                          if (keyWord.isNotEmpty) {
                            print(value);
                            widget.friendBloc
                                .add(onSearchFriendsClick(data: keyWord));
                          } else {
                            print("refesh");
                            widget.friendBloc.add(onLoadRefreshClick());
                          }
                        },
                      ),
                    )),
              ],
            ),
          ),
          Container(
            height: widget.constraints.maxHeight * 0.82,
            child: ListView.builder(
              itemCount: widget.list.length,
              physics: ScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, i) {
                return Column(
                  children: <Widget>[
                    Material(
                        child: InkWell(
                      onTap: () async {
                        if (widget.list[i].uid == await getUserID()) {
                          print("current user");
                          // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                          // UserProfile(
                          //   bodyColor: Colors.teal,
                          // ),)
                          // );
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => RequestFriend(
                                    userId: widget.list[i].uid,
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
                                      color: widget.list[i].imageProfile != null
                                          ? Colors.black.withOpacity(.1)
                                          : Colors.black.withOpacity(.15),
                                      borderRadius: BorderRadius.circular(50.0),
                                      image: DecorationImage(
                                        image: widget.list[i].imageProfile !=
                                                null
                                            ? NetworkImage(
                                                "${widget.list[i].imageProfile}")
                                            : NetworkImage(
                                                "https://img.favpng.com/20/11/12/computer-icons-user-profile-png-favpng-0UAKKCpRRsMj5NaiELzw1pV7L.jpg"),
                                        fit: BoxFit.cover,
                                      )),
                                ),
                                SizedBox(
                                  width: 12.0,
                                ),
                                Text(
                                  "${widget.list[i].userName}",
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
          )
        ],
      ),
    );
  }
}

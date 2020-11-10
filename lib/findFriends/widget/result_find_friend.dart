import 'package:flutter/material.dart';
import 'package:socialapp/findFriends/eport/export_friend.dart';

class ResultFindFriend extends StatefulWidget {
  final BoxConstraints constraints;
  final List<FrindsModel> list;
  final FriendBloc friendBloc;

  const ResultFindFriend(
      {Key key, this.constraints, this.list, this.friendBloc})
      : super(key: key);

  @override
  _ResultFindFriendState createState() => _ResultFindFriendState();
}

class _ResultFindFriendState extends State<ResultFindFriend> {
  final txtSearchFriends = TextEditingController();

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
                  topLeft: Radius.circular(75.0),
                  bottomLeft: Radius.circular(75.0),
                )),
            child: Row(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(
                        top: 28.0, right: 16.0, left: 16.0),
                    child: InkWell(
                      onTap: () {
                        widget.friendBloc.add(onLoadFriendsClick());
                      },
                      child: Container(
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: 30.0,
                            color: Colors.yellow.shade900,
                          )),
                    )),
                Padding(
                    padding: const EdgeInsets.only(
                        top: 28.0, right: 16.0, left: 16.0),
                    child: Container(
                      height: 40,
                      width: widget.constraints.maxWidth * 0.75,
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
              itemCount: 1,
              physics: ScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, i) {
                return Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RequestFriend(
                            userId: widget.list[0].uid,
                          ),
                        ));
                      },
                      child: Material(
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
                                        color:
                                            widget.list[0].imageProfile != null
                                                ? Colors.black.withOpacity(.1)
                                                : Colors.black.withOpacity(.15),
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        image: DecorationImage(
                                          image: widget.list[0].imageProfile !=
                                                  null
                                              ? NetworkImage(
                                                  "${widget.list[0].imageProfile}")
                                              : NetworkImage(
                                                  "https://img.favpng.com/20/11/12/computer-icons-user-profile-png-favpng-0UAKKCpRRsMj5NaiELzw1pV7L.jpg"),
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                  SizedBox(
                                    width: 12.0,
                                  ),
                                  Text(
                                    "${widget.list[0].userName}",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              Icon(Icons.more_horiz)
                            ],
                          ),
                        ),
                      ),
                    ),
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

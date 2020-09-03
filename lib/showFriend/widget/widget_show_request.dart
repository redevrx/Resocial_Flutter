import 'package:flutter/material.dart';
import 'package:socialapp/findFriends/eport/export_friend.dart';


class widgetShowRequest extends StatelessWidget {
  const widgetShowRequest({
    Key key, this.constraints, this.list,
  }) : super(key: key);
  
  final BoxConstraints constraints;
  final List<FrindsModel> list;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: constraints.maxHeight * .85,
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, i) {
           //friendManagerBloc.add(onCheckStatusFrinds(uid: state.list[i].uid));
          return Padding(
            padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 8.0,
                bottom: 8.0),
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
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${list[i].userName}",
                        style: TextStyle(
                            color: Colors.black,
                            decorationThickness: 4.0,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w400),
                      ),
                    Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () {},
                            elevation: 8.0,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        8.0)),
                            color: Colors.blueAccent,
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                  color: Colors.white
                                      .withOpacity(.90)),
                            ),
                          ),
                          SizedBox(
                            width: 32.0,
                          ),
                          RaisedButton(
                            onPressed: () {},
                            elevation: 8.0,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        8.0)),
                            color: Colors.grey,
                            child: Text(
                              "Block",
                              style: TextStyle(
                                  color: Colors.white
                                      .withOpacity(.90)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

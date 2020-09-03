import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/home/export/export_file.dart';
import 'package:socialapp/home/screen/look_image.dart';
import 'package:socialapp/likes/export/export_like.dart';
import 'package:socialapp/shared/shared_app.dart';
import 'package:socialapp/textMore/export/export.dart';
import 'package:socialapp/comments/widget/widget_like_ui.dart';

class widget_card_comemt_detail extends StatelessWidget {
  const widget_card_comemt_detail({
    Key key,
    @required this.textMoreBloc,
    @required this.likeBloc,
    this.constraints,
    this.postModels,
    this.i,
  }) : super(key: key);

  final TextMoreBloc textMoreBloc;
  final LikeBloc likeBloc;
  final BoxConstraints constraints;
  final List<PostModel> postModels;
  final int i;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 22.0,
      // margin: EdgeInsets.all(12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 2.0,
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<DocumentSnapshot>(
                future: postModels[i].getUserDetail(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              height: 45.0,
                              width: 45.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(.5, .5),
                                        blurRadius: 0.5,
                                        color: Colors.black.withOpacity(.15),
                                        spreadRadius: .5)
                                  ],
                                  //shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        snapshot.data.get("imageProfile"),
                                      ),
                                      fit: BoxFit.cover)),
                            ),
                            SizedBox(
                              width: 6.0,
                            ),
                            Text(
                              snapshot.data.get("user"),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.0),
                            ),
                          ],
                        ),
                        Icon(Icons.more_horiz)
                      ],
                    );
                  }
                },
              )),
          // bloc check text more
          postModels[i].body.isNotEmpty
              ? BlocBuilder<TextMoreBloc, TextMoreState>(
                  builder: (context, state) {
                  if (state is onTextMoreResult) {
                    return Container(
                        padding: const EdgeInsets.only(
                            top: 16.0, left: 12.0, right: 12.0, bottom: 16.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              Align(
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    postModels[i].body,
                                    overflow: TextOverflow.fade,
                                    textAlign: TextAlign.start,
                                    softWrap: true,
                                    maxLines: state.value ? 400 : 6,
                                    style: TextStyle(fontSize: 18.0),
                                  )),
                              InkWell(
                                onTap: () {
                                  textMoreBloc.add(onShowMoreClick(
                                      value: !state.value,
                                      textLen: postModels[i].body.length));
                                },
                                child: BlocBuilder<TextMoreBloc, TextMoreState>(
                                  builder: (context, state) {
                                    if (state is onTextMoreResult) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          state.value &&
                                                  postModels[i].body.length >=
                                                      260
                                              ? Text(
                                                  "Show Less",
                                                  style: TextStyle(
                                                      color: Colors.blue),
                                                )
                                              : !state.value &&
                                                      postModels[i]
                                                              .body
                                                              .length >= //state.models[i].body.length >=
                                                          260
                                                  ? Text("Show More",
                                                      style: TextStyle(
                                                          color: Colors.blue))
                                                  : Container()
                                        ],
                                      );
                                    }
                                    return Container();
                                  },
                                ),
                              )
                            ],
                          ),
                        ));
                  }
                })
              : SizedBox(
                  height: 12.0,
                ),
          Card(
              elevation: 1.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              clipBehavior: Clip.antiAlias,
              child: postModels[i].type == "image"
                  ? InkWell(
                      onTap: () {
                        //user click look image
                        print('Look image');

                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              LookImage(imageUrl: postModels[i].image, i: i),
                        ));
                      },
                      child: Hero(
                        tag: "look${i}",
                        child: Image.network(
                          '${postModels[i].image}',
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width * 1,
                          height: 320.0,
                        ),
                      ))
                  : Container()),
          SizedBox(
            height: 4.0,
          ),
          SizedBox(
            width: constraints.maxWidth,
            height: 1.0,
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 12.0, left: 8.0, right: 8.0, bottom: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // likes bloc
                BlocBuilder<LikeBloc, LikeState>(
                  builder: (context, state) {
                    if (state is onCheckLikesResult) {
                      return widget_like_ui(
                          postModels: postModels, i: i, likeBloc: likeBloc);
                    }
                    if (state is onLikesResult) {
                      return widget_like_ui(
                          postModels: postModels, i: i, likeBloc: likeBloc);
                    }
                    if (state is onLikeProgress) {
                      return widget_like_ui(
                          postModels: postModels, i: i, likeBloc: likeBloc);
                    }
                    if (state is onLikeResultPost) {
                      return widget_like_ui(
                          postModels: postModels, i: i, likeBloc: likeBloc);
                    }
                    return Container();
                  },
                ),
                //comments bloc
                InkWell(
                  onTap: () {},
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.mode_comment,
                        size: 20.0,
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Text("Comments"),
                    ],
                  ),
                ),
                //share bloc
                InkWell(
                  onTap: () {
                    var shared = SharedApp();
                    if (postModels[i].type == "image") {
                      shared.sharedImage(
                          context, postModels[i].image, postModels[i].body);
                    } else {
                      shared.sharedText(context, postModels[i].body);
                    }
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.share,
                        size: 20.0,
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Text('Share')
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/edit_profile_bloc.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/event/edit_profile_event.dart';
import 'package:socialapp/comments/export/export_comment.dart';
import 'package:socialapp/home/export/export_file.dart';
import 'package:socialapp/comments/widget/widget_card_comments.dart';
import 'package:socialapp/likes/bloc/likes_bloc.dart';
import 'package:socialapp/likes/export/export_like.dart';
import 'package:socialapp/textMore/bloc/text_more_bloc.dart';
import 'package:socialapp/textMore/export/export.dart';
import 'package:socialapp/userPost/bloc/post_bloc.dart';
import 'package:socialapp/userPost/export/export_new_post.dart';

//comment post  page
class Comments extends StatelessWidget {
  final List<PostModel> postModels;
  final int i;
  final String uid;

  const Comments({
    Key key,
    this.postModels,
    this.i,
    this.uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
      create: (context) => TextMoreBloc(),
      child: BlocProvider(
          create: (context) => LikeBloc(new LikeRepository()),
          child: BlocProvider(
              create: (context) => CommentBloc(new CommentRepository()),
              child: BlocProvider(
                  create: (context) => MyFeedBloc(new FeedRepository()),
                  child: BlocProvider(
                      create: (context) => PostBloc(new PostRepository()),
                      child: BlocProvider(
                        create: (context) => EditProfileBloc(),
                        child: _Comments(
                          uid: uid,
                          postModels: postModels,
                          i: i,
                        ),
                      ))))),
    ));
  }
}

class _Comments extends StatefulWidget {
  final List<PostModel> postModels;
  final int i;
  final String uid;

  const _Comments({
    Key key,
    this.postModels,
    this.i,
    this.uid,
  }) : super(key: key);
  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<_Comments> {
  TextMoreBloc textMoreBloc;
  LikeBloc likeBloc;
  CommentBloc commentBloc;
  var message = '';
  TextEditingController txtComment;
  MyFeedBloc myFeedBloc;
  PostBloc postBloc;
  EditProfileBloc editProfileBloc;

  @override
  void initState() {
    //initial bloc and text controller
    txtComment = TextEditingController();
    textMoreBloc = BlocProvider.of<TextMoreBloc>(context);
    likeBloc = BlocProvider.of<LikeBloc>(context);
    commentBloc = BlocProvider.of<CommentBloc>(context);
    myFeedBloc = BlocProvider.of<MyFeedBloc>(context);
    postBloc = BlocProvider.of<PostBloc>(context);
    editProfileBloc = BlocProvider.of<EditProfileBloc>(context);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    //commentCount = int.parse(widget.postModels.commentCount);
    likeBloc.add(onLikeResultPostClick());
    commentBloc.add(onLoadComments(postId: widget.postModels[widget.i].postId));
    editProfileBloc.add(loadFriendProfilePost());
    // print(message.length);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //free memory from stream connection
    //database
    commentBloc.add(onDisponseComment());

    //freem memory from text controller
    txtComment.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                children: <Widget>[
                  // make widget show detail post

                  //make post with image and message
                  SizedBox(
                    height: 16.0,
                  ),
                  widget_card_comemt_detail(
                      uid: widget.uid,
                      i: widget.i,
                      postModels: widget.postModels,
                      constraints: constraints,
                      textMoreBloc: textMoreBloc,
                      likeBloc: likeBloc),
                  //make post with message
                  //make comment
                  BlocBuilder<CommentBloc, CommentState>(
                    builder: (context, state) {
                      if (state is onCommentProgress) {
                        return Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      if (state is onAddCommentSuccess) {
                        //if there add comment give refresh page
                        //by call onLoadComments()
                        //tuture will use stream for build
                        //connect data real-time
                        //give cut onLoadComments() out
                        //---------------------------------
                        // commentBloc.add(onLoadComments(
                        //     postId: widget.postModels[widget.i].postId));
                      }
                      if (state is onLoadCommentSuccess) {
                        //print access event onLoadCommentSuccess
                        //add comment bloc
                        return buildContainerComment(constraints, state);
                      }
                      return Container();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Container buildContainerComment(
      BoxConstraints constraints, onLoadCommentSuccess state) {
    return Container(
      height: constraints.maxHeight * .7129,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Comments'),
            ),
          ),
          SizedBox(
            height: 4.0,
          ),
          Expanded(
            child: ListView.builder(
              reverse: false,
              physics: ScrollPhysics(),
              itemCount: state.comments.length,
              itemBuilder: (context, index) {
                return Container(
                    //make user detail ,user comment
                    child: Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Container(
                            height: 35.0,
                            width: 35.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(
                                      state.comments[index].imageProfile),
                                  fit: BoxFit.cover,
                                )),
                          ),
                        ),
                        //make user Name
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 4.0, top: 4.0, right: 0.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18.0),
                                color: Colors.grey.withOpacity(.25)),
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16.0, top: 8.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '${state.comments[index].userName}',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      //message len 32 not over
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 2.0, bottom: 4.0),
                                        child: Text(
                                          '${state.comments[index].body}',
                                          overflow: TextOverflow.fade,
                                          softWrap: false,
                                          maxLines: 100,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ],
                ));
              },
            ),
          ),
          //make box get message comments
          Material(
            elevation: 22.0,
            borderRadius: BorderRadius.circular(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: 8.0,
                ),
                Container(
                  child: InkWell(
                    onTap: () {
                      print('selecte image');
                    },
                    child: Icon(Icons.image, color: Colors.orange),
                  ),
                ),
                SizedBox(
                  width: 12.0,
                ),
                Column(
                  children: <Widget>[
                    Container(
                      width: 320.0,
                      child: TextFormField(
                        controller: txtComment,
                        onChanged: (value) {
                          message = '${value}';
                          print(message);
                        },
                        onFieldSubmitted: (value) {
                          // commentCount += 1;
                          commentBloc.add(onAddCommentClick(
                              message: message,
                              postModel: widget.postModels[widget.i]));

                          message = "";
                          txtComment.clear();
                        },
                        keyboardType: TextInputType.multiline,
                        decoration:
                            InputDecoration(hintText: 'Enter Comments 32 char'),
                      ),
                    ),
                  ],
                ),
                //make button send comments
                InkWell(
                  onTap: () {
                    // commentCount += 1;
                    commentBloc.add(onAddCommentClick(
                        message: message,
                        postModel: widget.postModels[widget.i]));
                    message = "";
                    txtComment.clear();
                  },
                  child: Icon(Icons.send, size: 32, color: Colors.blue),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

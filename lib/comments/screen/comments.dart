import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_buttonx/materialButtonX.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/edit_profile_bloc.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/event/edit_profile_event.dart';
import 'package:socialapp/Profile/EditPtofile/screen/user_profile.dart';
import 'package:socialapp/comments/export/export_comment.dart';
import 'package:socialapp/home/export/export_file.dart';
import 'package:socialapp/comments/widget/widget_card_comments.dart';
import 'package:socialapp/likes/bloc/likes_bloc.dart';
import 'package:socialapp/likes/export/export_like.dart';
import 'package:socialapp/textMore/bloc/text_more_bloc.dart';
import 'package:socialapp/textMore/export/export.dart';
import 'package:socialapp/userPost/bloc/post_bloc.dart';
import 'package:socialapp/userPost/export/export_new_post.dart';
import 'package:socialapp/utils/utils.dart';

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
    likeBloc.add(OnLikeResultPostClick());
    commentBloc.add(OnLoadComments(postId: widget.postModels[widget.i].postId));
    editProfileBloc.add(loadFriendProfilePost());
    // print(message.length);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //free memory from stream connection
    //database
    commentBloc.add(OnDisponseComment());

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
                      if (state is OnCommentProgress) {
                        return Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      if (state is OnAddCommentSuccess) {
                        //if there add comment give refresh page
                        //by call onLoadComments()
                        //tuture will use stream for build
                        //connect data real-time
                        //give cut onLoadComments() out
                        //---------------------------------
                        // commentBloc.add(onLoadComments(
                        //     postId: widget.postModels[widget.i].postId));
                      }
                      if (state is OnLoadCommentSuccess) {
                        //print access event onLoadCommentSuccess
                        //add comment bloc
                        return buildContainerComment(
                            constraints, state, widget.uid, commentBloc);
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

  Container buildContainerComment(BoxConstraints constraints,
      OnLoadCommentSuccess state, String uid, CommentBloc commentBloc) {
    var message = '';
    return Container(
      height: constraints.maxHeight * .6,
      width: double.infinity,
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
              itemCount: state.comments.length,
              itemBuilder: (context, index) {
                return CommentDetailItems(
                  index: index,
                  comments: state.comments,
                  currentUid: uid,
                  commentBloc: commentBloc,
                  txtComment: txtComment,
                );
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
                      child: TextField(
                        controller: txtComment,
                        onChanged: (value) => message = value,
                        onSubmitted: (value) {
                          // commentCount += 1;
                          FocusScope.of(context).unfocus();
                          commentBloc.add(OnAddCommentClick(
                              message: message,
                              postModel: widget.postModels[widget.i]));
                          message = "";
                          txtComment.clear();
                        },
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(hintText: 'Enter ....'),
                      ),
                    ),
                  ],
                ),
                //make button send comments
                Expanded(
                  child: InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      // commentCount += 1;
                      commentBloc.add(OnAddCommentClick(
                          message: message,
                          postModel: widget.postModels[widget.i]));
                      message = "";
                      txtComment.clear();
                    },
                    child: Icon(Icons.send, size: 32, color: Colors.blue),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CommentDetailItems extends StatelessWidget {
  const CommentDetailItems(
      {Key key,
      this.comments,
      this.index,
      this.currentUid,
      this.commentBloc,
      this.txtComment})
      : super(key: key);
  final List<CommentModel> comments;
  final int index;
  final String currentUid;
  final CommentBloc commentBloc;
  final TextEditingController txtComment;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        onSelected: (selected) {
          if (selected.contains("remove") &&
              uid.contains(comments[index].uid)) {
            // remove comment
            //check user id  as onwer comment right ?
            dialogRemoveComment(context, false,
                comments: comments, index: index, commentBloc: commentBloc);
          }
          if (selected.contains("edit")) {
            // txtComment.text = comments[index].body;
            // txtComment.
            // commentBloc.add(OnUpdateComment(comments: comments, index: index));
          } else {
            //close popup or user not permission remove comment
            print("close popup or user not permission remove comment");
          }
        },
        itemBuilder: (context) => [
              PopupMenuItem(
                value: "remove",
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent.withOpacity(.25)),
                      child: Icon(
                        Icons.remove,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text('Remove'),
                  ],
                ),
              ),
              PopupMenuDivider(
                height: 1.5,
              ),
              PopupMenuItem(
                value: "edit",
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green.withOpacity(.25)),
                      child: Icon(
                        Icons.edit_attributes_rounded,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text('Edit'),
                  ],
                ),
              ),
              PopupMenuDivider(
                height: 1.5,
              ),
              PopupMenuItem(
                value: "exit",
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.withOpacity(.25)),
                      child: Icon(
                        Icons.exit_to_app,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text('Exit'),
                  ],
                ),
              )
            ],
        child: Container(
          //make user detail ,user comment
          child: SingleChildScrollView(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Container(
                    height: 35.0,
                    width: 35.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(
                              comments[index].imageProfile == null ||
                                      comments[index]
                                          .imageProfile
                                          .toString()
                                          .isEmpty
                                  ? PersonURL
                                  : comments[index].imageProfile),
                          fit: BoxFit.cover,
                        )),
                  ),
                ),
                //make user Name
                Container(
                  width: comments[index].body.length < 20
                      ? null
                      : MediaQuery.of(context).size.width * 0.8,
                  margin:
                      const EdgeInsets.only(left: 4.0, top: 4.0, right: 0.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.grey.withOpacity(.25)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${comments[index].userName}',
                        textAlign: TextAlign.start,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      //message len 32 not over

                      Text(
                        '${comments[index].body}',
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

Future<void> dialogRemoveComment(BuildContext context, bool _fromTop,
    {List<CommentModel> comments, int index, CommentBloc commentBloc}) async {
  return showGeneralDialog(
    barrierLabel: "",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 700),
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) {
      return Align(
        alignment: _fromTop ? Alignment.topCenter : Alignment.bottomCenter,
        child: Container(
          height: MediaQuery.of(context).size.height * .15,
          child: SizedBox.expand(
            child: Column(
              children: <Widget>[
                //make text show you remove this comment sure ?
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  "You want remove comment sure ?",
                  style: Theme.of(context).textTheme.headline6.copyWith(
                      color: Colors.black, fontWeight: FontWeight.normal),
                  textAlign: TextAlign.center,
                ),
                Spacer(),
                // make button  no and  remove
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Material(
                        child: MaterialButtonX(
                          color: Colors.green,
                          height: 40.0,
                          width: 120.0,
                          iconSize: 22.0,
                          icon: Icons.exit_to_app,
                          message: "Exit",
                          radius: 80.0,
                          onClick: () {
                            //close dialog
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Spacer(),
                      Material(
                        child: MaterialButtonX(
                          color: Colors.redAccent,
                          height: 40.0,
                          width: 120.0,
                          iconSize: 22.0,
                          icon: Icons.remove,
                          message: "Remove",
                          radius: 80.0,
                          onClick: () {
                            //remove comment
                            commentBloc.add(OnRemoveComment(
                                comments: comments, index: index));

                            //close dialog
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          margin: EdgeInsets.symmetric(horizontal: 32.0, vertical: 32.0),
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween(begin: Offset(0, _fromTop ? -1 : 1), end: Offset(0, 0))
            .animate(animation),
        child: child,
      );
    },
  );
}

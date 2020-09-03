import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/edit_profile_bloc.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/event/edit_profile_event.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/state/edit_profile_state.dart';
import 'package:socialapp/home/export/export_file.dart';
import 'package:socialapp/userPost/export/export_new_post.dart';
import 'dart:async';

class EditPost extends StatelessWidget {
  final PostModel postModel;
  const EditPost({Key key, this.postModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => PostBloc(new PostRepository()),
        child: BlocProvider(
          create: (context) => EditProfileBloc(),
          child: _EditPost(postModel: postModel),
        ),
      ),
    );
  }
}

class _EditPost extends StatefulWidget {
  final PostModel postModel;

  const _EditPost({Key key, this.postModel}) : super(key: key);
  @override
  __EditPostState createState() => __EditPostState();
}

class __EditPostState extends State<_EditPost> {
  TextEditingController txtMessage = TextEditingController();
  String url = '';
  File _image;
  @override
  void initState() {
    //set message body to edit text
    txtMessage.text = widget.postModel.body;
    url = widget.postModel.image;
    super.initState();
  }

  Future _checkUserPost() async {
    final _mAuth = FirebaseAuth.instance.currentUser;
    final uid = _mAuth.uid.toString();

    if (uid != widget.postModel.uid) {
      Navigator.of(context).pop();
    }
  }

  //check camera or gallery permission grant
  Future<void> _checkGalleryPermission() async {
    var gallery = await Permission.storage;

    if (await gallery.status.isUndetermined) {
      //not grant
      if (await gallery.request().isGranted) {
        // permission grant
      }
    }

    if (await gallery.status.isRestricted) {
      //user block
    }

    if (await gallery.status.isGranted) {
      // permission grant
      _pickGallery();
    }
  }

  Future<void> _checkCameraPermission() async {
    var camera = await Permission.camera;

    if (await camera.status.isUndetermined) {
      //not grant
      if (await camera.request().isGranted) {
        // permission grant
      }
    }

    if (await camera.status.isRestricted) {
      //user block
    }

    if (await camera.status.isGranted) {
      // permission grant
      _pickCamera();
    }
  }

  Future<void> _pickGallery() async {
    final file = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      setState(() {
        _image = file;
        url = "";
      });
    }
  }

  Future<void> _pickCamera() async {
    final file = await ImagePicker.pickImage(source: ImageSource.camera);

    if (file != null) {
      setState(() {
        _image = file;
        url = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    EditProfileBloc editProfileBloc = BlocProvider.of<EditProfileBloc>(context);
    PostBloc postBloc = BlocProvider.of<PostBloc>(context);

    setState(() {
      _checkUserPost();
      //_portraitModeOnly();
      // get user detail
      editProfileBloc.add(EditProfileLoadUserInfo(uid: widget.postModel.uid));
      print(txtMessage.text.toString());
      _portraitModeOnly();
    });
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              children: <Widget>[
                //make widget show post details
                // show message and image content
                //1. make app bar show name screen
                widgetAppBarPost(
                    constraints: constraints, message: 'Edit Post'),
                //2. make content widget
                //add bloc get user detail name and image profile
                BlocBuilder<EditProfileBloc, EditProfileState>(
                  builder: (context, state) {
                    if (state is onLoadUserSuccessfully) {
                      return widgetShowUserDetail(model: state.data);
                    }
                    return Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                ),
                //3 make post bloc
                BlocBuilder<PostBloc, StatePost>(
                  builder: (context, state) {
                    if (state is onPostProgress) {
                      return Container(
                          child: Center(
                        child: CircularProgressIndicator(),
                      ));
                    }
                    if (state is onPostFailed) {
                      return Container(
                          child: Center(
                        child: Text(
                          'Failed',
                          style: TextStyle(fontSize: 28.0),
                        ),
                      ));
                    }
                    if (state is onPostSuccessful) {
                      // Navigator.of(context).pop();
                      return Container(
                          child: Center(
                        child: CircularProgressIndicator(),
                      ));
                    }
                    return Container();
                  },
                ),
                //4. check bloc event navigator
                BlocListener<PostBloc, StatePost>(
                  listener: (context, state) {
                    if (state is onPostSuccessful) {
                      Navigator.of(context).pushNamed('/home');
                    }
                  },
                  child: Container(),
                ),
                //content screen
                widget.postModel.type == 'image'
                    ? Container(
                        child: Column(
                          children: <Widget>[
                            //make get text from user
                            SizedBox(
                              height: 16.0,
                            ),
                            widgetGetMessage(
                              txtMessage: txtMessage,
                            ),
                            //make image view
                            SizedBox(
                              height: 4.0,
                            ),
                            widgetShowImage(
                              image: _image,
                              url: url,
                            ),
                            //make bottom sheet
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: _buildFloatingActionButtonPost(postBloc),
                              ),
                            ),
                            // _buildFloatingActionButtonPost(),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: _buildContainerBottonNav(),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        child: Column(
                          children: <Widget>[
                            //make get text from user
                            SizedBox(
                              height: 16.0,
                            ),
                            widgetGetMessage(
                              txtMessage: txtMessage,
                            ),
                            //make bottom sheet
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: _buildFloatingActionButtonPost(postBloc),
                              ),
                            ),
                            // _buildFloatingActionButtonPost(),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: _buildContainerBottonNav(),
                            ),
                          ],
                        ),
                      )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // _enableRatation();
    _enableRatation();
    super.dispose();
    txtMessage.dispose();
  }

  _portraitModeOnly() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  }

  _enableRatation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp
    ]);
  }

  Container _buildContainerBottonNav() {
    return Container(
      height: 55.0,
      margin: const EdgeInsets.all(12.0),
      child: Material(
        color: Colors.white,
        elevation: 28.0,
        borderRadius: BorderRadius.circular(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.add_a_photo,
                      size: 30.0,
                      color: Colors.red.withOpacity(.85),
                    ),
                    onPressed: () {
                      _checkCameraPermission();
                    }),
                Text(
                  'Camera',
                  style: TextStyle(fontSize: 18.0),
                )
              ],
            ),
            Row(
              children: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.image,
                      size: 30.0,
                      color: Colors.orange.withOpacity(.85),
                    ),
                    onPressed: () {
                      _checkGalleryPermission();
                    }),
                Text(
                  'Gallery',
                  style: TextStyle(
                    fontSize: 18.0,
                    //color: Colors.orange
                  ),
                )
              ],
            ),
            // IconButton(icon: Icon(Icons.image), onPressed: (){})
          ],
        ),
      ),
    );
  }

  Container _buildFloatingActionButtonPost(PostBloc postBloc) {
    return Container(
        height: 50.0,
        width: 150.0,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              blurRadius: 30.0, offset: Offset(0, 20.0), color: Colors.black12)
        ], color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
        child: InkWell(
          onTap: () async {
            final _mAuth = await FirebaseAuth.instance.currentUser;
            // update user post
            print('updating post....');
            postBloc.add(onUpdatePostClick(
                type: widget.postModel.type,
                postId: widget.postModel.postId,
                uid: widget.postModel.uid,
                message: txtMessage.text,
                image: _image,
                url: url,
                commentCount: widget.postModel.commentCount,
                likeCount: widget.postModel.likesCount));
          },
          child: Row(
            children: <Widget>[
              Container(
                width: 110.0,
                height: 50.0,
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(95.0),
                        bottomLeft: Radius.circular(95.0),
                        topRight: Radius.circular(0.0),
                        bottomRight: Radius.circular(200.0))),
                child: Text(
                  'Edit',
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .apply(color: Colors.white),
                ),
              ),
              Icon(
                Icons.mode_edit,
                size: 30.0,
              )
            ],
          ),
        ));
  }
}

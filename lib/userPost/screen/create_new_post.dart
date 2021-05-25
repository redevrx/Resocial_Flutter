import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_buttonx/materialButtonX.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/edit_profile_bloc.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/event/edit_profile_event.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/state/edit_profile_state.dart';
import 'package:socialapp/home/screen/home_page.dart';
import 'package:socialapp/userPost/bloc/event_post.dart';
import 'package:socialapp/userPost/bloc/post_bloc.dart';
import 'package:socialapp/userPost/bloc/state_post.dart';
import 'package:socialapp/userPost/repository/post_repository.dart';
import 'package:socialapp/userPost/widget/widget_app_bar_post.dart';
import 'package:socialapp/userPost/widget/widget_get_message.dart';
import 'package:socialapp/userPost/widget/widget_show_image.dart';
import 'package:socialapp/userPost/widget/widget_show_user_detail.dart';
import 'dart:async';

import 'package:socialapp/utils/utils.dart';

class CreatePost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
            create: (context) => EditProfileBloc(),
            child: BlocProvider(
              create: (context) => PostBloc(new PostRepository()),
              child: _CreatePost(),
            )));
  }
}

class _CreatePost extends StatefulWidget {
  @override
  __CreatePostState createState() => __CreatePostState();
}

class __CreatePostState extends State<_CreatePost> {
  EditProfileBloc editProfileBloc;
  PostBloc postBloc;

  //uid of current user that login
  var uid = '';

  //get uid from shard pref
  void _getUid() async {
    final _pref = await SharedPreferences.getInstance();
    uid = _pref.getString("uid");
  }

  //chcek gallery permission
  //if user grant give open gallery
  //and select image
  Future _checkGalleryPermission(PostBloc postBloc) async {
    final gallery = await Permission.storage;

    //check grant
    if (await gallery.status.isDenied) {
      //user not grant permission
      if (await gallery.request().isGranted) {
        //user permission grant
      }
    }

    //check user block permission
    if (await gallery.status.isRestricted) {
      //user bloc permission
    }

    if (await gallery.status.isGranted) {
      //user permission grant
      //open gallery and get image

      _pickGallery(postBloc);
    }
  }

//chcek camara permission
  //if user grant give open camara
  //and select image
  Future _checkCameraPermission(PostBloc postBloc) async {
    final camera = await Permission.camera;

    //check user grant permission
    if (await camera.status.isDenied) {
      //user not grant permission

      if (await camera.request().isGranted) {
        //user permission grant
      }
    }

    //check user block permission
    if (await camera.status.isRestricted) {
      //user bloc permission
    }

    if (await camera.status.isGranted) {
      //user permission grant
      //open gallery and get camera
      await _pickCamera(postBloc);
    }
  }

//get image from gallery
  Future _pickGallery(PostBloc postBloc) async {
    var arg = await ImagePicker().getImage(source: ImageSource.gallery);
    //_image = arg;
    if (arg != null) {
      // _image = File(arg.path);
      postBloc.add(omImageFilePostChange(imageFile: File(arg.path)));
    }
  }

//get image from camara
  Future _pickCamera(PostBloc postBloc) async {
    var arg = await ImagePicker().getImage(source: ImageSource.camera);
    if (arg != null) {
      // _image = File(arg.path);
      postBloc.add(omImageFilePostChange(imageFile: File(arg.path)));
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    editProfileBloc = BlocProvider.of<EditProfileBloc>(context);
    postBloc = BlocProvider.of<PostBloc>(context);

    _portraitModeOnly();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    // get user detail
    editProfileBloc.add(EditProfileLoadUserInfo());

    //get uid
    _getUid();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                children: <Widget>[
                  //make widget get message and image that current use post

                  //1. make app bar show name screen
                  widgetAppBarPost(
                      constraints: constraints, message: 'New Post'),
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

                  //3 make post bloc show post status
                  // - success  give got to home
                  //- error show status error
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
                  //check bloc event navigator
                  BlocListener<PostBloc, StatePost>(
                    listener: (context, state) {
                      if (state is onPostSuccessful) {
                        // Navigator.of(context).pushNamed('/home');
                        //close dialog
                        Navigator.of(context).pop();
                        //
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => HomePage(
                                pageNumber: 0,
                              ),
                            ),
                            (route) => false);
                      }
                      if (state is onPostFailed) {
                        //close dialog
                        Navigator.of(context).pop();
                      }
                    },
                    child: Container(),
                  ),
                  //make get text from user
                  SizedBox(
                    height: 16.0,
                  ),
                  widgetGetMessage(
                    postBloc: postBloc,
                  ),

                  //make image view
                  //make bloc for get image
                  SizedBox(
                    height: 4.0,
                  ),
                  BlocBuilder<PostBloc, StatePost>(
                    // buildWhen: (previous, current) => previous.imageFile != current.imageFIle,
                    cubit: postBloc,
                    builder: (context, state) {
                      if (state is onImageFilePostChangeState) {
                        return widgetShowImage(
                          image: state.imageFile,
                          url: "",
                        );
                      }
                      return widgetShowImage(
                        image: null,
                        url: "",
                      );
                    },
                  ),
                  //make bottom sheet
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButtonX(
                          message: "Post",
                          height: 50.0,
                          width: 150.0,
                          color: Colors.blueAccent,
                          icon: Icons.add,
                          iconSize: 30.0,
                          radius: 46.0,
                          onClick: () {
                            onLoadingDialog(context);
                            //
                            postBloc.add(onUserPost(
                              uid: uid,
                            ));
                          },
                        )
                        //_buildFloatingActionButtonPost(postBloc),
                        ),
                  ),
                  // _buildFloatingActionButtonPost(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _buildContainerBottonNav(postBloc),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _enableRatation();
    //free memory from stream subscription
    editProfileBloc.add(onDisponscEditProfile());
  }

  //make navBar button
  //there are button select image from
  //gallery and camara
  Container _buildContainerBottonNav(PostBloc postBloc) {
    return Container(
      height: 55.0,
      margin: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
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
                      //call _checkCameraPermission
                      //for check permission
                      _checkCameraPermission(postBloc);
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
                      //call _checkCameraPermission
                      //for check permission
                      _checkGalleryPermission(postBloc);
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

//disible ratation
  void _portraitModeOnly() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  }

  // Container _buildFloatingActionButtonPost(PostBloc postBloc) {
  //   return Container(
  //       height: 50.0,
  //       width: 150.0,
  //       decoration: BoxDecoration(boxShadow: [
  //         BoxShadow(
  //             blurRadius: 30.0, offset: Offset(0, 20.0), color: Colors.black12)
  //       ], color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
  //       child: InkWell(
  //         onTap: () async {
  //           final _mAuth = await FirebaseAuth.instance.currentUser;
  //           final uid = await _mAuth.uid.toString();

  //           postBloc.add(
  //               onUserPost(uid: uid, message: txtMessage.text, image: _image));
  //         },
  //         child: Row(
  //           children: <Widget>[
  //             Container(
  //               width: 110.0,
  //               height: 50.0,
  //               padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
  //               decoration: BoxDecoration(
  //                   color: Colors.blueAccent,
  //                   borderRadius: BorderRadius.only(
  //                       topLeft: Radius.circular(95.0),
  //                       bottomLeft: Radius.circular(95.0),
  //                       topRight: Radius.circular(0.0),
  //                       bottomRight: Radius.circular(200.0))),
  //               child: Text(
  //                 'Post',
  //                 style: Theme.of(context)
  //                     .textTheme
  //                     .headline5
  //                     .apply(color: Colors.white),
  //               ),
  //             ),
  //             Icon(
  //               Icons.add,
  //               size: 30.0,
  //             )
  //           ],
  //         ),
  //       ));
  // }

  //enable rotation
  void _enableRatation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp
    ]);
  }
}

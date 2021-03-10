import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/event/edit_profile_event.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/models/EditProfileModel.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/state/edit_profile_state.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc() : super(onEditFailed(data: ""));

  StreamSubscription _streamSubscription;

  @override
  Stream<EditProfileState> mapEventToState(EditProfileEvent event) async* {
    if (event is EditProfileLoadUserInfo) {
      try {
        yield* loadUserProfile(event);
      } catch (e) {
        print(e);
      }
    }
    if (event is EditProfileImageClick) {
      yield* updateImageProfile(event);
    }
    if (event is EditProfileBackgroundClik) {
      yield* onUpdateImageBackground(event);
    }
    if (event is EditProfileStstusClick) {
      yield* onUpdateUserStatus(event);
    }

    if (event is EditProfileNameClik) {
      yield* updateUserName(event);
    }

    if (event is loadFriendProfile) {
      try {
        yield* loadedFriendProfile(event);
      } catch (e) {
        print(e);
      }
    }
    if (event is EditProfileLoadedUserInfo) {
      try {
        if (event.model != null) yield onLoadUserSuccessfully(event.model);
      } catch (e) {
        print(e);
      }
    }
    if (event is loadedFriendProfileSuccess) {
      try {
        if (event.model != null) yield onLoadUserSuccessfully(event.model);
      } catch (e) {
        print(e);
      }
    }
    if (event is onDisponscEditProfile) {
      _streamSubscription?.cancel();
    }
    if (event is loadFriendProfilePost) {
      yield onLoadUserSuccessfully(null);
    }
  }

//load friend profile
//show in friend profile page
//show info name status other
//user profile return result onLoadUserSuccessfully
//and it will working in page friend profile
  @override
  Stream<EditProfileState> loadedFriendProfile(loadFriendProfile event) async* {
    final _mRef = FirebaseFirestore.instance;
    final userInfo =
        _mRef.collection("user info").doc(event.uid).snapshots().map((event) {
      return EditProfileModel.fromJson(event.data());
    });

    _streamSubscription?.cancel();
    _streamSubscription = userInfo.listen((model) {
      add(loadedFriendProfileSuccess(model: model));
    });

    // final userModel = EditProfileModel(
    //     email: userInfo.get("email").toString(),
    //     userName: userInfo.get("user").toString(),
    //     uid: userInfo.get("uid").toString(),
    //     imageProfile: userInfo.get("imageProfile").toString(),
    //     userStatus: userInfo.get("userStatus").toString(),
    //     nickName: userInfo.get("nickName").toString(),
    //     backgroundImage: userInfo.get("imageBackground").toString());

    // yield onLoadUserSuccessfully(userModel);
  }

//update user name
//update 1 field is user name
  @override
  Stream<EditProfileState> updateUserName(EditProfileNameClik event) async* {
    yield onShowDialog();

    final _mAuth = await FirebaseAuth.instance.currentUser;
    final uid = await _mAuth.uid.toString();

    final _mRef = FirebaseFirestore.instance;
    final map = Map<String, Object>();
    map["user"] = event.data.toString();
    var it = false;
    var error;

    await _mRef
        .collection("user info")
        .doc(uid)
        .update(map)
        .then((value) => it = true)
        .catchError((e) {
      it = false;
      error = e.toString();
    });

    if (it) {
      yield onEditUserNameSuccessfully();
    } else {
      yield onEditFailed(data: error.toString());
    }
  }

//update user status update 1 field
  @override
  Stream<EditProfileState> onUpdateUserStatus(
      EditProfileStstusClick event) async* {
    yield onShowDialog();

    final _mAuth = await FirebaseAuth.instance.currentUser;
    final uid = await _mAuth.uid.toString();

    final _mRef = FirebaseFirestore.instance;

    final map = Map<String, Object>();
    map["userStatus"] = event.data.toString();
    var it = false;
    var error;

    await _mRef.collection("user info").doc(uid).update(map).then((_) {
      it = true;
      print("Update User Status Successfully..");
    }).catchError((e) {
      it = false;
      error = e.toString();
      print("Update User Status Fauled.. :" + e.toString());
    });

    if (it) {
      yield onEditStatsSuccessfully();
    } else {
      yield onEditFailed(data: error);
    }
  }

// update image background
//remove old image in data storage
//and upload new image as storage
//send url to update that filed image background
//in cloud firestore
  @override
  Stream<EditProfileState> onUpdateImageBackground(
      EditProfileBackgroundClik event) async* {
    yield onShowDialog();

    final _mAuth = await FirebaseAuth.instance.currentUser;
    final uid = await _mAuth.uid.toString();

    final _sRef =
        FirebaseStorage.instance.ref().child("Profile Image/Backgrounds");
    final uploadTask = _sRef.child("${uid}" + ".jpg").putFile(event.image);

    var url = await uploadTask.snapshot.ref.getDownloadURL();

    final it = await updateUserImageBackground(uid, url.toString());

    if (it) {
      yield onEditBackgroundSuccessfully();
    } else {
      yield onEditFailed(data: "update Background Failed");
    }
  }

//update image profile
//remove old image and upload new imaae
//to storage
//and send image url to colud firetsore
  @override
  Stream<EditProfileState> updateImageProfile(
      EditProfileImageClick event) async* {
    yield onShowDialog();

    final _mAuth = await FirebaseAuth.instance.currentUser;
    final uid = await _mAuth.uid.toString();

    final _sRef = FirebaseStorage.instance.ref().child("Profile Image/Images");
    final uploadTask = _sRef.child("${uid}" + ".jpg").putFile(event.image);

    var url = await uploadTask.snapshot.ref.getDownloadURL();

    var it = await updateUserinfo(uid, url.toString());

    if (it) {
      yield onEditImageSuccessfully();
    } else {
      yield onEditFailed(data: "update Image Failed");
    }
  }

//load user info
//show in page my profile
//if alter get data give send data from
//stream to event EditProfileLoadedUserInfo and update ui
//user profile return result onLoadUserSuccessfully
//and it will working in page my profile
  @override
  Stream<EditProfileState> loadUserProfile(
      EditProfileLoadUserInfo event) async* {
    final _mRef = FirebaseFirestore.instance;
    final _pref = await SharedPreferences.getInstance();
    final uid = _pref.getString("uid");

    print("uid load profile :${uid}");

    // var userInfo = await
    final userInfo =
        _mRef.collection("user info").doc(uid).snapshots().map((snapshot) {
      return EditProfileModel.fromJson(snapshot.data());
    });

    _streamSubscription?.cancel();
    _streamSubscription = userInfo.listen((model) {
      add(EditProfileLoadedUserInfo(model: model));
    });

    // final userModel = EditProfileModel(
    //     email: userInfo.get("email").toString(),
    //     userName: userInfo.get("user").toString(),
    //     uid: userInfo.get("uid").toString(),
    //     imageProfile: userInfo.get("imageProfile").toString(),
    //     userStatus: userInfo.get("userStatus").toString(),
    //     nickName: userInfo.get("nickName").toString(),
    //     backgroundImage: userInfo.get("imageBackground").toString());

    //  final map = Map<String, Object>();
    // map["email"] = userInfo["email"].toString();
    // map["user"] = userInfo["user"].toString();
    // map["uid"] = userInfo["uid"].toString();
    // map["imageProfile"] = userInfo["imageProfile"].toString();
    // map["userStaus"] = userInfo["userStaus"].toString();
    // map["nickName"] = userInfo["nickName"].toString();
  }

//update imahe url of image profile
//update 1 field
//if update success if return true
  Future<bool> updateUserinfo(String uid, String url) async {
    final _mRef = await FirebaseFirestore.instance;
    // final getData = await _mRef.collection("user info").document(uid).get();

    final map = Map<String, Object>();
    map["imageProfile"] = url.toString();

    return await _mRef
        .collection("user info")
        .doc(uid)
        .update(map)
        .then((value) {
      print("Update user info successfully..");
      return true;
    }).catchError((e) {
      print("Update user info error :" + e);
      return false;
    });
  }

//update image url image bacground
//update 1 field
//if update success if return true
  Future<bool> updateUserImageBackground(String uid, String url) async {
    final _mRef = FirebaseFirestore.instance;
    // var data = _mRef.collection("user info").doc(uid).get();

    final mapBody = Map<String, Object>();
    mapBody["imageBackground"] = url.toString();

    return await _mRef
        .collection("user info")
        .doc(uid)
        .update(mapBody)
        .then((_) {
      return true;
    }).catchError((_) {
      return false;
    });
  }
}

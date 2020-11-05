import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/event/edit_profile_event.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/models/EditProfileModel.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/state/edit_profile_state.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc() : super(onEditFailed(data: ""));
  @override
  Stream<EditProfileState> mapEventToState(EditProfileEvent event) async* {
    if (event is EditProfileLoadUserInfo) {
      yield* loadUserProfile(event);
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
      yield* loadedFriendProfile(event);
    }
    if (event is loadFriendProfilePost) {
      yield onLoadUserSuccessfully(null);
    }
  }

  @override
  Stream<EditProfileState> loadedFriendProfile(loadFriendProfile event) async* {
    final _mRef = FirebaseFirestore.instance;
    var userInfo = await _mRef.collection("user info").doc(event.uid).get();

    final userModel = EditProfileModel(
        email: userInfo.get("email").toString(),
        userName: userInfo.get("user").toString(),
        uid: userInfo.get("uid").toString(),
        imageProfile: userInfo.get("imageProfile").toString(),
        userStatus: userInfo.get("userStatus").toString(),
        nickName: userInfo.get("nickName").toString(),
        backgroundImage: userInfo.get("imageBackground").toString());

    yield onLoadUserSuccessfully(userModel);
  }

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

  @override
  Stream<EditProfileState> onUpdateImageBackground(
      EditProfileBackgroundClik event) async* {
    yield onShowDialog();

    final _mAuth = await FirebaseAuth.instance.currentUser;
    final uid = await _mAuth.uid.toString();

    final _sRef =
        FirebaseStorage.instance.ref().child("Profile Image/Backgrounds");
    final uploadTask = _sRef.child("${uid}" + ".jpg").putFile(event.image);

    var url = await (await uploadTask.onComplete).ref.getDownloadURL();

    final it = await updateUserImageBackground(uid, url.toString());

    if (it) {
      yield onEditBackgroundSuccessfully();
    } else {
      yield onEditFailed(data: "update Background Failed");
    }
  }

  @override
  Stream<EditProfileState> updateImageProfile(
      EditProfileImageClick event) async* {
    yield onShowDialog();

    final _mAuth = await FirebaseAuth.instance.currentUser;
    final uid = await _mAuth.uid.toString();

    final _sRef = FirebaseStorage.instance.ref().child("Profile Image/Images");
    final uploadTask = _sRef.child("${uid}" + ".jpg").putFile(event.image);

    var url = await (await uploadTask.onComplete).ref.getDownloadURL();

    var it = await updateUserinfo(uid, url.toString());

    if (it) {
      yield onEditImageSuccessfully();
    } else {
      yield onEditFailed(data: "update Image Failed");
    }
  }

  @override
  Stream<EditProfileState> loadUserProfile(
      EditProfileLoadUserInfo event) async* {
    final _mAuth = FirebaseAuth.instance;
    final _mRef = FirebaseFirestore.instance;
    final uid = _mAuth.currentUser.uid;
    var userInfo = await _mRef.collection("user info").doc(uid).get();

    final userModel = EditProfileModel(
        email: userInfo.get("email").toString(),
        userName: userInfo.get("user").toString(),
        uid: userInfo.get("uid").toString(),
        imageProfile: userInfo.get("imageProfile").toString(),
        userStatus: userInfo.get("userStatus").toString(),
        nickName: userInfo.get("nickName").toString(),
        backgroundImage: userInfo.get("imageBackground").toString());

    //  final map = Map<String, Object>();
    // map["email"] = userInfo["email"].toString();
    // map["user"] = userInfo["user"].toString();
    // map["uid"] = userInfo["uid"].toString();
    // map["imageProfile"] = userInfo["imageProfile"].toString();
    // map["userStaus"] = userInfo["userStaus"].toString();
    // map["nickName"] = userInfo["nickName"].toString();

    yield onLoadUserSuccessfully(userModel);
  }

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

  Future<bool> updateUserImageBackground(String uid, String url) async {
    final _mRef = FirebaseFirestore.instance;
    var data = _mRef.collection("user info").doc(uid).get();

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

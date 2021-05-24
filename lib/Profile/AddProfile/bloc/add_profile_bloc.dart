import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/Profile/AddProfile/bloc/event/add_profile_event.dart';
import 'package:socialapp/Profile/AddProfile/bloc/models/add_profile_model.dart';
import 'package:socialapp/Profile/AddProfile/bloc/state/add_profile_state.dart';
import 'dart:async';

class AddProfileBloc extends Bloc<AddProfileEvent, AddProfileState> {
  AddProfileBloc() : super(onSaveAddProfileFailed(data: " "));
  //pref use as keep data
  SharedPreferences _preferences;

  @override
  Stream<AddProfileState> mapEventToState(AddProfileEvent event) async* {
    if (event is onSaveAddprofile) {
      yield* onSaveProfileData(event);
    }
    if (event is onUserStatusChange) {
      //get instances
      _preferences = await SharedPreferences.getInstance();

      //remove data before and
      await _preferences.remove("userStatus");
      //keep new value
      await _preferences.setString("userStatus", event.userStatus);
    }
    if (event is onNickNameChange) {
      //get instances
      _preferences = await SharedPreferences.getInstance();

      //remove data before and
      await _preferences.remove("nickName");
      //keep new value
      await _preferences.setString("nickName", event.nickName);
    }
    if (event is onImageProfileChange) {
      //get instances
      _preferences = await SharedPreferences.getInstance();

      //remove data before and
      await _preferences.remove("imageProfile");
      //keep new value
      await _preferences.setString("imageProfile", event.imagePath);

      yield onSelecImageSuccess(imagePath: event.imagePath);
    }
  }

  @override
  Stream<AddProfileState> onSaveProfileData(onSaveAddprofile event) async* {
    yield onSaveAddprofileDialog();
    //get instances
    _preferences = await SharedPreferences.getInstance();

    //add data from shared pref to add profile model

    final data = AddProfileModel(
        File(_preferences.getString("imageProfile") ?? "") ?? "",
        _preferences.getString("nickName") ?? "",
        _preferences.getString("userStatus") ?? "");

//get uid
    final _auth = FirebaseAuth.instance.currentUser;
    var uid = _auth.uid.toString();

//check image file
    if (_preferences.getString("imageProfile") != null) {
//upload image to data storage
      final mRef =
          FirebaseStorage.instance.ref().child("Profile Image").child("Images");
      final uploadTask = mRef.child("${uid}" + ".jpg").putFile(data.image);

      //download image url
      final task = await uploadTask;
      var dowurl = await task.ref.getDownloadURL();
      // var dowurl = await uploadTask.snapshot.ref.getDownloadURL();
      var url = dowurl.toString();

      //update user info
      //update image field
      final it = await updateUserInfo(
          url, data.status ?? "", data.nickName ?? "", uid);

      if (it) {
        //clear data that keep in shared pref
        _preferences.remove("imageProfile");
        _preferences.remove("nickName");
        _preferences.remove("userStatus");

        yield onSaveAddProfileSuccessfully(
            data: "Save Image and Update user info");
      } else {
        yield onSaveAddProfileFailed(
            data: "save image and update user info failed");
      }
    } else if (_preferences.getString("imageProfile") == null) {
      //update user info
      //update image field
      final it = await updateUserInfo("", data.status, data.nickName, uid);

      if (it) {
        //clear data that keep in shared pref
        _preferences.remove("imageProfile");
        _preferences.remove("nickName");
        _preferences.remove("userStatus");

        yield onSaveAddProfileSuccessfully(
            data: "Save Image and Update user info");
      } else {
        yield onSaveAddProfileFailed(data: "update profile failed");
      }
    } else {
      yield onSaveAddProfileFailed(data: "Image file null");
    }
  }

//update user info data
  Future<bool> updateUserInfo(
      String url, String status, String nickName, String uid) async {
    final mRef = FirebaseFirestore.instance;

    //get old user info
    var olnData = await mRef.collection("user info").doc(uid).get();

    final map = Map<String, Object>();
    map["email"] = olnData.get("email").toString();
    map["user"] = olnData.get("user").toString();
    map["uid"] = olnData.get("uid").toString();
    map["imageProfile"] = url;
    map["imageBackground"] = "";
    map["userStatus"] = status;
    map["nickName"] = nickName;
    map['deviceToken'] = '';

    return await mRef
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
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/Profile/AddProfile/bloc/event/add_profile_event.dart';
import 'package:socialapp/Profile/AddProfile/bloc/state/add_profile_state.dart';
import 'dart:async';

class AddProfileBloc extends Bloc<AddProfileEvent, AddProfileState> {
  AddProfileBloc() : super(onSaveAddProfileFailed(data: "State initial"));

  @override
  Stream<AddProfileState> mapEventToState(AddProfileEvent event) async* {
    if (event is onSaveAddprofile) {
      yield* onSaveProfileData(event);
    }
  }

  @override
  Stream<AddProfileState> onSaveProfileData(onSaveAddprofile event) async* {
    yield onSaveAddprofileDialog();

    if (event.data.image != null) {
      final _auth = await FirebaseAuth.instance.currentUser;
      var uid = _auth.uid.toString();

      final StorageReference mRef =
          FirebaseStorage().ref().child("Profile Image").child("Images");
      final StorageUploadTask uploadTask =
          mRef.child("${uid}" + ".jpg").putFile(event.data.image);
      var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
      var url = dowurl.toString();

      final it = await updateUserInfo(
          url, event.data.status, event.data.nickName, uid);

      if (it) {
        yield onSaveAddProfileSuccessfully(
            data: "Save Image and Update user info");
      } else {
        yield onSaveAddProfileFailed(
            data: "save image and update user info failed");
      }
    } else {
      yield onSaveAddProfileFailed(data: "Image file null");
    }
  }

  Future<bool> updateUserInfo(
      String url, String status, String nickName, String uid) async {
    final mRef = FirebaseFirestore.instance;

    //get oln user info
    var olnData = await mRef.collection("user info").doc(uid).get();

    final map = Map<String, Object>();
    map["email"] = olnData.get("email").toString();
    map["user"] = olnData.get("user").toString();
    map["uid"] = olnData.get("uid").toString();
    map["imageProfile"] = url;
    map["userStatus"] = status;
    map["nickName"] = nickName;

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

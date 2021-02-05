import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/call/bloc/call_bloc.dart';
import 'package:socialapp/call/bloc/call_event.dart';
import 'package:socialapp/call/bloc/call_state.dart';
import 'package:socialapp/call/model/call_model.dart';
import 'package:socialapp/call/repository/call_agora_repository.dart';
import 'package:socialapp/call/screen/pickUp/pick_screen.dart';

class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  final String uid;
  final CallBloc callBloc;
  final CallAgoraRepository callAgoraRepository = CallAgoraRepository();
  PickupLayout(
      {Key key, @required this.callBloc, @required this.scaffold, this.uid});

  @override
  Widget build(BuildContext context) {
    // callBloc.add(OnCallStreamStating(uid: uid));
    // return BlocBuilder<CallBloc, CallState>(
    //   cubit: callBloc,
    //   builder: (context, state) {
    //     if (state is OnCallStreamSuccess) {
    //       if (state.callModel != null) {
    //         if (!state.callModel.hasDialled) {
    //           return PickUpScreen(call: state.callModel, uid: uid);
    //         } else {
    //           return scaffold;
    //         }
    //       } else {
    //         return scaffold;
    //       }
    //     } else {
    //       return scaffold;
    //     }
    //   },
    // );
    return StreamBuilder<DocumentSnapshot>(
      stream: callAgoraRepository.CallStream1(),
      builder: (context, snapshot) {
        if (snapshot.data.data() != null) {
          print("There is call to you");
          CallModel callModel = CallModel.formMap(snapshot.data.data());
          if (!callModel.hasDialled) {
            return PickUpScreen(
              call: callModel,
              uid: uid,
            );
          } else {
            return scaffold;
          }
        } else {
          print("not call");
          return scaffold;
        }
      },
    );
  }
}

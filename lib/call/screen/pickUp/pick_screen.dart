import 'package:flutter/material.dart';
import 'package:socialapp/call/model/call_model.dart';
import 'package:socialapp/call/permission.dart';
import 'package:socialapp/call/repository/call_agora_repository.dart';
import 'package:socialapp/call/screen/call_screen.dart';
import 'package:transparent_image/transparent_image.dart';

class PickUpScreen extends StatelessWidget {
  final CallModel call;
  final String uid;
  final CallAgoraRepository _callAgoraRepository = CallAgoraRepository();
  PickUpScreen({@required this.call, @required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //show text calling
            Text(
              "Incoming...",
              style: TextStyle(fontSize: 30.0),
            ),
            SizedBox(
              height: 50.0,
            ),
            //show image call
            FadeInImage.memoryNetwork(
                height: 150.0,
                width: 150.0,
                fit: BoxFit.cover,
                placeholder: kTransparentImage,
                image: call.callPic ?? ""),
            SizedBox(
              height: 15.0,
            ),
            //show caller name
            Text(call.callName ?? "",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            //
            SizedBox(
              height: 75.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //make end call button
                IconButton(
                    icon: Icon(Icons.call_end),
                    color: Colors.redAccent,
                    onPressed: () async {
                      //call method callEdn
                      await _callAgoraRepository.onEndCall(call: call);
                    }),
                //make accept call button
                SizedBox(
                  width: 25.0,
                ),
                IconButton(
                  icon: Icon(Icons.call),
                  color: Colors.greenAccent,
                  onPressed: () async =>
                      await Permissions.checkVideoAndMicroPhonegrant()
                          ? Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CallScreen(
                                call: call,
                                uid: uid,
                              ),
                            ))
                          : {}
                  //go to call screen

                  ,
                ),
                //
              ],
            )
          ],
        ),
      ),
    );
  }
}

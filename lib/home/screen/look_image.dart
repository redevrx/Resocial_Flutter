import 'package:path/path.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class LookImage extends StatelessWidget {
  final String imageUrl;
  final int i;

  const LookImage({Key key, @required this.imageUrl = "", this.i})
      : super(key: key);

  Future checkStoragePermission(String imageUrl) async {
    var storage = await Permission.storage;

    if (await storage.status.isUndetermined) {
      if (await storage.request().isGranted) {
        //downloadImage(imageUrl);
      }
    }

    if (await storage.status.isRestricted) {}

    if (await storage.status.isGranted) {
      downloadImage(imageUrl);
    }
  }

  Future<void> downloadImage(String imageUrl) async {
    var path = "";
    if (Platform.isAndroid) {
      print("android");
      path = "/storage/emulated/0/Download/";
    }
    if (Platform.isIOS) {
      print('ios');
      path = (await getApplicationDocumentsDirectory()).path;
    }

    var response = await http.get(imageUrl);
    File file = new File(join(path, "image${i}.png"));
    await file.writeAsBytesSync(response.bodyBytes);
    print('object :${file}');
    //print(object)
  }

  @override
  Widget build(BuildContext context) {
    print('image :' + imageUrl);
    return WillPopScope(
        child: Scaffold(
            backgroundColor: Colors.black45,
            bottomNavigationBar: Container(
              margin: EdgeInsets.only(bottom: 12.0, right: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  InkWell(
                    onTap: () => checkStoragePermission(imageUrl),
                    child: Icon(
                      Icons.file_download,
                      size: 30.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            appBar: AppBar(
              backgroundColor: Colors.black45,
              leading: InkWell(
                onTap: () {
                  print('icon arrow back');
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 28.0,
                ),
              ),
              actions: <Widget>[
                InkWell(
                  onTap: () {
                    print('icon close to home page');
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.close,
                    size: 32,
                  ),
                )
              ],
            ),
            body: _widgetShowImage(i: i, imageUrl: imageUrl)
            // Draggable(
            //     data: 'drag image',
            //     onDragStarted: () {
            //       Future.delayed(Duration(milliseconds: 200), () {
            //         print('drag close to home page');
            //         Navigator.of(context).pop();
            //       });
            //     },
            //     onDragCompleted: () {
            //       print('complete drag');
            //     },
            //     childWhenDragging: Container(),
            //     child: _widgetShowImage(i: i, imageUrl: imageUrl),
            //     feedback: _widgetShowImage(i: i, imageUrl: imageUrl)
            //     )
            ),
        onWillPop: () => Future(() => false));
  }
}

// class _widgetShowImage extends StatefulWidget {
//   _widgetShowImage({Key key, this.i, this.imageUrl}) : super(key: key);
//   final int i;
//   final String imageUrl;
//   @override
//   __widgetShowImageState createState() => __widgetShowImageState();
// }

// class __widgetShowImageState extends State<_widgetShowImage> {
//   final TransformationController controller = TransformationController();
//   @override
//   Widget build(BuildContext context) {
//     return Hero(
//       tag: "look${widget.i}",
//       child: InteractiveViewer(
//           //boundaryMargin: EdgeInsets.all(double.infinity),
//           transformationController: controller,
//           //  minScale: 0.1,
//           //maxScale: 1.6,
//           panEnabled: false,
//           onInteractionEnd: (details) {
//             controller.value = Matrix4.identity();
//           },
//           child: Center(
//             child: Container(
//                 height: MediaQuery.of(context).size.height * .4,
//                 width: MediaQuery.of(context).size.width * 1,
//                 child: Image.network(
//                   widget.imageUrl,
//                   fit: BoxFit.cover,
//                 )),
//           )),
//     );
//   }
// }

class _widgetShowImage extends StatelessWidget {
  final int i;
  final String imageUrl;

  const _widgetShowImage({Key key, this.i, this.imageUrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final TransformationController controller = TransformationController();
    return Center(
      child: Hero(
        tag: "look${i}",
        child: ClipRect(
          child: InteractiveViewer(
              //  boundaryMargin: EdgeInsets.all(double.infinity),
              //transformationController: controller,
              //  minScale: 0.1,
              maxScale: 20.0,
              // onInteractionEnd: (details) {
              //   controller.value = Matrix4.identity();
              // },

              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height * .4,
                width: MediaQuery.of(context).size.width * 1,
              )
              // Container(
              // height: MediaQuery.of(context).size.height * .4,
              // width: MediaQuery.of(context).size.width * 1,
              // child: Image.network(
              //   imageUrl,
              //   fit: BoxFit.cover,
              // )),
              ),
        ),
      ),
    );
  }
}

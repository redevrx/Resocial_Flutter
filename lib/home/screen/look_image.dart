import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:socialapp/home/bloc/download_cubit.dart';
import 'package:socialapp/home/widget/post_widget.dart';
import 'package:transparent_image/transparent_image.dart';

class LookImage extends StatelessWidget {
  final List urls;
  final List urlsType;
  final int i;

  const LookImage({Key key, @required this.urls = null, this.urlsType, this.i})
      : super(key: key);

  Future checkStoragePermission(BuildContext context, List imageUrl) async {
    var storage = await Permission.storage;

    if (await storage.status.isDenied) {
      if (await storage.request().isGranted) {
        //downloadImage(imageUrl);
      }
    }

    if (await storage.status.isRestricted) {}

    if (await storage.status.isGranted) {
      //downloadImage(imageUrl);
      downloadImage(context, urls);
    }
  }

  Future<void> downloadImage(BuildContext context, List imageUrl) async {
    var path = "";
    if (Platform.isAndroid) {
      print("android");
      path = "/storage/emulated/0/Download";
      final createDirect = Directory("${path}/resocial");
      if (await createDirect.exists()) {
      } else {
        await createDirect.create(recursive: true);
      }
    }
    if (Platform.isIOS) {
      print('ios');
      path = (await getApplicationDocumentsDirectory()).path;
      final createDirect = Directory("${path}/resocial");
      if (await createDirect.exists()) {
      } else {
        await createDirect.create(recursive: true);
      }
    }

    for (int i = 0; i < urls.length; i++) {
      // var response = await http.Client().get(Uri.parse(imageUrl));
      var response = await http.Client().get(Uri.parse(urls[i]));
      File file = new File(join(path + "/resocial", "image${i}.png"));
      file.writeAsBytesSync(response.bodyBytes);
      print('object :${file}');

      onShowDownloadDialog(context);
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context);
        context.read<DownloadCubit>().onDownloadSuccess();
      });
      //print(object)
    }
  }

  @override
  Widget build(BuildContext context) {
    // print('image : $i' + urls);
    return BlocProvider(
      create: (context) => DownloadCubit(DownloadState.onNormalDwonlaod),
      child: Scaffold(
          backgroundColor: Colors.black45,
          bottomNavigationBar: Container(
            margin: EdgeInsets.only(bottom: 12.0, right: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                BlocBuilder<DownloadCubit, DownloadState>(
                  // cubit: context.read<DownloadCubit>(),
                  builder: (context, state) {
                    switch (state) {
                      case DownloadState.onNormalDwonlaod:
                        return InkWell(
                            onTap: () {
                              checkStoragePermission(context, urls);
                              context.read<DownloadCubit>().onClickDownload();
                            },
                            child: Icon(
                              Icons.file_download,
                              size: 30.0,
                              color: Colors.white,
                            ));
                        break;
                      case DownloadState.onStartDownload:
                        return CircularProgressIndicator();
                        break;
                      case DownloadState.onDownloadSuccess:
                        return InkWell(
                            onTap: () {
                              checkStoragePermission(context, urls);
                              context.read<DownloadCubit>().onClickDownload();
                            },
                            child: Icon(
                              Icons.file_download,
                              size: 30.0,
                              color: Colors.white,
                            ));
                        break;
                      default:
                        return Container();
                        break;
                    }
                  },
                ),
                // BlocListener<DownloadCubit, DownloadState>(
                //   listener: (context, state) {
                //     switch (state) {
                //       // case DownloadState.onDownloadSuccess:
                //       //   // call dilaog status download
                //       //   onShowDownloadDialog(context);
                //       //   break;
                //       // case DownloadState.onNormalDwonlaod:
                //       //   return Container();
                //       //   break;
                //       default:
                //         return Container();
                //         break;
                //     }
                //   },
                //   child: Container(),
                // )
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
          body: Center(
            child: _widgetShowImage(
              i: i,
              urls: urls,
              urlsType: urlsType,
            ),
          )
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
    );
  }

  Future onShowDownloadDialog(BuildContext context) {
    final fromTop = false;
    return showGeneralDialog(
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      barrierLabel: 'downlaod image status',
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: fromTop ? Alignment.topCenter : Alignment.bottomCenter,
          child: AnimatedContainer(
              duration: Duration(milliseconds: 450),
              height: 55.0,
              width: MediaQuery.of(context).size.width * .45,
              margin: EdgeInsets.only(top: 50, left: 12, right: 12, bottom: 50),
              decoration: BoxDecoration(
                color: Colors.green,
                boxShadow: [
                  BoxShadow(
                      color: Colors.green,
                      blurRadius: 20,
                      offset: Offset(1, .5),
                      spreadRadius: .1)
                ],
                borderRadius: BorderRadius.circular(45),
              ),
              child: Center(
                  child: Text(
                "Success",
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(color: Colors.white),
              ))),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, fromTop ? -1 : 1), end: Offset(0, 0))
              .animate(animation),
          child: child,
        );
      },
    );
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
  final List urls;
  final List urlsType;

  const _widgetShowImage({Key key, this.i, this.urls, @required this.urlsType})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    // final TransformationController controller = TransformationController();
    return AspectRatio(
      aspectRatio: 2 / 2,
        child: ClipRect(
          child: InteractiveViewer(
              maxScale: 20.0,
              child: Container(
                // height: MediaQuery.of(context).size.height * .4,
                width: MediaQuery.of(context).size.width * 1,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: urls.length,
                  itemBuilder: (context, index) {
                    return urlsType[index] == "video"
                        ? PlayVideoList(
                            fulScreen: true,
                            urls: urls[index],
                          )
                        : FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: urls[index],
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width * 1,
                          );
                  },
                ),
              )),
        ),
    );
  }
}

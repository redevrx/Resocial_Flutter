import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/home/export/export_file.dart';
import 'package:socialapp/localizations/languages.dart';
import 'package:socialapp/notifications/bloc/notifyBloc.dart';
import 'package:socialapp/notifications/bloc/notifyEvent.dart';
import 'package:socialapp/notifications/bloc/notifyState.dart';
import 'package:socialapp/notifications/exportNotify.dart';
import 'package:socialapp/notifications/widget/notify_card.dart';
import 'package:socialapp/widgets/appBar/app_bar_login.dart';

class NotifyScreen extends StatefulWidget {
  final Color bodyColor;
  final int pagePosition;

  const NotifyScreen({Key key, this.bodyColor, this.pagePosition})
      : super(key: key);

  @override
  _notifyScreen createState() => _notifyScreen();
}

class _notifyScreen extends State<NotifyScreen> {
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  NotifyBloc notifyBloc;
  MyFeedBloc myFeedBloc;

  @override
  void initState() {
    _portraitModeOnly();
    notifyBloc = BlocProvider.of<NotifyBloc>(context);
    myFeedBloc = BlocProvider.of<MyFeedBloc>(context);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    notifyBloc.add(LoadNotifications());
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    notifyBloc.add(Disponse());
    _enableRotation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: constraints.maxHeight, minWidth: constraints.maxWidth),
          child: SingleChildScrollView(
            child: Column(
              children: [
                //build app bar
                AppBarCustom(
                  widgetSize: 150,
                  title: "${AppLocalizations.of(context).translate("appName")}",
                  titleColor: widget.bodyColor,
                  status: "home page",
                ),
                //make bloc notify
                //load all notify
                BlocBuilder(
                  cubit: notifyBloc,
                  builder: (context, state) {
                    if (state is NotifyLoading) {
                      return CircularProgressIndicator();
                    }
                    if (state is LoadNotifySuccess) {
                      // print('load success');
                      //clear stream
                      return RefreshIndicator(
                        color: Colors.pinkAccent,
                        key: _refreshIndicatorKey,
                        child: build_list_notify(
                            constraints: constraints,
                            itemsNotify: state.notifyItems,
                            myFeedBloc: myFeedBloc,
                            notifyBloc: notifyBloc),
                        onRefresh: () async {
                          print('refresh notify');
                          notifyBloc.add(LoadNotifications());
                        },
                      );
                    }
                    return Container();
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _portraitModeOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void _enableRotation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
}

class build_list_notify extends StatelessWidget {
  const build_list_notify({
    Key key,
    this.constraints,
    this.itemsNotify,
    this.notifyBloc,
    this.myFeedBloc,
  }) : super(key: key);
  final BoxConstraints constraints;
  final List<NotifyModel> itemsNotify;
  final NotifyBloc notifyBloc;
  final MyFeedBloc myFeedBloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .75,
      width: double.infinity,
      child: new ListView(
        children: itemsNotify.map((model) {
          //card notify list
          return NotifyCard(
            model: model,
            notifyBloc: notifyBloc,
            myFeedBloc: myFeedBloc,
          );
        }).toList(),
      ),
    );
  }
}

// class build_card_notify extends StatelessWidget {
//   const build_card_notify({
//     Key key,
//     this.model,
//     this.notifyBloc,
//     this.myFeedBloc,
//   }) : super(key: key);
//   final NotifyModel model;
//   final NotifyBloc notifyBloc;
//   final MyFeedBloc myFeedBloc;

//   @override
//   Widget build(BuildContext context) {
//     return Dismissible(
//       key: UniqueKey(),
//       onDismissed: (direction) {
//         if (direction == DismissDirection.startToEnd) {
//           notifyBloc.add(RemoveNotify(postId: model.postID));
//         } else {
//           notifyBloc.add(RemoveNotify(postId: model.postID));
//         }
//       },
//       background: Container(
//         height: 95.0,
//         decoration: BoxDecoration(
//             color: Colors.redAccent, borderRadius: BorderRadius.circular(12.0)),
//         child: Icon(
//           Icons.remove_circle_outline,
//           size: 32.0,
//           color: Colors.white,
//         ),
//       ),
//       child: InkWell(
//         onLongPress: () {},
//         onTap: () async {
//           // print("on click notify");
//           //check if type notidy
//           //- like give go to post that like
//           //- new post or new feed go to new post
//           //- comment go to comment page
//           //and before to  page
//           //give load post info and comment info

//           final feed = FeedRepository();

//           final item = await feed.getOneFeed(model.postID);

//           Navigator.of(context).push(MaterialPageRoute(
//             builder: (context) => Comments(
//               i: 0,
//               postModels: [item],
//               uid: model.uid,
//             ),
//           ));
//         },
//         child: Container(
//           width: double.infinity,
//           decoration: BoxDecoration(boxShadow: [
//             BoxShadow(
//                 color: Colors.black12,
//                 blurRadius: 12,
//                 offset: Offset(.5, .5),
//                 spreadRadius: .1)
//           ]),
//           padding: EdgeInsets.only(
//             bottom: 4.0,
//           ),
//           child: Stack(
//             children: [
//               Container(
//                 height: 95.0,
//                 width: MediaQuery.of(context).size.width * 1,
//                 decoration: BoxDecoration(
//                     color: Colors.pinkAccent.withOpacity(.6),
//                     boxShadow: [
//                       BoxShadow(
//                           color: Colors.pinkAccent.withOpacity(.3),
//                           blurRadius: 4,
//                           offset: Offset(.5, .5),
//                           spreadRadius: .1)
//                     ],
//                     borderRadius: BorderRadius.circular(8.0)),
//               ),
//               Container(
//                 height: 95.0,
//                 margin: EdgeInsets.symmetric(horizontal: 6.0),
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(8.0)),
//                 child: Stack(
//                   children: [
//                     Positioned(
//                       top: 8.5,
//                       left: 6.0,
//                       child: Container(
//                           height: 65.0,
//                           width: 65.0,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(50.0),
//                             color: Colors.white,
//                             boxShadow: [
//                               BoxShadow(
//                                   offset: Offset(.5, .5),
//                                   blurRadius: 0.5,
//                                   color: Colors.black.withOpacity(.15),
//                                   spreadRadius: .5)
//                             ],
//                             //shape: BoxShape.circle,
//                             image: DecorationImage(
//                               image: NetworkImage(
//                                   // '${userDetail[0].imageProfile}'
//                                   model.profileUrl.toString()),
//                               fit: BoxFit.cover,
//                             ),
//                           )),
//                     ),
//                     //create show user name if type is like notify
//                     //if not if show
//                     Positioned(
//                       left: 85.0,
//                       top: 16.0,
//                       child: Text(
//                         (model.getTypeNotify() == "comment")
//                             ? model.name + " comment" + "\n"
//                             : model.name + "\n",
//                         style: Theme.of(context).textTheme.headline6,
//                       ),
//                     ),
//                     //type is like show "give like your post"
//                     //type is post "He create new post now"
//                     Positioned(
//                         left: 85.0,
//                         top: 42.0,
//                         child: Text(
//                           model.getTypeNotify() == "new feed"
//                               ? "He create new post now"
//                               : (model.getTypeNotify() == "comment")
//                                   ? "${model.message}"
//                                   : "give like your post",
//                           style: TextStyle(
//                               color: Colors.black54,
//                               fontSize: 18.0,
//                               fontWeight: FontWeight.bold),
//                         )),
//                     //show time that make like or create post
//                     Positioned(
//                         right: 16.0,
//                         bottom: 12.0,
//                         child: Text(
//                           "${model.time}",
//                           style: TextStyle(
//                             fontSize: 14.0,
//                           ),
//                         ))
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

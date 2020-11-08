import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/home/export/export_file.dart';
import 'package:socialapp/notifications/bloc/notifyBloc.dart';
import 'package:socialapp/notifications/bloc/notifyEvent.dart';
import 'package:socialapp/notifications/bloc/notifyState.dart';
import 'package:socialapp/notifications/exportNotify.dart';
import 'package:socialapp/widgets/appBar/app_bar_login.dart';
import 'dart:async';

class NotifyScreen extends StatelessWidget {
  const NotifyScreen({Key key, this.bodyColor, this.pagePosition})
      : super(key: key);
  final Color bodyColor;
  final int pagePosition;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
        new GlobalKey<RefreshIndicatorState>();
    NotifyBloc notifyBloc = BlocProvider.of<NotifyBloc>(context);
    notifyBloc.add(LoadNotifications());

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
                  title: "Resocial",
                  titleColor: bodyColor,
                  status: "home page",
                ),
                //make bloc notify
                //load all notify
                BlocBuilder(
                  cubit: notifyBloc,
                  builder: (context, state) {
                    if (state is NotifyLoading) {
                      print('load notify :{}');
                      return CircularProgressIndicator();
                    }
                    if (state is LoadNotifySuccess) {
                      // print('load success');
                      //clear stream
                      notifyBloc.add(Disponse());
                      return RefreshIndicator(
                        color: Colors.pinkAccent,
                        key: _refreshIndicatorKey,
                        child: build_list_notify(
                            constraints: constraints,
                            itemsNotify: state.notifyItems,
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
}

class build_list_notify extends StatelessWidget {
  const build_list_notify({
    Key key,
    this.constraints,
    this.itemsNotify,
    this.notifyBloc,
  }) : super(key: key);
  final BoxConstraints constraints;
  final List<NotifyModel> itemsNotify;
  final NotifyBloc notifyBloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .75,
      width: double.infinity,
      child: new ListView(
        children: itemsNotify.map((model) {
          //card notify list
          return build_card_notify(model: model, notifyBloc: notifyBloc);
        }).toList(),
      ),
    );
  }
}

class build_card_notify extends StatelessWidget {
  const build_card_notify({
    Key key,
    this.model,
    this.notifyBloc,
  }) : super(key: key);
  final NotifyModel model;
  final NotifyBloc notifyBloc;
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('${model}'),
      onDismissed: (direction) {
        notifyBloc.add(RemoveNotify(postId: model.postID));
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: Offset(.5, .5),
              spreadRadius: .1)
        ]),
        padding: EdgeInsets.only(
          bottom: 4.0,
        ),
        child: Stack(
          children: [
            Container(
              height: 95.0,
              width: MediaQuery.of(context).size.width * 1,
              decoration: BoxDecoration(
                  color: Colors.pinkAccent.withOpacity(.6),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.pinkAccent.withOpacity(.3),
                        blurRadius: 4,
                        offset: Offset(.5, .5),
                        spreadRadius: .1)
                  ],
                  borderRadius: BorderRadius.circular(8.0)),
            ),
            Container(
              height: 95.0,
              margin: EdgeInsets.symmetric(horizontal: 6.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0)),
              child: Stack(
                children: [
                  Positioned(
                    top: 8.5,
                    left: 6.0,
                    child: Container(
                        height: 65.0,
                        width: 65.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(.5, .5),
                                blurRadius: 0.5,
                                color: Colors.black.withOpacity(.15),
                                spreadRadius: .5)
                          ],
                          //shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(
                                // '${userDetail[0].imageProfile}'
                                model.profileUrl.toString()),
                            fit: BoxFit.cover,
                          ),
                        )),
                  ),
                  //create show user name if type is like notify
                  //if not if show
                  Positioned(
                    left: 85.0,
                    top: 16.0,
                    child: Text(
                      model.name + "\n",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  //type is like show "give like your post"
                  //type is post "He create new post now"
                  Positioned(
                      left: 85.0,
                      top: 42.0,
                      child: Text(
                        model.getTypeNotify() == "new feed"
                            ? "He create new post now"
                            : "give like your post",
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      )),
                  //show time that make like or create post
                  Positioned(
                      right: 16.0,
                      bottom: 12.0,
                      child: Text(
                        "${model.time}",
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

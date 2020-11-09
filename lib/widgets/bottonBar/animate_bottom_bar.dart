import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/home/bloc/bloc_pageChange.dart';
import 'package:socialapp/home/bloc/event_pageChange.dart';
import 'package:socialapp/notifications/bloc/notifyBloc.dart';
import 'package:socialapp/notifications/bloc/notifyEvent.dart';
import 'package:socialapp/notifications/bloc/notifyState.dart';
import 'dart:async';

class AnimationBottomBar extends StatefulWidget {
  final List<BarItem> barItems;
  final Duration animationDuration;
  final Function onBarTab;
  final BarStyle barStyle;
  final PageNaviagtorChageBloc pageBloc;

  const AnimationBottomBar(
      {Key key,
      this.barItems,
      this.animationDuration = const Duration(milliseconds: 500),
      this.onBarTab,
      this.barStyle,
      this.pageBloc})
      : super(key: key);

  @override
  _AnimationBottomBarState createState() => _AnimationBottomBarState();
}

class _AnimationBottomBarState extends State<AnimationBottomBar>
    with TickerProviderStateMixin {
  int selectedBarIndex = 0;
  NotifyBloc notifyBloc;

  @override
  void initState() {
    // TODO: implement initState
    notifyBloc = BlocProvider.of<NotifyBloc>(context);
    notifyBloc.add(LoadCounter());
    super.initState();
  }

  @override
  void dispose() {
    notifyBloc.add(Disponse());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10.0,
      child: Padding(
        padding: const EdgeInsets.only(
            bottom: 10.0, top: 10.0, left: 16.0, right: 16.0),
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _buildBarItems(notifyBloc)),
      ),
    );
  }

  List<Widget> _buildBarItems(NotifyBloc notifyBloc) {
    List<Widget> _barItems = List();
    for (int i = 0; i < widget.barItems.length; i++) {
      BarItem item = widget.barItems[i];

      bool isSelected = selectedBarIndex == i;
      if (i == 1) {
        _barItems.add(inkWellButton(i, notifyBloc, isSelected, item));
      } else {
        _barItems.add(inkWellButtonNoBadge(i, isSelected, item));
      }
    }
    return _barItems;
  }

  InkWell inkWellButtonNoBadge(int i, bool isSelected, BarItem item) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        setState(() {
          selectedBarIndex = i;
          widget.onBarTab(selectedBarIndex);
          widget.pageBloc
              .add(new onPageChangeEvent(pageNumber: selectedBarIndex));
        });
      },
      child: AnimatedContainer(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        duration: widget.animationDuration,
        decoration: BoxDecoration(
            color:
                isSelected ? item.color.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(30.0))),
        child: Row(
          children: <Widget>[
            Icon(
              item.iconData,
              color: isSelected ? item.color : Colors.black,
              size: widget.barStyle.iconSize,
            ),
            SizedBox(
              width: 10.0,
            ),
            AnimatedSize(
              duration: widget.animationDuration,
              curve: Curves.easeInOut,
              vsync: this,
              child: Text(
                isSelected ? item.text : "",
                style: TextStyle(
                    color: item.color,
                    fontWeight: widget.barStyle.fontWeight,
                    fontSize: widget.barStyle.fointSize),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InkWell inkWellButton(
      int i, NotifyBloc notifyBloc, bool isSelected, BarItem item) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        // SharedPreferences _sharedPreferences =
        //     await SharedPreferences.getInstance();
        // setState(() {
        //if i as 1 is click page notify
        //if clear notify counter number
        (i == 1) ? notifyBloc.add(ClearCounterNotify()) : null;
        selectedBarIndex = i;
        widget.onBarTab(selectedBarIndex);

        widget.pageBloc.add(onPageChangeEvent(pageNumber: selectedBarIndex));
        // });
      },
      child: AnimatedContainer(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        duration: widget.animationDuration,
        decoration: BoxDecoration(
            color:
                isSelected ? item.color.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(30.0))),
        child: Row(
          children: <Widget>[
            BlocBuilder(
              cubit: notifyBloc,
              builder: (context, state) {
                if (state is LoadNotifyCounter) {
                  print('notify counter :' + state.counter);
                  return Badge(
                    toAnimate: false,
                    animationType: BadgeAnimationType.slide,
                    badgeColor: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                    badgeContent: (state.counter == "0")
                        ? null
                        : Text('${state.counter}',
                            style: TextStyle(color: Colors.white)),
                    child: Icon(
                      item.iconData,
                      color: isSelected ? item.color : Colors.black,
                      size: widget.barStyle.iconSize,
                    ),
                  );
                }
                return Icon(item.iconData,
                    color: isSelected ? item.color : Colors.black,
                    size: widget.barStyle.iconSize);
              },
            ),
            SizedBox(
              width: 10.0,
            ),
            AnimatedSize(
              duration: widget.animationDuration,
              curve: Curves.easeInOut,
              vsync: this,
              child: Text(
                isSelected ? item.text : "",
                style: TextStyle(
                    color: item.color,
                    fontWeight: widget.barStyle.fontWeight,
                    fontSize: widget.barStyle.fointSize),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BarStyle {
  final double fointSize, iconSize;
  final FontWeight fontWeight;

  BarStyle(
      {this.fointSize = 18.0,
      this.iconSize = 32.0,
      this.fontWeight = FontWeight.w600});
}

class BarItem {
  final String text;
  final IconData iconData;
  final Color color;

  BarItem(this.text, this.iconData, this.color);
}

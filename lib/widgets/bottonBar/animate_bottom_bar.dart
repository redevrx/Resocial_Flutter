import 'package:flutter/material.dart';

class AnimationBottomBar extends StatefulWidget {

  final List<BarItem> barItems;
  final Duration animationDuration;
  final Function onBarTab;
  final BarStyle barStyle;

  const AnimationBottomBar({Key key, this.barItems, this.animationDuration = const Duration(milliseconds: 500), this.onBarTab, this.barStyle}) : super(key: key);

  @override
  _AnimationBottomBarState createState() => _AnimationBottomBarState();
}

class _AnimationBottomBarState extends State<AnimationBottomBar> with TickerProviderStateMixin {
  int selectedBarIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10.0,
      child: Padding(
        padding: const EdgeInsets.only
        (
          bottom:10.0,
          top:10.0,
          left: 16.0,
          right: 16.0
          ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _buildBarItems()
        ),
      ),
    );
  }
 List<Widget> _buildBarItems(){
   List<Widget> _barItems = List();
   for(int i = 0; i < widget.barItems.length;i++)
   {
     BarItem item = widget.barItems[i];
     bool isSelected = selectedBarIndex == i;
     _barItems.add(InkWell
     (
       splashColor: Colors.transparent,
       onTap: (){
         setState(() {
           selectedBarIndex = i;
           widget.onBarTab(selectedBarIndex);
         });
       },
       child: AnimatedContainer(
         padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8.0),
         duration: widget.animationDuration,
         decoration: BoxDecoration
         (
           color: isSelected ? item.color.withOpacity(0.15) : Colors.transparent,
           borderRadius: BorderRadius.all(
             Radius.circular(30.0)
           )
         ),
         child: Row(
         children: <Widget>[
            Icon(item.iconData, color: isSelected ? item.color : Colors.black ,
           size: widget.barStyle.iconSize,
           ),
           SizedBox(width: 10.0,),
           AnimatedSize
           (
             duration: widget.animationDuration,
             curve: Curves.easeInOut,
             vsync: this,
             child: Text(
             isSelected ? item.text : "",
           style: TextStyle
           (
             color: item.color,
             fontWeight: widget.barStyle.fontWeight,
             fontSize: widget.barStyle.fointSize
           ),),
           ),
         ],
     ),
       ),
     )
     );
   }
   return _barItems;
  }
}

class BarStyle
{
  final double fointSize , iconSize;
  final FontWeight fontWeight;

  BarStyle({this.fointSize = 18.0, this.iconSize = 32.0, this.fontWeight =  FontWeight.w600});
}


class BarItem {
  final String text;
  final IconData iconData;
  final Color color;

  BarItem(this.text, this.iconData, this.color);
}

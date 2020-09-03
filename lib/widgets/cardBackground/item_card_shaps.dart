import 'package:flutter/cupertino.dart';
import 'package:socialapp/widgets/cardBackground/item_card_background_clip.dart';
class ItemCardShape extends ShapeBorder
{
  final double width;
  final double height;

 const ItemCardShape(this.width, this.height);
  
  @override
  // TODO: implement dimensions
  EdgeInsetsGeometry get dimensions => throw UnimplementedError();

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    // TODO: implement getInnerPath
    return null;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    // TODO: implement getOuterPath
    return ItemCardBackgroundClipper().getClip((Size(width,height))); //getClip(Size(width,height))
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {
    // TODO: implement paint
  }

  @override
  ShapeBorder scale(double t) {
    // TODO: implement scale
    return null;
  }
  
}
abstract class TextMoreEvent{}
class onShowMoreClick extends TextMoreEvent
{
  final bool value;
  final int textLen;

  onShowMoreClick({this.textLen,this.value = false});
}
class onShowLessClick extends TextMoreEvent
{
  final bool value;

  onShowLessClick({this.value = false});
}
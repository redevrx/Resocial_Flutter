abstract class TextMoreState{}
class onTextMoreResult extends TextMoreState
{
  final bool value;

  onTextMoreResult({this.value});
  @override
  String toString()=> "${this.value}";
}
import 'package:flutter/material.dart';

class widgetGetMessage extends StatefulWidget {
  final TextEditingController txtMessage;

  const widgetGetMessage({Key key, this.txtMessage}) : super(key: key);
  @override
  _widgetGetMessageState createState() => _widgetGetMessageState();
}
class _widgetGetMessageState extends State<widgetGetMessage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        height: 140.0,
        child: TextFormField(
          keyboardType: TextInputType.multiline,
          //  maxLength: 100,
          maxLines: 120,
          controller: widget.txtMessage,
          showCursor: true,
          decoration: InputDecoration(
              hintText: "Messages ....",
              disabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none),
        ),
      ),
    );
  }
  @override
  void dispose() {
    widget.txtMessage.dispose();
    super.dispose();
  }
}

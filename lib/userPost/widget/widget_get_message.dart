import 'package:flutter/material.dart';
import 'package:socialapp/userPost/bloc/post_bloc.dart';
import 'package:socialapp/userPost/export/export_new_post.dart';

class widgetGetMessage extends StatelessWidget {
  final PostBloc postBloc;
  final String oldMessage;

  const widgetGetMessage({Key key, this.postBloc, this.oldMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        child: TextFormField(
          onChanged: (message) =>
              postBloc.add(OnMessagePostChange(message: message)),
          keyboardType: TextInputType.multiline,
          maxLines: null,
          minLines: 4,
          initialValue: oldMessage ?? "",
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
}

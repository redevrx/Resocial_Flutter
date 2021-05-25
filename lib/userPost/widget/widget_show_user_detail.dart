import 'package:flutter/material.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/models/EditProfileModel.dart';
import 'package:socialapp/utils/utils.dart';

class widgetShowUserDetail extends StatelessWidget {
  final EditProfileModel model;
  const widgetShowUserDetail({
    Key key,
    this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          // make show icon user and name
          SizedBox(
            height: 12.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: <Widget>[
                ClipOval(
                  child: Image.network(
                    model.imageProfile == null || model.imageProfile.isEmpty
                        ? PersonURL
                        : "${model.imageProfile}",
                    fit: BoxFit.cover,
                    width: 50.0,
                    height: 50.0,
                  ),
                ),
                SizedBox(
                  width: 16.0,
                ),
                Text('${model.userName}',
                    style: Theme.of(context).textTheme.headline6),
              ],
            ),
          )
        ],
      ),
    );
  }
}

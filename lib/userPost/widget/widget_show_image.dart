import 'dart:io';
import 'package:flutter/material.dart';
import 'package:socialapp/home/widget/post_widget.dart';
import 'package:socialapp/userPost/models/file_model..dart';

class widgetShowImage extends StatelessWidget {
  final List<String> files;
  final List urls;
  final List urlsType;
  const widgetShowImage(
      {Key key, this.files = null, this.urls = null, this.urlsType})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<FileModel> filesModel = files == null
        ? null
        : files.map((e) => FileModel(file: File(e))).toList();
    return Container(
        child: filesModel != null
            ? Container(
                height: 300.0,
                width: double.infinity,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: filesModel.length,
                  itemBuilder: (context, index) {
                    return filesModel[index].getTypeFile()
                        ? PlayVideoList(
                            file: filesModel[index].file,
                            height: 300.0,
                          )
                        : Image.file(
                            filesModel[index].file,
                            fit: BoxFit.cover,
                            height: 300.0,
                          );
                  },
                ),
              )
            : (urls == null)
                ? Container(
                    height: 300.0,
                  )
                : Container(
                    height: 300.0,
                    child: ListView.builder(
                      itemCount: urls.length,
                      itemBuilder: (context, index) {
                        return urlsType[index] == "video"
                            ? PlayVideoList(
                                urls: urls[index],
                                height: 300.0,
                              )
                            : Image.network(
                                urls[index],
                                fit: BoxFit.cover,
                                height: 300.0,
                                width: double.infinity,
                              );
                      },
                    ),
                  ));
  }
}

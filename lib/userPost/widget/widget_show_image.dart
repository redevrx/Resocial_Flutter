import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/home/widget/post_widget.dart';
import 'package:socialapp/userPost/bloc/event_post.dart';
import 'package:socialapp/userPost/bloc/post_bloc.dart';
import 'package:socialapp/userPost/bloc/state_post.dart';

class WidgetShowImage extends StatelessWidget {
  final List<String> files;
  final List urls;
  final List urlsType;
  final bool editPost;
  final PostBloc postBloc;
  const WidgetShowImage(
      {Key key,
      this.files,
      this.urls,
      this.urlsType,
      this.editPost = false,
      this.postBloc})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    // List<FileModel> filesModel = files == null
    //     ? null
    //     : files.map((e) => FileModel(file: File(e))).toList();
    return postBloc != null && urls != null
        ? _buildRemoveImage()
        : urls != null
            ? WidgetItemImage(
                onTab: (index, type) {},
                urls: urls,
                urlsType: urlsType,
              )
            : Container(
                height: 300.0,
              );
    // return Container(
    //     child: filesModel != null
    //         ? Container(
    //             height: 300.0,
    //             width: double.infinity,
    //             child: ListView.builder(
    //               scrollDirection: Axis.horizontal,
    //               itemCount: filesModel.length,
    //               itemBuilder: (context, index) {
    //                 return filesModel[index].getTypeFile()
    //                     ? PlayVideoList(
    //                         file: filesModel[index].file,
    //                         height: 300.0,
    //                       )
    //                     : Image.file(
    //                         filesModel[index].file,
    //                         fit: BoxFit.cover,
    //                         height: 300.0,
    //                       );
    //               },
    //             ),
    //           )
    //         : (urls == null)
    //             ? Container(
    //                 height: 300.0,
    //               )
    //             : Container(
    //                 height: 300.0,
    //                 width: double.infinity,
    //                 child: ListView.builder(
    //                   scrollDirection: Axis.horizontal,
    //                   itemCount: urls.length,
    //                   itemBuilder: (context, index) {
    //                     return urlsType[index] == "video"
    //                         ? PlayVideoList(
    //                             urls: urls[index],
    //                             height: 300.0,
    //                           )
    //                         : Image.network(
    //                             urls[index],
    //                             fit: BoxFit.cover,
    //                             height: 300.0,
    //                           );
    //                   },
    //                 ),
    //               ));
  }

  Container _buildRemoveImage() {
    return Container(
      height: 300.0,
      width: double.infinity,
      child: BlocBuilder<PostBloc, StatePost>(
        cubit: postBloc,
        builder: (context, state) {
          if (state is OnImageFileRemoveChangeState) {
            return WidgetItemImage(
              onTab: (index, type) {
                postBloc.add(OnImageFileRemoveChange(
                    type: type,
                    indexRemove: index,
                    urlTypes: state.urlTypes,
                    urls: state.urls));
              },
              urls: state.urls,
              urlsType: state.urlTypes,
            );
          }
          return WidgetItemImage(
            onTab: (index, type) {
              postBloc.add(OnImageFileRemoveChange(
                  type: type,
                  indexRemove: index,
                  urlTypes: urlsType,
                  urls: urls));
            },
            urls: urls,
            urlsType: urlsType,
          );
        },
      ),
    );
  }
}

class WidgetItemImage extends StatelessWidget {
  const WidgetItemImage({
    Key key,
    this.urls,
    this.urlsType,
    this.onTab,
  }) : super(key: key);

  final List urls;
  final List urlsType;
  final Function(int, String) onTab;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.0,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: urls.length,
        itemBuilder: (context, index) {
          switch (urlsType[index]) {
            case "video":
              return InkWell(
                onTap: () {
                  onTab(index, "video");
                },
                child: Stack(
                  children: [
                    PlayVideoList(
                      file: File(urls[index]),
                      height: 300.0,
                    ),
                    Positioned(
                      right: 16.0,
                      child: PhysicalModel(
                        color: Colors.white,
                        shadowColor: Colors.black,
                        elevation: 12.0,
                        shape: BoxShape.circle,
                        child: Icon(Icons.close),
                      ),
                    )
                  ],
                ),
              );
              break;
            case "video_url":
              return InkWell(
                onTap: () {
                  onTab(index, "video_url");
                },
                child: Stack(
                  children: [
                    PlayVideoList(
                      urls: urls[index],
                      height: 300.0,
                    ),
                    Positioned(
                      right: 16.0,
                      child: PhysicalModel(
                        color: Colors.white,
                        shadowColor: Colors.black,
                        elevation: 12.0,
                        shape: BoxShape.circle,
                        child: Icon(Icons.close),
                      ),
                    )
                  ],
                ),
              );
              break;
            case "image":
              return InkWell(
                onTap: () {
                  onTab(index, "image");
                },
                child: Stack(
                  children: [
                    Image.file(
                      File(urls[index]),
                      fit: BoxFit.cover,
                      height: 300.0,
                    ),
                    Positioned(
                      right: 16.0,
                      child: PhysicalModel(
                        color: Colors.white,
                        shadowColor: Colors.black,
                        elevation: 12.0,
                        shape: BoxShape.circle,
                        child: Icon(Icons.close),
                      ),
                    )
                  ],
                ),
              );
              break;
            case "image_url":
              return InkWell(
                onTap: () {
                  onTab(index, "image_url");
                },
                child: Stack(
                  children: [
                    Image.network(
                      urls[index],
                      fit: BoxFit.cover,
                      height: 300.0,
                    ),
                    Positioned(
                      right: 16.0,
                      child: PhysicalModel(
                        color: Colors.white,
                        shadowColor: Colors.black,
                        elevation: 12.0,
                        shape: BoxShape.circle,
                        child: Icon(Icons.close),
                      ),
                    )
                  ],
                ),
              );
              break;
            default:
              return Container();
              break;
          }
        },
      ),
    );
  }
}

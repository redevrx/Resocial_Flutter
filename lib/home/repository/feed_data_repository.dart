import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/models/EditProfileModel.dart';
import 'package:socialapp/home/export/export_file.dart';

class FeedRepository {
  Future<PostModel> getOneFeed(String postId) async {
    // print("on click notify");
    final _mRef = FirebaseFirestore.instance.collection("Post");

    return await _mRef.doc(postId).get().then((postItem) {
      // print(postItem.get("body"));
      return PostModel.fromJson(postItem);
    });
  }

//list and stream of this user feed
  // StreamController<List<PostModel>> streamControllerOnwerUser =
  //     StreamController.broadcast();

  BehaviorSubject<List<PostModel>> streamControllerOnwerUser =
      BehaviorSubject<List<PostModel>>();

  List<List<PostModel>> onwerListFeed = [[]];
  DocumentSnapshot _lastDocumentOnweFeed;
  bool _hasMoreDataOnwerFeed = true;

  Stream<List<PostModel>> getMyFeed(String uid) {
    requestOnwerFeed(uid);

    return streamControllerOnwerUser.stream;
  }

  Future<List<String>> onCheckUserLikePost(
      List<DocumentSnapshot> postId) async {
    List<String> result = [];

    //  print('I :${i}');
    //db
    final _mRef = FirebaseFirestore.instance;
    final _mAuth = await FirebaseAuth.instance.currentUser;
    final uid = _mAuth.uid.toString();

    for (int i = 0; i < postId.length; i++) {
      await _mRef
          .collection("likes post")
          .doc(postId[i].data()['postId'].toString())
          .collection(uid)
          .doc("likes")
          .get()
          .then((value) async {
        var it = value.get("user").toString();
        //print("like result :${it}");

        if (it == uid) {
          await result.add('likes');
          // unlike
        } else {
          await result.add('un');
          // user like
        }
      }).catchError((e) async {
        await result.add('un');
      });
    }

    //get data in path
    // try
    // {
    //   await _mRef.collection("likes post").document(postId).get()
    // .then((value) async{
    //  var it = value["${uid}"].toString();
    //  //print("like result :${it}");

    //   if(it == uid)
    //   {
    //    await result.add('likes');
    //     // unlike
    //   }
    //   else
    //   {
    //   await result.add('un');
    //     // user like
    //   }
    // }).catchError((e) async
    // {

    //   await result.add('un');
    //    print("error load like :${e}");
    // });
    // }
    // catch(e)
    // {
    //   print(e);
    //    await result.add(false);
    // }
    return result;
  }

  // StreamController<List<PostModel>> _feedController =
  //     StreamController<List<PostModel>>.broadcast();

  BehaviorSubject<List<PostModel>> _feedController =
      BehaviorSubject<List<PostModel>>();

  List<List<PostModel>> models = [[]];
  // List<DocumentSnapshot> likeModel;
  DocumentSnapshot _lastDocument;
  bool _hasMoreData = true;

  Stream<List<PostModel>> getFeed(int min, int max) {
    requestAllFeedLimit(min, max);

    return _feedController.stream;

    // await _mRef.collection("Post").get().then((value) {
    //   // print('map Value :'+value.documents[0].data['likeResult']['${value.documents[0].data['uid'].toString()}'].toString());
    //   //print('map Value :${value.documents.length}');
    //   // for (int i = 0; i < value.documents.length; i++) {

    //   //   likeModel.add(new LiekModel
    //   //   (
    //   //     user: value.documents[i].data['likeResult']['${value.documents[i].data['uid'].toString()}']
    //   //   ));

    //   //   models.add(new PostModel(
    //   //       body: value.documents[i].data['body'].toString(),
    //   //       commentCount: value.documents[i].data['commentCount'].toString(),
    //   //       date: value.documents[i].data['date'].toString(),
    //   //       image: value.documents[i].data['image'].toString(),
    //   //       likeResult:  likeModel,
    //   //       likesCount: value.documents[i].data['likesCount'].toString(),
    //   //       postId: value.documents[i].data['postId'],
    //   //       time: value.documents[i].data['time'].toString(),
    //   //       type: value.documents[i].data['type'].toString(),
    //   //       uid: value.documents[i].data['uid'].toString(),));
    //   // }
    //   models = value.docs.map((model) => PostModel.fromJson(model)).toList();
    // });

    // print('map Value :${models.length}');
    // return models;
  }

  void requestAllFeedLimit(int min, int max) {
    final _mRef = FirebaseFirestore.instance;

    var feedRequest =
        _mRef.collection("Post").orderBy("date", descending: true).limit(max);
    //load after feed

    //check last document
    if (_lastDocument != null) {
      feedRequest = feedRequest.startAfterDocument(_lastDocument);
    }

    if (!_hasMoreData) return;

    // If there's no more posts then bail out of the function
    var currentPage = models.length;

    feedRequest.snapshots(includeMetadataChanges: true).listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        var feed =
            snapshot.docs.map((model) => PostModel.fromJson(model)).toList();
        bool pageExists = currentPage < models.length;

        if (pageExists) {
          models[currentPage] = feed;
        } else {
          models.add(feed);
        }
        //  // Concatenate the full list to be shown
        var allFeed = models.fold<List<PostModel>>(
            [], (initialValue, element) => initialValue..addAll(element));

        print('all feed legnth service :${allFeed.length}');

        _feedController..sink.add(allFeed);

        // Save the last document from the results only if it's the current last page
        if (currentPage == models.length - 1) {
          _lastDocument = snapshot.docs.last;
        }
        _hasMoreData = feed.length == max;
        // return allFeed;
      }
    });
  }

  void close() async {
    await _feedController?.close();
    await streamControllerOnwerUser?.close();
    models = [];
    onwerListFeed = [];
  }

  void requestMoreData() => requestAllFeedLimit(0, 6);

  Future<List<EditProfileModel>> getUserDetail() async {
    List<EditProfileModel> detailModel = [];

    final _mRef = FirebaseFirestore.instance;

    await _mRef.collection('user info').get().then((value) {
      detailModel = value.docs
          .map((model) => EditProfileModel.fromJson(model.data()))
          .toList();
    });

    return detailModel;
  }

  void requestOnwerFeed(String uid) {
    int max = 6;

    //firebase data path
    print("start load user feed :${uid}");
    final _mRef = FirebaseFirestore.instance;

    var refFeed = _mRef
        .collection("Post")
        .where("uid", isEqualTo: uid)
        .orderBy("date", descending: true)
        .limit(max);

    //check last document
    if (_lastDocumentOnweFeed != null) {
      refFeed = refFeed.startAfterDocument(_lastDocumentOnweFeed);
    }

    if (!_hasMoreDataOnwerFeed) return;

    // If there's no more posts then bail out of the function
    var currentPage = onwerListFeed.length;

    refFeed.snapshots(includeMetadataChanges: true).listen((snapshot) {
      // if (snapshot.docs == null) return;
      var feedOnwer = snapshot.docs.map((e) => PostModel.fromJson2(e)).toList();

      bool pageExists = currentPage < onwerListFeed.length;
      //position item in list

      if (pageExists) {
        onwerListFeed[currentPage] = feedOnwer;
      } else {
        onwerListFeed.add(feedOnwer);
      }

      //  // Concatenate the full list to be shown
      var allFeed = onwerListFeed.fold<List<PostModel>>(
          [], (initialValue, element) => initialValue..addAll(element));

      print('all feed onwer user legnth service :${allFeed.length}');

      streamControllerOnwerUser
        ..sink
        ..add(allFeed);

      // Save the last document from the results only if it's the current last page
      if (currentPage == onwerListFeed.length - 1) {
        _lastDocumentOnweFeed = snapshot.docs.last;
      }
      _hasMoreDataOnwerFeed = feedOnwer.length == max;
      // return allFeed;
    });
  }
}

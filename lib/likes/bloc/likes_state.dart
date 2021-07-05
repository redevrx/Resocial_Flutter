abstract class LikeState {}

class OnLikesResult extends LikeState {
  final bool likeResult;

  OnLikesResult({this.likeResult});
  @override
  String toString() => "${this.likeResult}";
}

class OnCheckLikesResult extends LikeState {
  final List<String> likeResult;

  OnCheckLikesResult({this.likeResult});
  @override
  String toString() => "${this.likeResult}";
}

class OnLikeProgress extends LikeState {}

class OnLikeResultPost extends LikeState {}

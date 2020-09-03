abstract class LikeState{}
class onLikesResult extends LikeState
{
  final bool likeResult;

  onLikesResult({this.likeResult});
  @override
  String toString()=> "${this.likeResult}";
}
class onCheckLikesResult extends LikeState
{
  final List<String> likeResult;

  onCheckLikesResult({this.likeResult});
  @override
  String toString()=> "${this.likeResult}";
}
class onLikeProgress extends LikeState{}
class onLikeResultPost extends LikeState{}
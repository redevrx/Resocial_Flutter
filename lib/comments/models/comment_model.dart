class CommentModel
{
   String commentId;
   String body;
   String day;
   String time;
   String uid;
   String userName;
   String imageProfile;

  CommentModel({this.commentId, this.body, this.day, this.time, this.uid, this.userName, this.imageProfile});

  CommentModel.fromJson(Map json):
  commentId = json['commentId'],
  body = json['body'],
  day = json['day'],
  time = json['time'],
  userName = json['userName'],
  uid = json['uid'],
  imageProfile = json['imageProfile'];

  Map toJson()
  {
    return {'commentId':commentId,'body':body,'day':day,'time':time,'userName':userName,'uid':uid,'imageProfile':imageProfile};
  }

}
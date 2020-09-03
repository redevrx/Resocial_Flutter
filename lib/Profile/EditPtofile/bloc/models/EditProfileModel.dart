class EditProfileModel
{
  final String email;
  final String imageProfile;
  final String nickName;
  final String uid;
  final String userName;
  final String userStatus;
  final String backgroundImage;

  EditProfileModel({this.email = "", this.imageProfile = "", this.nickName = "", this.uid = "", this.userName = "", this.userStatus = "", this.backgroundImage = ""});

  EditProfileModel.fromJson(Map json):
  email = json['email'],
  imageProfile = json['imageProfile'],
  nickName = json['nickName'],
  uid = json['uid'],
  userName = json['user'],
  userStatus = json['userStatus'],
  backgroundImage = json['backgroundImage'];

  Map toJson()
  {
    return {'email':email , 'imageProfile':imageProfile ,'nickName':nickName ,'uid':uid ,'user':userName ,'userStatus':userStatus ,'backgroundImage':backgroundImage};
  }

}
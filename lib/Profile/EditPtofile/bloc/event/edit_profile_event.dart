import 'dart:io';

abstract class EditProfileEvent{}
class EditProfileBackgroundClik extends EditProfileEvent
{
   final File image;

  EditProfileBackgroundClik(this.image);
}
class EditProfileImageClick extends EditProfileEvent
{
  final File image;

  EditProfileImageClick(this.image);
}
class EditProfileNameClik extends EditProfileEvent
{
  final String data;

  EditProfileNameClik({this.data = ""});
}
class EditProfileStstusClick extends EditProfileEvent
{
  final String data;

  EditProfileStstusClick({this.data = ""});
}
class EditProfileLoadUserInfo extends EditProfileEvent
{
  final String uid;
  EditProfileLoadUserInfo({this.uid = ""});
}
class loadFriendProfile extends EditProfileEvent
{
  final String uid;

  loadFriendProfile({this.uid = ""});
}
class loadFriendProfilePost extends EditProfileEvent
{
}
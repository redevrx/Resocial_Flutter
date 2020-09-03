import 'package:socialapp/Profile/AddProfile/bloc/models/add_profile_model.dart';

abstract class AddProfileEvent{}
class onSaveAddprofile extends AddProfileEvent
{
  final AddProfileModel data;

  onSaveAddprofile(this.data);
}
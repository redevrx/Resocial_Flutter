abstract class FriendManageEvent
{}

class onCheckStatusFrinds extends FriendManageEvent
{
  final String uid;

  onCheckStatusFrinds({this.uid = ""});
  @override
  String toString() => "${this..uid}";
}
class onRequestFriendClick extends FriendManageEvent
{
  final String data;

  onRequestFriendClick({this.data = ""});
}

class onUnRequestFriendClick extends FriendManageEvent
{
  final String data;

  onUnRequestFriendClick({this.data = ""});
}

class onAcceptFriendClick extends FriendManageEvent
{
  final String data;

  onAcceptFriendClick({this.data = ""});
}

class onRemoveFriendClick extends FriendManageEvent
{
  final String data;

  onRemoveFriendClick({this.data = ""});
}
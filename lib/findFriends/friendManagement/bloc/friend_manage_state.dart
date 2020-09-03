abstract class FriendMangeState{}

class onShowDialogRequest extends FriendMangeState{}
class onNewFreind extends FriendMangeState{}
class onShowFriend extends FriendMangeState{}
class onShowRequestFrind extends FriendMangeState{}
class onShowUnRequestfrind extends FriendMangeState{}
class onShowAcceptFriend extends FriendMangeState{}
class onShowRemoveFrind extends FriendMangeState{}
class onShowRemoveRequest extends FriendMangeState{}
class onFailed extends FriendMangeState
{
  final String e;
  onFailed(this.e);
  @override
  String toString ()=> "${e}";
}
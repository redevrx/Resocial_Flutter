import 'package:equatable/equatable.dart';

abstract class ChatState extends Equatable {}

//show while that downloading chat info
class ChatLoadingState extends ChatState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

//show while that downloaded success
class ChatLoadedState extends ChatState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

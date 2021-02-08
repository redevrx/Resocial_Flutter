import 'package:equatable/equatable.dart';
import 'package:socialapp/call/model/call_model.dart';

abstract class CallState extends Equatable {}

//initial state
//return null value
class CallInitialState extends CallState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

/**
 this event will return result call stream 
 */
class OnCallStreamSuccess extends CallState {
  CallModel callModel;

  OnCallStreamSuccess({this.callModel});
  @override
  // TODO: implement props
  List<Object> get props => [this.callModel];
}

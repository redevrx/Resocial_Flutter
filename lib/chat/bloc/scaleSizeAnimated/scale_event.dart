import 'package:equatable/equatable.dart';

abstract class ScaleEvent extends Equatable {}

class OnInitialSize extends ScaleEvent {
  final double size;

  OnInitialSize({this.size});
  @override
  // TODO: implement props
  List<Object> get props => [this.size];
}

class OnScaleSize extends ScaleEvent {
  final double size;

  OnScaleSize({this.size});

  @override
  // TODO: implement props
  List<Object> get props => [this.size];
}

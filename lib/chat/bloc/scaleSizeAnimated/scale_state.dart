import 'package:equatable/equatable.dart';

abstract class ScaleState extends Equatable {}

class OnScaleSizeInitialResult extends ScaleState {
  final double size;

  OnScaleSizeInitialResult(this.size);
  @override
  // TODO: implement props
  List<Object> get props => [this.size];
}

class OnScaleSizeResult extends ScaleState {
  final double size;

  OnScaleSizeResult(this.size);
  @override
  // TODO: implement props
  List<Object> get props => [this.size];
}

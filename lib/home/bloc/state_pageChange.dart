import 'package:equatable/equatable.dart';

abstract class PageChangeState extends Equatable {}

class onPageChangeState extends PageChangeState {
  final int pageNumber;

  onPageChangeState({this.pageNumber});

  @override
  // TODO: implement props
  List<Object> get props => [this.pageNumber];
}

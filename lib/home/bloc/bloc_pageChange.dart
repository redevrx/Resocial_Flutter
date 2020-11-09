import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/home/bloc/event_pageChange.dart';
import 'package:socialapp/home/bloc/state_pageChange.dart';
import 'dart:async';

class PageNaviagtorChageBloc extends Bloc<PageChangeEvent, PageChangeState> {
  PageNaviagtorChageBloc(PageChangeState initialState) : super(initialState);

  @override
  Stream<PageChangeState> mapEventToState(PageChangeEvent event) async* {
    if (event is onPageChangeEvent) {
      yield onPageChangeState(pageNumber: event.pageNumber);
    }
  }
}

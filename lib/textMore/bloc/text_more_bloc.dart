import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/textMore/bloc/text_more_event.dart';
import 'package:socialapp/textMore/bloc/text_more_state.dart';
import 'dart:async';

class TextMoreBloc extends Bloc<TextMoreEvent, TextMoreState> {
  TextMoreBloc() : super(onTextMoreResult(value: false));
  @override
  Stream<TextMoreState> mapEventToState(TextMoreEvent event) async* {
    if (event is onShowMoreClick) {
      yield onTextMoreResult(value: event.value);
    }
    if (event is onShowLessClick) {
      yield onTextMoreResult(value: event.value);
    }
  }
}

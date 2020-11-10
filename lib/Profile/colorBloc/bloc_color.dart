import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/Profile/colorBloc/event_color.dart';
import 'package:socialapp/Profile/colorBloc/state_color.dart';
import 'dart:async';

class ColorBloc extends Bloc<ColorEvent, ColorState> {
  ColorBloc(ColorState initialState) : super(initialState);

  @override
  Stream<ColorState> mapEventToState(ColorEvent event) async* {
    if (event is onColorChangeEvent) {
      yield onColorChangeState(color: event.color);
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/Login/bloc/states/login_state.dart';
import 'package:socialapp/chat/bloc/scaleSizeAnimated/scale_event.dart';
import 'package:socialapp/chat/bloc/scaleSizeAnimated/scale_state.dart';

class ScaleBloc extends Bloc<ScaleEvent, ScaleState> {
  ScaleBloc(ScaleState initialState) : super(OnScaleSizeInitialResult(0.0));

  @override
  Stream<ScaleState> mapEventToState(ScaleEvent event) async* {
    if (event is OnInitialSize) {
      yield OnScaleSizeInitialResult(0.0);
    }
    if (event is OnScaleSize) {
      yield OnScaleSizeResult(event.size);
    }
  }
}

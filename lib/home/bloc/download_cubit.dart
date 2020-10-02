import 'package:flutter_bloc/flutter_bloc.dart';

enum DownloadState { onNormalDwonlaod, onStartDownload, onDownloadSuccess }
// normalDwonlaod no start download

class DownloadCubit extends Cubit<DownloadState> {
  DownloadCubit(DownloadState state) : super(state);

  void onNormalDownload() => emit(DownloadState.onNormalDwonlaod);
  void onClickDownload() => emit(DownloadState.onStartDownload);
  void onDownloadSuccess() => emit(DownloadState.onDownloadSuccess);
}

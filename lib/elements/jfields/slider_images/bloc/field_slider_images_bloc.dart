import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:omdk/common/enums/enums.dart';
import 'package:omdk_opera_repo/omdk_opera_repo.dart';

part 'field_slider_images_event.dart';

part 'field_slider_images_state.dart';

class FieldSliderImagesBloc
    extends Bloc<FieldSliderImagesEvent, FieldSliderImagesState> {
  FieldSliderImagesBloc(this._attachmentRepo)
      : super(const FieldSliderImagesState()) {
    on<DownloadImages>(_onDownloadImages);
  }

  final AttachmentRepo _attachmentRepo;

  Future<void> _onDownloadImages(
    DownloadImages event,
    Emitter<FieldSliderImagesState> emit,
  ) async {
    if (event.images == null) {
      return emit(
        state.copyWith(loadingStatus: LoadingStatus.failure),
      );
    }
    try {
      final imageList = <Uint8List>[];
      for(final i in event.images!){
        final image = await _attachmentRepo.download(i);
        imageList.add(image);
      }
      emit(
        state.copyWith(
          loadingStatus: LoadingStatus.done,
          imageList: imageList,
        ),
      );
    } catch (_) {
      return emit(
        state.copyWith(loadingStatus: LoadingStatus.failure),
      );
    }
  }
}

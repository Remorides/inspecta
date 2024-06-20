import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:omdk/common/enums/enums.dart';
import 'package:omdk_opera_repo/omdk_opera_repo.dart';

part 'field_image_event.dart';

part 'field_image_state.dart';

class FieldImageBloc extends Bloc<FieldImageEvent, FieldImageState> {
  FieldImageBloc(this._attachmentRepo) : super(const FieldImageState()) {
    on<DownloadImage>(_onDownloadImage);
  }

  final AttachmentRepo _attachmentRepo;

  Future<void> _onDownloadImage(
    DownloadImage event,
    Emitter<FieldImageState> emit,
  ) async {
    if(event.imageGuid == null) {
      return emit(
        state.copyWith(loadingStatus: LoadingStatus.failure),
      );
    }
    try {
      final image = await _attachmentRepo.download(event.imageGuid!);
      return emit(
        state.copyWith(
          loadingStatus: LoadingStatus.done,
          attachment: image,
        ),
      );
    } catch (_) {
      return emit(
        state.copyWith(loadingStatus: LoadingStatus.failure),
      );
    }
  }
}

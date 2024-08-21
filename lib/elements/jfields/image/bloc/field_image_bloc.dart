import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:omdk_inspecta/common/enums/enums.dart';
import 'package:omdk_opera_repo/omdk_opera_repo.dart';

part 'field_image_event.dart';

part 'field_image_state.dart';

class FieldImageBloc extends Bloc<FieldImageEvent, FieldImageState> {
  FieldImageBloc(this._attachmentRepo) : super(const FieldImageState()) {
    on<DownloadImage>(_onDownloadImage);
  }

  final OperaAttachmentRepo _attachmentRepo;

  Future<void> _onDownloadImage(
    DownloadImage event,
    Emitter<FieldImageState> emit,
  ) async {
    if (event.imageGuid == null) {
      return emit(
        state.copyWith(loadingStatus: LoadingStatus.failure),
      );
    }
    final imageRequest = await _attachmentRepo.download(event.imageGuid!);
    imageRequest.fold(
      (data) => emit(
        state.copyWith(
          loadingStatus: LoadingStatus.done,
          attachment: data,
        ),
      ),
      (failure) => emit(state.copyWith(loadingStatus: LoadingStatus.failure)),
    );
  }
}

import 'package:flutter/cupertino.dart';

extension FieldTextErrorHelper on FieldTextError? {
  String localizateError(BuildContext context) => switch (this) {
        FieldTextError.mandatory => 'Campo obbligatorio',
        FieldTextError.notEmpty => 'Questo campo non puo essere vuoto',
        FieldTextError.notNullable => 'Questo campo non puo essere null',
        null => '',
      };
}

enum FieldTextError {
  mandatory,
  notEmpty,
  notNullable,
}

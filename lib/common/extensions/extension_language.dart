import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:omdk_inspecta/common/common.dart';
import 'package:omdk_opera_api/omdk_opera_api.dart';

export 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension LanguageContextHelper on BuildContext {
  AppLocalizations get l => AppLocalizations.of(this)!;
}

extension LanguageCodeHelper on BuildContext {
  String get languageCode => Localizations.localeOf(this).languageCode;

}

extension LabelLanguageContextHelper on BuildContext {
  String? localizeLabel(List<JCultureDependentValue>? titles) {
    return (titles?.singleWhereOrNull(
              (e) =>
                  e.culture?.contains(
                    Localizations.localeOf(this).languageCode,
                  ) ??
                  false,
            ) ??
            titles?[0])
        ?.value;
  }
}

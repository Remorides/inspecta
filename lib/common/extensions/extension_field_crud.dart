import 'package:omdk_opera_api/omdk_opera_api.dart';

export 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension CRUDHelper on JOperation? {

  bool get checkC => this?.values?.contains('C') ?? false;

  bool get checkR => this?.values?.contains('R') ?? false;

  bool get checkU => this?.values?.contains('U') ?? false;

  bool get checkD => this?.values?.contains('D') ?? false;

}

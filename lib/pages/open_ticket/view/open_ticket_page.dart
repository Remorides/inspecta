import 'dart:html' as web;

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:omdk_inspecta/common/enums/enums.dart';
import 'package:omdk_inspecta/elements/alerts/alerts.dart';
import 'package:omdk_inspecta/elements/elements.dart';
import 'package:omdk_inspecta/pages/open_ticket/bloc/open_ticket_bloc.dart';
import 'package:omdk_opera_api/omdk_opera_api.dart';
import 'package:omdk_opera_repo/omdk_opera_repo.dart';
import 'package:omdk_repo/omdk_repo.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

part 'open_ticket_view.dart';

/// Login page builder
class OpenTicketPage extends StatelessWidget {
  /// Create [OpenTicketPage] instance
  OpenTicketPage({super.key});

  /// Global route of login page
  static Route<void> route() {
    return CupertinoPageRoute<void>(builder: (_) => OpenTicketPage());
  }

  //Get params from url
  final _paramGUID = Uri.base.queryParameters['guid'];
  final _paramClose = Uri.base.queryParameters['close'];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OpenTicketBloc(
        assetRepo: context.read<EntityRepo<Asset>>(),
        scheduledRepo: context.read<EntityRepo<ScheduledActivity>>(),
        schemaListRepo: context.read<EntityRepo<SchemaListItem>>(),
        mappingRepo: context.read<EntityRepo<MappingVersion>>(),
        operaUtils: context.read<OperaUtils>(),
        schemaRepo: context.read<EntityRepo<OSchema>>(),
      )
        ..add(InitAssetReference(guid: _paramGUID))
        ..add(InitSchemas()),
      child: _OpenTicketView(
        closePage: _paramClose != null,
      ),
    );
  }
}

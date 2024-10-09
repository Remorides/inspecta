import 'dart:html' as web;

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk_inspecta/common/common.dart';
import 'package:omdk_inspecta/elements/alerts/alerts.dart';
import 'package:omdk_inspecta/elements/elements.dart';
import 'package:omdk_inspecta/pages/edit_ticket/bloc/edit_ticket_bloc.dart';
import 'package:omdk_opera_api/omdk_opera_api.dart';
import 'package:omdk_opera_repo/omdk_opera_repo.dart';
import 'package:omdk_repo/omdk_repo.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

part 'edit_ticket_view.dart';

/// Login page builder
class EditTicketPage extends StatelessWidget {
  /// Create [EditTicketPage] instance
  const EditTicketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditTicketBloc(
        scheduledRepo: context.read<EntityRepo<ScheduledActivity>>(),
        mappingRepo: context.read<EntityRepo<MappingVersion>>(),
        operaUtils: context.read<OperaUtils>(),
      )..add(CheckStateTicket(guid: Uri.base.queryParameters['guid'])),
      child: _EditTicketView(
        closePage: Uri.base.queryParameters['close'] != null,
      ),
    );
  }
}

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk/common/enums/enums.dart';
import 'package:omdk/common/extensions/extensions.dart';
import 'package:omdk/elements/elements.dart';
import 'package:omdk/pages/open_ticket/bloc/open_ticket_bloc.dart';
import 'package:omdk_mapping/omdk_mapping.dart';
import 'package:omdk_repo/omdk_repo.dart';
import 'package:opera_api_asset/opera_api_asset.dart';
import 'package:opera_api_entity/opera_api_entity.dart';
import 'package:opera_repo/opera_repo.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OpenTicketBloc(
        assetRepo: context.read<EntityRepo<Asset>>(),
        schemaListRepo: context.read<EntityRepo<SchemaListItem>>(),
        mappingRepo: context.read<EntityRepo<MappingVersion>>(),
        operaRepo: context.read<OperaRepo>(),
        schemaRepo: context.read<EntityRepo<OSchema>>(),
      )
        ..add(InitAssetReference(guid: _paramGUID))
        ..add(InitSchemas()),
      child: const _OpenTicketView(),
    );
  }
}

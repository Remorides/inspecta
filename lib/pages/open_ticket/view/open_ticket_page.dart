import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk/common/enums/enums.dart';
import 'package:omdk/elements/elements.dart';
import 'package:omdk/pages/open_ticket/bloc/open_ticket_bloc.dart';
import 'package:omdk_repo/omdk_repo.dart';
import 'package:opera_api_asset/opera_api_asset.dart';
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
        schemaRepo: context.read<EntityRepo<SchemaListItem>>(),
      )..add(InitAssetReference(guid: _paramGUID)),
      child: const _OpenTicketView(),
    );
  }
}

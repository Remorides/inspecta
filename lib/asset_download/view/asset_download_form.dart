import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk/asset_download/bloc/asset_download_bloc.dart';
import 'package:omdk/common/enums/loading_status.dart';
import 'package:omdk_repo/omdk_repo.dart';
import 'package:opera_api_asset/opera_api_asset.dart';

class AssetDownloadForm extends StatelessWidget {
  const AssetDownloadForm({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => AssetDownloadBloc(
          assetRepo: context.read<EntityRepo<Asset>>(),
        ),
        child: const AssetDownloadForm(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AssetDownloadBloc, AssetDownloadState>(
      listener: (context, state) {
        if (state.loadingStatus == LoadingStatus.done) {
          Navigator.of(context).pop();
        }
        if (state.loadingStatus == LoadingStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Asset Failure')),
            );
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _GuidAssetInput(),
              const Padding(padding: EdgeInsets.all(12)),
              _DownloadButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _GuidAssetInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssetDownloadBloc, AssetDownloadState>(
      buildWhen: (previous, current) => previous.assetGuid != current.assetGuid,
      builder: (context, state) {
        return ColoredBox(
          color: Colors.green,
          child: TextField(
            key: const Key('assetForm_guidInput_textField'),
            onChanged: (username) => context
                .read<AssetDownloadBloc>()
                .add(AssetInputGuidChanged(username)),
          ),
        );
      },
    );
  }
}

class _DownloadButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssetDownloadBloc, AssetDownloadState>(
      builder: (context, state) {
        return state.loadingStatus == LoadingStatus.inProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('assetForm_continue_raisedButton'),
                onPressed: () =>
                    context.read<AssetDownloadBloc>().add(AssetDownload()),
                child: const Text('Download Asset'),
              );
      },
    );
  }
}

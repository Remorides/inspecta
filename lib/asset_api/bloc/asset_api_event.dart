part of 'asset_api_bloc.dart';

/// Event for [AssetApiBloc]
sealed class AssetApiEvent extends Equatable {
  @override
  List<Object> get props => [];
}

/// Event to collect new assets
final class AssetApiFetched extends AssetApiEvent {}

/// Subscribe to asset_isar data stream
final class AssetApiStreamSubscribe extends AssetApiEvent {}

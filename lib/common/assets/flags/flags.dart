const String _pathAsset = 'assets/flags';

class FlagAssets {
  const FlagAssets(this.iconAsset);

  final String iconAsset;

  static FlagAssets get it => const FlagAssets('$_pathAsset/it.png');

  static FlagAssets get en => const FlagAssets('$_pathAsset/en.png');

  static FlagAssets get es => const FlagAssets('$_pathAsset/es.png');

  static FlagAssets get fr => const FlagAssets('$_pathAsset/fr.png');
}

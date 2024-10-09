const String _pathAsset = 'assets/company';

class CompanyAssets {
  const CompanyAssets(this.iconAsset);

  final String iconAsset;

  static CompanyAssets get example =>
      const CompanyAssets('$_pathAsset/example.svg');

  static CompanyAssets get operaLogo =>
      const CompanyAssets('$_pathAsset/opera_logo.png');

  static CompanyAssets get operaBackground =>
      const CompanyAssets('$_pathAsset/opera_background.png');
}

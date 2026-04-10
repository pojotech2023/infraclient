

class AppConfig {
  final String name;
  final String companyCode;
  final String baseUrl;
    final String imageUrl;
  final String colorScheme;
  final String logo;
   final String appNameImg;
  final String language;
  final String appTheme;

  AppConfig({
    required this.name,
    required this.companyCode,
    required this.baseUrl,
     required this.imageUrl,
    required this.colorScheme,
       required this.appNameImg,
    required this.logo,
    required this.appTheme,
    required this.language,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      name: json['name'],
      companyCode: json['companyCode'],
      baseUrl: json['baseUrl'],
      imageUrl: json['imageUrl'],
    colorScheme:json['colorScheme'],
    appNameImg:json['appNameImg'],
    //  appColor: _parseColor(json['appColor']),
      logo: json['logo'],
      language: json['language'],
      appTheme: json['appTheme'],
    );
  }


}

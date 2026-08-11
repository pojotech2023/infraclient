import 'package:builder_customer/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../../../../core/cache/local_storage.dart';
import '../../../../core/injector/injector_conf.dart';
import '../../../../core/theme/bloc/theme_bloc.dart';
import '../../../../core/theme/bloc/theme_state.dart';
import '../../../../core/theme/appearance/app_appearance.dart';
import '../../../../core/localization/bloc/locale_bloc.dart';
import '../../../../core/localization/bloc/locale_state.dart';
import '../../../../core/config/flavor_config.dart';
import '../../../login/data/models/customer_model.dart';
import '../../../login/domain/entities/customer_entity.dart';

import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/routes/app_router.dart';

class StartupPage extends StatefulWidget {
  const StartupPage({super.key});

  @override
  State<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<LocaleBloc, LocaleState>(
          builder: (context, localeState) {
            final appearance = ApplicationAppearance();
            final brightness = _getBrightness(themeState.themeMode);
            final themeData = appearance.getThemeData(
              brightness,
              themeState.appTheme,
            );

            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: '${FlavorConfig.appConfig.name} - Avenum Movie App',
              routerConfig: appRouter.router,
              theme: themeData,
              darkTheme: appearance.getThemeData(
                Brightness.dark,
                themeState.appTheme,
              ),
              themeMode: themeState.themeMode,
              locale: Locale(localeState.languageCode),
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en', ''), // English
                Locale('ar', ''), // Arabic
                Locale('ta', ''), // Tamil
              ],
            );
          },
        );
      },
    );
  }

  Brightness _getBrightness(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return Brightness.light;
      case ThemeMode.dark:
        return Brightness.dark;
      case ThemeMode.system:
        return WidgetsBinding.instance.platformDispatcher.platformBrightness;
    }
  }
}

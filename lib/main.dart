import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/config/flavor_config.dart';
import 'core/config/env_service.dart';
import 'core/injector/injector_conf.dart';
import 'core/network/network.dart';
import 'core/theme/bloc/theme_bloc.dart';
import 'core/theme/bloc/theme_event.dart';
import 'core/localization/bloc/locale_bloc.dart';
import 'core/localization/bloc/locale_event.dart';
import 'feature/startup/presentation/pages/startup_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Local Storage


  await configureDependencies();
    await Hive.initFlutter();
  await Hive.openBox('auth');


  // Load default dev environment variables
  await EnvService.loadEnvFile('prod');
  final appConfig = EnvService.getAppConfigFromEnv();
  FlavorConfig.init(appConfig);

  // Connectivity Checking
  final connectionChecker = ConnectionCheckerImpl(Connectivity());
  final connectionService = ConnectionServiceImpl(connectionChecker);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeBloc()..add(const ThemeInitialized()),
        ),
        BlocProvider(
          create: (context) => LocaleBloc()..add(const LocaleInitialized()),
        ),
        BlocProvider(
          create:
              (_) => ConnectionBloc(
                CheckConnection(connectionService),
                connectionService.connectionStream,
              )..add(CheckConnectionEvent()),
        ),
      ],
      child: const StartupPage(),
    ),
  );
}

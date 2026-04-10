
import '../../../../core/localization/context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/bloc/theme_bloc.dart';
import '../../../../core/theme/bloc/theme_state.dart';
import '../../../../core/config/flavor_config.dart';
import '../widgets/color_scheme_section.dart';
import '../widgets/preview_section.dart';
import '../widgets/themes_modes_section.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({super.key});

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n!.theme ),
        centerTitle: true,
      ),
      body: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Theme Mode Section
                ThemesModesSection(state : state),
                const SizedBox(height: 32),
                ColorSchemeSection( state:state),
                const SizedBox(height: 32),
                PreviewSection( state:state),
                Text(FlavorConfig.appConfig.companyCode),
              ],
            ),
          );
        },
      ),
    );
  }
}

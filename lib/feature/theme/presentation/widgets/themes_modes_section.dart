

import '../../../../core/localization/context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/bloc/theme_bloc.dart';
import '../../../../core/theme/bloc/theme_event.dart';
import '../../../../core/theme/bloc/theme_state.dart';


class ThemesModesSection extends StatelessWidget {


   const ThemesModesSection({super.key, required this.state});
   final  ThemeState state;
  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Theme Mode',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              _buildThemeModeTile(
                context,context.l10n!.lightMode ?? 'Light Mode',
                ThemeMode.light,
                Icons.light_mode,
                state.themeMode == ThemeMode.light,
              ),
              const Divider(height: 1),
              _buildThemeModeTile(
                context,
                context.l10n!.darkMode ?? 'Dark Mode',
                ThemeMode.dark,
                Icons.dark_mode,
                state.themeMode == ThemeMode.dark,
              ),
              const Divider(height: 1),
              _buildThemeModeTile(
                context,
                context.l10n!.systemMode ?? "SYSYTEM MODE",
                ThemeMode.system,
                Icons.settings_suggest,
                state.themeMode == ThemeMode.system,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildThemeModeTile(
      BuildContext context,
      String title,
      ThemeMode mode,
      IconData icon,
      bool isSelected,
      ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: isSelected ? const Icon(Icons.check) : null,
      onTap: () {
        context.read<ThemeBloc>().add(ThemeModeChanged(mode));
      },
    );
  }

}



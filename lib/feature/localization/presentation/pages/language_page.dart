import '../../../../core/localization/context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/bloc/locale_bloc.dart';
import '../../../../core/localization/bloc/locale_event.dart';
import '../../../../core/localization/bloc/locale_state.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n?.language ?? 'Language'),
        centerTitle: true,
      ),
      body: BlocBuilder<LocaleBloc, LocaleState>(
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
                Text(
                  context.l10n?.selectLanguage ?? 'Select Language',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Column(
                    children: [
                      _buildLanguageTile(
                        context,
                        'English',
                        'en',
                        Icons.language,
                        state.languageCode == 'en',
                      ),
                      const Divider(height: 1),
                      _buildLanguageTile(
                        context,
                        'العربية',
                        'ar',
                        Icons.language,
                        state.languageCode == 'ar',
                      ),
                      const Divider(height: 1),
                      _buildLanguageTile(
                        context,
                        'தமிழ்',
                        'ta',
                        Icons.language,
                        state.languageCode == 'ta',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                _buildLanguagePreview(context, state.languageCode),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLanguageTile(
    BuildContext context,
    String title,
    String languageCode,
    IconData icon,
    bool isSelected,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: isSelected ? const Icon(Icons.check) : null,
      onTap: () {
        context.read<LocaleBloc>().add(LocaleChanged(languageCode));
      },
    );
  }

  Widget _buildLanguagePreview(BuildContext context, String languageCode) {
    String previewText;
    String languageName;
    
    switch (languageCode) {
      case 'ar':
        previewText = 'مرحباً بك في تطبيق إيفوم';
        languageName = 'العربية';
        break;
      case 'ta':
        previewText = 'ஏவம் பயன்பாட்டிற்கு வரவேற்கிறோம்';
        languageName = 'தமிழ்';
        break;
      case 'en':
      default:
        previewText = 'Welcome to Avenum App';
        languageName = 'English';
        break;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preview',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Selected Language: $languageName',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              previewText,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Done'),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () {
                    // Reset to default language
                    context.read<LocaleBloc>().add(const LocaleChanged('en'));
                  },
                  child: const Text('Reset to Default'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

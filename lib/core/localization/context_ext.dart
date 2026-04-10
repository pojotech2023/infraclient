import 'package:builder_customer/gen_l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';


extension L10nExtension on BuildContext {
  AppLocalizations? get l10n => AppLocalizations.of(this);
}

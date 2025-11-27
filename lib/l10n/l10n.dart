import 'package:flutter/material.dart';
import '../generated/app_localizations.dart';

/// Kullanım: context.l10n.appTitle
extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

import "package:flutter/material.dart";

import "../di.dart";
import "../localization/app_localizations.dart";
import "../../data/local/storage_service.dart";

class LocaleController extends ValueNotifier<Locale?> {
  LocaleController() : super(null);

  Future<void> load() async {
    final storage = sl<StorageService>();
    final code = await storage.readLocaleCode();
    if (code == null) {
      value = null;
      return;
    }
    value = Locale(code);
  }

  Future<void> setLocale(Locale locale) async {
    final storage = sl<StorageService>();
    await storage.saveLocaleCode(locale.languageCode);
    value = locale;
  }

  List<Locale> get supportedLocales => AppLocalizations.supportedLocales;
}

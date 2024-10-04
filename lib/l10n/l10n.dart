import 'dart:ui';

class L10n {
  static final all = [
    const Locale.fromSubtags(languageCode: 'en'), // English
    const Locale.fromSubtags(languageCode: 'en', countryCode: 'US'), // English
    const Locale.fromSubtags(languageCode: 'it'), // Italian
    const Locale.fromSubtags(languageCode: 'it', countryCode: 'IT'), // Italian
  ];
}

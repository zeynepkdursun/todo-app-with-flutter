// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Yapılacaklar - Günlük Görevler';

  @override
  String get addNewTaskHint => 'Yeni bir görev ekle';

  @override
  String get addButton => 'Görev Ekle';

  @override
  String get editTask => 'Görevi Düzenle';

  @override
  String get cancel => 'İptal';

  @override
  String get save => 'Kaydet';

  @override
  String get noTasks => 'Gösterilecek görev yok.\nİlk görevini ekle!';

  @override
  String get totalTasks => 'Toplam';

  @override
  String get completedTasks => 'Tamamlanan';
}

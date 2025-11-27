import 'dart:io';

class Strings {
  static Map<String, Map<String, String>> translations = {
    'en': {
      'appTitle': 'Todos - Daily Tasks',
      'addHint': 'Add a new task...',
      'addButton': 'Add a task',
      'edit': 'Edit Task',
      'cancel': 'Cancel',
      'save': 'Save',
      'noTasks': 'No task to display.\nAdd your first task!',
      'total': 'Total',
      'completed': 'Completed',
    },
    'tr': {
      'appTitle': 'Yapılacaklar - Günlük Görevler',
      'addHint': 'Yeni bir görev ekle...',
      'addButton': 'Görev Ekle',
      'edit': 'Görevi Düzenle',
      'cancel': 'İptal',
      'save': 'Kaydet',
      'noTasks': 'Gösterilecek görev yok.\nİlk görevini ekle!',
      'total': 'Toplam',
      'completed': 'Tamamlanan',
    },
  };

  static String get(String key) {
    String lang = Platform.localeName.split('_').first; // tr, en, de...
    return translations[lang]?[key] ?? translations['en']![key]!;
  }
}

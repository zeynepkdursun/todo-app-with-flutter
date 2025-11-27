// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Todos - Daily Tasks';

  @override
  String get addNewTaskHint => 'Add a new task';

  @override
  String get addButton => 'Add Task';

  @override
  String get editTask => 'Edit Task';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get noTasks => 'No tasks to display.\nAdd your first task!';

  @override
  String get totalTasks => 'Total';

  @override
  String get completedTasks => 'Completed';
}

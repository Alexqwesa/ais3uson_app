import 'package:ais3uson_app/journal.dart';

/// Journal with all archived dates.
///
/// {@category Journal}
class JournalArchiveAll extends JournalArchive {
  JournalArchiveAll({
    required super.ref,
    required super.apiKey,
    required super.state,
  });

  /// If aData null - load all values.
  @override
  DateTime? get aData => null;
}

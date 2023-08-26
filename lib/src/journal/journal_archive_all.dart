import 'package:ais3uson_app/journal.dart';

/// Journal with all archived dates.
///
/// {@category Journal}
class JournalArchiveAll extends JournalArchive {
  JournalArchiveAll(super.workerProfile, super.state);

  /// If aData null - load all values.
  @override
  DateTime? get aData => null;
}

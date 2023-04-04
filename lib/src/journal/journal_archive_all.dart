import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/journal.dart';

/// Journal with all archived dates.
///
/// {@category Journal}
class JournalArchiveAll extends JournalArchive {
  JournalArchiveAll(WorkerProfile wp) : super(wp);

  /// If aData null - load all values.
  @override
  DateTime? get aData => null;
}

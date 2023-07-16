import 'package:ais3uson_app/api_classes.dart';
import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:ais3uson_app/repositories.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tuple/tuple.dart';

/// A profile of worker, just model with shortcuts to various providers.
///
/// {@category Data Models}
@immutable
class WorkerProfile {
  /// Constructor [WorkerProfile] with [Journal] by default
  WorkerProfile(this.key, this._ref) {
    hiveRepository = JournalHiveRepository(this);
    httpRepository = JournalHttpRepository(this);
    journalProvider = ProviderOfJournal(this);
  }

  final Ref? _ref;
  final WorkerKey key;
  late final JournalHiveRepository hiveRepository;
  late final JournalHttpRepository httpRepository;
  late final ProviderOfJournal journalProvider;

  Ref get ref => _ref ?? ProviderContainer() as Ref;
  Provider<Journal> get journalOf => journalProvider.journalOf;

  Provider<Journal> get journalAllOf => journalProvider.journalAllOf;

  Provider<Journal> journalAtDateOf(DateTime date) =>
      journalProvider.journalAtDateOf(date);

  String get apiKey => key.apiKey;

  String get name => key.name;

  String get hiveName => 'journal_$apiKey';

  String get urlClients => '${key.activeServer}/clients';

  String get urlPlan => '${key.activeServer}/planned';

  String get urlServices => '${key.activeServer}/services';

  Tuple2<WorkerKey, String> get apiUrlClients => Tuple2(key, urlClients);

  Tuple2<WorkerKey, String> get apiUrlPlan => Tuple2(key, urlPlan);

  Tuple2<WorkerKey, String> get apiUrlServices => Tuple2(key, urlServices);
}

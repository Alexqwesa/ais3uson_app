
import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/repositories.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// DateTime of last update of [planOfWorker].
///
/// {@category Providers}
final planOfWorkerSyncDate =
    Provider.family<DateTime, WorkerProfile>((ref, wp) {
  return ref.watch(lastHttpUpdate(wp.apiKey + wp.urlPlan));
});

/// DateTime of last update of [servicesOfWorker].
///
/// {@category Providers}
final servicesOfWorkerSyncDate =
    Provider.family<DateTime, WorkerProfile>((ref, wp) {
  return ref.watch(lastHttpUpdate(wp.apiKey + wp.urlServices));
});
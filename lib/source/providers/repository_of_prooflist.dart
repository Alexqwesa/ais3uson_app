import 'package:ais3uson_app/source/data_models/client_profile.dart';
import 'package:ais3uson_app/source/data_models/client_service.dart';
import 'package:ais3uson_app/source/data_models/proof_list.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/providers/providers_of_app_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:record/record.dart';
import 'package:tuple/tuple.dart';

/// Global record controller.
///
/// {@category Providers}
/// {@category Controllers}
final proofRecorder = Provider((ref) {
  return _ProofRecorder(ref);
});

class _ProofRecorder {
  _ProofRecorder(this.ref);

  final ProviderRef ref;
  final _record = Record();

  String _audioPath = '';

  ProofEntry? _proof;

  ProofEntry? get proof => _proof;

  RecorderState get state => ref.read(proofRecorderState);

  set state(RecorderState newState) =>
      ref.read(proofRecorderState.notifier).state = newState;

  bool setProof(ProofEntry? value) {
    if (state == RecorderState.ready) {
      // if (!(await _record.isRecording()) || !(await _record.isPaused())) {
      _proof = value;

      return true;
      // }
    }

    return false;
  }

  Future<RecorderState> start(
    ProofEntry newProof, {
    String prefix = 'after_audio_',
  }) async {
    if (state == RecorderState.ready) {
      state = RecorderState.busy;
      _proof = newProof;
      // if (setProof(newProof)) {
      state = RecorderState.recording;
      final dir = await newProof.proof.proofPath(newProof.name ?? '0');
      if (dir != null) {
        _audioPath = path.join(
          dir.path,
          '${prefix}_${newProof.proof.client}_${newProof.proof.date}.m4a',
        );
        // Check and request permission
        if (await _record.hasPermission()) {
          await _record.start(path: _audioPath);

          return state;
        } else {
          state = RecorderState.ready;

          return RecorderState.failed;
        }
      }
      // }
    }

    return state;
  }

  Future<RecorderState> stop() async {
    if (state == RecorderState.recording) {
      await _record.stop();
      _proof!.afterAudio = _audioPath;
      state = RecorderState.ready;

      return RecorderState.finished;
    }

    return RecorderState.failed;
  }

  /// Return color for buttons (active/inactive).
  Color? color(ProofEntry? newProof) {
    if (state == RecorderState.ready) {
      return null;
    } else if (state == RecorderState.recording) {
      return (newProof == _proof) ? Colors.red : Colors.grey;
    } else {
      return Colors.grey;
    }
  }
}

/// State of global recorder.
///
/// Todo: make it readOnly!
/// {@category Providers}
final proofRecorderState = StateProvider<RecorderState>((ref) {
  return RecorderState.ready;
});

/// States used by ProofRecorder.
///
/// {@category Providers}
enum RecorderState {
  // States of _ProofRecorder.state
  ready,
  recording,
  busy,
  // additional states: only for return
  failed,
  finished,
}

/// Create [ProofList] for [ClientService] at date,
/// if date is null: ref.watch(archiveDate) ?? DateTime.now().
///
/// {@category Providers}
final proofAtDate =
    Provider.family<ProofList, Tuple2<DateTime?, ClientProfile>>((ref, tuple) {
  return ref.watch(_proofAtDate(Tuple2(
    (tuple.item1 ?? ref.watch(archiveDate) ?? DateTime.now()).dateOnly(),
    tuple.item2,
  )));
});

/// Helper for [proofAtDate] - it cache ProofList.
final _proofAtDate =
    Provider.family<ProofList, Tuple2<DateTime, ClientProfile>>((ref, tuple) {
  final date = tuple.item1;
  final client = tuple.item2;

  return ProofList(
    workerId: client.workerProfile.key.workerDepId,
    contractId: client.contractId,
    date: standardFormat.format(date),
    serviceId: null,
    client: client.workerProfile.clients
        .firstWhere((element) => element.contractId == client.contractId)
        .name,
    worker: client.workerProfile.name,
    ref: ref.container,
  );
});

/// Create [ProofList] for [ClientService] at date,
/// if date is null: ref.watch(archiveDate) ?? DateTime.now().
///
/// {@category Providers}
final servProofAtDate =
    Provider.family<ProofList, Tuple2<DateTime?, ClientService>>((ref, tuple) {
  return ref.watch(_servProofAtDate(Tuple2(
    (tuple.item1 ?? ref.watch(archiveDate) ?? DateTime.now()).dateOnly(),
    tuple.item2,
  )));
});

/// Helper for [servProofAtDate] - it cache ProofList.
final _servProofAtDate =
    Provider.family<ProofList, Tuple2<DateTime, ClientService>>((ref, tuple) {
  final date = tuple.item1;
  final service = tuple.item2;

  return ProofList(
    workerId: service.workerDepId,
    contractId: service.contractId,
    date: standardFormat.format(date),
    serviceId: service.servId,
    client: service.workerProfile.clients
        .firstWhere((element) => element.contractId == service.contractId)
        .name,
    worker: service.workerProfile.name,
    service: service.shortText,
    ref: ref.container,
  );
});

/// Store list of ProofGroup for [ProofList] (for [ClientService]).
///
/// {@category Providers}
final groupsOfProof = StateNotifierProvider.family<_GroupsOfProofState,
    List<ProofEntry>, ProofList>((ref, proofList) {
  proofList.crawler();

  return _GroupsOfProofState();
});

class _GroupsOfProofState extends StateNotifier<List<ProofEntry>> {
  _GroupsOfProofState() : super([]);

  void add(ProofEntry value) {
    state = [...state, value];
  }

  // Todo: rework it
  void forceUpdate() {
    state = [...state];
  }

  @override
  set state(List<ProofEntry> value) {
    super.state = value;
  }
}

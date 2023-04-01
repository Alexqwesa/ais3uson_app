import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/helpers/global_helpers.dart';
import 'package:ais3uson_app/src/data_models/proofs/recorder_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:record/record.dart';

/// Global audio record controller.
///
/// Used to record audio proofs of services.
/// {@category Providers}
/// {@category Controllers}
/// {@category UI Proofs}
final proofRecorder = Provider((ref) {
  return _ControllerOfProofRecorder(ref);
});

class _ControllerOfProofRecorder {
  _ControllerOfProofRecorder(this.ref);

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
          safeName(
            '${prefix}_${newProof.proof.client}_${newProof.proof.date}.m4a',
          ),
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
      if (path.basename(_audioPath).startsWith('after_audio_')) {
        _proof!.afterAudio = _audioPath;
      } else {
        _proof!.beforeAudio = _audioPath;
      }

      state = RecorderState.ready;

      return RecorderState.finished;
    }

    return RecorderState.failed;
  }

  /// Return color for buttons (active/inactive).
  Color? colorOf(ProofEntry? newProof) {
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
/// {@category Providers}
final proofRecorderState = StateProvider<RecorderState>((ref) {
  return RecorderState.ready;
});

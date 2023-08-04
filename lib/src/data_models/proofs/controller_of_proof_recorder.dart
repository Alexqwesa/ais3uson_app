import 'dart:io';

import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:record/record.dart';
import 'package:universal_html/html.dart' as html;

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
  _ControllerOfProofRecorder(this.ref) : _record = AudioRecorder();

  final Ref ref;
  late final AudioRecorder _record;

  String _audioPath = '';

  ProofEntry? _curProof;

  ProofEntry? get proof => _curProof;

  RecorderState get state => ref.read(proofRecorderState);

  set state(RecorderState newState) =>
      ref.read(proofRecorderState.notifier).state = newState;

  /// Start recording into file.
  Future<RecorderState> start({
    required String audioPath,
    required ProofEntry curProof,
  }) async {
    if (state == RecorderState.ready) {
      state = RecorderState.busy;
      // Check and request permission
      if (await _record.hasPermission()) {
        state = RecorderState.recording;
        _curProof = curProof; // set current recording proof
        _audioPath = audioPath;
        await _record.start(const RecordConfig(), path: audioPath);

        return state;
      } else {
        showErrorNotification(tr().microphoneAccessDenied);
        state = RecorderState.ready;

        return RecorderState.failed;
      }
    }

    return state;
  }

  Future<RecorderState> stop() async {
    if (state == RecorderState.recording) {
      _audioPath = await _record.stop() ?? '';
      if (_audioPath != '') {
        if (kIsWeb) {
          if (_audioPath.startsWith('after_audio_')) {
            _curProof!.afterAudio = _audioPath;
          } else {
            _curProof!.beforeAudio = _audioPath;
          }

          html.AnchorElement(href: _audioPath)
            ..setAttribute('download', _audioPath)
            ..click();
        } else if (File(_audioPath).existsSync()) {
          if (path.basename(_audioPath).startsWith('after_audio_')) {
            _curProof!.afterAudio = _audioPath;
          } else {
            _curProof!.beforeAudio = _audioPath;
          }
        }
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
      return (newProof == _curProof) ? Colors.red : Colors.grey;
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

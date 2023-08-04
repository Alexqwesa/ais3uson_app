import 'dart:io';

import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:universal_html/html.dart' as html;

part 'recorder.g.dart';

/// Global audio recorder .
///
/// Used to record audio proofs of services.
/// {@category Providers}
/// {@category Controllers}
/// {@category UI Proofs}
@Riverpod(keepAlive: true)
class Recorder extends _$Recorder {
  ProofEntry? get proof => _curProof;

  @override
  RecorderState build() {
    _record = AudioRecorder();

    return RecorderState.ready;
  }

  late final AudioRecorder _record;
  ProofEntry? _curProof;
  String _beforeOrAfter = '';
  String _audioPath = '';

  /// Start recording into file.
  Future<RecorderState> start({
    required String beforeOrAfter,
    required ProofEntry curProof,
  }) async {
    // Check file permissions
    final audioPath = await curProof.audioPath(prefix: beforeOrAfter);
    if (audioPath == null) {
      return RecorderState.failed;
    }

    if (state == RecorderState.ready) {
      state = RecorderState.busy;
      // Check and request permission
      if (await _record.hasPermission()) {
        state = RecorderState.recording;
        _beforeOrAfter = beforeOrAfter;
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
          if (_beforeOrAfter.startsWith('after_audio_')) {
            _curProof!.afterAudio = _audioPath;
          } else {
            _curProof!.beforeAudio = _audioPath;
          }

          html.AnchorElement(href: _audioPath)
            ..setAttribute('download', _audioPath)
            ..click();
        } else if (File(_audioPath).existsSync()) {
          if (_beforeOrAfter.startsWith('after_audio_')) {
            _curProof!.afterAudio = _audioPath;
          } else {
            _curProof!.beforeAudio = _audioPath;
          }
        } else {
          showErrorNotification(tr().error);
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

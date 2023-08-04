import 'dart:io';

import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:ais3uson_app/src/data_models/proofs/proof_entry.dart';
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

  /// Start recording into file.
  Future<RecorderState> start({
    required ProofEntry curProof,
  }) async {
    // Check file permissions
    final audioPath = await curProof.audioPath();
    if (audioPath == null) {
      return RecorderState.failed;
    }

    if (state == RecorderState.ready) {
      state = RecorderState.busy;
      // Check and request permission
      if (await _record.hasPermission()) {
        state = RecorderState.recording;
        _curProof = curProof; // set current recording proof
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
      final audioPath = await _record.stop() ?? '';
      if (audioPath != '') {
        if (kIsWeb) {
          _curProof!.audio = audioPath;

          html.AnchorElement(href: audioPath)
            ..setAttribute('download', audioPath)
            ..click();
        } else if (File(audioPath).existsSync()) {
          _curProof!.audio = audioPath;
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

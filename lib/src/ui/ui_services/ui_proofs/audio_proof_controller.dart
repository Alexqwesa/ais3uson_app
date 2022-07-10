// ignore_for_file: unnecessary_null_comparison

import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/main.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tuple/tuple.dart';

/// Widget for record, play and share audio proof.
///
/// {@category UI Proofs}
class AudioProofController extends ConsumerWidget {
  AudioProofController({
    this.proofs,
    this.client,
    this.service,
    this.beforeOrAfter = 'after_audio_',
    Key? key,
  }) : super(key: key) {
    if (!(proofs != null || (client != null && service != null))) {
      throw StateError('AudioProofController: wrong parameters!');
    }
  }

  final String beforeOrAfter;
  final ServiceOfJournal? service;
  final ClientProfile? client;
  final Proofs? proofs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    // > init
    //
    final player = ref.watch(audioPlayer);
    final playState = ref.watch(proofPlayState);
    final recorder = ref.watch(proofRecorder);
    final recorderState = ref.watch(proofRecorderState);
    //
    // > get proof
    //
    final proofController = proofs != null
        ? proofs!
        : ref.watch(proofAtDate(Tuple2(service?.provDate.dateOnly(), client!)));
    final firstProof = ref.watch(groupsOfProof(proofController)).isNotEmpty
        ? ref.watch(groupsOfProof(proofController)).first
        : null;
    final audioProof = firstProof?[beforeOrAfter] as String?;

    //
    // > build
    //
    return Row(
      children: [
        //
        // > record button
        //
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: FloatingActionButton(
            heroTag: null,
            // tooltip: ,
            child: const Icon(Icons.record_voice_over_sharp),
            backgroundColor: recorder.colorOf(
              firstProof,
            ),
            //
            // > onPressed: start/stop
            //
            onPressed: () async {
              if (ref.read(proofRecorderState) != RecorderState.ready) {
                await recorder.stop();
              } else {
                if (firstProof == null) {
                  proofController.addNewGroup();
                }
                await recorder.start(
                  ref.read(groupsOfProof(proofController)).first,
                  prefix: beforeOrAfter,
                );
              }
            },
          ),
        ),
        //
        // > play button
        //
        if (audioProof != null)
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: FloatingActionButton(
              heroTag: null,
              // tooltip: ,
              backgroundColor: recorderState != RecorderState.ready
                  ? Colors.grey
                  : playState == PlayerState.stopped
                      ? null
                      : Colors.green,
              child: playState == PlayerState.stopped
                  ? const Icon(Icons.play_arrow)
                  : const Icon(Icons.stop),
              //
              // > onPressed: play/stop
              //
              onPressed: () async {
                await recorder.stop();
                if (playState == PlayerState.playing) {
                  await player.stop();
                } else {
                  if (audioProof != null) {
                    ref.watch(proofPlayState.notifier).state =
                        PlayerState.playing;
                    await player.play(
                      DeviceFileSource(audioProof),
                      // mode: PlayerMode.lowLatency,
                    );
                  }
                }
              },
            ),
          ),
        //
        // > share button
        //
        if (audioProof != null)
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: FloatingActionButton(
              heroTag: null,
              // tooltip: ,
              backgroundColor:
                  recorderState == RecorderState.ready ? null : Colors.grey,
              child: const Icon(Icons.share),
              //
              // > onPressed: try share, or show notification
              //
              onPressed: () async {
                await recorder.stop();
                if (audioProof != null) {
                  final filePath = audioProof;
                  try {
                    await Share.shareFiles([filePath]);
                    // ignore: avoid_catching_errors
                  } on UnimplementedError {
                    showNotification(
                      tr().fileSavedTo + filePath,
                      duration: const Duration(seconds: 10),
                    );
                  } on MissingPluginException {
                    showNotification(
                      tr().fileSavedTo + filePath,
                      duration: const Duration(seconds: 10),
                    );
                  }
                }
              },
            ),
          ),
      ],
    );
  }
}

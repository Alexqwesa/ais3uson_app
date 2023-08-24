// ignore_for_file: unnecessary_null_comparison

import 'package:ais3uson_app/dynamic_data_models.dart';
import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

/// Widget for record, play and share audio proof.
///
/// {@category UI Proofs}
class AudioProofWidget extends ConsumerWidget {
  AudioProofWidget({
    this.proofs,
    this.client,
    this.service,
    this.beforeOrAfter = 'after_audio_',
    super.key,
  }) {
    if (!(proofs != null || (client != null && service != null))) {
      throw StateError('AudioProofController: wrong parameters!');
    }
  }

  final String beforeOrAfter;
  final ServiceOfJournal? service;
  final ClientProfile? client;
  final (List<Proof>, ProofList)? proofs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    // > init
    //
    final player = ref.watch(audioPlayer);
    final playState = ref.watch(proofPlayState);
    final recorder = ref.watch(recorderProvider.notifier);
    final recorderState = ref.watch(recorderProvider);
    //
    // > get proof
    //
    final (proofList, proofController) = proofs != null
        ? proofs!
        : ref.watch(groupProofAtDate((service?.provDate.dateOnly(), client!)));

    if (proofList.isEmpty) {
      proofController.addProofSilently();
    }
    final firstProof = (beforeOrAfter == 'after_audio_')
        ? proofList.first.after
        : proofList.first.before;
    final audioProof = firstProof.audio;

    //
    // > build
    //
    return Row(
      children: [
        //
        // > record button
        //
        Padding(
          padding: const EdgeInsets.all(2),
          child: FloatingActionButton(
            heroTag: null,
            backgroundColor: recorder.colorOf(firstProof),
            //
            // > onPressed: start/stop
            //
            onPressed: () async {
              if (ref.read(recorderProvider) != RecorderState.ready) {
                await recorder.stop();
              } else {
                if (firstProof == null) {
                  proofController.addProof();
                }
                await recorder.start(curProof: firstProof);
              }
            },
            // tooltip: ,
            child: const Icon(Icons.record_voice_over_sharp),
          ),
        ),
        //
        // > play button
        //
        if (audioProof != null)
          Padding(
            padding: const EdgeInsets.all(2),
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
                      kIsWeb
                          ? UrlSource(audioProof)
                          : DeviceFileSource(audioProof),
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
            padding: const EdgeInsets.all(2),
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
                    await Share.shareXFiles([XFile(filePath)]);
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

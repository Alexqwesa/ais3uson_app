// ignore_for_file: unnecessary_null_comparison

import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/source/data_models/client_profile.dart';
import 'package:ais3uson_app/source/data_models/proof_list.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/journal/service_of_journal.dart';
import 'package:ais3uson_app/source/providers/repository_of_prooflist.dart';
import 'package:ais3uson_app/src/generated/l10n.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tuple/tuple.dart';

/// Widget for record, play and share audio proof.
class AudioProofController extends ConsumerWidget {
  AudioProofController({
    this.proofs,
    this.client,
    this.service,
    this.beforeOrAfter = 'after_audio_',
    Key? key,
  }) : super(key: key) {
    if (!(proofs != null || (client != null && service != null))) {
      throw StateError('Wrong parameters for AudioProofController');
    }
  }

  final String beforeOrAfter;
  final ServiceOfJournal? service;
  final ClientProfile? client;
  final ProofList? proofs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late final List<ProofEntry> proofList;
    late final ProofList proof;
    if (client != null && service != null) {
      proof = proofs != null
          ? proofs!
          : ref.watch(
              proofAtDate(Tuple2(service?.provDate.dateOnly(), client!)),
            );
      proofList = ref.watch(groupsOfProof(proof));
    } else {
      proof = proofs!;
      proofList = ref.watch(groupsOfProof(proofs!));
    }

    final player = AudioPlayer();
    final recorder = ref.watch(proofRecorder);
    // only needed to trigger rebuild
    // ignore: unused_local_variable
    final recorderState = ref.watch(proofRecorderState);

    final audioProof =
        proofList.isEmpty ? null : proofList[0][beforeOrAfter] as String?;

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
            backgroundColor: recorder.color(
              proofList.isNotEmpty ? proofList.first : null,
            ),
            onPressed: () async {
              if (ref.read(proofRecorderState) != RecorderState.ready) {
                await recorder.stop();
              } else {
                if (proofList.isEmpty) {
                  proof.addNewGroup();
                }
                await recorder.start(
                  ref.read(groupsOfProof(proof)).first,
                  prefix: beforeOrAfter,
                );
              }
            },
          ),
        ),
        //
        // > play button
        //
        if (proofList.isNotEmpty && audioProof != null)
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: FloatingActionButton(
              heroTag: null,
              // tooltip: ,
              backgroundColor:
                  recorderState == RecorderState.ready ? null : Colors.grey,
              child: const Icon(Icons.play_arrow),
              onPressed: () async {
                await recorder.stop();
                if (audioProof != null) {
                  await player.play(DeviceFileSource(
                    audioProof,
                  ));
                }
              },
            ),
          ),
        //
        // > share button
        //
        if (proofList.isNotEmpty && audioProof != null)
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: FloatingActionButton(
              heroTag: null,
              // tooltip: ,
              backgroundColor:
                  recorderState == RecorderState.ready ? null : Colors.grey,
              child: const Icon(Icons.share),
              onPressed: () async {
                await recorder.stop();
                if (audioProof != null) {
                  final filePath = audioProof;
                  try {
                    await Share.shareFiles([filePath]);
                    // ignore: avoid_catching_errors
                  } on UnimplementedError {
                    showNotification(
                      locator<S>().fileSavedTo + filePath,
                      duration: const Duration(seconds: 10),
                    );
                  } on MissingPluginException {
                    showNotification(
                      locator<S>().fileSavedTo + filePath,
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

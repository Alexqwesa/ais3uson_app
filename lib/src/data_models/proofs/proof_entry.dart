import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

/// A single entry of proof, contains evidence image and/or audio.
///
/// {@category Data Models}
class ProofEntry {
  ProofEntry({
    this.proof,
    this.image,
    this.audio,
  });

  Proof? proof;
  Image? image;
  String? audio;

  Future<String?> audioPath() async {
    if (proof != null) {
      final prefix = (proof!.before == this)
          ? 'before_audio_'
          : (proof!.after == this)
              ? 'after_audio_'
              : '';
      if (prefix == '') throw StateError("ProofEntry doesn't have parent");

      final proofList = proof!.proofList;
      final name = proof!.name;
      if (kIsWeb) {
        showErrorNotification(tr().saveTheFileInOrderToNotLoseIt);

        return safeName('${prefix}_${proofList.client}_${proofList.date}.m4a');
      }

      final dir = await proofList.proofPath(name ?? '0');
      if (dir != null) {
        return path.join(
          dir.path,
          safeName(
            '${prefix}_${proofList.client}_${proofList.date}.m4a',
          ),
        );
      }
    }

    return null;
  }
}

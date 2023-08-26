import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/proofs.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

/// Mixin with logic to manage [Proof]s for [ProofList].
///
/// Most important functions:
/// - load proofs from filesystem with [loadProofsFromFS] function,
/// - add new proofs.
///
/// If serviceId == null, it create/collect proof for whole day.
///
/// {@category Data Models}
/// {@category Inner API}
mixin ProofListOf {
  Future<void>? loadedFromFS;

  late final int workerId_;
  late final int contractId_;
  late final int? serviceId_;
  late final String date_;
  late final String client_;
  late final String worker_;
  late final String service_;

  List<Proof> get proofs => throw UnimplementedError(); //state
  void forceUpdate() => throw UnimplementedError();

  /// Crawl through file system to generate [Proof]s.
  ///
  /// ![Mind map of directories tree](https://raw.githubusercontent.com/Alexqwesa/ais3uson_app/master/lib/source/data_models/proof_list.png)
  Future<void> loadProofsFromFS() async {
    if (kIsWeb) return Future(() => null);

    loadedFromFS ??= _loadProofsFromFS();

    return loadedFromFS;
  }

  Future<void> _loadProofsFromFS() async {
    final appDocDirPath = await getSafePath([]);
    if (appDocDirPath == null) {
      showErrorNotification(tr().errorFS);

      return;
    }
    final appDocDir = Directory(appDocDirPath)..createSync(recursive: true);
    //
    // > start search
    //
    await for (final depWorker in appDocDir.list()) {
      if (depWorker.baseName.startsWith('${workerId_}_') &&
          (depWorker is Directory)) {
        await for (final contract in depWorker.list()) {
          if (contract.baseName.startsWith('${contractId_}_') &&
              (contract is Directory)) {
            await for (final dat in contract.list()) {
              if (dat.baseName.startsWith('${date_}_') && (dat is Directory)) {
                if (serviceId_ != null) {
                  await for (final serv in dat.list()) {
                    if (serv.baseName.startsWith('${serviceId_}_') &&
                        (serv is Directory)) {
                      await _addGroups(serv);
                    }
                  }
                } else {
                  await for (final group in dat.list()) {
                    if (group.baseName == 'GroupProofs' && group is Directory) {
                      await _addGroups(group);
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  /// helper for _crawler.
  Future<void> _addGroups(Directory serv) async {
    await for (final group in serv.list()) {
      if (group.baseName.startsWith('group_') && (group is Directory)) {
        File? beforeImg;
        File? beforeAudio;
        File? afterImg;
        File? afterAudio;
        for (final file in group.listSync()) {
          if (file.baseName.startsWith('before_img_') && (file is File)) {
            beforeImg = file;
          }
          if (file.baseName.startsWith('before_audio_') && (file is File)) {
            beforeAudio = file;
          }
          if (file.baseName.startsWith('after_img_') && (file is File)) {
            afterImg = file;
          }
          if (file.baseName.startsWith('after_audio_') && (file is File)) {
            afterAudio = file;
          }
        }

        addProofFromFiles(
          beforeImg,
          beforeAudio,
          afterImg,
          afterAudio,
        );
      }
    }
  }

  void addProof() {
    throw UnimplementedError();
  }

  void addProofFromFiles(
    File? beforeImg,
    File? beforeAudio,
    File? afterImg,
    File? afterAudio,
  ) {
    throw UnimplementedError();
  }

  /// Create directory with proofs.
  Future<Directory?> proofPath(String group) async {
    final safePath = await getSafePath(
      [
        '${workerId_}_$worker_',
        '${contractId_}_$client_',
        '${date_}_',
        if (serviceId_ == null) 'GroupProofs' else '${serviceId_}_$service_',
        'group_${group}_',
      ],
    );
    if (safePath == null) return null;

    return Directory(safePath)..createSync(recursive: true);
  }

  /// Move the image into proof Directory and register it as a proof.
  Future<void> addImage(int i, XFile? xFile, String prefix) async {
    if (xFile == null) return;
    //
    // > create new path
    //
    final newPath = await proofPath(i.toString());
    if (newPath == null) return;
    //
    // > move file to group path
    //
    final tmpImgFile = File.fromRawPath(
      Uint8List.fromList(utf8.encode(xFile.path)),
    );
    final imgFile = tmpImgFile.copySync(
      path.join(
        newPath.path,
        '${prefix}img_${path.basename(xFile.path)}',
      ),
    );
    tmpImgFile.deleteSync();
    //
    // > update list
    //
    if (prefix == 'after_') {
      proofs[i].after.image = Image.file(imgFile);
    } else {
      proofs[i].before.image = Image.file(imgFile);
    }
    forceUpdate();
  }
}

extension _BaseNameForFileSystemEntity on FileSystemEntity {
  String get baseName {
    return path.basename(this.path);
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/source/data_models/client_service.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/providers/repository_of_prooflist.dart';
import 'package:ais3uson_app/src/generated/l10n.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart' as path;

/// Store and manage list of [ProofGroup]s for [ClientService].
///
/// Most important functions:
/// - load proofs from filesystem with [crawler] function,
/// - notify **one** [ClientService],
/// - save new proofs.
///
/// {@category Data Models}
/// {@category Client-Server API}
// ignore: prefer_mixin
class ProofList {
  ProofList({
    required this.workerId,
    required this.contractId,
    required this.date,
    required this.serviceId,
    required this.ref,
    this.worker = '',
    this.client = '',
    this.service = '',
  });

  final int workerId;
  final int contractId;
  final int serviceId;
  final String date;
  final String client;
  final String worker;
  final String service;
  final ProviderContainer ref;

  /// Future to be awaited(for tests).
  Future? crawled;

  List<ProofGroup> get proofGroups => ref.read(groupsOfProof(this));

  /// Crawl through file system to generate [ProofGroup]s.
  ///
  /// ![Mind map if directories tree](https://raw.githubusercontent.com/Alexqwesa/ais3uson_app/master/lib/source/data_models/proof_list.png)
  Future<void> crawler() async {
    crawled ??= _crawler();

    return crawled;
  }

  // ignore: long-method
  Future<void> _crawler() async {
    final appDocDirPath = await getSafePath([]);
    if (appDocDirPath == null) {
      showErrorNotification(locator<S>().errorFS);

      return;
    }
    final appDocDir = Directory(appDocDirPath)..createSync(recursive: true);
    //
    // > start search
    //
    await for (final depWorker in appDocDir.list()) {
      if (depWorker.baseName.startsWith('${workerId}_') &&
          (depWorker is Directory)) {
        await for (final contract in depWorker.list()) {
          if (contract.baseName.startsWith('${contractId}_') &&
              (contract is Directory)) {
            await for (final dat in contract.list()) {
              if (dat.baseName.startsWith('${date}_') && (dat is Directory)) {
                await for (final serv in dat.list()) {
                  if (serv.baseName.startsWith('${serviceId}_') &&
                      (serv is Directory)) {
                    await for (final group in serv.list()) {
                      if (group.baseName.startsWith('group_') &&
                          (group is Directory)) {
                        File? beforeImg;
                        File? beforeAudio;
                        File? afterImg;
                        File? afterAudio;
                        await for (final file in group.list()) {
                          if (file.baseName.startsWith('before_img_') &&
                              (file is File)) beforeImg = file;
                          if (file.baseName.startsWith('before_audio_') &&
                              (file is File)) beforeAudio = file;
                          if (file.baseName.startsWith('after_img_') &&
                              (file is File)) afterImg = file;
                          if (file.baseName.startsWith('after_audio_') &&
                              (file is File)) afterAudio = file;
                        }
                        await addGroup(
                          beforeImg,
                          beforeAudio,
                          afterImg,
                          afterAudio,
                        );
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
  }

  void addNewGroup() {
    ref
        .read(groupsOfProof(this).notifier)
        .add(ProofGroup.empty((proofGroups.length).toString()));
  }

  Future<void> addGroup(
    File? beforeImg,
    File? beforeAudio,
    File? afterImg,
    File? afterAudio,
  ) async {
    ref.read(groupsOfProof(this).notifier).add(
          ProofGroup(
            beforeImg: beforeImg != null ? Image.file(beforeImg) : null,
            beforeAudio: beforeAudio?.path,
            afterImg: afterImg != null ? Image.file(afterImg) : null,
            afterAudio: afterAudio?.path,
          ),
        );
  }

  Future<void> addImage(int i, XFile? xFile, String prefix) async {
    if (xFile == null) return;
    //
    // > create new path
    //
    final safePath = await getSafePath(
      [
        '${workerId}_$worker',
        '${contractId}_$client',
        '${date}_',
        '${serviceId}_$service',
        'group_${i}_',
      ],
    );
    if (safePath == null) return;
    final newPath = Directory(safePath)..createSync(recursive: true);
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
      proofGroups[i].afterImg = Image.file(imgFile);
    } else {
      proofGroups[i].beforeImg = Image.file(imgFile);
    }
    // force update
    ref.read(groupsOfProof(this).notifier).state = [
      ...ref.read(groupsOfProof(this)),
    ];
  }
}

/// A unit of proof, contains evidence of states before and after.
///
/// {@category Data Models}
// maybe use freezed?
class ProofGroup {
  ProofGroup({
    this.name,
    this.beforeImg,
    this.beforeAudio,
    this.afterImg,
    this.afterAudio,
  });

  ProofGroup.empty(this.name);

  Image? beforeImg;

  String? beforeAudio;

  Image? afterImg;

  String? afterAudio;

  String? name;
}

extension _BaseNameForFileSystemEntity on FileSystemEntity {
  String get baseName {
    return path.basename(this.path);
  }
}

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:ais3uson_app/source/data_classes/client_service.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

/// Store and manage list of [ProofGroup].
///
/// Most important functions:
/// - load proofs from filesystem with [crawler] function,
/// - notify **one** [ClientService],
/// - save new proofs.
// ignore: prefer_mixin
class ProofList with ChangeNotifier {
  final int workerId;

  final int contractId;

  final String date;

  final int serviceId;

  int iName = 1;

  List<ProofGroup> proofGroups = [];

  ProofList(
    this.workerId,
    this.contractId,
    this.date,
    this.serviceId,
  );

  /// Generate list of [ProofGroup] from file system.
  ///
  /// ![Mind map if directories tree](../proof_list.png)
  Future<void> crawler() async {
    Directory appDocDir;
    try {
      appDocDir = await getApplicationDocumentsDirectory();
    } on MissingPlatformDirectoryException {
      return;
    }
    await for (final depWorker in appDocDir.list()) {
      if (depWorker.path.startsWith('${workerId}_') &&
          (depWorker is Directory)) {
        await for (final contract in depWorker.list()) {
          if (contract.path.startsWith('${contractId}_') &&
              (contract is Directory)) {
            await for (final dat in contract.list()) {
              if (dat.path.startsWith('${date}_') && (dat is Directory)) {
                await for (final serv in dat.list()) {
                  if (serv.path.startsWith('${serviceId}_') &&
                      (serv is Directory)) {
                    await for (final group in serv.list()) {
                      if (group.path.startsWith('group_') &&
                          (group is Directory)) {
                        File? beforeImg;
                        File? beforeAudio;
                        File? afterImg;
                        File? afterAudio;
                        await for (final file in group.list()) {
                          if (file.path.startsWith('before_img_') &&
                              (file is File)) beforeImg = file;
                          if (file.path.startsWith('before_audio_') &&
                              (file is File)) beforeAudio = file;
                          if (file.path.startsWith('after_img_') &&
                              (file is File)) afterImg = file;
                          if (file.path.startsWith('after_audio_') &&
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
    proofGroups.add(
      ProofGroup.empty((iName++).toString()),
    );
    notifyListeners();
  }

  Future<void> addGroup(
    File? beforeImg,
    File? beforeAudio,
    File? afterImg,
    File? afterAudio,
  ) async {
    proofGroups.add(
      ProofGroup(
        beforeImg: beforeImg != null ? Image.file(beforeImg) : null,
        beforeAudio: beforeAudio?.path,
        afterImg: afterImg != null ? Image.file(afterImg) : null,
        afterAudio: afterAudio?.path,
      ),
    );
    notifyListeners();
  }

  void addImage(int i, XFile? xFile, String prefix) async {
    if (xFile == null) return;
    //
    // > create new path
    //
    Directory appDocDir;
    try {
      appDocDir = await getApplicationDocumentsDirectory();
    } on MissingPlatformDirectoryException {
      return;
    }
    // Todo: add names
    final newPath = Directory(
      path.join(
        appDocDir.path,
        '${workerId}_',
        '${contractId}_',
        '${date}_',
        '${serviceId}_',
        'group_${i}_',
      ),
    );
    await newPath.create(recursive: true);
    //
    // > move file to group path
    //
    var imgFile = File.fromRawPath(
      Uint8List.fromList(utf8.encode(xFile.path)),
    );
    imgFile = await imgFile.rename(
      path.join(
        newPath.path,
        path.basename(xFile.path),
      ),
    );
    //
    // > update list
    //
    if (prefix == "after_") {
      proofGroups[i].afterImg = Image.file(imgFile);
    } else {
      proofGroups[i].beforeImg = Image.file(imgFile);
    }
    notifyListeners();
  }
}

class ProofGroup {
  Image? beforeImg;

  String? beforeAudio;

  Image? afterImg;

  String? afterAudio;

  String? name;

  ProofGroup({
    this.name,
    this.beforeImg,
    this.beforeAudio,
    this.afterImg,
    this.afterAudio,
  });

  ProofGroup.empty(this.name);
}

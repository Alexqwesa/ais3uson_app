import 'dart:developer' as dev;

import 'package:ais3uson_app/source/app_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:quiver/iterables.dart';
import 'package:uuid/uuid.dart';

//
// > global constants
//
const uuid = Uuid();
const formatSQL = 'yyyy-MM-dd';
const formatStandard = 'dd.MM.yyyy';
final sqlFormat = DateFormat(formatSQL);
final standardFormat = DateFormat(formatStandard);
const hiveArchiveLimit = 1000;

/// qrData
///
/// test worker key in json format
String qrData = '''{"app": "AIS3USON web", "name": "Работник Тест Тестович", '''
    '''"worker_dep_id": 1, "api_key": "1234",  "dep": "80.87.196.11 отделение48081", '''
    '''"db": "kcson", "host": "80.87.196.11", "port": "48081"}''';
String qrData2 =
    '''{"app": "AIS3USON web", "name": "Работник Тестового Отделения №2", '''
    '''"worker_dep_id": 1, "api_key": "3.015679841875732e17ef73dc17-7af8-11ec-b7f8-04d9f5c97b0c", "dep": "Тестовое отделение 48080", '''
    '''"db": "kcson", "host": "80.87.196.11", "port": "48080"}''';
String qrData3 =
    '''{"app": "AIS3USON web", "name": "Работник Тестового Отделения №2", '''
    '''"worker_dep_id": 1, "api_key": "12345", "dep": "48081 отделение", '''
    '''"db": "kcson", "host": "80.87.196.11", "port": "48082"}''';
final qrCodes = [qrData, qrData2, qrData3];

class ScreenArguments {
  int profileNum = -1;
  int contractId = 0;
  int servId = 0;

  ScreenArguments({required int profile, int? contract, int? service}) {
    profileNum = profile;
    contractId = contract ?? 0;
    servId = service ?? 0;
    AppData().lastScreen = this;
  }
}

/// This is default headers for http request.
///
/// Just work with json, and before send, it should be concatenated with 'api_key'.
final Map<String, String> httpHeaders = {
  'Content-type': 'application/json',
  'Accept': 'application/json',
};

/// cutFromStart
///
/// cutting [cut] from [input] from the start of [input]
/// and replace it by ...
/// Note: It is assumed that both string is trimmed
String cutFromStart(String input, String cut) {
  final re = RegExp(' ');
  var cutIndex = 0;
  for (final lst in zip<RegExpMatch>(
    [re.allMatches(input), re.allMatches(cut)],
  )) {
    final in_ = lst[0];
    final cu_ = lst[1];
    final inWord = input.substring(cutIndex, in_.start);
    final cutWord = cut.substring(cutIndex, cu_.start);
    final match = inWord.matchAsPrefix(cutWord);
    if (match == null) {
      break;
    } else if (match.end != inWord.length) {
      cutIndex = match.end;
      break;
    } else {
      cutIndex = cu_.end;
    }
  }

  return cutIndex == 0
      ? input
      : '...${input.substring(cutIndex, input.length)}';
}

/// showErrorNotification
///
/// just display error to user
void showErrorNotification(String text) {
  try {
    showSimpleNotification(
      Text(text),
      background: Colors.red[300],
      position: NotificationPosition.bottom,
    );
    // ignore: avoid_catches_without_on_clauses
  } catch (e) {
    dev.log(e.toString());
  }
}

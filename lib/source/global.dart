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
final sqlFormat = DateFormat(formatSQL);
const hiveArchiveLimit = 1000;

/// qrData
///
/// test worker key in json format
String qrData =
    '''{"app": "AIS3USON web", "name": "Работник Тест Тестович", "worker_dep_id": 1, "api_key": "123",  "dep": "Тестовое отделение", "db": "kcson", "host": "80.87.196.11", "port": "48080"}''';
String qrData2 =
    '''{"app": "AIS3USON web", "name": "Работник Тест Тестович", "worker_dep_id": 1, "api_key": "123", "dep": "Тестовое отделение 2", "db": "kcson", "host": "80.87.196.11", "port": "48080"}''';

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

/// httpHeaders
///
/// defalult headers for http request
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
  showSimpleNotification(
    Text(text),
    background: Colors.red[300],
    position: NotificationPosition.bottom,
  );
}

import 'package:ais3uson_app/src/data_classes/app_data.dart';
import 'package:intl/intl.dart';
import 'package:quiver/iterables.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();
String formatSQL = 'yyyy-MM-dd';
DateFormat sqlFormat = DateFormat(formatSQL);

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

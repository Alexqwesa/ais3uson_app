import 'package:hive/hive.dart';
import 'data_classes/app_data.dart';

void sync_http() async {
  // static DateTime? last_sync;
  // if (last_sync == null) {
  // await Hive.openBox('data');

  Hive.box('data').put("userKey", AppData.instance.userKeys.last.toJson());
  Hive.box('data').get("userKey");
}

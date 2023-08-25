import 'dart:io';
import 'dart:math';

import 'package:path/path.dart' as path;

final _random = Random();
String _tempPath =
    path.join(Directory.current.path, '.dart_tool', 'test', 'tmp');

/// Returns a temporary directory in which a Hive can be initialized
Future<Directory> getTempDir() async {
  final name = _random.nextInt(pow(2, 32) as int);
  final dir = Directory(path.join(_tempPath, '${name}_tmp'));

  if (dir.existsSync()) await dir.delete(recursive: true);

  dir.createSync(recursive: true);
  return dir;
}

/// Hive in memory
// Future<void> setUpRealHive() async {
//   final tempDir = await getTempDir();
//   Hive.init(tempDir.path);
//
//   await Hive.openBox(hiveHttpCache);
// }
//
// /// Deletes the temporary [Hive].
// Future<void> tearDownRealHive() async {
//   await Hive.deleteFromDisk();
// }

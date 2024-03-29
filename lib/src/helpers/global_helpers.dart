import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:ais3uson_app/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

//
// > global constants
//

const uuid = Uuid();
const formatSQL = 'yyyy-MM-dd';
const formatStandard = 'dd.MM.yyyy';
final sqlFormat = DateFormat(formatSQL);
final standardFormat = DateFormat(formatStandard);
final nullDate = DateTime(1900);

/// Helper, convert String to List of Map<String, dynamic>
List<Map<String, dynamic>> mapJsonDecode(List<String> list) {
  return list.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
}

/// This is default headers for http request.
///
/// Before send, it should be concatenated with 'api_key'.
///
/// {@category Client-Server API}
const Map<String, String> httpHeaders = {
  'Content-type': 'application/json',
  'Accept': 'application/json',
};

/// Display error Notification to user.
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

/// Display Notification.
void showNotification(String text, {Duration? duration}) {
  try {
    showSimpleNotification(
      Text(text),
      background: Colors.green[400],
      position: NotificationPosition.bottom,
      duration: duration,
    );
    // ignore: avoid_catches_without_on_clauses
  } catch (e) {
    dev.log(e.toString());
  }
}

/// Return string - new path with only safe characters in DocumentsDirectory.
///
/// It join all subFolders into path string and make safety checks.
/// If file plugin or DocumentsDirectory didn't exist - return null.
Future<String?> getSafePath(List<String> subFolders) async {
  if (kIsWeb) {
    return '';
  }

  Directory? appDocDir;
  try {
    appDocDir = Directory(path.join(
      (await getApplicationDocumentsDirectory()).path,
      'Ais3uson',
    ));
    if (!appDocDir.existsSync()) {
      appDocDir.createSync(recursive: true);
    }
  } on MissingPlatformDirectoryException {
    log.severe('Can not find folder');
  } on MissingPluginException {
    log.severe('Can not find plugin');
  }
  appDocDir ??= await getApplicationSupportDirectory();
  //
  // > create path without special characters
  //

  return [
    appDocDir.path,
    ...subFolders.map(safeName),
  ].reduce(path.join);
}

String safeName(String s, {int length = 150}) {
  const regex = r'[^\p{Alphabetic}\p{Decimal_Number}_.]+';
  final e = s.replaceAll(RegExp(regex, unicode: true), '');

  return e.substring(0, e.length > length ? length : e.length);
}

DateTime mostRecentMonday({DateTime? date, int addDays = 0}) {
  date ??= DateTime.now();

  return DateTime(
    date.year,
    date.month,
    date.day - (date.weekday - 1) + addDays,
  );
}

DateTime mostRecentMonth({DateTime? date, int addMonths = 0}) {
  date ??= DateTime.now();

  return DateTime(date.year, date.month + addMonths);
}

extension AppLocalizationsExt on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

extension LocaleWithDelegate on Locale {
  /// Get class with translation strings for this locale.
  AppLocalizations get tr => lookupAppLocalizations(this);
}

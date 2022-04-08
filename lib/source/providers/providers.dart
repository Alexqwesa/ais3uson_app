// ignore_for_file: sort_constructors_first

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/journal/service_of_journal.dart';
import 'package:ais3uson_app/source/screens/service_related/service_card.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Provider of setting - serviceView.
///
/// Read/save from/to SharedPreferences, had default preinitialized value.
/// Depend on [locator]<SharedPreferences>.
///
/// {@category Providers}
final serviceViewProvider =
    StateNotifierProvider<ServiceViewState, String>((ref) {
  return ServiceViewState();
});

class ServiceViewState extends StateNotifier<String> {
  static const name = 'serviceView';

  @override
  set state(String value) {
    super.state = value;
    locator<SharedPreferences>().setString(name, value);
  }

  ServiceViewState()
      : super(locator<SharedPreferences>().getString(name) ?? '');
}

/// Provider of setting - hiveArchiveLimit.
///
/// Read/save from/to SharedPreferences, had default preinitialized value.
///
/// Depend on [locator]<SharedPreferences>.
/// {@category Providers}
final hiveArchiveLimit =
    StateNotifierProvider<HiveArchiveLimitState, int>((ref) {
  return HiveArchiveLimitState();
});

class HiveArchiveLimitState extends StateNotifier<int> {
  static const name = 'HiveArchiveLimitState';

  @override
  set state(int value) {
    super.state = value;
    locator<SharedPreferences>().setInt(name, value);
  }

  HiveArchiveLimitState()
      : super(locator<SharedPreferences>().getInt(name) ?? 3000);
}

/// Calculate size of [ServiceCard] based on parentSize and serviceView.
///
/// {@category Providers}
Size serviceCardSize(Size parentSize, String serviceView) {
  final parentWidth = parentSize.width;
  if (serviceView == 'tile') {
    final divider = (parentWidth - 20) ~/ 400.0;
    var cardWidth = (parentWidth / divider) - 10;
    if (divider == 0) {
      cardWidth = (parentWidth - 10).abs();
    }

    return Size(
      cardWidth * 1.0,
      cardWidth / 4,
    );
  } else if (serviceView == 'square') {
    var divider = (parentWidth - 20) ~/ 150.0;
    if (parentWidth < 130) {
      divider = 1;
    } else if (parentWidth < 260) {
      divider = 2;
    } else {
      divider = divider > 2 ? divider : 3;
    }
    final cardWidth = parentWidth / divider;

    return Size(
      cardWidth,
      cardWidth,
    );
  } else {
    var divider = (parentWidth - 20) ~/ 250.0;
    divider = divider > 1 ? divider : 2;
    final cardWidth = parentWidth / divider;

    return Size(
      cardWidth * 1.0,
      cardWidth * 1.2,
    );
  }
}

/// Provider of httpClient (with certificate if not null).
///
/// {@category Providers}
final httpClientProvider =
    Provider.family<http.Client, Uint8List?>((ref, certificate) {
  var client = http.Client();

  if (certificate != null) {
    try {
      if (certificate.isNotEmpty) {
        final context = SecurityContext()
          ..setTrustedCertificatesBytes(certificate);
        client = (HttpClient(context: context)
          ..badCertificateCallback = (cert, host, port) {
            // if (host == '80.87.196.11') {
            //   // for debug
            //   return true;
            // }
            log.severe('!!!!Bad certificate');
            // showErrorNotification('Ошибка!неправильный сертификат сервера!');

            return false;
          }) as http.Client;
      }
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      log.severe('!!!!Bad certificate');
      showErrorNotification(
        'Ошибка! Не удалось добавить сертификат отделения!',
      );
    }
  }

  return client;
});

/// Provider of setting - archiveDate. Inited with null, doesn't save its value.
final archiveDate = StateProvider<DateTime?>((ref) {
  return null;
});

/// Archive view or usual view of App.
///
/// Provider of setting - isArchive. Inited with false, doesn't save its value.
///
/// {@category Providers}
final isArchive = StateProvider<bool>((ref) {
  return false;
});

final preference = FutureProvider<SharedPreferences>((ref) async {
  return SharedPreferences.getInstance();
});

final hiveBox = FutureProvider.family<Box<dynamic>, String>((ref, boxName) {
  return Hive.openBox<dynamic>(boxName);
});

final hiveStringBox =
    FutureProvider.family<Box<String>, String>((ref, boxName) {
  return Hive.openBox<String>(boxName);
});

final hiveJournalBox =
    FutureProvider.family<Box<ServiceOfJournal>, String>((ref, boxName) {
  return Hive.openBox<ServiceOfJournal>(boxName);
});

final hiveDateTimeBox = FutureProvider.family<Box<DateTime>, String>(
  (ref, boxName) async => Hive.openBox<DateTime>(boxName),
);

/// Helper, convert String to List of Map<String, dynamic>
final loadMapFromHiveKeyProvider =
    Provider.family<List<Map<String, dynamic>>, String>((ref, hiveKey) {
  // ignore: avoid_dynamic_calls
  return jsonDecode(
    ref.watch(hiveBox(hiveProfiles)).value?.get(hiveKey) as String? ?? '[]',
  ).whereType<Map<String, dynamic>>().toList() as List<Map<String, dynamic>>;
});

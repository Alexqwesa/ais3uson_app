// ignore_for_file: unnecessary_import

import 'dart:io';

import 'package:ais3uson_app/dynamic_data_models.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

/// Stub provider of current service. Separate from [lastUsed] for overriding.
final currentService = Provider<ClientService>(
  (ref) => ref.watch(lastUsed).service,
);

/// Provider of current size of container of services.
final currentServiceContainerSize =
    StateNotifierProvider<_ServiceContainerSizeState, Size>((ref) {
  return _ServiceContainerSizeState(ref);
});

final speechEngineStatus = StateNotifierProvider<_SpeechEngineStatus, String>((
  ref,
) {
  return _SpeechEngineStatus();
});

class _SpeechEngineStatus extends StateNotifier<String> {
  _SpeechEngineStatus() : super(stt.SpeechToText.notListeningStatus);

  @override
  set state(String value) {
    super.state = value;
  }
}

final speechEngineInited = FutureProvider((ref) async {
  final speech = ref.watch(speechEngine);
  await _initSpeechEngine(speech, ref);

  return speech;
});

Future<void> _initSpeechEngine(stt.SpeechToText speech, Ref ref) async {
  if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
    try {
      final available = await speech.initialize(
        onStatus: (status) {
          ref.read(speechEngineStatus.notifier).state = status;
          // log.fine('Speech status $status');
        },
        onError: (error) {
          log.severe('Speech error $error');
        },
      );
      if (available) {
        log.fine('speech ${speech.lastStatus}');
      } else {
        log.warning('The user has denied the use of speech recognition.');
      }
    } on PlatformException catch (e) {
      // todo: handle no Bluetooth permission here
      log.severe(e.details);
    }
  }
}

/// speech_to_text provider
///
/// {@category Providers}
final speechEngine = Provider((ref) {
  final speech = stt.SpeechToText();
  () async {
    await _initSpeechEngine(speech, ref);
  }();

  return speech;
});

/// Last searched text by user.
///
/// {@category Providers}
// {@category App State}
final currentSearchText = StateNotifierProvider<_CurrentSearch, String>((ref) {
  return _CurrentSearch();
});

class _CurrentSearch extends StateNotifier<String> {
  _CurrentSearch() : super('');

  @override
  set state(String value) {
    super.state = value;
  }
}

class _ServiceContainerSizeState extends StateNotifier<Size> {
  _ServiceContainerSizeState(this.ref) : super(const Size(100, 100));

  final Ref ref;

  @override
  Size get state => super.state;

  @override
  set state(Size value) {
    super.state = value;
  }

  Future<void> delayedChange(Size value) async {
    ref.read(_sizeHelper.notifier).state = value;
    Future.delayed(const Duration(milliseconds: 1000), () {
      final size = ref.read(_sizeHelper);
      if (value.width == size.width && value.height == size.height) {
        super.state = value;
      }
    });
  }
}

/// Provider of current size of container of services.
final _sizeHelper = StateNotifierProvider<__SizeHelper, Size>((ref) {
  return __SizeHelper();
});

class __SizeHelper extends StateNotifier<Size> {
  __SizeHelper() : super(const Size(100, 100));
}

/// List of services of client filtered by [currentSearchText].
final filteredServices =
    Provider.family<List<ClientService>, ClientProfile>((ref, client) {
  final searched = ref.watch(currentSearchText).toLowerCase();
  final servList = ref
      .watch(client.servicesOf)
      .where((element) => element.servText.toLowerCase().contains(searched))
      .toList(growable: false);

  return servList;
});

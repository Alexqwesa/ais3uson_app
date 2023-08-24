import 'package:ais3uson_app/main.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State of [audioPlayer].
///
/// {@category Providers}
final proofPlayState = StateProvider<PlayerState>((ref) {
  return PlayerState.stopped;
});

/// Global audioPlayer.
///
/// Init and subscribe [proofPlayState] to streams of state change.
/// {@category Providers}
/// {@category UI Proofs}
final audioPlayer = Provider<AudioPlayer>((ref) {
  final player = AudioPlayer();
  player.onPlayerStateChanged.listen((s) {
    ref.watch(proofPlayState.notifier).state = s;
    log.finest(player.state.toString());
  });

  player.onPlayerComplete.listen((event) {
    ref.watch(proofPlayState.notifier).state = PlayerState.stopped;
    player.state = PlayerState.stopped;
    log.finest(player.state.toString());
  });

  return player;
});

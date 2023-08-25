import 'package:ais3uson_app/proofs.dart';

/// Just a union class for [ProofEntry]s [after] and [before].
///
/// It does:
/// - auto-create both [after] and [before] on init,
/// - or if [ProofEntry]s provided - link them to itself,
/// - store link to [ProofList],
/// - store [name] (of a directory with proof).
class Proof {
  Proof(this.proofList, {this.name, ProofEntry? before, ProofEntry? after})
      : after = after ?? ProofEntry(),
        before = before ?? ProofEntry() {
    _updateEntries();
  }

  void _updateEntries() {
    after.proof = this;
    before.proof = this;
  }

  String? name;
  ProofList proofList;
  late ProofEntry before;
  late ProofEntry after;

  dynamic operator [](Object? key) {
    switch (key) {
      case 'after_img_':
        return after.image;
      case 'before_img_':
        return before.image;
      case 'after_audio_':
        return after.audio;
      case 'before_audio_':
        return before.image;
      default:
        throw StateError('Wrong key of ProofEntry');
    }
  }
}

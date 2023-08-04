/// States used by ProofRecorder.
///
/// {@category Providers}
enum RecorderState {
  // States of _ProofRecorder.state
  ready,
  recording,
  busy,
  // additional states: only for return
  failed,
  finished,
}

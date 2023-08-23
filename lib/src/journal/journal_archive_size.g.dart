// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_archive_size.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$journalArchiveSizeHash() =>
    r'd5479088af42e7076754dfdbf3ae05240a59fcb6';

/// Provider of setting - max amount of entries stored in [Journal].
///
/// Read/save from/to SharedPreferences, had default preinitialized value.
///
/// Depend on [locator]<SharedPreferences>.
///
/// {@category Providers}
/// {@category UI Settings}
/// {@category Journal}
///
/// Copied from [JournalArchiveSize].
@ProviderFor(JournalArchiveSize)
final journalArchiveSizeProvider =
    AutoDisposeNotifierProvider<JournalArchiveSize, int>.internal(
  JournalArchiveSize.new,
  name: r'journalArchiveSizeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$journalArchiveSizeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$JournalArchiveSize = AutoDisposeNotifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member

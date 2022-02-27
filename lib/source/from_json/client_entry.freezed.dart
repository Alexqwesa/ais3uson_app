// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'client_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ClientEntry _$ClientEntryFromJson(Map<String, dynamic> json) {
  return _ClientEntry.fromJson(json);
}

/// @nodoc
class _$ClientEntryTearOff {
  const _$ClientEntryTearOff();

  _ClientEntry call(
      {required int contract_id,
      required int dep_id,
      required int client_id,
      String contract = 'ERROR',
      String client = 'ERROR',
      required int dhw_id}) {
    return _ClientEntry(
      contract_id: contract_id,
      dep_id: dep_id,
      client_id: client_id,
      contract: contract,
      client: client,
      dhw_id: dhw_id,
    );
  }

  ClientEntry fromJson(Map<String, Object?> json) {
    return ClientEntry.fromJson(json);
  }
}

/// @nodoc
const $ClientEntry = _$ClientEntryTearOff();

/// @nodoc
mixin _$ClientEntry {
  int get contract_id => throw _privateConstructorUsedError;
  int get dep_id => throw _privateConstructorUsedError;
  int get client_id => throw _privateConstructorUsedError;
  String get contract => throw _privateConstructorUsedError;
  String get client => throw _privateConstructorUsedError;
  int get dhw_id => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ClientEntryCopyWith<ClientEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClientEntryCopyWith<$Res> {
  factory $ClientEntryCopyWith(
          ClientEntry value, $Res Function(ClientEntry) then) =
      _$ClientEntryCopyWithImpl<$Res>;
  $Res call(
      {int contract_id,
      int dep_id,
      int client_id,
      String contract,
      String client,
      int dhw_id});
}

/// @nodoc
class _$ClientEntryCopyWithImpl<$Res> implements $ClientEntryCopyWith<$Res> {
  _$ClientEntryCopyWithImpl(this._value, this._then);

  final ClientEntry _value;
  // ignore: unused_field
  final $Res Function(ClientEntry) _then;

  @override
  $Res call({
    Object? contract_id = freezed,
    Object? dep_id = freezed,
    Object? client_id = freezed,
    Object? contract = freezed,
    Object? client = freezed,
    Object? dhw_id = freezed,
  }) {
    return _then(_value.copyWith(
      contract_id: contract_id == freezed
          ? _value.contract_id
          : contract_id // ignore: cast_nullable_to_non_nullable
              as int,
      dep_id: dep_id == freezed
          ? _value.dep_id
          : dep_id // ignore: cast_nullable_to_non_nullable
              as int,
      client_id: client_id == freezed
          ? _value.client_id
          : client_id // ignore: cast_nullable_to_non_nullable
              as int,
      contract: contract == freezed
          ? _value.contract
          : contract // ignore: cast_nullable_to_non_nullable
              as String,
      client: client == freezed
          ? _value.client
          : client // ignore: cast_nullable_to_non_nullable
              as String,
      dhw_id: dhw_id == freezed
          ? _value.dhw_id
          : dhw_id // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$ClientEntryCopyWith<$Res>
    implements $ClientEntryCopyWith<$Res> {
  factory _$ClientEntryCopyWith(
          _ClientEntry value, $Res Function(_ClientEntry) then) =
      __$ClientEntryCopyWithImpl<$Res>;
  @override
  $Res call(
      {int contract_id,
      int dep_id,
      int client_id,
      String contract,
      String client,
      int dhw_id});
}

/// @nodoc
class __$ClientEntryCopyWithImpl<$Res> extends _$ClientEntryCopyWithImpl<$Res>
    implements _$ClientEntryCopyWith<$Res> {
  __$ClientEntryCopyWithImpl(
      _ClientEntry _value, $Res Function(_ClientEntry) _then)
      : super(_value, (v) => _then(v as _ClientEntry));

  @override
  _ClientEntry get _value => super._value as _ClientEntry;

  @override
  $Res call({
    Object? contract_id = freezed,
    Object? dep_id = freezed,
    Object? client_id = freezed,
    Object? contract = freezed,
    Object? client = freezed,
    Object? dhw_id = freezed,
  }) {
    return _then(_ClientEntry(
      contract_id: contract_id == freezed
          ? _value.contract_id
          : contract_id // ignore: cast_nullable_to_non_nullable
              as int,
      dep_id: dep_id == freezed
          ? _value.dep_id
          : dep_id // ignore: cast_nullable_to_non_nullable
              as int,
      client_id: client_id == freezed
          ? _value.client_id
          : client_id // ignore: cast_nullable_to_non_nullable
              as int,
      contract: contract == freezed
          ? _value.contract
          : contract // ignore: cast_nullable_to_non_nullable
              as String,
      client: client == freezed
          ? _value.client
          : client // ignore: cast_nullable_to_non_nullable
              as String,
      dhw_id: dhw_id == freezed
          ? _value.dhw_id
          : dhw_id // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ClientEntry extends _ClientEntry with DiagnosticableTreeMixin {
  const _$_ClientEntry(
      {required this.contract_id,
      required this.dep_id,
      required this.client_id,
      this.contract = 'ERROR',
      this.client = 'ERROR',
      required this.dhw_id})
      : super._();

  factory _$_ClientEntry.fromJson(Map<String, dynamic> json) =>
      _$$_ClientEntryFromJson(json);

  @override
  final int contract_id;
  @override
  final int dep_id;
  @override
  final int client_id;
  @JsonKey()
  @override
  final String contract;
  @JsonKey()
  @override
  final String client;
  @override
  final int dhw_id;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ClientEntry(contract_id: $contract_id, dep_id: $dep_id, client_id: $client_id, contract: $contract, client: $client, dhw_id: $dhw_id)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ClientEntry'))
      ..add(DiagnosticsProperty('contract_id', contract_id))
      ..add(DiagnosticsProperty('dep_id', dep_id))
      ..add(DiagnosticsProperty('client_id', client_id))
      ..add(DiagnosticsProperty('contract', contract))
      ..add(DiagnosticsProperty('client', client))
      ..add(DiagnosticsProperty('dhw_id', dhw_id));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ClientEntry &&
            const DeepCollectionEquality()
                .equals(other.contract_id, contract_id) &&
            const DeepCollectionEquality().equals(other.dep_id, dep_id) &&
            const DeepCollectionEquality().equals(other.client_id, client_id) &&
            const DeepCollectionEquality().equals(other.contract, contract) &&
            const DeepCollectionEquality().equals(other.client, client) &&
            const DeepCollectionEquality().equals(other.dhw_id, dhw_id));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(contract_id),
      const DeepCollectionEquality().hash(dep_id),
      const DeepCollectionEquality().hash(client_id),
      const DeepCollectionEquality().hash(contract),
      const DeepCollectionEquality().hash(client),
      const DeepCollectionEquality().hash(dhw_id));

  @JsonKey(ignore: true)
  @override
  _$ClientEntryCopyWith<_ClientEntry> get copyWith =>
      __$ClientEntryCopyWithImpl<_ClientEntry>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ClientEntryToJson(this);
  }
}

abstract class _ClientEntry extends ClientEntry {
  const factory _ClientEntry(
      {required int contract_id,
      required int dep_id,
      required int client_id,
      String contract,
      String client,
      required int dhw_id}) = _$_ClientEntry;
  const _ClientEntry._() : super._();

  factory _ClientEntry.fromJson(Map<String, dynamic> json) =
      _$_ClientEntry.fromJson;

  @override
  int get contract_id;
  @override
  int get dep_id;
  @override
  int get client_id;
  @override
  String get contract;
  @override
  String get client;
  @override
  int get dhw_id;
  @override
  @JsonKey(ignore: true)
  _$ClientEntryCopyWith<_ClientEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

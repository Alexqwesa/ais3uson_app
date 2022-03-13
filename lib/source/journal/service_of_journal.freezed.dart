// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'service_of_journal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ServiceOfJournal _$ServiceOfJournalFromJson(Map<String, dynamic> json) {
  return _ServiceOfJournal.fromJson(json);
}

/// @nodoc
class _$ServiceOfJournalTearOff {
  const _$ServiceOfJournalTearOff();

  _ServiceOfJournal call(
      {@HiveField(0) required int servId,
      @HiveField(1) required int contractId,
      @HiveField(2) required int workerId,
      @HiveField(3) required DateTime provDate,
      @HiveField(4) required String uid,
      @HiveField(5) ServiceState state = ServiceState.added,
      @HiveField(6) String error = ''}) {
    return _ServiceOfJournal(
      servId: servId,
      contractId: contractId,
      workerId: workerId,
      provDate: provDate,
      uid: uid,
      state: state,
      error: error,
    );
  }

  ServiceOfJournal fromJson(Map<String, Object?> json) {
    return ServiceOfJournal.fromJson(json);
  }
}

/// @nodoc
const $ServiceOfJournal = _$ServiceOfJournalTearOff();

/// @nodoc
mixin _$ServiceOfJournal {
  @HiveField(0)
  int get servId => throw _privateConstructorUsedError;
  @HiveField(1)
  int get contractId => throw _privateConstructorUsedError;
  @HiveField(2)
  int get workerId => throw _privateConstructorUsedError;
  @HiveField(3)
  DateTime get provDate => throw _privateConstructorUsedError;
  @HiveField(4)
  String get uid => throw _privateConstructorUsedError;
  @HiveField(5)
  ServiceState get state => throw _privateConstructorUsedError;
  @HiveField(6)
  String get error => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ServiceOfJournalCopyWith<ServiceOfJournal> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceOfJournalCopyWith<$Res> {
  factory $ServiceOfJournalCopyWith(
          ServiceOfJournal value, $Res Function(ServiceOfJournal) then) =
      _$ServiceOfJournalCopyWithImpl<$Res>;
  $Res call(
      {@HiveField(0) int servId,
      @HiveField(1) int contractId,
      @HiveField(2) int workerId,
      @HiveField(3) DateTime provDate,
      @HiveField(4) String uid,
      @HiveField(5) ServiceState state,
      @HiveField(6) String error});
}

/// @nodoc
class _$ServiceOfJournalCopyWithImpl<$Res>
    implements $ServiceOfJournalCopyWith<$Res> {
  _$ServiceOfJournalCopyWithImpl(this._value, this._then);

  final ServiceOfJournal _value;
  // ignore: unused_field
  final $Res Function(ServiceOfJournal) _then;

  @override
  $Res call({
    Object? servId = freezed,
    Object? contractId = freezed,
    Object? workerId = freezed,
    Object? provDate = freezed,
    Object? uid = freezed,
    Object? state = freezed,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      servId: servId == freezed
          ? _value.servId
          : servId // ignore: cast_nullable_to_non_nullable
              as int,
      contractId: contractId == freezed
          ? _value.contractId
          : contractId // ignore: cast_nullable_to_non_nullable
              as int,
      workerId: workerId == freezed
          ? _value.workerId
          : workerId // ignore: cast_nullable_to_non_nullable
              as int,
      provDate: provDate == freezed
          ? _value.provDate
          : provDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      uid: uid == freezed
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      state: state == freezed
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as ServiceState,
      error: error == freezed
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$ServiceOfJournalCopyWith<$Res>
    implements $ServiceOfJournalCopyWith<$Res> {
  factory _$ServiceOfJournalCopyWith(
          _ServiceOfJournal value, $Res Function(_ServiceOfJournal) then) =
      __$ServiceOfJournalCopyWithImpl<$Res>;
  @override
  $Res call(
      {@HiveField(0) int servId,
      @HiveField(1) int contractId,
      @HiveField(2) int workerId,
      @HiveField(3) DateTime provDate,
      @HiveField(4) String uid,
      @HiveField(5) ServiceState state,
      @HiveField(6) String error});
}

/// @nodoc
class __$ServiceOfJournalCopyWithImpl<$Res>
    extends _$ServiceOfJournalCopyWithImpl<$Res>
    implements _$ServiceOfJournalCopyWith<$Res> {
  __$ServiceOfJournalCopyWithImpl(
      _ServiceOfJournal _value, $Res Function(_ServiceOfJournal) _then)
      : super(_value, (v) => _then(v as _ServiceOfJournal));

  @override
  _ServiceOfJournal get _value => super._value as _ServiceOfJournal;

  @override
  $Res call({
    Object? servId = freezed,
    Object? contractId = freezed,
    Object? workerId = freezed,
    Object? provDate = freezed,
    Object? uid = freezed,
    Object? state = freezed,
    Object? error = freezed,
  }) {
    return _then(_ServiceOfJournal(
      servId: servId == freezed
          ? _value.servId
          : servId // ignore: cast_nullable_to_non_nullable
              as int,
      contractId: contractId == freezed
          ? _value.contractId
          : contractId // ignore: cast_nullable_to_non_nullable
              as int,
      workerId: workerId == freezed
          ? _value.workerId
          : workerId // ignore: cast_nullable_to_non_nullable
              as int,
      provDate: provDate == freezed
          ? _value.provDate
          : provDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      uid: uid == freezed
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      state: state == freezed
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as ServiceState,
      error: error == freezed
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@HiveType(typeId: 0)
class _$_ServiceOfJournal extends _ServiceOfJournal {
  _$_ServiceOfJournal(
      {@HiveField(0) required this.servId,
      @HiveField(1) required this.contractId,
      @HiveField(2) required this.workerId,
      @HiveField(3) required this.provDate,
      @HiveField(4) required this.uid,
      @HiveField(5) this.state = ServiceState.added,
      @HiveField(6) this.error = ''})
      : super._();

  factory _$_ServiceOfJournal.fromJson(Map<String, dynamic> json) =>
      _$$_ServiceOfJournalFromJson(json);

  @override
  @HiveField(0)
  final int servId;
  @override
  @HiveField(1)
  final int contractId;
  @override
  @HiveField(2)
  final int workerId;
  @override
  @HiveField(3)
  final DateTime provDate;
  @override
  @HiveField(4)
  final String uid;
  @JsonKey()
  @override
  @HiveField(5)
  final ServiceState state;
  @JsonKey()
  @override
  @HiveField(6)
  final String error;

  @override
  String toString() {
    return 'ServiceOfJournal(servId: $servId, contractId: $contractId, workerId: $workerId, provDate: $provDate, uid: $uid, state: $state, error: $error)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ServiceOfJournal &&
            const DeepCollectionEquality().equals(other.servId, servId) &&
            const DeepCollectionEquality()
                .equals(other.contractId, contractId) &&
            const DeepCollectionEquality().equals(other.workerId, workerId) &&
            const DeepCollectionEquality().equals(other.provDate, provDate) &&
            const DeepCollectionEquality().equals(other.uid, uid) &&
            const DeepCollectionEquality().equals(other.state, state) &&
            const DeepCollectionEquality().equals(other.error, error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(servId),
      const DeepCollectionEquality().hash(contractId),
      const DeepCollectionEquality().hash(workerId),
      const DeepCollectionEquality().hash(provDate),
      const DeepCollectionEquality().hash(uid),
      const DeepCollectionEquality().hash(state),
      const DeepCollectionEquality().hash(error));

  @JsonKey(ignore: true)
  @override
  _$ServiceOfJournalCopyWith<_ServiceOfJournal> get copyWith =>
      __$ServiceOfJournalCopyWithImpl<_ServiceOfJournal>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ServiceOfJournalToJson(this);
  }
}

abstract class _ServiceOfJournal extends ServiceOfJournal {
  factory _ServiceOfJournal(
      {@HiveField(0) required int servId,
      @HiveField(1) required int contractId,
      @HiveField(2) required int workerId,
      @HiveField(3) required DateTime provDate,
      @HiveField(4) required String uid,
      @HiveField(5) ServiceState state,
      @HiveField(6) String error}) = _$_ServiceOfJournal;
  _ServiceOfJournal._() : super._();

  factory _ServiceOfJournal.fromJson(Map<String, dynamic> json) =
      _$_ServiceOfJournal.fromJson;

  @override
  @HiveField(0)
  int get servId;
  @override
  @HiveField(1)
  int get contractId;
  @override
  @HiveField(2)
  int get workerId;
  @override
  @HiveField(3)
  DateTime get provDate;
  @override
  @HiveField(4)
  String get uid;
  @override
  @HiveField(5)
  ServiceState get state;
  @override
  @HiveField(6)
  String get error;
  @override
  @JsonKey(ignore: true)
  _$ServiceOfJournalCopyWith<_ServiceOfJournal> get copyWith =>
      throw _privateConstructorUsedError;
}

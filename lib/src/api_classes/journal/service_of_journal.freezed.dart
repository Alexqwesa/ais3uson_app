// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_of_journal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ServiceOfJournal _$ServiceOfJournalFromJson(Map<String, dynamic> json) {
  return _ServiceOfJournal.fromJson(json);
}

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
      _$ServiceOfJournalCopyWithImpl<$Res, ServiceOfJournal>;
  @useResult
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
class _$ServiceOfJournalCopyWithImpl<$Res, $Val extends ServiceOfJournal>
    implements $ServiceOfJournalCopyWith<$Res> {
  _$ServiceOfJournalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? servId = null,
    Object? contractId = null,
    Object? workerId = null,
    Object? provDate = null,
    Object? uid = null,
    Object? state = null,
    Object? error = null,
  }) {
    return _then(_value.copyWith(
      servId: null == servId
          ? _value.servId
          : servId // ignore: cast_nullable_to_non_nullable
              as int,
      contractId: null == contractId
          ? _value.contractId
          : contractId // ignore: cast_nullable_to_non_nullable
              as int,
      workerId: null == workerId
          ? _value.workerId
          : workerId // ignore: cast_nullable_to_non_nullable
              as int,
      provDate: null == provDate
          ? _value.provDate
          : provDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as ServiceState,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ServiceOfJournalCopyWith<$Res>
    implements $ServiceOfJournalCopyWith<$Res> {
  factory _$$_ServiceOfJournalCopyWith(
          _$_ServiceOfJournal value, $Res Function(_$_ServiceOfJournal) then) =
      __$$_ServiceOfJournalCopyWithImpl<$Res>;
  @override
  @useResult
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
class __$$_ServiceOfJournalCopyWithImpl<$Res>
    extends _$ServiceOfJournalCopyWithImpl<$Res, _$_ServiceOfJournal>
    implements _$$_ServiceOfJournalCopyWith<$Res> {
  __$$_ServiceOfJournalCopyWithImpl(
      _$_ServiceOfJournal _value, $Res Function(_$_ServiceOfJournal) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? servId = null,
    Object? contractId = null,
    Object? workerId = null,
    Object? provDate = null,
    Object? uid = null,
    Object? state = null,
    Object? error = null,
  }) {
    return _then(_$_ServiceOfJournal(
      servId: null == servId
          ? _value.servId
          : servId // ignore: cast_nullable_to_non_nullable
              as int,
      contractId: null == contractId
          ? _value.contractId
          : contractId // ignore: cast_nullable_to_non_nullable
              as int,
      workerId: null == workerId
          ? _value.workerId
          : workerId // ignore: cast_nullable_to_non_nullable
              as int,
      provDate: null == provDate
          ? _value.provDate
          : provDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as ServiceState,
      error: null == error
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
  @override
  @JsonKey()
  @HiveField(5)
  final ServiceState state;
  @override
  @JsonKey()
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
            other is _$_ServiceOfJournal &&
            (identical(other.servId, servId) || other.servId == servId) &&
            (identical(other.contractId, contractId) ||
                other.contractId == contractId) &&
            (identical(other.workerId, workerId) ||
                other.workerId == workerId) &&
            (identical(other.provDate, provDate) ||
                other.provDate == provDate) &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, servId, contractId, workerId, provDate, uid, state, error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ServiceOfJournalCopyWith<_$_ServiceOfJournal> get copyWith =>
      __$$_ServiceOfJournalCopyWithImpl<_$_ServiceOfJournal>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ServiceOfJournalToJson(
      this,
    );
  }
}

abstract class _ServiceOfJournal extends ServiceOfJournal {
  factory _ServiceOfJournal(
      {@HiveField(0) required final int servId,
      @HiveField(1) required final int contractId,
      @HiveField(2) required final int workerId,
      @HiveField(3) required final DateTime provDate,
      @HiveField(4) required final String uid,
      @HiveField(5) final ServiceState state,
      @HiveField(6) final String error}) = _$_ServiceOfJournal;
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
  _$$_ServiceOfJournalCopyWith<_$_ServiceOfJournal> get copyWith =>
      throw _privateConstructorUsedError;
}

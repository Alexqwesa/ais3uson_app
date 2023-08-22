// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'client_service.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ClientService {
  /// Reference to existing [Worker].
  Worker get workerProfile => throw _privateConstructorUsedError;

  /// Reference to existing [ServiceEntry].
  ServiceEntry get service => throw _privateConstructorUsedError;

  /// Reference to existing [ClientPlan].
  ClientPlan get planned => throw _privateConstructorUsedError;

  /// Should be Null to depend on global variable, !null break dependency.
  DateTime? get date => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ClientServiceCopyWith<ClientService> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClientServiceCopyWith<$Res> {
  factory $ClientServiceCopyWith(
          ClientService value, $Res Function(ClientService) then) =
      _$ClientServiceCopyWithImpl<$Res, ClientService>;
  @useResult
  $Res call(
      {Worker workerProfile,
      ServiceEntry service,
      ClientPlan planned,
      DateTime? date});

  $ServiceEntryCopyWith<$Res> get service;
  $ClientPlanCopyWith<$Res> get planned;
}

/// @nodoc
class _$ClientServiceCopyWithImpl<$Res, $Val extends ClientService>
    implements $ClientServiceCopyWith<$Res> {
  _$ClientServiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workerProfile = null,
    Object? service = null,
    Object? planned = null,
    Object? date = freezed,
  }) {
    return _then(_value.copyWith(
      workerProfile: null == workerProfile
          ? _value.workerProfile
          : workerProfile // ignore: cast_nullable_to_non_nullable
              as Worker,
      service: null == service
          ? _value.service
          : service // ignore: cast_nullable_to_non_nullable
              as ServiceEntry,
      planned: null == planned
          ? _value.planned
          : planned // ignore: cast_nullable_to_non_nullable
              as ClientPlan,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ServiceEntryCopyWith<$Res> get service {
    return $ServiceEntryCopyWith<$Res>(_value.service, (value) {
      return _then(_value.copyWith(service: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ClientPlanCopyWith<$Res> get planned {
    return $ClientPlanCopyWith<$Res>(_value.planned, (value) {
      return _then(_value.copyWith(planned: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_ClientServiceCopyWith<$Res>
    implements $ClientServiceCopyWith<$Res> {
  factory _$$_ClientServiceCopyWith(
          _$_ClientService value, $Res Function(_$_ClientService) then) =
      __$$_ClientServiceCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Worker workerProfile,
      ServiceEntry service,
      ClientPlan planned,
      DateTime? date});

  @override
  $ServiceEntryCopyWith<$Res> get service;
  @override
  $ClientPlanCopyWith<$Res> get planned;
}

/// @nodoc
class __$$_ClientServiceCopyWithImpl<$Res>
    extends _$ClientServiceCopyWithImpl<$Res, _$_ClientService>
    implements _$$_ClientServiceCopyWith<$Res> {
  __$$_ClientServiceCopyWithImpl(
      _$_ClientService _value, $Res Function(_$_ClientService) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workerProfile = null,
    Object? service = null,
    Object? planned = null,
    Object? date = freezed,
  }) {
    return _then(_$_ClientService(
      workerProfile: null == workerProfile
          ? _value.workerProfile
          : workerProfile // ignore: cast_nullable_to_non_nullable
              as Worker,
      service: null == service
          ? _value.service
          : service // ignore: cast_nullable_to_non_nullable
              as ServiceEntry,
      planned: null == planned
          ? _value.planned
          : planned // ignore: cast_nullable_to_non_nullable
              as ClientPlan,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$_ClientService extends _ClientService {
  const _$_ClientService(
      {required this.workerProfile,
      required this.service,
      required this.planned,
      this.date = null})
      : super._();

  /// Reference to existing [Worker].
  @override
  final Worker workerProfile;

  /// Reference to existing [ServiceEntry].
  @override
  final ServiceEntry service;

  /// Reference to existing [ClientPlan].
  @override
  final ClientPlan planned;

  /// Should be Null to depend on global variable, !null break dependency.
  @override
  @JsonKey()
  final DateTime? date;

  @override
  String toString() {
    return 'ClientService(workerProfile: $workerProfile, service: $service, planned: $planned, date: $date)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ClientService &&
            (identical(other.workerProfile, workerProfile) ||
                other.workerProfile == workerProfile) &&
            (identical(other.service, service) || other.service == service) &&
            (identical(other.planned, planned) || other.planned == planned) &&
            (identical(other.date, date) || other.date == date));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, workerProfile, service, planned, date);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ClientServiceCopyWith<_$_ClientService> get copyWith =>
      __$$_ClientServiceCopyWithImpl<_$_ClientService>(this, _$identity);
}

abstract class _ClientService extends ClientService {
  const factory _ClientService(
      {required final Worker workerProfile,
      required final ServiceEntry service,
      required final ClientPlan planned,
      final DateTime? date}) = _$_ClientService;
  const _ClientService._() : super._();

  @override

  /// Reference to existing [Worker].
  Worker get workerProfile;
  @override

  /// Reference to existing [ServiceEntry].
  ServiceEntry get service;
  @override

  /// Reference to existing [ClientPlan].
  ClientPlan get planned;
  @override

  /// Should be Null to depend on global variable, !null break dependency.
  DateTime? get date;
  @override
  @JsonKey(ignore: true)
  _$$_ClientServiceCopyWith<_$_ClientService> get copyWith =>
      throw _privateConstructorUsedError;
}

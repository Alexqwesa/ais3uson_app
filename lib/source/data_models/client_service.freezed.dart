// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'client_service.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ClientService {
  /// Reference to existing [WorkerProfile].
  WorkerProfile get workerProfile => throw _privateConstructorUsedError;

  /// Reference to existing [ServiceEntry].
  ServiceEntry get service => throw _privateConstructorUsedError;

  /// Reference to existing [ClientPlan].
  ClientPlan get planned => throw _privateConstructorUsedError;

  /// Null - for dynamic date (from provider [archiveDate])
  DateTime? get date => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ClientServiceCopyWith<ClientService> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClientServiceCopyWith<$Res> {
  factory $ClientServiceCopyWith(
          ClientService value, $Res Function(ClientService) then) =
      _$ClientServiceCopyWithImpl<$Res>;
  $Res call(
      {WorkerProfile workerProfile,
      ServiceEntry service,
      ClientPlan planned,
      DateTime? date});

  $ServiceEntryCopyWith<$Res> get service;
  $ClientPlanCopyWith<$Res> get planned;
}

/// @nodoc
class _$ClientServiceCopyWithImpl<$Res>
    implements $ClientServiceCopyWith<$Res> {
  _$ClientServiceCopyWithImpl(this._value, this._then);

  final ClientService _value;
  // ignore: unused_field
  final $Res Function(ClientService) _then;

  @override
  $Res call({
    Object? workerProfile = freezed,
    Object? service = freezed,
    Object? planned = freezed,
    Object? date = freezed,
  }) {
    return _then(_value.copyWith(
      workerProfile: workerProfile == freezed
          ? _value.workerProfile
          : workerProfile // ignore: cast_nullable_to_non_nullable
              as WorkerProfile,
      service: service == freezed
          ? _value.service
          : service // ignore: cast_nullable_to_non_nullable
              as ServiceEntry,
      planned: planned == freezed
          ? _value.planned
          : planned // ignore: cast_nullable_to_non_nullable
              as ClientPlan,
      date: date == freezed
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }

  @override
  $ServiceEntryCopyWith<$Res> get service {
    return $ServiceEntryCopyWith<$Res>(_value.service, (value) {
      return _then(_value.copyWith(service: value));
    });
  }

  @override
  $ClientPlanCopyWith<$Res> get planned {
    return $ClientPlanCopyWith<$Res>(_value.planned, (value) {
      return _then(_value.copyWith(planned: value));
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
  $Res call(
      {WorkerProfile workerProfile,
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
    extends _$ClientServiceCopyWithImpl<$Res>
    implements _$$_ClientServiceCopyWith<$Res> {
  __$$_ClientServiceCopyWithImpl(
      _$_ClientService _value, $Res Function(_$_ClientService) _then)
      : super(_value, (v) => _then(v as _$_ClientService));

  @override
  _$_ClientService get _value => super._value as _$_ClientService;

  @override
  $Res call({
    Object? workerProfile = freezed,
    Object? service = freezed,
    Object? planned = freezed,
    Object? date = freezed,
  }) {
    return _then(_$_ClientService(
      workerProfile: workerProfile == freezed
          ? _value.workerProfile
          : workerProfile // ignore: cast_nullable_to_non_nullable
              as WorkerProfile,
      service: service == freezed
          ? _value.service
          : service // ignore: cast_nullable_to_non_nullable
              as ServiceEntry,
      planned: planned == freezed
          ? _value.planned
          : planned // ignore: cast_nullable_to_non_nullable
              as ClientPlan,
      date: date == freezed
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
      this.date})
      : super._();

  /// Reference to existing [WorkerProfile].
  @override
  final WorkerProfile workerProfile;

  /// Reference to existing [ServiceEntry].
  @override
  final ServiceEntry service;

  /// Reference to existing [ClientPlan].
  @override
  final ClientPlan planned;

  /// Null - for dynamic date (from provider [archiveDate])
  @override
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
            const DeepCollectionEquality()
                .equals(other.workerProfile, workerProfile) &&
            const DeepCollectionEquality().equals(other.service, service) &&
            const DeepCollectionEquality().equals(other.planned, planned) &&
            const DeepCollectionEquality().equals(other.date, date));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(workerProfile),
      const DeepCollectionEquality().hash(service),
      const DeepCollectionEquality().hash(planned),
      const DeepCollectionEquality().hash(date));

  @JsonKey(ignore: true)
  @override
  _$$_ClientServiceCopyWith<_$_ClientService> get copyWith =>
      __$$_ClientServiceCopyWithImpl<_$_ClientService>(this, _$identity);
}

abstract class _ClientService extends ClientService {
  const factory _ClientService(
      {required final WorkerProfile workerProfile,
      required final ServiceEntry service,
      required final ClientPlan planned,
      final DateTime? date}) = _$_ClientService;
  const _ClientService._() : super._();

  @override

  /// Reference to existing [WorkerProfile].
  WorkerProfile get workerProfile => throw _privateConstructorUsedError;
  @override

  /// Reference to existing [ServiceEntry].
  ServiceEntry get service => throw _privateConstructorUsedError;
  @override

  /// Reference to existing [ClientPlan].
  ClientPlan get planned => throw _privateConstructorUsedError;
  @override

  /// Null - for dynamic date (from provider [archiveDate])
  DateTime? get date => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_ClientServiceCopyWith<_$_ClientService> get copyWith =>
      throw _privateConstructorUsedError;
}

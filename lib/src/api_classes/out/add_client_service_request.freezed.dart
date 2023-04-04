// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_client_service_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AddClientServiceRequest {
  String get vdate => throw _privateConstructorUsedError;
  String get uuid => throw _privateConstructorUsedError;
  int get contracts_id => throw _privateConstructorUsedError;
  int get dep_has_worker_id => throw _privateConstructorUsedError;
  int get serv_id => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AddClientServiceRequestCopyWith<AddClientServiceRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddClientServiceRequestCopyWith<$Res> {
  factory $AddClientServiceRequestCopyWith(AddClientServiceRequest value,
          $Res Function(AddClientServiceRequest) then) =
      _$AddClientServiceRequestCopyWithImpl<$Res, AddClientServiceRequest>;
  @useResult
  $Res call(
      {String vdate,
      String uuid,
      int contracts_id,
      int dep_has_worker_id,
      int serv_id});
}

/// @nodoc
class _$AddClientServiceRequestCopyWithImpl<$Res,
        $Val extends AddClientServiceRequest>
    implements $AddClientServiceRequestCopyWith<$Res> {
  _$AddClientServiceRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vdate = null,
    Object? uuid = null,
    Object? contracts_id = null,
    Object? dep_has_worker_id = null,
    Object? serv_id = null,
  }) {
    return _then(_value.copyWith(
      vdate: null == vdate
          ? _value.vdate
          : vdate // ignore: cast_nullable_to_non_nullable
              as String,
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      contracts_id: null == contracts_id
          ? _value.contracts_id
          : contracts_id // ignore: cast_nullable_to_non_nullable
              as int,
      dep_has_worker_id: null == dep_has_worker_id
          ? _value.dep_has_worker_id
          : dep_has_worker_id // ignore: cast_nullable_to_non_nullable
              as int,
      serv_id: null == serv_id
          ? _value.serv_id
          : serv_id // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AddClientServiceRequestCopyWith<$Res>
    implements $AddClientServiceRequestCopyWith<$Res> {
  factory _$$_AddClientServiceRequestCopyWith(_$_AddClientServiceRequest value,
          $Res Function(_$_AddClientServiceRequest) then) =
      __$$_AddClientServiceRequestCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String vdate,
      String uuid,
      int contracts_id,
      int dep_has_worker_id,
      int serv_id});
}

/// @nodoc
class __$$_AddClientServiceRequestCopyWithImpl<$Res>
    extends _$AddClientServiceRequestCopyWithImpl<$Res,
        _$_AddClientServiceRequest>
    implements _$$_AddClientServiceRequestCopyWith<$Res> {
  __$$_AddClientServiceRequestCopyWithImpl(_$_AddClientServiceRequest _value,
      $Res Function(_$_AddClientServiceRequest) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vdate = null,
    Object? uuid = null,
    Object? contracts_id = null,
    Object? dep_has_worker_id = null,
    Object? serv_id = null,
  }) {
    return _then(_$_AddClientServiceRequest(
      vdate: null == vdate
          ? _value.vdate
          : vdate // ignore: cast_nullable_to_non_nullable
              as String,
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      contracts_id: null == contracts_id
          ? _value.contracts_id
          : contracts_id // ignore: cast_nullable_to_non_nullable
              as int,
      dep_has_worker_id: null == dep_has_worker_id
          ? _value.dep_has_worker_id
          : dep_has_worker_id // ignore: cast_nullable_to_non_nullable
              as int,
      serv_id: null == serv_id
          ? _value.serv_id
          : serv_id // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_AddClientServiceRequest extends _AddClientServiceRequest {
  const _$_AddClientServiceRequest(
      {required this.vdate,
      required this.uuid,
      required this.contracts_id,
      required this.dep_has_worker_id,
      required this.serv_id})
      : super._();

  @override
  final String vdate;
  @override
  final String uuid;
  @override
  final int contracts_id;
  @override
  final int dep_has_worker_id;
  @override
  final int serv_id;

  @override
  String toString() {
    return 'AddClientServiceRequest(vdate: $vdate, uuid: $uuid, contracts_id: $contracts_id, dep_has_worker_id: $dep_has_worker_id, serv_id: $serv_id)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AddClientServiceRequest &&
            (identical(other.vdate, vdate) || other.vdate == vdate) &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.contracts_id, contracts_id) ||
                other.contracts_id == contracts_id) &&
            (identical(other.dep_has_worker_id, dep_has_worker_id) ||
                other.dep_has_worker_id == dep_has_worker_id) &&
            (identical(other.serv_id, serv_id) || other.serv_id == serv_id));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, vdate, uuid, contracts_id, dep_has_worker_id, serv_id);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AddClientServiceRequestCopyWith<_$_AddClientServiceRequest>
      get copyWith =>
          __$$_AddClientServiceRequestCopyWithImpl<_$_AddClientServiceRequest>(
              this, _$identity);
}

abstract class _AddClientServiceRequest extends AddClientServiceRequest {
  const factory _AddClientServiceRequest(
      {required final String vdate,
      required final String uuid,
      required final int contracts_id,
      required final int dep_has_worker_id,
      required final int serv_id}) = _$_AddClientServiceRequest;
  const _AddClientServiceRequest._() : super._();

  @override
  String get vdate;
  @override
  String get uuid;
  @override
  int get contracts_id;
  @override
  int get dep_has_worker_id;
  @override
  int get serv_id;
  @override
  @JsonKey(ignore: true)
  _$$_AddClientServiceRequestCopyWith<_$_AddClientServiceRequest>
      get copyWith => throw _privateConstructorUsedError;
}

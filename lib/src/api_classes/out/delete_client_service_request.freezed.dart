// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delete_client_service_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$DeleteClientServiceRequest {
  String get uuid => throw _privateConstructorUsedError;
  int get serv_id => throw _privateConstructorUsedError;
  int get contracts_id => throw _privateConstructorUsedError;
  int get dep_has_worker_id => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DeleteClientServiceRequestCopyWith<DeleteClientServiceRequest>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeleteClientServiceRequestCopyWith<$Res> {
  factory $DeleteClientServiceRequestCopyWith(DeleteClientServiceRequest value,
          $Res Function(DeleteClientServiceRequest) then) =
      _$DeleteClientServiceRequestCopyWithImpl<$Res,
          DeleteClientServiceRequest>;
  @useResult
  $Res call(
      {String uuid, int serv_id, int contracts_id, int dep_has_worker_id});
}

/// @nodoc
class _$DeleteClientServiceRequestCopyWithImpl<$Res,
        $Val extends DeleteClientServiceRequest>
    implements $DeleteClientServiceRequestCopyWith<$Res> {
  _$DeleteClientServiceRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? serv_id = null,
    Object? contracts_id = null,
    Object? dep_has_worker_id = null,
  }) {
    return _then(_value.copyWith(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      serv_id: null == serv_id
          ? _value.serv_id
          : serv_id // ignore: cast_nullable_to_non_nullable
              as int,
      contracts_id: null == contracts_id
          ? _value.contracts_id
          : contracts_id // ignore: cast_nullable_to_non_nullable
              as int,
      dep_has_worker_id: null == dep_has_worker_id
          ? _value.dep_has_worker_id
          : dep_has_worker_id // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_DeleteClientServiceRequestCopyWith<$Res>
    implements $DeleteClientServiceRequestCopyWith<$Res> {
  factory _$$_DeleteClientServiceRequestCopyWith(
          _$_DeleteClientServiceRequest value,
          $Res Function(_$_DeleteClientServiceRequest) then) =
      __$$_DeleteClientServiceRequestCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uuid, int serv_id, int contracts_id, int dep_has_worker_id});
}

/// @nodoc
class __$$_DeleteClientServiceRequestCopyWithImpl<$Res>
    extends _$DeleteClientServiceRequestCopyWithImpl<$Res,
        _$_DeleteClientServiceRequest>
    implements _$$_DeleteClientServiceRequestCopyWith<$Res> {
  __$$_DeleteClientServiceRequestCopyWithImpl(
      _$_DeleteClientServiceRequest _value,
      $Res Function(_$_DeleteClientServiceRequest) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? serv_id = null,
    Object? contracts_id = null,
    Object? dep_has_worker_id = null,
  }) {
    return _then(_$_DeleteClientServiceRequest(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      serv_id: null == serv_id
          ? _value.serv_id
          : serv_id // ignore: cast_nullable_to_non_nullable
              as int,
      contracts_id: null == contracts_id
          ? _value.contracts_id
          : contracts_id // ignore: cast_nullable_to_non_nullable
              as int,
      dep_has_worker_id: null == dep_has_worker_id
          ? _value.dep_has_worker_id
          : dep_has_worker_id // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_DeleteClientServiceRequest extends _DeleteClientServiceRequest {
  const _$_DeleteClientServiceRequest(
      {required this.uuid,
      required this.serv_id,
      required this.contracts_id,
      required this.dep_has_worker_id})
      : super._();

  @override
  final String uuid;
  @override
  final int serv_id;
  @override
  final int contracts_id;
  @override
  final int dep_has_worker_id;

  @override
  String toString() {
    return 'DeleteClientServiceRequest(uuid: $uuid, serv_id: $serv_id, contracts_id: $contracts_id, dep_has_worker_id: $dep_has_worker_id)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_DeleteClientServiceRequest &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.serv_id, serv_id) || other.serv_id == serv_id) &&
            (identical(other.contracts_id, contracts_id) ||
                other.contracts_id == contracts_id) &&
            (identical(other.dep_has_worker_id, dep_has_worker_id) ||
                other.dep_has_worker_id == dep_has_worker_id));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, uuid, serv_id, contracts_id, dep_has_worker_id);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_DeleteClientServiceRequestCopyWith<_$_DeleteClientServiceRequest>
      get copyWith => __$$_DeleteClientServiceRequestCopyWithImpl<
          _$_DeleteClientServiceRequest>(this, _$identity);
}

abstract class _DeleteClientServiceRequest extends DeleteClientServiceRequest {
  const factory _DeleteClientServiceRequest(
      {required final String uuid,
      required final int serv_id,
      required final int contracts_id,
      required final int dep_has_worker_id}) = _$_DeleteClientServiceRequest;
  const _DeleteClientServiceRequest._() : super._();

  @override
  String get uuid;
  @override
  int get serv_id;
  @override
  int get contracts_id;
  @override
  int get dep_has_worker_id;
  @override
  @JsonKey(ignore: true)
  _$$_DeleteClientServiceRequestCopyWith<_$_DeleteClientServiceRequest>
      get copyWith => throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'client_plan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ClientPlan _$ClientPlanFromJson(Map<String, dynamic> json) {
  return _ClientPlan.fromJson(json);
}

/// @nodoc
mixin _$ClientPlan {
  int get contract_id => throw _privateConstructorUsedError;
  int get serv_id => throw _privateConstructorUsedError;
  int get planned => throw _privateConstructorUsedError;
  int get filled => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ClientPlanCopyWith<ClientPlan> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClientPlanCopyWith<$Res> {
  factory $ClientPlanCopyWith(
          ClientPlan value, $Res Function(ClientPlan) then) =
      _$ClientPlanCopyWithImpl<$Res, ClientPlan>;
  @useResult
  $Res call({int contract_id, int serv_id, int planned, int filled});
}

/// @nodoc
class _$ClientPlanCopyWithImpl<$Res, $Val extends ClientPlan>
    implements $ClientPlanCopyWith<$Res> {
  _$ClientPlanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contract_id = null,
    Object? serv_id = null,
    Object? planned = null,
    Object? filled = null,
  }) {
    return _then(_value.copyWith(
      contract_id: null == contract_id
          ? _value.contract_id
          : contract_id // ignore: cast_nullable_to_non_nullable
              as int,
      serv_id: null == serv_id
          ? _value.serv_id
          : serv_id // ignore: cast_nullable_to_non_nullable
              as int,
      planned: null == planned
          ? _value.planned
          : planned // ignore: cast_nullable_to_non_nullable
              as int,
      filled: null == filled
          ? _value.filled
          : filled // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ClientPlanCopyWith<$Res>
    implements $ClientPlanCopyWith<$Res> {
  factory _$$_ClientPlanCopyWith(
          _$_ClientPlan value, $Res Function(_$_ClientPlan) then) =
      __$$_ClientPlanCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int contract_id, int serv_id, int planned, int filled});
}

/// @nodoc
class __$$_ClientPlanCopyWithImpl<$Res>
    extends _$ClientPlanCopyWithImpl<$Res, _$_ClientPlan>
    implements _$$_ClientPlanCopyWith<$Res> {
  __$$_ClientPlanCopyWithImpl(
      _$_ClientPlan _value, $Res Function(_$_ClientPlan) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contract_id = null,
    Object? serv_id = null,
    Object? planned = null,
    Object? filled = null,
  }) {
    return _then(_$_ClientPlan(
      contract_id: null == contract_id
          ? _value.contract_id
          : contract_id // ignore: cast_nullable_to_non_nullable
              as int,
      serv_id: null == serv_id
          ? _value.serv_id
          : serv_id // ignore: cast_nullable_to_non_nullable
              as int,
      planned: null == planned
          ? _value.planned
          : planned // ignore: cast_nullable_to_non_nullable
              as int,
      filled: null == filled
          ? _value.filled
          : filled // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ClientPlan extends _ClientPlan {
  const _$_ClientPlan(
      {required this.contract_id,
      required this.serv_id,
      required this.planned,
      required this.filled})
      : super._();

  factory _$_ClientPlan.fromJson(Map<String, dynamic> json) =>
      _$$_ClientPlanFromJson(json);

  @override
  final int contract_id;
  @override
  final int serv_id;
  @override
  final int planned;
  @override
  final int filled;

  @override
  String toString() {
    return 'ClientPlan(contract_id: $contract_id, serv_id: $serv_id, planned: $planned, filled: $filled)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ClientPlan &&
            (identical(other.contract_id, contract_id) ||
                other.contract_id == contract_id) &&
            (identical(other.serv_id, serv_id) || other.serv_id == serv_id) &&
            (identical(other.planned, planned) || other.planned == planned) &&
            (identical(other.filled, filled) || other.filled == filled));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, contract_id, serv_id, planned, filled);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ClientPlanCopyWith<_$_ClientPlan> get copyWith =>
      __$$_ClientPlanCopyWithImpl<_$_ClientPlan>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ClientPlanToJson(
      this,
    );
  }
}

abstract class _ClientPlan extends ClientPlan {
  const factory _ClientPlan(
      {required final int contract_id,
      required final int serv_id,
      required final int planned,
      required final int filled}) = _$_ClientPlan;
  const _ClientPlan._() : super._();

  factory _ClientPlan.fromJson(Map<String, dynamic> json) =
      _$_ClientPlan.fromJson;

  @override
  int get contract_id;
  @override
  int get serv_id;
  @override
  int get planned;
  @override
  int get filled;
  @override
  @JsonKey(ignore: true)
  _$$_ClientPlanCopyWith<_$_ClientPlan> get copyWith =>
      throw _privateConstructorUsedError;
}

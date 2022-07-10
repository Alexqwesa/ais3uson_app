// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

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
      _$ClientPlanCopyWithImpl<$Res>;
  $Res call({int contract_id, int serv_id, int planned, int filled});
}

/// @nodoc
class _$ClientPlanCopyWithImpl<$Res> implements $ClientPlanCopyWith<$Res> {
  _$ClientPlanCopyWithImpl(this._value, this._then);

  final ClientPlan _value;
  // ignore: unused_field
  final $Res Function(ClientPlan) _then;

  @override
  $Res call({
    Object? contract_id = freezed,
    Object? serv_id = freezed,
    Object? planned = freezed,
    Object? filled = freezed,
  }) {
    return _then(_value.copyWith(
      contract_id: contract_id == freezed
          ? _value.contract_id
          : contract_id // ignore: cast_nullable_to_non_nullable
              as int,
      serv_id: serv_id == freezed
          ? _value.serv_id
          : serv_id // ignore: cast_nullable_to_non_nullable
              as int,
      planned: planned == freezed
          ? _value.planned
          : planned // ignore: cast_nullable_to_non_nullable
              as int,
      filled: filled == freezed
          ? _value.filled
          : filled // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$$_ClientPlanCopyWith<$Res>
    implements $ClientPlanCopyWith<$Res> {
  factory _$$_ClientPlanCopyWith(
          _$_ClientPlan value, $Res Function(_$_ClientPlan) then) =
      __$$_ClientPlanCopyWithImpl<$Res>;
  @override
  $Res call({int contract_id, int serv_id, int planned, int filled});
}

/// @nodoc
class __$$_ClientPlanCopyWithImpl<$Res> extends _$ClientPlanCopyWithImpl<$Res>
    implements _$$_ClientPlanCopyWith<$Res> {
  __$$_ClientPlanCopyWithImpl(
      _$_ClientPlan _value, $Res Function(_$_ClientPlan) _then)
      : super(_value, (v) => _then(v as _$_ClientPlan));

  @override
  _$_ClientPlan get _value => super._value as _$_ClientPlan;

  @override
  $Res call({
    Object? contract_id = freezed,
    Object? serv_id = freezed,
    Object? planned = freezed,
    Object? filled = freezed,
  }) {
    return _then(_$_ClientPlan(
      contract_id: contract_id == freezed
          ? _value.contract_id
          : contract_id // ignore: cast_nullable_to_non_nullable
              as int,
      serv_id: serv_id == freezed
          ? _value.serv_id
          : serv_id // ignore: cast_nullable_to_non_nullable
              as int,
      planned: planned == freezed
          ? _value.planned
          : planned // ignore: cast_nullable_to_non_nullable
              as int,
      filled: filled == freezed
          ? _value.filled
          : filled // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ClientPlan extends _ClientPlan with DiagnosticableTreeMixin {
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
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ClientPlan(contract_id: $contract_id, serv_id: $serv_id, planned: $planned, filled: $filled)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ClientPlan'))
      ..add(DiagnosticsProperty('contract_id', contract_id))
      ..add(DiagnosticsProperty('serv_id', serv_id))
      ..add(DiagnosticsProperty('planned', planned))
      ..add(DiagnosticsProperty('filled', filled));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ClientPlan &&
            const DeepCollectionEquality()
                .equals(other.contract_id, contract_id) &&
            const DeepCollectionEquality().equals(other.serv_id, serv_id) &&
            const DeepCollectionEquality().equals(other.planned, planned) &&
            const DeepCollectionEquality().equals(other.filled, filled));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(contract_id),
      const DeepCollectionEquality().hash(serv_id),
      const DeepCollectionEquality().hash(planned),
      const DeepCollectionEquality().hash(filled));

  @JsonKey(ignore: true)
  @override
  _$$_ClientPlanCopyWith<_$_ClientPlan> get copyWith =>
      __$$_ClientPlanCopyWithImpl<_$_ClientPlan>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ClientPlanToJson(this);
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
  int get contract_id => throw _privateConstructorUsedError;
  @override
  int get serv_id => throw _privateConstructorUsedError;
  @override
  int get planned => throw _privateConstructorUsedError;
  @override
  int get filled => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_ClientPlanCopyWith<_$_ClientPlan> get copyWith =>
      throw _privateConstructorUsedError;
}

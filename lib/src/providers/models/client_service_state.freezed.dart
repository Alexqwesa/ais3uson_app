// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'client_service_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ClientServiceState {
  int get rejected => throw _privateConstructorUsedError;
  int get added => throw _privateConstructorUsedError;

  /// plan - filled - added - done
  int get left => throw _privateConstructorUsedError;

  /// finished + outDated
  int get done => throw _privateConstructorUsedError;
  ClientService get client => throw _privateConstructorUsedError;
  Ref<Object?> get ref => throw _privateConstructorUsedError;

  /// Only true for Archive app state
  bool get isReadOnly => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ClientServiceStateCopyWith<ClientServiceState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClientServiceStateCopyWith<$Res> {
  factory $ClientServiceStateCopyWith(
          ClientServiceState value, $Res Function(ClientServiceState) then) =
      _$ClientServiceStateCopyWithImpl<$Res, ClientServiceState>;
  @useResult
  $Res call(
      {int rejected,
      int added,
      int left,
      int done,
      ClientService client,
      Ref<Object?> ref,
      bool isReadOnly});

  $ClientServiceCopyWith<$Res> get client;
}

/// @nodoc
class _$ClientServiceStateCopyWithImpl<$Res, $Val extends ClientServiceState>
    implements $ClientServiceStateCopyWith<$Res> {
  _$ClientServiceStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rejected = null,
    Object? added = null,
    Object? left = null,
    Object? done = null,
    Object? client = null,
    Object? ref = null,
    Object? isReadOnly = null,
  }) {
    return _then(_value.copyWith(
      rejected: null == rejected
          ? _value.rejected
          : rejected // ignore: cast_nullable_to_non_nullable
              as int,
      added: null == added
          ? _value.added
          : added // ignore: cast_nullable_to_non_nullable
              as int,
      left: null == left
          ? _value.left
          : left // ignore: cast_nullable_to_non_nullable
              as int,
      done: null == done
          ? _value.done
          : done // ignore: cast_nullable_to_non_nullable
              as int,
      client: null == client
          ? _value.client
          : client // ignore: cast_nullable_to_non_nullable
              as ClientService,
      ref: null == ref
          ? _value.ref
          : ref // ignore: cast_nullable_to_non_nullable
              as Ref<Object?>,
      isReadOnly: null == isReadOnly
          ? _value.isReadOnly
          : isReadOnly // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ClientServiceCopyWith<$Res> get client {
    return $ClientServiceCopyWith<$Res>(_value.client, (value) {
      return _then(_value.copyWith(client: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_ClientServiceStateCopyWith<$Res>
    implements $ClientServiceStateCopyWith<$Res> {
  factory _$$_ClientServiceStateCopyWith(_$_ClientServiceState value,
          $Res Function(_$_ClientServiceState) then) =
      __$$_ClientServiceStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int rejected,
      int added,
      int left,
      int done,
      ClientService client,
      Ref<Object?> ref,
      bool isReadOnly});

  @override
  $ClientServiceCopyWith<$Res> get client;
}

/// @nodoc
class __$$_ClientServiceStateCopyWithImpl<$Res>
    extends _$ClientServiceStateCopyWithImpl<$Res, _$_ClientServiceState>
    implements _$$_ClientServiceStateCopyWith<$Res> {
  __$$_ClientServiceStateCopyWithImpl(
      _$_ClientServiceState _value, $Res Function(_$_ClientServiceState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rejected = null,
    Object? added = null,
    Object? left = null,
    Object? done = null,
    Object? client = null,
    Object? ref = null,
    Object? isReadOnly = null,
  }) {
    return _then(_$_ClientServiceState(
      rejected: null == rejected
          ? _value.rejected
          : rejected // ignore: cast_nullable_to_non_nullable
              as int,
      added: null == added
          ? _value.added
          : added // ignore: cast_nullable_to_non_nullable
              as int,
      left: null == left
          ? _value.left
          : left // ignore: cast_nullable_to_non_nullable
              as int,
      done: null == done
          ? _value.done
          : done // ignore: cast_nullable_to_non_nullable
              as int,
      client: null == client
          ? _value.client
          : client // ignore: cast_nullable_to_non_nullable
              as ClientService,
      ref: null == ref
          ? _value.ref
          : ref // ignore: cast_nullable_to_non_nullable
              as Ref<Object?>,
      isReadOnly: null == isReadOnly
          ? _value.isReadOnly
          : isReadOnly // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_ClientServiceState extends _ClientServiceState {
  const _$_ClientServiceState(
      {required this.rejected,
      required this.added,
      required this.left,
      required this.done,
      required this.client,
      required this.ref,
      this.isReadOnly = false})
      : super._();

  @override
  final int rejected;
  @override
  final int added;

  /// plan - filled - added - done
  @override
  final int left;

  /// finished + outDated
  @override
  final int done;
  @override
  final ClientService client;
  @override
  final Ref<Object?> ref;

  /// Only true for Archive app state
  @override
  @JsonKey()
  final bool isReadOnly;

  @override
  String toString() {
    return 'ClientServiceState(rejected: $rejected, added: $added, left: $left, done: $done, client: $client, ref: $ref, isReadOnly: $isReadOnly)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ClientServiceState &&
            (identical(other.rejected, rejected) ||
                other.rejected == rejected) &&
            (identical(other.added, added) || other.added == added) &&
            (identical(other.left, left) || other.left == left) &&
            (identical(other.done, done) || other.done == done) &&
            (identical(other.client, client) || other.client == client) &&
            (identical(other.ref, ref) || other.ref == ref) &&
            (identical(other.isReadOnly, isReadOnly) ||
                other.isReadOnly == isReadOnly));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, rejected, added, left, done, client, ref, isReadOnly);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ClientServiceStateCopyWith<_$_ClientServiceState> get copyWith =>
      __$$_ClientServiceStateCopyWithImpl<_$_ClientServiceState>(
          this, _$identity);
}

abstract class _ClientServiceState extends ClientServiceState {
  const factory _ClientServiceState(
      {required final int rejected,
      required final int added,
      required final int left,
      required final int done,
      required final ClientService client,
      required final Ref<Object?> ref,
      final bool isReadOnly}) = _$_ClientServiceState;
  const _ClientServiceState._() : super._();

  @override
  int get rejected;
  @override
  int get added;
  @override

  /// plan - filled - added - done
  int get left;
  @override

  /// finished + outDated
  int get done;
  @override
  ClientService get client;
  @override
  Ref<Object?> get ref;
  @override

  /// Only true for Archive app state
  bool get isReadOnly;
  @override
  @JsonKey(ignore: true)
  _$$_ClientServiceStateCopyWith<_$_ClientServiceState> get copyWith =>
      throw _privateConstructorUsedError;
}

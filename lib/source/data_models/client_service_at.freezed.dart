// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'client_service_at.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ClientServiceAt {
  /// Reference to existing [WorkerProfile].
  @override
  ClientService get clientService => throw _privateConstructorUsedError;

  /// Null - for dynamic date (from provider [archiveDate])
  @override
  DateTime? get date => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ClientServiceAtCopyWith<ClientServiceAt> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClientServiceAtCopyWith<$Res> {
  factory $ClientServiceAtCopyWith(
          ClientServiceAt value, $Res Function(ClientServiceAt) then) =
      _$ClientServiceAtCopyWithImpl<$Res>;
  $Res call({@override ClientService clientService, @override DateTime? date});

  $ClientServiceCopyWith<$Res> get clientService;
}

/// @nodoc
class _$ClientServiceAtCopyWithImpl<$Res>
    implements $ClientServiceAtCopyWith<$Res> {
  _$ClientServiceAtCopyWithImpl(this._value, this._then);

  final ClientServiceAt _value;
  // ignore: unused_field
  final $Res Function(ClientServiceAt) _then;

  @override
  $Res call({
    Object? clientService = freezed,
    Object? date = freezed,
  }) {
    return _then(_value.copyWith(
      clientService: clientService == freezed
          ? _value.clientService
          : clientService // ignore: cast_nullable_to_non_nullable
              as ClientService,
      date: date == freezed
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }

  @override
  $ClientServiceCopyWith<$Res> get clientService {
    return $ClientServiceCopyWith<$Res>(_value.clientService, (value) {
      return _then(_value.copyWith(clientService: value));
    });
  }
}

/// @nodoc
abstract class _$$_ClientServiceAtCopyWith<$Res>
    implements $ClientServiceAtCopyWith<$Res> {
  factory _$$_ClientServiceAtCopyWith(
          _$_ClientServiceAt value, $Res Function(_$_ClientServiceAt) then) =
      __$$_ClientServiceAtCopyWithImpl<$Res>;
  @override
  $Res call({@override ClientService clientService, @override DateTime? date});

  @override
  $ClientServiceCopyWith<$Res> get clientService;
}

/// @nodoc
class __$$_ClientServiceAtCopyWithImpl<$Res>
    extends _$ClientServiceAtCopyWithImpl<$Res>
    implements _$$_ClientServiceAtCopyWith<$Res> {
  __$$_ClientServiceAtCopyWithImpl(
      _$_ClientServiceAt _value, $Res Function(_$_ClientServiceAt) _then)
      : super(_value, (v) => _then(v as _$_ClientServiceAt));

  @override
  _$_ClientServiceAt get _value => super._value as _$_ClientServiceAt;

  @override
  $Res call({
    Object? clientService = freezed,
    Object? date = freezed,
  }) {
    return _then(_$_ClientServiceAt(
      clientService: clientService == freezed
          ? _value.clientService
          : clientService // ignore: cast_nullable_to_non_nullable
              as ClientService,
      date: date == freezed
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$_ClientServiceAt extends _ClientServiceAt {
  const _$_ClientServiceAt(
      {@override required this.clientService, @override this.date})
      : super._();

  /// Reference to existing [WorkerProfile].
  @override
  @override
  final ClientService clientService;

  /// Null - for dynamic date (from provider [archiveDate])
  @override
  @override
  final DateTime? date;

  @override
  String toString() {
    return 'ClientServiceAt(clientService: $clientService, date: $date)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ClientServiceAt &&
            const DeepCollectionEquality()
                .equals(other.clientService, clientService) &&
            const DeepCollectionEquality().equals(other.date, date));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(clientService),
      const DeepCollectionEquality().hash(date));

  @JsonKey(ignore: true)
  @override
  _$$_ClientServiceAtCopyWith<_$_ClientServiceAt> get copyWith =>
      __$$_ClientServiceAtCopyWithImpl<_$_ClientServiceAt>(this, _$identity);
}

abstract class _ClientServiceAt extends ClientServiceAt {
  const factory _ClientServiceAt(
      {@override required final ClientService clientService,
      @override final DateTime? date}) = _$_ClientServiceAt;
  const _ClientServiceAt._() : super._();

  @override

  /// Reference to existing [WorkerProfile].
  @override
  ClientService get clientService => throw _privateConstructorUsedError;
  @override

  /// Null - for dynamic date (from provider [archiveDate])
  @override
  DateTime? get date => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_ClientServiceAtCopyWith<_$_ClientServiceAt> get copyWith =>
      throw _privateConstructorUsedError;
}

import 'package:ais3uson_app/api_classes.dart';
import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/ui_service_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'client_service.freezed.dart';

/// Model for [ServiceCard] and other widget.
///
/// This is mostly a view model for data from:
/// - [Journal],
/// - [ServiceEntry],
/// - [ClientPlan]...
///
/// {@category Data Models}
@freezed
class ClientService with _$ClientService {
  const factory ClientService({
    required Ref ref,

    /// Reference to existing [ServiceEntry].
    required ServiceEntry service,

    /// Reference to existing [ClientPlan].
    required ClientPlan planned,
    required String apiKey,

    /// Should be Null to depend on global variable, !null break dependency.
    @Default(null) DateTime? date,
  }) = _ClientService;

  const ClientService._();

  //
  // > shortcuts for underline classes
  //

  int get contractId => planned.contractId;

  int get servId => planned.servId;

  int get plan => planned.planned;

  int get filled => planned.filled;

  int get subServ => service.subServ;

  String get servText => service.servText;

  String get servTextAdd => service.servTextAdd;

  String get shortText => service.shortText;

  String get image => service.imagePath;
}

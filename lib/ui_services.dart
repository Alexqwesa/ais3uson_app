/// # Classes to display services and related data
///
/// There are two screens to display services:
///
/// - [ListOfClientServicesScreen] to display **list** of services,
/// - [ClientServiceScreen] to display **one** service.
///
/// Both of them use [ServiceCard] to display [ClientService].
///
/// The [ServiceCard] is display widget for [ClientService].
/// Based on [tileTypeProvider] it select one of views:
/// - [ServiceCardView],
/// - [ServiceCardSquareView],
/// - [ServiceCardTileView],
/// each of them get it size from provider [tileSize] (which depend on [tileMagnificationProvider]).
///
/// Each [ServiceCard] view use [ServiceCardState] to display data from [Journal]
/// (how many services is added, etc...).
///
/// [ClientServiceScreen] is also displayed service's [Proofs].
library ui_services;

import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/settings.dart';
import 'package:ais3uson_app/ui_service_card.dart';
import 'package:ais3uson_app/ui_services.dart';

export 'package:ais3uson_app/src/ui/ui_services/archive_services_of_client_screen.dart';
export 'package:ais3uson_app/src/ui/ui_services/client_service_screen.dart';
export 'package:ais3uson_app/src/ui/ui_services/list_of_client_services_screen.dart';
export 'package:ais3uson_app/src/ui/ui_services/list_of_services_screen_helper.dart';

/// # Classes to display and manage [WorkerProfile]s.
///
/// These classes provide gui for actions:
///
/// - Add worker profile from QR-code [QRScanScreen],
/// - Add worker profile from text string [AddDepartmentScreen],
/// - Delete worker profile [DeleteDepartmentScreen],
/// - Open worker profile [ListOfDepartments],
/// - Show list of clients of worker profile [ListOfClientsScreen].
///
/// There is also [HomeScreen] screen for displaying main menu and [ListOfDepartments]. It is initial route
/// of app.
library ui_departments;

import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/ui_departments.dart';
import 'package:ais3uson_app/ui_root.dart';

export 'package:ais3uson_app/src/ui/ui_departments/add_department_screen.dart';
export 'package:ais3uson_app/src/ui/ui_departments/delete_department_screen.dart';
export 'package:ais3uson_app/src/ui/ui_departments/list_of_clients_screen.dart';
export 'package:ais3uson_app/src/ui/ui_departments/list_of_departments.dart';
export 'package:ais3uson_app/src/ui/ui_departments/qr_scan_screen.dart';

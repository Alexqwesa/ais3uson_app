import 'dart:developer' as dev;

import 'package:ais3uson_app/source/app_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:uuid/uuid.dart';

//
// > global constants
//
const uuid = Uuid();
const formatSQL = 'yyyy-MM-dd';
const formatStandard = 'dd.MM.yyyy';
final sqlFormat = DateFormat(formatSQL);
final standardFormat = DateFormat(formatStandard);
final startDate = DateTime(1900);

/// qrData
///
/// test worker key in json format
String qrDataShortKey =
    '''{"app": "AIS3USON web", "name": "Работник Тест Тестович", '''
    '''"worker_dep_id": 1, "api_key": "3.015679841875732e17ef73dc17-7af8-11ec-b7f8-04d9f5c97b0c", "dep": "https://alexqwesa.fvds.ru:48081 отделение", '''
    '''"db": "kcson", "host": "alexqwesa.fvds.ru", "port": "48081"}''';
String qrData2WithAutossl =
    '''{"app": "AIS3USON web", "name": "Работник Тестового Отделения №2", '''
    '''"worker_dep_id": 1, "api_key": "3.015679841875732e17ef73dc17-7af8-11ec-b7f8-04d9f5c97b0c", "dep": "Тестовое отделение https://alexqwesa.fvds.ru:48082", '''
    '''"db": "kcson", "host": "alexqwesa.fvds.ru", "port": "48082", "comment": "защищенный SSL", "ssl": "auto"}''';
String qrDataWithSSL =
    '''{"app": "AIS3USON web", "name": "Работник Тестового Отделения ", '''
    '''"worker_dep_id": 1, "api_key": "3.015679841875732e17ef73dc17-7af8-11ec-b7f8-04d9f5c97b0c",  "dep": "Тестовое отделение 48082", '''
    '''"db": "kcson", "host": "alexqwesa.fvds.ru", "port": "48082", "comment": "self-signed SSL, didn't work with WEB platform", "certBase64": "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUZNRENDQXhpZ0F3SUJBZ0lVRUVVdE1wa2ZNUURRNEF3NVdVNUh1b3pWRkl3d0RRWUpLb1pJaHZjTkFRRUwKQlFBd0ZqRVVNQklHQTFVRUF3d0xaWGhoYlhCc1pTNWpiMjB3SGhjTk1qSXdNakUwTVRZd05EUTBXaGNOTXpJdwpNakV5TVRZd05EUTBXakFXTVJRd0VnWURWUVFEREF0bGVHRnRjR3hsTG1OdmJUQ0NBaUl3RFFZSktvWklodmNOCkFRRUJCUUFEZ2dJUEFEQ0NBZ29DZ2dJQkFLOVA1TlhoNC9EdlV0WHgyMEdjNmNwRWtFMGJkNzArRjIvMi9iY0EKUzRLaWhPNzdlTG9PeU5nclRnczRSVFkwbXowdi94R0Fhc3QyaWNNbG9mWnBKTWpKeCtCNnVvWWdxQjJ6THIvYQpaODNQRnF0T0tDeXNjNWFadVRKUDNtT0RUVitRSDFvSytTSmZ1bWY1WHhJeGRib1Y5OENaUmhGV2sreGlZN25xCkdpRC9qTUkyU2lxcmtrdkNLTDdqc3VOZEJFV3I2b2xyN1o2UkJzTUZrbUFBUWV2eHY2TVZHZm1TcExkU0w1bVQKMEVrWkpNRXV5WnFuZlFMeVp1MkFGbCs2N3MvVUhic29aamM1R0tvR09rMXF6N05tYk1JL0lGY25BU05UNXlmWApFTXlqQStrUkcweEdiVkFyVVhYTjFaR2RJUlRHUmVsUVIvZEVDb0VEZWVEWngwb2hWc0x2STVlbk9ydzBTMlFoCm05MnpLUmpkUkRBWEk0Zk5MZXpRZ0RPdXE4RXBaQlVwYUl4NEhEZU1EMnE5QjV4M2VtbzN1bERDTk1zTzdLNzkKOGlaUENuUE9uZUs3d1dXeDdaSzliOCs3OTQ1dFJjREg4V2RLRWFNT0g5cWx5dHdib3A5RldqbkFiZzdkQUNnQgpFRnN4N1NVaWdLUTFrMWZYWnVOLzZNOGtBb0M1UXBuNnNRV0U3Rm5hemF2OTlMN2g5ZE10andQUVpHbkhlOUkyClhIcUR5ZS9MeUhZQ2JRQXBpVWhaWkdJZTM4QzZ5cmVtVTlBOXpST1lJQ1JIN0w1eS94Wm1SOFpaTm5va1BaNnUKaUs0SGJUYUxadzJXMUVIZERsQmFBUStWN3BNalpuYXg2d0QxbVNoVUJycFZ2TkpRcFY2eG5US2lTTUZEOUVPSQpzZ2loQWdNQkFBR2pkakIwTUIwR0ExVWREZ1FXQkJSTENPeWNTZnZNMlBMSXdsd01CZHNPRHVsSVR6QWZCZ05WCkhTTUVHREFXZ0JSTENPeWNTZnZNMlBMSXdsd01CZHNPRHVsSVR6QVBCZ05WSFJNQkFmOEVCVEFEQVFIL01DRUcKQTFVZEVRUWFNQmlIQkZCWHhBdUhCSDhBQUFHSEJNQ29BR2FIQk1Db0ZBSXdEUVlKS29aSWh2Y05BUUVMQlFBRApnZ0lCQUdkckQ1V3F0N1pnU0x4MEFrd1lSaEFJcDJ0c29RNmF2NXJhd05WWGplQ1Yzb3RnMnBqNEwwQ283clNyClhpWklma1ZrM3pIZGIyVmlSZSs4OThPRlc5L1g5WDE5bHZ6ZDZpWjBmOUhTMkhUblRYc1VtOFdkTzFZbHBZdnMKNDFFSVdnVnF1T1RkOXNzQ3ptOGlZLzNha1hRTzhMTWJnM2JYMkdNUVJUUmg5VG9JQnh1dWJVdUQ1ZFV1NUx2cgpwcGJIVXR3NnRucCtGU3ROSmFHbm03TjdRWk9Ia3c1YmFHM2VCQ3RNbGNaazFnck1HOWhRT3R6bTMzL3pTMjFYCklLbmRXc3pIOW9CaVJmYTJTZFFKZzMvWExwelE0N25rdDA4Q3VaMWNrTE9KVkVVWmxWR2VxaHZUYkxwaFZMaUsKeUYwOUd6YmZNWk81bHBjZlBscnc2Q3pxVyttMlNyMXpxV1RYcnBWWE05eGJSSkFoL29tUy9vMEtlOVB1WW5pOAovMmYzMHdNeE5HbDRmWU5lVUkxNVVSejJkK2FNZW14MXhLVWQ5V0FHVjBSdkZ5azVLd1dTYnYxSFd6eFVORkhDCkdJTW5VNTBUY0ZqRGc0SDFvdStaTXc2R3JLOHQ1MWQ3MnNOS0xWL0RkUnIrRThTWi9uU2dsdEszUmhuRjBFMzgKWW5EcHRCa2E4eXMyY21ZWDloa0J1bDc5VmRrTS8yclJUVlkzWDF4WFhGTkpYMTM4NGpQZlRYeCs0QXA5OFY3MwpUS2NOd2xjdVQwR1NLZVMxamo4VTFyb1U2dm0vZ2ZITldLUEVncFFBNlkram5uVi80YVRUc1c0b1d5YjR1TUVMCm5jNlc4Q0ZneWI4ZngzTW0xUklwNWdFN1lkMHJpb2lhMXhZVnVRazdxZG1YZVcxTwotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg=="}''';
final qrCodes = [qrData2WithAutossl];

class ScreenArguments {
  int profileNum = -1;
  int contractId = 0;
  int servId = 0;

  ScreenArguments({required int profile, int? contract, int? service}) {
    profileNum = profile;
    contractId = contract ?? 0;
    servId = service ?? 0;
    AppData().lastScreen = this;
  }
}

/// This is default headers for http request.
///
/// Just work with json, and before send, it should be concatenated with 'api_key'.
final Map<String, String> httpHeaders = {
  'Content-type': 'application/json',
  'Accept': 'application/json',
};

/// showErrorNotification
///
/// just display error to user
void showErrorNotification(String text) {
  try {
    showSimpleNotification(
      Text(text),
      background: Colors.red[300],
      position: NotificationPosition.bottom,
    );
    // ignore: avoid_catches_without_on_clauses
  } catch (e) {
    dev.log(e.toString());
  }
}

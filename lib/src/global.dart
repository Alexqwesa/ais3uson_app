String qrData =
    '''{"app": "AIS3USON web", "name": "test", "api_key": "123", "otd_id": 1, "otd": "Тестовое отделение", "db": "kcson", "host": "80.87.196.11", "port": "48080"}''';
String qrData2 =
    '''{"app": "AIS3USON web", "name": "test", "api_key": "123", "otd_id": 2, "otd": "Тестовое отделение 2", "db": "kcson", "host": "80.87.196.11", "port": "48080"}''';

class ScreenArguments {
  int profileNum = -1;
  int contractId = 0;
  int servId = 0;

  ScreenArguments({required profile, contract, service}) {
    profileNum = profile;
    contractId = contract ??  0;
    servId = service ?? 0;
  }
}

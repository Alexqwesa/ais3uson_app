// ignore_for_file: missing_whitespace_between_adjacent_strings

import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'default_data.dart';
import 'mock_server.mocks.dart';

final httpTestHeader = {
  'Content-type': 'application/json',
  'Accept': 'application/json',
  'api_key': '3.015679841875732e17ef73dc17-7af8-11ec-b7f8-04d9f5c97b0c',
};

/// Generate a MockClient using the Mockito package.
@GenerateMocks([http.Client])
http.Client getMockHttpClient() {
  final client = MockClient();

  when(client.testReqGetAny)
      .thenAnswer((_) async => http.Response('{"title": "Test"}', 200));
  when(client.testReqGetClients)
      .thenAnswer((_) async => http.Response(SERVER_DATA_CLIENTS, 200));
  when(client.testReqGetServices)
      .thenAnswer((_) async => http.Response(SERVER_DATA_SERVICES, 200));
  when(client.testReqGetPlanned)
      .thenAnswer((_) async => http.Response(SERVER_DATA_PLANNED, 200));
  when(client.testReqGetStat).thenAnswer((_) async => http.Response(
        '<html><head><title>Статистика WEB-сервера АИС ТриУСОН</title>'
        '</head><body><p>Статистика WEB-сервера АИС ТриУСОН</p>'
        '<p>Request: /stat</p>'
        '<p>Thread: Thread-542</p>'
        '<p>Thread Count: 5</p></body></html>',
        200,
      ));

  return client;
}

extension ExtMock on MockClient {
  Map<String, String> get h => httpTestHeader;

  String get httpTcpIpPort =>
      'http://alexqwesa.fvds.ru:48082'; // use the same address as in global_helpers.dart

  Future<http.Response> get testReqGetAny =>
      get(any); //, headers: anyNamed('header'));

  Future<http.Response> get testReqGetClients =>
      get(Uri.parse('$httpTcpIpPort/clients'), headers: h);

  Future<http.Response> get testReqGetServices =>
      get(Uri.parse('$httpTcpIpPort/services'), headers: h);

  Future<http.Response> get testReqGetPlanned =>
      get(Uri.parse('$httpTcpIpPort/planned'), headers: h);

  Future<http.Response> get testReqGetStat =>
      get(Uri.parse('$httpTcpIpPort/stat'), headers: h);

  Future<http.Response> get testReqPostAdd => post(
        Uri.parse('$httpTcpIpPort/add'),
        headers: h,
        body: anyNamed('body'),
      );

  Future<http.Response> get testReqDelete => delete(
        Uri.parse('$httpTcpIpPort/delete'),
        headers: h,
        body: anyNamed('body'),
      );
}

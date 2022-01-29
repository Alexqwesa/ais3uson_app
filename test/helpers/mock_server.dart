import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'default_data.dart';
import 'mock_server.mocks.dart';

/// Generate a MockClient using the Mockito package.
@GenerateMocks([http.Client])
http.Client getMockHttpClient() {
  final client = MockClient();
  final h = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'api_key': '3.015679841875732e17ef73dc17-7af8-11ec-b7f8-04d9f5c97b0c',
  };

  when(client.get(any, headers: h))
      .thenAnswer((_) async => http.Response('{"title": "Test"}', 200));
  when(client.get(Uri.parse('http://80.87.196.11:48080/clients'), headers: h))
      .thenAnswer((_) async => http.Response(SERVER_DATA_CLIENTS, 200));
  when(client.get(Uri.parse('http://80.87.196.11:48080/services'), headers: h))
      .thenAnswer((_) async => http.Response(SERVER_DATA_SERVICES, 200));
  when(client.get(Uri.parse('http://80.87.196.11:48080/planned'), headers: h))
      .thenAnswer((_) async => http.Response(SERVER_DATA_PLANNED, 200));
  when(client.get(Uri.parse('http://80.87.196.11:48080/stat'), headers: h))
      .thenAnswer((_) async => http.Response(SERVER_DATA_CLIENTS, 200));

  return client;
}

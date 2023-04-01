import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:http_certificate_pinning/secure_http_client.dart';

import 'package:http/http.dart' as http;

const apiKey = '3.015679841875732e17ef73dc17-7af8-11ec-b7f8-04d9f5c97b0c';

// final certificateSHA256Fingerprints = '0F:63:53:E8:F5:75:90:05:BB:ED:73:99:EA:4C:44:EA:F6:FD:0F:72:01:B3:00:4E:DE:21:DE:73:75:46:C1:13';
// // Uses SecureHttpClient to make requests
// SecureHttpClient getClient(List<String> allowedSHAFingerprints) {
//   final secureClient = SecureHttpClient.build(certificateSHA256Fingerprints);
//   return secureClient;
// }
// const server = 'https://alexqwesa.fvds.ru:48080'
// const server = 'https://127.0.0.1:4444';
const server = 'http://127.0.0.1:4445';
final jsonResponse =
    startsWith('{"Web worker version":'); //stringContainsInOrder
// '{"Web worker version":7,"DB version":[["version"],[[91]]],"MySQL ping status":"ok","MySQL api_key correct":false}';

void main() {
  setUpAll(WidgetsFlutterBinding.ensureInitialized);
  //
  // > Tests start
  //
  group('Tests for Server', () {
    test('it fail to call server without context', () async {
      try {
        await http.Client().get(
          Uri.parse('$server/stat_json'),
        );

        expect(true, false); // it should already fail
      } on HandshakeException {
        final data =
            await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
        SecurityContext.defaultContext
            .setTrustedCertificatesBytes(data.buffer.asUint8List());

        final response = await http.Client().get(
          Uri.parse('$server/stat_json'),
        );

        expect(response.body, jsonResponse);
      }
    });
    test('it call server with previous context', () async {
      final response = await http.Client().get(
        Uri.parse('$server/stat_json'),
      );

      expect(response.body, jsonResponse);
    });

    test('it call server', () async {
      final response = await http.Client().get(
        Uri.parse('$server/stat_json'),
      );

      expect(response.body, jsonResponse);
    });

    test('it call server/clients ', () async {
      final response = await http.Client().get(
        Uri.parse('$server/clients'),
      );

      expect(response.contentLength, 2);
    });

    test('it call server/clients with key', () async {
      final response = await http.Client()
          .get(Uri.parse('$server/clients'), headers: <String, String>{
        'accept': 'application/json',
        'api-key': apiKey,
      });

      expect(response.statusCode, 200);
      expect(response.contentLength, greaterThanOrEqualTo(500));
    });
  });
}

//
// test('it call server and accept all SSL', () async {
//   final client = (HttpClient(context: SecurityContext())
//     ..badCertificateCallback = (cert, host, port) {
//       return true;
//     });
//
//   final response = await client.get(
//       host = alexqwesa.fvds.ru, port = 48080, path = stat_json
//   );
//
//   expect(response.connectionInfo. statusCode, 200);
//   expect(response.body,
//       '{"Web worker version":7,"DB version":[["version"],[[91]]],"MySQL ping status":"ok","MySQL api_key correct":false}');
// });
//
// test('it call server with lets-encrypt-r3.pem', () async {
//   final sccontext = SecurityContext.defaultContext;
//   String data =
//       await rootBundle.loadString("assets/ca/lets-encrypt-r3.pem");
//   sccontext.setTrustedCertificatesBytes(utf8.encode(data));
//   HttpClient client = new HttpClient(context: sccontext);
//
//   final request = await client
//       .getUrl(Uri.parse('$server/stat_json'));
//   expect(request.contentLength, 200);
//   final response = await request.close();
//   expect(
//     response.transform(utf8.decoder).join(),
//     '{"Web worker version":7,"DB version":[["version"],[[91]]],"MySQL ping status":"ok","MySQL api_key correct":false}',
//   );
//   final dynamic stringData = await response.transform(utf8.decoder).join();
// });

import 'dart:convert';
import 'dart:io';

import 'package:ais3uson_app/access_to_io.dart';
import 'package:ais3uson_app/api_classes.dart';
import 'package:ais3uson_app/dynamic_data_models.dart';
import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/main.dart';
import 'package:http/http.dart';

/// This class send add/delete request of [ServiceOfJournal] to server.
///
/// It used: [DeleteClientServiceRequest], [AddClientServiceRequest] and [httpClientProvider].
///
/// Getting services from server is not yet supported, and probably will not.
/// Maybe only allow to get today services? (not really useful and add security risks...)
interface class JournalHttpInterface {
  const JournalHttpInterface(this.workerProfile);

  final Worker workerProfile;

  /// Delete service from remote DB.
  ///
  /// Create request body and call [_commitUrl].
  Future<(ServiceState?, String)> sendDelete(ServiceOfJournal serv) async {
    //
    // > create body of post request
    //
    final body = DeleteClientServiceRequest(
      uuid: serv.uid,
      serv_id: serv.servId,
      contracts_id: serv.contractId,
      dep_has_worker_id: serv.workerId,
    ).toJson();
    //
    // > send Post
    //
    final k = workerProfile.key;
    final urlAddress = '${k.activeServer}/delete';

    return _commitUrl(urlAddress, body: body);
  }

  /// Add service to remote DB.
  ///
  /// Create request body and call [_commitUrl].
  Future<(ServiceState?, String)> sendAdd(
    ServiceOfJournal serv, {
    String? body,
  }) async {
    //
    // > create body of post request
    //
    // ignore: parameter_assignments
    body ??= AddClientServiceRequest(
      vdate: sqlFormat.format(serv.provDate),
      uuid: serv.uid,
      contracts_id: serv.contractId,
      dep_has_worker_id: serv.workerId,
      serv_id: serv.servId,
    ).toJson();

    //
    // > check: is it in right state (not finished etc...)
    //
    if (ServiceState.added != serv.state) {
      return (serv.state, '');
    }
    //
    // > send Post
    //
    final k = workerProfile.key;
    final urlAddress = '${k.activeServer}/add';

    return _commitUrl(urlAddress, body: body);
  }

  /// Try to commit service(send http post/delete request).
  ///
  /// Return error text and new state, didn't change service state itself.
  ///
  /// {@category Client-Server API}
  Future<(ServiceState?, String)> _commitUrl(
    String urlAddress, {
    String? body,
  }) async {
    final url = Uri.parse(urlAddress);
    final http = workerProfile.ref
        .read(httpClientProvider(workerProfile.key.certBase64));
    var ret = ServiceState.added;
    var error = '';
    final fullHeaders = {'api-key': workerProfile.apiKey}..addAll(httpHeaders);
    try {
      Response response;

      if (urlAddress.endsWith('/add')) {
        response = await http.post(url, headers: fullHeaders, body: body);
        //
        // > check response
        //
        if (response.statusCode == 200) {
          if (response.body.isNotEmpty &&
              response.body != 'Wrong authorization key') {
            final res = jsonDecode(response.body) as Map<String, dynamic>;

            ret = (res['id'] as int) > 0
                ? ServiceState.finished
                : ServiceState.rejected;
          } else {
            ret = ServiceState.added;
          }
        }
      } else if (urlAddress.endsWith('/delete')) {
        response = await http.delete(url, headers: fullHeaders, body: body);
        if (response.statusCode == 200) ret = ServiceState.removed;
      } else {
        response = await http.get(url, headers: fullHeaders);
      }
      log.info(
        '$url response.statusCode = ${response.statusCode}\n\n '
        '${response.body}',
      );
      //
      // > just error handling
      //
    } on HandshakeException {
      error = tr().sslError;
    } on ClientException {
      error = tr().serverError;
      log.severe('Server error  $url  ');
    } on SocketException {
      error = tr().internetError;
      log.warning('No internet connection $url ');
    } on HttpException {
      error = tr().httpAccessError;
      log.severe('Server access error $url ');
    } finally {
      log.fine('sync ended $url ');
    }

    return (ret, error);
  }
}

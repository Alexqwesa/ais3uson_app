# Client-Server API

## Input API

Classes like: [ClientEntry](../source_client_server_api_client_entry/ClientEntry-class.html),
[ClientPlan](../source_client_server_api_client_plan/ClientPlan-class.html)
and [ServerEntry](../source_client_server_api_service_entry/ServiceEntry-class.html) are used to
convert server responses from Json strings to dart classes. Mostly [freezed].

First [httpDataProvider](../source_providers_providers_of_http_data/httpDataProvider.html) get data
from server and convert to Json. Then it is converted to classes and assigned to providers of
family [WorkerProfile].

## Output API

The methods for output are:

- [Journal.commitUrl] is used to send **/add** and **/delete** requests to server,
- [Journal.exportToFile] is used to save list of [ServiceOfJournal] to a file **.ais_json** .

These methods use json format.

## Storage API

Most data is stored in [Hive] Boxes. Http responses are stored as strings.

The settings and [WorkerKey]s are stored in [SharedPreferences].

The [ServiceOfJournal]s are stored in [Hive] as objects.

The [ProofList] store files in filesystem.
# Client-Server API

## Input API

Classes like:

- [ClientEntry],
- [ClientPlan],
- [ServiceEntry],

are used to convert server responses from Json strings to dart classes.
Mostly freezed.

First [httpDataProvider] get data
from server and convert to Json. Then it is converted to classes and assigned to providers of
family [WorkerProfile].

## Output API

The methods for output are:

- [Journal.post] is used to send **/add** requests to server,
- [Journal.delete] is used to send **/delete** requests to server,
- [Journal.exportToFile] is used to save list of [ServiceOfJournal] to a file **.ais_json** .

These methods use json format.

#### Http headers

```json
{
"Content-type": "application/json",
"Accept": "application/json",
"api_key": "your real key will be here"
}
```

## Storage API

Most data is stored in [Hive] Boxes. Http responses are stored as strings.

The settings and [WorkerKey]s are stored in [SharedPreferences].

The [ServiceOfJournal]s are stored in [Hive] as objects.

The [Proofs]s store files in filesystem.
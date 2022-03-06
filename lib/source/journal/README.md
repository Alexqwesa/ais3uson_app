# Journal Classes

This is the classes that store worker input: such as add service, delete service and in between
states. It store input services as instances of [ServiceOfJournal], in 4 different lists(for each
state, see [ServiceState]). These classes:

- store services in Hive,
- make network requests(add/delete),
- manage state of [ServiceOfJournal],
- store archived services.

Each instance of [WorkerProfile] had it's own [Journal].
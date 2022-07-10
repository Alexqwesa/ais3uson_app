# Journal Classes

There are two classes [Journal] and [JournalArchive].

The [Journal] class store worker inputs as instances of [ServiceOfJournal], it store them in 4
different lists (see [ServiceState]) which are provided by [groupsOfJournal]. This class:

- store services in Hive(via provider [servicesOfJournal]),
- make network requests(add/delete),
- change state of [ServiceOfJournal],
- move old [finished] and [outDated] services into [JournalArchive].

The [JournalArchive] class is a cut version of [Journal], it store old [finished] and [outDated]
services.

Each instance of [WorkerProfile] had it's own [Journal].
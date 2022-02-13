# Data Classes

Hierarchy of classes: 
- [AppData] had several:
    - [WorkerProfile]s with different:
        - [ClientProfile]s with different:
            - [ClientService]s with different:
                - [ProofList]s. 

[WorkerProfile], [ClientProfile], [ClientService] classes provide data that they got from classes in category [Import_from_json].

[WorkerProfile] is stored in [SharedPreferences] via class [WorkerKey]. 
It use [SyncDataMixin] to get network data, store data to hive, and finally load it.

[ProofList] class collect data from filesystem and make lists of [ProofGroup]s. 
It also has methods for creating new [ProofGroup]s.  
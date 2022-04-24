# Data Models

These classes provide data for UI classes: [UI Services], [UIWorkerProfile].

Hierarchy of classes:

- provider [workerProfiles] store list of:
    - [WorkerProfile]s with different:
        - [ClientProfile]s with different:
            - [ClientService]s with different:
                - [ProofList]s.

[WorkerProfile], [ClientProfile], [ClientService] classes provide data that they got from classes in
category [Client-Server API].

[ProofList] class collect data from filesystem and make lists of [ProofGroup]s. It also has methods
for creating new [ProofGroup]s.  
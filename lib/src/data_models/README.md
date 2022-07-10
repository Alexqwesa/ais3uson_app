# Data Models

These classes provide data for UI classes.

Hierarchy of classes:

- provider [workerProfiles] store list of:
    - [WorkerProfile]s with different:
        - [ClientProfile]s with different:
            - [ClientService]s with different:
                - [currentService] provider witch is set by overridden, with different:
                    - [ServiceOfJournal]s,
                    - [Proofs]s.

Note: [Proofs] is intentionally not depend on [ServiceOfJournal] to allow:

- make one proof for several [ServiceOfJournal],
- to leave proof even in case of deleting of [ServiceOfJournal].

[WorkerProfile], [ClientProfile], [ClientService] classes provide data that they got from classes in
category [Client-Server API].

[Proofs] class collect data from filesystem and make lists of [ProofEntry]s. It also has methods
for creating new [ProofEntry]s.  
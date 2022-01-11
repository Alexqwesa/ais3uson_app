// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServiceOfJournalAdapter extends TypeAdapter<ServiceOfJournal> {
  @override
  final int typeId = 0;

  @override
  ServiceOfJournal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServiceOfJournal(
      servId: fields[0] as int,
      contractId: fields[1] as int,
      workerId: fields[2] as int,
    )
      ..provDate = fields[3] as DateTime
      .._state = fields[4] as ServiceState
      ..error = fields[5] as String
      ..uid = fields[6] as String;
  }

  @override
  void write(BinaryWriter writer, ServiceOfJournal obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.servId)
      ..writeByte(1)
      ..write(obj.contractId)
      ..writeByte(2)
      ..write(obj.workerId)
      ..writeByte(3)
      ..write(obj.provDate)
      ..writeByte(4)
      ..write(obj._state)
      ..writeByte(5)
      ..write(obj.error)
      ..writeByte(6)
      ..write(obj.uid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceOfJournalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ServiceStateAdapter extends TypeAdapter<ServiceState> {
  @override
  final int typeId = 10;

  @override
  ServiceState read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ServiceState.added;
      case 1:
        return ServiceState.stalled;
      case 2:
        return ServiceState.finished;
      case 3:
        return ServiceState.rejected;
      case 4:
        return ServiceState.outDated;
      default:
        return ServiceState.added;
    }
  }

  @override
  void write(BinaryWriter writer, ServiceState obj) {
    switch (obj) {
      case ServiceState.added:
        writer.writeByte(0);
        break;
      case ServiceState.stalled:
        writer.writeByte(1);
        break;
      case ServiceState.finished:
        writer.writeByte(2);
        break;
      case ServiceState.rejected:
        writer.writeByte(3);
        break;
      case ServiceState.outDated:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

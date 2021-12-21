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
      depId: fields[3] as int,
    )
      ..state = fields[5] as ServiceState
      ..error = fields[6] as String;
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
      ..write(obj.depId)
      ..writeByte(4)
      ..write(obj.provDate)
      ..writeByte(5)
      ..write(obj.state)
      ..writeByte(6)
      ..write(obj.error);
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

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_of_journal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServiceOfJournalAdapter extends TypeAdapter<_$_ServiceOfJournal> {
  @override
  final int typeId = 0;

  @override
  _$_ServiceOfJournal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$_ServiceOfJournal(
      servId: fields[0] as int,
      contractId: fields[1] as int,
      workerId: fields[2] as int,
      provDate: fields[3] as DateTime,
      uid: fields[4] as String,
      state: fields[5] as ServiceState,
      error: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, _$_ServiceOfJournal obj) {
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
      ..write(obj.uid)
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

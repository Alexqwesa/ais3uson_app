// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServiceStateAdapter extends TypeAdapter<ServiceState> {
  @override
  final int typeId = 10;

  @override
  ServiceState read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ServiceState.added;
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

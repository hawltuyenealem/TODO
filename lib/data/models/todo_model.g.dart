// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TODOModelAdapter extends TypeAdapter<TODOModel> {
  @override
  final int typeId = 1;

  @override
  TODOModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TODOModel(
      id: fields[0] as String,
      description: fields[2] as String,
      date: fields[3] as DateTime,
      title: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TODOModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TODOModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

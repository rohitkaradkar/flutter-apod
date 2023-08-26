// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'picture_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PictureEntityAdapter extends TypeAdapter<PictureEntity> {
  @override
  final int typeId = 0;

  @override
  PictureEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PictureEntity(
      date: fields[0] as DateTime,
      explanation: fields[1] as String,
      hdImageUrl: fields[2] as String?,
      imageUrl: fields[3] as String,
      title: fields[4] as String,
      copyright: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PictureEntity obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.explanation)
      ..writeByte(2)
      ..write(obj.hdImageUrl)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.title)
      ..writeByte(5)
      ..write(obj.copyright);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PictureEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

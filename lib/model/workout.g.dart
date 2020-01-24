// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeightExerciseAdapter extends TypeAdapter<WeightExercise> {
  @override
  WeightExercise read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeightExercise()
      ..sets = fields[0] as int
      ..reps = fields[2] as int
      ..weight = fields[3] as int;
  }

  @override
  void write(BinaryWriter writer, WeightExercise obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.sets)
      ..writeByte(2)
      ..write(obj.reps)
      ..writeByte(3)
      ..write(obj.weight);
  }
}

class WorkoutAdapter extends TypeAdapter<Workout> {
  @override
  Workout read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Workout()
      ..name = fields[0] as String
      ..exercises = (fields[1] as List)?.cast<Exercise>();
  }

  @override
  void write(BinaryWriter writer, Workout obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.exercises);
  }
}

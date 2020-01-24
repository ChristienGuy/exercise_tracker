import 'package:hive/hive.dart';

part 'workout.g.dart';

enum MuscleGroup {
  BICEP,
  TRICEP,
  QUADS,
  UPPER_BACK,
  MIDDLE_BACK,
  LOWER_BACK,
  CHEST,
}

abstract class Exercise {
  String name;
  Duration rest;
}

@HiveType()
class WeightExercise extends Exercise {
  @HiveField(0)
  int sets;
  @HiveField(2)
  int reps;
  @HiveField(3)
  int weight;
}

class Superset extends Exercise {
  String name;
  List<Exercise> exercises;
}

@HiveType()
class Workout extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<Exercise> exercises;
}

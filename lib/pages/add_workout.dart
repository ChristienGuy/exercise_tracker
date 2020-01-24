import 'package:exercise_tracker/main.dart';
import 'package:exercise_tracker/model/workout.dart';
import 'package:flutter/material.dart';

class AddWorkoutScreen extends StatefulWidget {
  final Function(Workout) onDone;
  AddWorkoutScreen({@required this.onDone});

  @override
  _AddWorkoutScreenState createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {
  Workout workout = Workout()..exercises = [];
  final TextEditingController nameController = TextEditingController();

  _addExercise(Exercise exercise) {
    workout.exercises.add(exercise);
  }

  _done() {
    workout.name = nameController.text;
    widget.onDone(workout);
    Navigator.maybePop(context);
  }

  _renderExercise(Exercise exercise) {
    if (exercise is WeightExercise) {
      return Row(
        children: <Widget>[
          Text(exercise.name),
          Text(exercise.reps.toString()),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                RaisedButton(
                  child: Text("done"),
                  onPressed: _done,
                )
              ],
            ),
            Text("Name:"),
            TextField(
              controller: nameController,
            ),
            ...workout.exercises.map(_renderExercise).toList(),
            RaisedButton(
              child: Text("add exercise"),
              onPressed: () {
                MaterialPageRoute route = MaterialPageRoute(
                    builder: (context) =>
                        AddExerciseScreen(onAdd: _addExercise));
                Navigator.push(context, route);
              },
            )
          ],
        ),
      ),
    );
  }
}

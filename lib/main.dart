import 'package:exercise_tracker/backdrop.dart';
import 'package:exercise_tracker/pages/add_workout.dart';

import './model/workout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  if (!kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }

  Hive.registerAdapter(WorkoutAdapter(), 0);
  Hive.registerAdapter(WeightExerciseAdapter(), 1);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 600),
        child: FutureBuilder(
          future: Future.wait([
            Hive.openBox('workouts'),
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.error != null) {
                return Scaffold(
                  body: Center(
                    child: Text('Something went wrong :/'),
                  ),
                );
              } else {
                return Backdrop(
                  backLayer: Menu(),
                  frontLayer: WorkoutMainScreen(),
                  frontTitle: Text('front'),
                  backTitle: Text('back'),
                );
              }
            } else {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class Menu extends StatelessWidget {
  _addWorkout(Workout workout) {
    Hive.box('workouts').add(workout);
  }

  _buildMenuItem({String text, Function onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 24.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 30.0),
            _buildMenuItem(
              text: 'ADD A WORKOUT',
              onTap: () {
                MaterialPageRoute route = MaterialPageRoute(
                  builder: (context) => AddWorkoutScreen(onDone: _addWorkout),
                );
                Navigator.push(context, route);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class WorkoutMainScreen extends StatelessWidget {
  Widget _buildWorkout(workout) {
    return Row(
      children: <Widget>[
        Placeholder(
          fallbackHeight: 40,
          fallbackWidth: 40,
        ),
        SizedBox(width: 12),
        Column(
          children: <Widget>[
            Text(workout.name),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: WatchBoxBuilder(
          box: Hive.box('workouts'),
          builder: (context, Box box) {
            var workouts = box.values.toList().cast<Workout>();
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: workouts.map(_buildWorkout).toList(),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          print("start a workout");
        },
        label: Text('Start workout'),
      ),
    );
  }
}

class AddExerciseScreen extends StatefulWidget {
  final Function onAdd;
  AddExerciseScreen({@required this.onAdd});

  @override
  _AddExerciseScreenState createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  final nameController = TextEditingController();
  final repsController = TextEditingController();

  _addExercise() {
    Exercise exercise = new WeightExercise()
      ..name = nameController.text
      ..reps = int.parse(repsController.text);

    widget.onAdd(exercise);

    Navigator.maybePop(context);
  }

  @override
  void dispose() {
    nameController.dispose();
    repsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: nameController,
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: repsController,
            ),
            RaisedButton(
              child: Text('add'),
              onPressed: _addExercise,
            )
          ],
        ),
      ),
    );
  }
}

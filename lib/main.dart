import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';

/*
This application that we are making is a project for detecting accidents. We will have to acquire sensor data from the gyroscope and compass to detect the 3d tilt and the rotation. We will also use precise location tracking sensors to detect the translational motion in space.
At first we need to design a simple app that will allow use to control a 3d model using slider widgets. These sliders will allow use to move the model, tilt is or rotate it. Lets see what the home screen of this basic simulator looks like:
we will have three buttons on the home screen that will allow us to select the type of control for the mode. Here are the three buttons:
3d tilt: this button will take us to a different screen where we can control the right, left, forward and the back tilting of the model using 4 sliders.
Direction rotation: this one is simpler. It simply uses the compass and rotates the model between 0 and 360 degrees. 0 degree being the north. This will be done using the flutter compass package. A slider will allow us to change the angle of the model.
3d translation: this is the last button to navigate to a screen where we will control the position of the model in the 3d space. This will be done using 3 sliders through which we can change the position of the model on the x, y and z planes
We are using the flutter cube package to load and manipulate the models in the app. 

 */

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Space Simulator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Space Simulator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //lets create the three buttons here
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TiltScreen()),
                );
              },
              child: Text('3D Tilt'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RotationScreen()),
                );
              },
              child: Text('Direction Rotation'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Translation()),
                );
              },
              child: Text('3D Translation'),
            ),
          ],
        ),
      ),
    );
  }
}

//creating the control screen for the 3d tilt

class TiltScreen extends StatefulWidget {
  const TiltScreen({super.key});

  @override
  State<TiltScreen> createState() => _TiltScreenState();
}

double _sideTilt = 0.0;
double _forwardTilt = 0.0; //global for state management
double _rotation = 0.0;

class _TiltScreenState extends State<TiltScreen> {
  late Object _cube;
  Scene? _scene;

  @override
  void initState() {
    super.initState();
    _cube = Object(
      position: Vector3(0, 0, 0),
      scale: Vector3(5.0, 5.0, 5.0),
      lighting: true,
      backfaceCulling: false,
      fileName: 'assets/cube/cube.obj',
    );
  }

  void _updateRotation() {
    if (_scene == null) return;
    _cube.rotation.setValues(_sideTilt * 90, 90, _forwardTilt * 90); //the constant y value makes the model rotate which is the purpose of the compass. so i fixed it to 90 just to make the model face the right direction
    _cube.updateTransform();
    log('$_sideTilt, $_forwardTilt');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('3D Tilt'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _buildSlider('Side tilt', _sideTilt, (value) => _sideTilt = value),
            _buildSlider('Forward tilt', _forwardTilt, (value) => _forwardTilt = value),
            Expanded(
              child: Container(
                height: 300,
                color: Colors.black26,
                child: Cube(
                  onSceneCreated: (Scene scene) {
                    _scene = scene;
                    scene.world.add(_cube);

                    _updateRotation();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(String title, double value, Function(double) onChanged) {
    return ListTile(
      title: Text(title),
      subtitle: SizedBox(
        width: 200,
        child: Slider(
          value: value,
          min: -1.0,
          max: 1.0,
          onChanged: (newValue) {
            setState(() {
              onChanged(newValue);
              _updateRotation();
            });
          },
        ),
      ),
      trailing: Text(value.toStringAsFixed(2)),
    );
  }
}

class RotationScreen extends StatefulWidget {
  const RotationScreen({super.key});

  @override
  State<RotationScreen> createState() => _RotationScreenState();
}

class _RotationScreenState extends State<RotationScreen> {
  late Object _cube;
  Scene? _scene;

  @override
  void initState() {
    super.initState();
    _cube = Object(
      position: Vector3(0, 0, 0),
      scale: Vector3(5.0, 5.0, 5.0),
      lighting: true,
      backfaceCulling: false,
      fileName: 'assets/cube/cube.obj',
    );
  }

  void _updateRotation() {
    if (_scene == null) return;
    _cube.rotation.setValues(_sideTilt * 90, _rotation, _forwardTilt * 90);
    _cube.updateTransform();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Direction Rotation'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('Rotation'),
              subtitle: SizedBox(
                width: 200,
                child: Slider(
                  value: _rotation,
                  min: 0,
                  max: 360,
                  onChanged: (newValue) {
                    setState(() {
                      _rotation = newValue;
                      _updateRotation();
                    });
                  },
                ),
              ),
              trailing: Text(_rotation.toStringAsFixed(2)),
            ),
            Container(
              height: 500,
              color: Colors.black26,
              child: Cube(
                onSceneCreated: (Scene scene) {
                  _scene = scene;
                  scene.world.add(_cube);

                  _updateRotation();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

//3d translation will determine the position of the model in the 3d space. the location of the model will be controlled by 3 sliders to determine the position in xyz plane

double _x = 0.0;
double _y = 0.0;
double _z = 0.0;

class Translation extends StatefulWidget {
  const Translation({super.key});

  @override
  State<Translation> createState() => _TranslationState();
}

class _TranslationState extends State<Translation> {
  late Object _cube;
  Scene? _scene;

  @override
  void initState() {
    super.initState();
    _cube = Object(
      position: Vector3(0, 0, 0),
      scale: Vector3(5.0, 5.0, 5.0),
      lighting: true,
      backfaceCulling: false,
      fileName: 'assets/cube/cube.obj',
    );
  }

  void _updateTranslation() {
    if (_scene == null) return;
    _cube.position.setValues(_x, _y, _z);
    _cube.rotation.setValues(_sideTilt * 90, _rotation, _forwardTilt * 90);
    _cube.updateTransform();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('3D Translation'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _buildSlider('X', _x, (value) => _x = value),
            _buildSlider('Y', _y, (value) => _y = value),
            _buildSlider('Z', _z, (value) => _z = value),
            Container(
              height: 400,
              color: Colors.black26,
              child: Cube(
                onSceneCreated: (Scene scene) {
                  _scene = scene;
                  scene.world.add(_cube);

                  _updateTranslation();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(String title, double value, Function(double) onChanged) {
    return ListTile(
      title: Text(title),
      subtitle: SizedBox(
        width: 200,
        child: Slider(
          value: value,
          min: -10.0,
          max: 10.0,
          onChanged: (newValue) {
            setState(() {
              onChanged(newValue);
              _updateTranslation();
            });
          },
        ),
      ),
      trailing: Text(value.toStringAsFixed(2)),
    );
  }
}

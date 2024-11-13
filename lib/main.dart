import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late MapboxMap mapboxMap;
  PointAnnotationManager? pointAnnotationManager;

  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    pointAnnotationManager =
        await mapboxMap.annotations.createPointAnnotationManager();

    final ByteData bytes =
        await rootBundle.load('assets/images/custom-icon.png');
    final Uint8List imageData = bytes.buffer.asUint8List();

    List<PointAnnotationOptions> points = [
      PointAnnotationOptions(
        geometry: Point(coordinates: Position(102.6095382, 17.8896417)),
        image: imageData,
        iconSize: 0.1,
      ),
      PointAnnotationOptions(
        geometry: Point(coordinates: Position(102.599682, 17.964099)),
        image: imageData,
        iconSize: 0.1,
      ),
    ];

    // Add all annotations to the map
    pointAnnotationManager?.createMulti(points);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    String accessToken = const String.fromEnvironment("ACCESS_TOKEN");
    MapboxOptions.setAccessToken(accessToken);
    CameraOptions camera = CameraOptions(
        center: Point(coordinates: Position(102.6046, 17.92687)),
        zoom: 13,
        bearing: 0,
        pitch: 30);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: Scaffold(
        body: MapWidget(
          cameraOptions: camera,
          onMapCreated: _onMapCreated,
        ),
      ),
    );
  }
}

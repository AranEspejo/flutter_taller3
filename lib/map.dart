import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_taller3/consts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import  'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  Location _locationController = new Location(); 

  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();//controlar la funcionalidad de google map

  static const LatLng _pGooglePlex = LatLng(37.4223, -122.0848);//San Francisco
  static const LatLng _pApplePark = LatLng(37.3346, -122.0090);
  LatLng? _currentP = null;

  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    getLocationUpdate().then(
      (_) => { //se usa (_) ya que la funcion se completa
        getPolylinePoints().then((coordinates) => {
          print(coordinates),
        }),
      },
    ); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentP == null ? const Center(child: Text("Loading..."),) : GoogleMap( //si la ubi es nula se muestra un mensaje
        onMapCreated: ((GoogleMapController controller) =>_mapController.complete(controller)),
        initialCameraPosition: CameraPosition(
          target: _pGooglePlex, 
          zoom: 13,
        ),
        markers: {
          Marker(
            markerId: MarkerId("_currentLocation"),
            icon: BitmapDescriptor.defaultMarker, 
            position: _currentP!,),
          Marker(
            markerId: MarkerId("_sourceLocation"),
            icon: BitmapDescriptor.defaultMarker, 
            position: _pGooglePlex),
          Marker(
            markerId: MarkerId("_destinationLocation"), 
            icon: BitmapDescriptor.defaultMarker, 
            position: _pApplePark)

        },
        polylines: Set<Polyline>.of(polylines.values),
      ),
    );
  }

  //apuntar la camara en una posicion especifica
  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(
      target: pos,
      zoom: 13,
      );
      await controller.animateCamera(CameraUpdate.newCameraPosition(_newCameraPosition),
      );
  }

  Future<void> getLocationUpdate() async{
    bool _serviceEnabled; //para saber si se puede obtener la ubicacion del usuario
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if(_serviceEnabled){
      _serviceEnabled = await _locationController.requestService();
    }else{
      return;
    }
    //verificar permiso
    _permissionGranted = await _locationController.hasPermission();
    if(_permissionGranted == PermissionStatus.denied){
      //pedir el permiso
      _permissionGranted = await _locationController.requestPermission();
      if(_permissionGranted != PermissionStatus.granted){
        return;
      }
    }
  //cuando permiso concedido
    _locationController.onLocationChanged.listen((LocationData currentLocation){
      if(currentLocation.latitude != null && currentLocation.longitude != null){
        setState(() { //reconstruir el mapa y las variables dentro de el
          _currentP = LatLng(currentLocation.latitude!, currentLocation.longitude!); // se usa ! ya que se sabe que el valor no es nulo
          _cameraToPosition(_currentP!);
        });

      }
    });
  }
  //dibujar la ruta
  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: GOOGLE_MAPS_API_KEY,
      request: PolylineRequest(
        origin:  PointLatLng(_pGooglePlex.latitude, _pGooglePlex.longitude), 
        destination: PointLatLng(_pApplePark.latitude, _pApplePark.longitude), 
        mode: TravelMode.walking,
        ),
    /*polylinePoints.getRouteBetweenCoordinates(
      GOOGLE_MAPS_API_KEY,
      PointLatLng(_pGooglePlex.latitude, _pGooglePlex.longitude),
      PointLatLng(_pApplePark.latitude, _pApplePark.longitude), 
      travelMode: TravelMode.walking, 
      request: null,
      */
    );
    if(result.points.isNotEmpty){
      result.points.forEach((PointLatLng point){
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    return polylineCoordinates;
  }

  void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) async {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id, 
      color: Colors.black, 
      points: polylineCoordinates, 
      width:8);
    setState(() {
      polylines[id] = polyline;
    });
  }
}
import 'dart:collection';

import "package:flutter/material.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";


class GMap extends StatefulWidget {
  GMap({Key key}) : super(key: key);

  @override
  _GMapState createState() => _GMapState();
}

class _GMapState extends State<GMap> {
  Set<Marker> _markers = HashSet<Marker>();
  Set<Polygon> _polygons = HashSet<Polygon>();
  GoogleMapController _mapController;
  BitmapDescriptor _markerIcon;

  @override
  void initState() {
    super.initState();
    _setMarkerIcon();
    _setPolygons();
  }

  void _setMarkerIcon() async{
    _markerIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(), "flutter_01.png");
    // Añadir el icono que queramos!!!
  }

  void _setPolygons() {
    List<LatLng> polygonLatLongs = <LatLng>[];
    polygonLatLongs.add(LatLng(41.1,1.95));
    polygonLatLongs.add(LatLng(41.4,1.95));
    polygonLatLongs.add(LatLng(41.1,2.18));
    polygonLatLongs.add(LatLng(41.4,2.18));

    _polygons.add(
      Polygon(
        polygonId: PolygonId("0"),
        points: polygonLatLongs,
        fillColor: Colors.transparent,
        strokeWidth: 1,
      )
    );
  }

  void _onMapCreated(GoogleMapController controller){
    _mapController = controller;

    setState(() {
      _markers.add(Marker(
        markerId: MarkerId("0"),
        position: LatLng(41.275555,1.9869444),
        infoWindow: InfoWindow(
          title: "EETAC",
          snippet: "Aerospacials & Telecos",
        ),
        icon: _markerIcon,
        ));
    });
  }

   @override 
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Location"),
      ),
      body: Stack(children: <Widget>[
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
          target: LatLng(41.3879, 2.16992),
          zoom: 15,
          ),
          markers: _markers,
          polygons: _polygons,
        ),
        // Para añadir cosas en el mapa que no estan fijas en el, sino como encima, que si mueves el mapa sigue estando en la pantalla
        Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
          child: Text("Whatever"))
        ],
      )
          );
        }
      }
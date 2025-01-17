import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';

import 'package:flutter_map/flutter_map.dart';

class MapaPage extends StatefulWidget {

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  final mapCtrl = new MapController();

  String tipoMapa = 'streets';

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: (){
              mapCtrl.move(scan.getLatLng(), 15.0);
            },
          )
        ],
      ),
      body: _crearFlutterMap(scan),
      floatingActionButton: _crearBotonFlotante(context),
    );
  }

  Widget _crearFlutterMap(ScanModel scan) {
    return FlutterMap(
      mapController: mapCtrl,
      options: new MapOptions(
        center: scan.getLatLng(),
        zoom: 15.0,
      ),
      layers: [
        _crearMapa(),
        _crearMarcadores(scan),
      ],
    );
  }

  _crearMapa(){
    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/v4/'
      '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
      additionalOptions: {
        'accessToken': 'pk.eyJ1Ijoia29ybGF5MzciLCJhIjoiY2s5YzVibGw2MDFjOTNsbWxsdWFyZG9tciJ9.n7U2-DSVRb9bHGXGw_HBWw',
        'id': 'mapbox.$tipoMapa' 
        //streets, dark, light, outdoors, satellite
      }
    );
  }

  _crearMarcadores(ScanModel scan){
    return MarkerLayerOptions(
      markers: <Marker>[
        Marker(
          width: 100.0,
          height: 100.0,
          point: scan.getLatLng(),
          builder: (context) => Container(
            child: Icon(
              Icons.location_on, 
              size: 70.0, 
              color: Colors.deepPurple
              ),
          )
        )
      ]
    );
  }

  Widget _crearBotonFlotante(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.repeat),
      backgroundColor: Colors.deepPurple,
      onPressed: (){
        //streets, dark, light, outdoors, satellite
        if(tipoMapa == 'streets'){
          tipoMapa='dark';
        }else if (tipoMapa == 'dark'){
          tipoMapa = 'light';
        }else if (tipoMapa == 'light'){
          tipoMapa = 'outdoors';
        }else if (tipoMapa == 'outdoors'){
          tipoMapa = 'satellite';
        }else{
          tipoMapa = 'streets';
        }
        setState((){});
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MarkerWithValue extends Marker {

  // L'identifiant de l'objet associé au marker
  dynamic objectId;

  MarkerWithValue({
    final this.objectId,
    required final LatLng point,
    required final WidgetBuilder builder,
    final Key? key,
    final double width = 30.0,
    final double height = 30.0,
    final bool? rotate,
    final Offset? rotateOrigin,
    final AlignmentGeometry? rotateAlignement,
    final AnchorPos? anchorPos,
  }) : super (
    point: point, 
    builder: builder, 
    key: key, 
    width: width,
    height: height,
    rotate: rotate,
    rotateOrigin: rotateOrigin,
    rotateAlignment: rotateAlignement,
    anchorPos: anchorPos);

}
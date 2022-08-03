import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_map_marker_cluster/src/node/marker_cluster_node.dart';


import 'package:nancy_stationnement/utils/marker_with_value.dart';
import 'package:latlong2/latlong.dart';

import 'dart:math';


import 'package:flutter_map_marker_popup/extension_api.dart';
class PopupOptionsWithMarkerwithValue extends PopupOptions {
  /// Used to construct the popup.
  @override
  final PopupBuilderA popupBuilder;

  PopupOptionsWithMarkerwithValue({
    required this.popupBuilder,
    final PopupSnap popupSnap = PopupSnap.markerTop,
    final PopupController? popupController,
    final PopupAnimation? popupAnimation,
    final bool markerRotate = false,
    final MarkerTapBehavior? markerTapBehavior,
  }) : super (
    popupBuilder: popupBuilder,
    popupSnap: popupSnap,
    popupController: popupController,
    popupAnimation: popupAnimation,
    markerRotate: markerRotate,
    markerTapBehavior: markerTapBehavior
  );

}
@override
typedef PopupBuilderA = Widget Function(BuildContext, MarkerWithValue);


@override
typedef ClusterWidgetBuilder = Widget Function(
    BuildContext context, List<MarkerWithValue> markers);


class MarkerWithValueClusterLayerOptions extends MarkerClusterLayerOptions {
    /// List of markers
  // @override
  @override
  final List<MarkerWithValue> markers;

  @override
  final ClusterWidgetBuilder builder;

  //   /// Cluster compute size
  // // @override
  // final Size Function(List<MarkerWithValueClusterLayerOptions>)? computeSize;


  // /// Function to call when a Marker is tapped
  // // @override
  // final void Function(MarkerWithValue)? onMarkerTap;

  // // @override
  // /// Function to call when markers are clustered
  // final void Function(List<MarkerWithValue>)? onMarkersClustered;

  MarkerWithValueClusterLayerOptions({

    required this.builder,
    final bool? rotate,
    final Offset? rotateOrigin,
    final AlignmentGeometry? rotateAlignment,
    final this.markers = const [],
    final Size size = const Size(30, 30),
    final Size Function(List<Marker>)? computeSize,
    final AnchorPos? anchor,
    final int maxClusterRadius = 80,
    final int disableClusteringAtZoom = 20,
    final AnimationsOptions animationsOptions = const AnimationsOptions(),
    final FitBoundsOptions fitBoundsOptions = const FitBoundsOptions(padding: EdgeInsets.all(12)),
    final bool zoomToBoundsOnClick = true,
    final bool centerMarkerOnClick = true,
    final int spiderfyCircleRadius = 40,
    final int spiderfySpiralDistanceMultiplier = 1,
    final int circleSpiralSwitchover = 9,
    final List<Point> Function(int, Point)? spiderfyShapePositions,
    final PolygonOptions polygonOptions = const PolygonOptions(),
    final bool showPolygon = true,
    final void Function(Marker)? onMarkerTap,
    final void Function(MarkerClusterNode)? onClusterTap,
    final void Function(List<Marker>)? onMarkersClustered,
    final PopupOptions? popupOptions,
  }) : super (
    builder: builder,
    rotate: rotate,
    rotateOrigin: rotateOrigin,
    rotateAlignment: rotateAlignment,
    markers: markers,
    size: size,
    computeSize: computeSize,
    anchor: anchor,
    maxClusterRadius: maxClusterRadius,
    disableClusteringAtZoom: disableClusteringAtZoom,
    animationsOptions: animationsOptions,
    fitBoundsOptions: fitBoundsOptions,
    zoomToBoundsOnClick: zoomToBoundsOnClick,
    centerMarkerOnClick: centerMarkerOnClick,
    spiderfyCircleRadius: spiderfyCircleRadius,
    spiderfySpiralDistanceMultiplier: spiderfySpiralDistanceMultiplier,
    circleSpiralSwitchover: circleSpiralSwitchover,
    spiderfyShapePositions: spiderfyShapePositions,
    polygonOptions: polygonOptions,
    showPolygon: showPolygon,
    onMarkerTap: onMarkerTap,
    onClusterTap: onClusterTap,
    onMarkersClustered: onMarkersClustered,
    popupOptions: popupOptions,
  );

}
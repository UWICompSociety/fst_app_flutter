import 'package:flutter/material.dart';
import 'package:fst_app_flutter/models/from_postgres/map/geometry_types/geometry_object.dart';
import 'package:fst_app_flutter/models/from_postgres/map/geometry_types/geometry_type.dart';
import 'package:fst_app_flutter/models/from_postgres/map/geometry_types/linear_ring.dart';

// TODO: document GeoJsonPolygon @richtwin567
class GeoJsonPolygon extends GeoJsonGeometryObject {
  List<GeoJsonLinearRing> _coordinates;

  List<GeoJsonLinearRing> get coordinates => _coordinates;

  GeoJsonPolygon({@required coordsJson})
      : assert(coordsJson != null),
        super(GeoJsonGeometryType.polygon) {
    _coordinates = [];
    var linearRingCoords = [];
    for (var i = 0; i < coordsJson.length; i++) {
      if (coordsJson[i]['marker'] == 'END') {
        linearRingCoords.add(coordsJson[i]);
        _coordinates.add(GeoJsonLinearRing(coordsJson: linearRingCoords));
        linearRingCoords = [];
      } else {
        linearRingCoords.add(coordsJson[i]);
      }
    }
  }

  @override
  toGeoJsonFile() {
    return {
      '\"type\"': '\"${type.toShortString()}\"',
      '\"coordinates\"': coordinates.map((e) => e.toGeoJsonFile()).toList()
    };
  }

  @override
  toGeoJson() {
    return {
      'type': type.toShortString(),
      'coordinates': coordinates.map((e) => e.toGeoJson()).toList()
    };
  }

  @override
  extractLatLng() {
    var list = coordinates.expand((e) => e.extractLatLng()).toList();
    return list;
  }
  /*
  For Polygons with more than one of these rings, the first MUST be
      the exterior ring, and any others MUST be interior rings.  The
      exterior ring bounds the surface, and the interior rings (if
      present) bound holes within the surface.*/
}

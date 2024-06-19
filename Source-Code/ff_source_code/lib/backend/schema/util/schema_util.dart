import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:from_css_color/from_css_color.dart';

import '/flutter_flow/flutter_flow_util.dart';

export 'package:collection/collection.dart' show ListEquality;
export 'package:flutter/material.dart' show Color, Colors;
export 'package:from_css_color/from_css_color.dart';

typedef StructBuilder<T> = T Function(Map<String, dynamic> data);

abstract class BaseStruct {
  Map<String, dynamic> toSerializableMap();
  String serialize() => json.encode(toSerializableMap());
}

List<T>? getStructList<T>(
  dynamic value,
  StructBuilder<T> structBuilder,
) =>
    value is! List
        ? null
        : value
            .where((e) => e is Map<String, dynamic>)
            .map((e) => structBuilder(e as Map<String, dynamic>))
            .toList();

Color? getSchemaColor(dynamic value) => value is String
    ? fromCssColor(value)
    : value is Color
        ? value
        : null;

List<Color>? getColorsList(dynamic value) =>
    value is! List ? null : value.map(getSchemaColor).withoutNulls;

List<T>? getDataList<T>(dynamic value) =>
    value is! List ? null : value.map((e) => castToType<T>(e)!).toList();

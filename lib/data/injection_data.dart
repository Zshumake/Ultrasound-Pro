import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/injection_technique.dart';

const _dataFiles = [
  'assets/data/shoulder.json',
  'assets/data/elbow.json',
  'assets/data/hand.json',
  'assets/data/hip.json',
  'assets/data/knee.json',
  'assets/data/foot.json',
];

Future<List<InjectionTechnique>> loadInjectionData() async {
  final List<InjectionTechnique> all = [];
  for (final path in _dataFiles) {
    final jsonStr = await rootBundle.loadString(path);
    final List<dynamic> list = json.decode(jsonStr);
    all.addAll(list.map((e) => InjectionTechnique.fromJson(e)));
  }
  return all;
}

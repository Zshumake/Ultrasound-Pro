import 'dart:convert';
import 'package:flutter/foundation.dart';
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

class LoadResult {
  final List<InjectionTechnique> procedures;
  final List<String> errors;
  const LoadResult({required this.procedures, required this.errors});
  bool get hasErrors => errors.isNotEmpty;
}

Future<LoadResult> loadInjectionData() async {
  final List<InjectionTechnique> all = [];
  final List<String> errors = [];

  for (final path in _dataFiles) {
    List<dynamic> list;
    try {
      final jsonStr = await rootBundle.loadString(path);
      list = json.decode(jsonStr) as List;
    } catch (e) {
      final msg = 'Failed to load $path: $e';
      errors.add(msg);
      debugPrint('[InjectionData] $msg');
      continue; // skip file, keep loading others
    }

    for (final entry in list) {
      try {
        all.add(InjectionTechnique.fromJson(entry as Map<String, dynamic>));
      } catch (e) {
        final id = (entry as Map<String, dynamic>?)?['id'] ?? 'unknown';
        final msg = '[$path] procedure "$id": $e';
        errors.add(msg);
        debugPrint('[InjectionData] Parse error: $msg');
        // skip this procedure, keep loading the rest
      }
    }
  }

  return LoadResult(procedures: all, errors: errors);
}

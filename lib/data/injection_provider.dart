import 'package:flutter/material.dart';
import '../models/injection_technique.dart';
import 'injection_data.dart';

class InjectionDataProvider extends ChangeNotifier {
  List<InjectionTechnique> _injections = [];
  List<String> _loadErrors = [];
  bool _isLoaded = false;

  List<InjectionTechnique> get injections => _injections;
  bool get isLoaded => _isLoaded;
  List<String> get loadErrors => _loadErrors;
  bool get hasLoadErrors => _loadErrors.isNotEmpty;

  InjectionDataProvider() {
    _load();
  }

  Future<void> _load() async {
    final result = await loadInjectionData();
    _injections = result.procedures;
    _loadErrors = result.errors;
    _isLoaded = true;
    notifyListeners();
  }

  InjectionTechnique? findById(String id) =>
      _injections.where((i) => i.id == id).firstOrNull;
}

import 'package:flutter/material.dart';
import '../models/injection_technique.dart';
import 'injection_data.dart';

class InjectionDataProvider extends ChangeNotifier {
  List<InjectionTechnique> _injections = [];
  bool _isLoaded = false;

  List<InjectionTechnique> get injections => _injections;
  bool get isLoaded => _isLoaded;

  InjectionDataProvider() {
    _load();
  }

  Future<void> _load() async {
    _injections = await loadInjectionData();
    _isLoaded = true;
    notifyListeners();
  }

  InjectionTechnique? findById(String id) {
    try {
      return _injections.firstWhere((i) => i.id == id);
    } catch (_) {
      return null;
    }
  }
}

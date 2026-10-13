import 'package:flutter/foundation.dart';

class QueueProvider extends ChangeNotifier {
  final List<String> _clients = [];

  // Vue non modifiable : on force à passer par les méthodes (donc notifyListeners)
  List<String> get clients => List.unmodifiable(_clients);

  void addClient(String name) {
    _clients.add(name);
    notifyListeners();
  }

  void removeClient(String name) {
    if (_clients.remove(name)) {
      notifyListeners();
    }
  }

  void nextClient() {
    if (_clients.isNotEmpty) {
      _clients.removeAt(0);
      notifyListeners();
    }
  }
}
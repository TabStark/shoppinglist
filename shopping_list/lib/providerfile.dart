import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WordProvider extends ChangeNotifier {
  List<String> namewords = [];

  void getName(String word) {
    namewords.add(word);
    notifyListeners();
  }

  

  void delete(String word) {
    namewords.remove(word);
    notifyListeners();
  }
}

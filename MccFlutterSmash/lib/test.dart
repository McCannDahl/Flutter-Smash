import 'dart:convert';

void main() {
  List<String> bob = ['1','2'];
  print(bob.toString());
  print(jsonEncode({
    'test': bob
  }));
}
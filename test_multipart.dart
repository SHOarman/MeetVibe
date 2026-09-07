import 'dart:io';
import 'package:get/get.dart';

void main() {
  File f = File('test.jpg');
  try {
    var m = MultipartFile(f, filename: 'test.jpg');
    print("Success");
  } catch (e) {
    print("Error: $e");
  }
}

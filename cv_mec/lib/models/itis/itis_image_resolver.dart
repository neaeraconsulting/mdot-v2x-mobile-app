import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:image/image.dart' as img_lib;

class ItisImageResolver{
  final Logger logger = Logger();
  Future<ImageProvider> getImage(String imageName) async {
    throw UnimplementedError("This is an abstract class - Make sure to only call this method on subclasses");
  }

  Future<img_lib.Image?> getDecodedImage(String imageName) async{
    throw UnimplementedError("This is an abstract class - Make sure to only call this method on subclasses");
  }

  Future<ImageProvider> getMissing() async {
    return const AssetImage("assets/images/tims/missing.png");
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Base provider of Images.
///
/// {@category Base Providers}
final image = Provider.family<Image, String>(
  (ref, imgSrc) {
    return imgSrc.startsWith('http://') || imgSrc.startsWith('https://')
        ? Image.network(imgSrc)
        : Image.asset('images/$imgSrc');
  },
);

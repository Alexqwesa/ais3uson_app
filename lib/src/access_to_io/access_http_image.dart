import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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

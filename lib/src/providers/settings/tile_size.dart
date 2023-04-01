import 'dart:ui';

import 'package:ais3uson_app/src/providers/settings/tile_magnification.dart';
import 'package:ais3uson_app/src/providers/settings/tile_type.dart';
import 'package:ais3uson_app/ui_service_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tuple/tuple.dart';

/// Calculate size of [ServiceCard] based on parentSize and [tileType].
///
/// {@category Providers}
/// {@category UI Settings}
final tileSize = Provider.family<Size, Tuple2<Size, String>>((ref, tuple) {
  final magnification = ref.watch(tileMagnification);

  final parentSize = tuple.item1;
  final tileType = tuple.item2;
  final parentWidth = parentSize.width;

  if (tileType == 'tile') {
    final divider = (parentWidth - 20) ~/ (magnification * 400.0);
    var cardWidth = (parentWidth / divider) - 10;
    if (divider == 0) {
      cardWidth = (parentWidth - 10).abs();
    }

    return Size(
      cardWidth * 1.0,
      cardWidth / 4,
    );
  } else if (tileType == 'square') {
    var divider = (parentWidth - 20) ~/ (magnification * 150.0);
    if (parentWidth < (magnification * 130)) {
      divider = 1;
    } else if (parentWidth < (magnification * 260)) {
      divider = 2;
    } else {
      divider = divider > 2 ? divider : 3;
    }
    final cardWidth = parentWidth / divider;

    return Size(
      cardWidth,
      cardWidth,
    );
  } else {
    var divider = (parentWidth - 20) ~/ (magnification * 250.0);
    divider = divider > 1 ? divider : 2;
    final cardWidth = parentWidth / divider;

    return Size(
      cardWidth * 1.0,
      cardWidth * 1.2,
    );
  }
});

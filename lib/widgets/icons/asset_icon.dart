import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Список файлов, которые реально попали в сборку.
///
/// Пока png нет, на экране стоит встроенный значок Flutter.
/// Файл кладётся по пути из виджета, например `assets/icons/nav/tasks.png`,
/// после этого нужен полный перезапуск, не горячая перезагрузка.
class IconCatalog {
  static Set<String> _paths = const {};

  static Future<void> load() async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    _paths = manifest.listAssets().toSet();
  }

  static bool has(String path) => _paths.contains(path);
}

/// Картинка из assets либо запасной значок, если файла ещё нет.
class AssetIcon extends StatelessWidget {
  const AssetIcon({
    super.key,
    required this.path,
    required this.fallback,
    this.size = 24,
    this.color,
    this.tint = false,
  });

  final String path;
  final IconData fallback;
  final double size;
  final Color? color;

  /// Красит png в [color]. Для белых значков шапки и панелей.
  /// Цветные картинки карточек оставляют `tint: false`.
  final bool tint;

  @override
  Widget build(BuildContext context) {
    if (!IconCatalog.has(path)) {
      return Icon(fallback, size: size, color: color);
    }
    return Image.asset(
      path,
      width: size,
      height: size,
      fit: BoxFit.contain,
      color: tint ? color : null,
      colorBlendMode: tint ? BlendMode.srcIn : null,
    );
  }
}

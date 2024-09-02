import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/constants.dart';

class LocalStorage {
  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(dir.path);
  }

  static Future<bool> saveCache<T>(String key, dynamic value) async {
    try {
      final box = await Hive.openBox<T>(Constants.cache);

      if (value is List<Map<String, dynamic>>) {
        final existingList = await _getValue<List<Map<String, dynamic>>>(key);
        final newList = List<Map<String, dynamic>>.from(existingList);
        for (var item in value) {
          if (!newList.any((element) => element['id'] == item['id'])) {
            newList.add(item);
          }
        }
        await box.put(key, newList as T);
      } else {
        final existingObject = await _getValue<Map<String, dynamic>>(key);
        if (existingObject == null || existingObject['id'] != value['id']) {
          await box.put(key, value);
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<dynamic> getCache<T>(String key, [int? id]) async {
    try {
      final box = await Hive.openBox<T>(Constants.cache);

      if (id != null) {
        final List<T> list = box.get(key) as List<T>;
        return list.firstWhere((element) => (element as dynamic).id == id);
      } else {
        return box.get(key);
      }
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> _getValue<T>(String key) async {
    return await Hive.openBox(Constants.cache).then((box) {
      return switch (T) {
        const (double) => box.get(key) ?? 0.0,
        const (int) => box.get(key) ?? 0,
        const (String) => box.get(key) ?? '',
        const (List) => box.get(key) ?? [],
        const (bool) => box.get(key) ?? false,
        _ => box.get(key)
      };
    });
  }

  static Future<bool> clearCache<T>() async {
    try {
      await Hive.deleteFromDisk();
      return true;
    } catch (e) {
      if (kDebugMode) print(e);
      return false;
    }
  }
}

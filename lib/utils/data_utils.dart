
class Refrigerator {
  int? id; //autoincrement
  final String name;
  final int favorites;

  Refrigerator({
    this.id,
    required this.name,
    required this.favorites,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'favorites': favorites,
    };
  }

  @override
  String toString() {
    return 'Refrigerator{id: $id, name: $name, favorites: $favorites}';
  }
}

class Food {
  int? id; //autoincrement
  final int rId;
  final String path;
  final String name;
  final String storage;
  final int count;
  final int expiration;
  String? memo;

  Food({
    this.id,
    required this.rId,
    required this.path,
    required this.name,
    required this.storage,
    required this.count,
    required this.expiration,
    this.memo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'r_id': rId,
      'path': path,
      'name': name,
      'storage': storage,
      'count': count,
      'expiration': expiration,
      'memo': memo,
    };
  }

  @override
  String toString() {
    return 'Food{id: $id, r_id: $rId, path: $path, name: $name, storage: $storage, count: $count, expiration: $expiration, memo: $memo}';
  }
}

class Category {
  String imagePath;
  String name;
  List<Category>? lists;

  Category({
    required this.imagePath,
    required this.name,
    this.lists,
  });
}

class AlertSetting {
  bool use;
  DateTime? time;

  AlertSetting({this.use = true, this.time}) {
    time ??= DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 9, 0);
  }
}

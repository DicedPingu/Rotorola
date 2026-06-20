enum ItemCategory {
  doImmediately,
  goodToDo,
  avoidOrWrong,
  destructive,
  mindBlowing,
}

class Item {
  final int id;
  final String title;
  final String description;
  final String guide;
  final ItemCategory category;

  const Item({
    required this.id,
    required this.title,
    required this.description,
    required this.guide,
    required this.category,
  });

  String get categoryName {
    switch (category) {
      case ItemCategory.doImmediately:
        return 'Do Immediately';
      case ItemCategory.goodToDo:
        return 'Good to Do';
      case ItemCategory.avoidOrWrong:
        return 'Avoid / Wrong';
      case ItemCategory.destructive:
        return 'Destructive (Risk)';
      case ItemCategory.mindBlowing:
        return 'Mind-Blowing Hacks';
    }
  }
}

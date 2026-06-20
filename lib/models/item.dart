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
  final String whatIsIt;
  final String whyDoIWantIt;

  const Item({
    required this.id,
    required this.title,
    required this.description,
    required this.guide,
    required this.category,
    required this.whatIsIt,
    required this.whyDoIWantIt,
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

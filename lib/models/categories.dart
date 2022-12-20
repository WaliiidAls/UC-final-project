class CategoriesClass {
  int id;
  String title;
  String desc;
  String imageUrl;
  String emoji;
  String dbTag;

  CategoriesClass(
      {required this.id,
      required this.title,
      required this.desc,
      required this.imageUrl,
      required this.emoji,
      required this.dbTag});

  static List<CategoriesClass> menu = [
    CategoriesClass(
        id: 0,
        title: "Popular",
        desc: "well-Known type of quotes",
        imageUrl: "assets/images/popular.svg",
        emoji: "🔥",
        dbTag: "popular"),
    CategoriesClass(
      id: 1,
      title: "Motherhood",
      desc: "quotes that inspire mothers",
      imageUrl: "assets/images/motherhood.svg",
      emoji: "👩‍👧",
      dbTag: "motherhood",
    ),
    CategoriesClass(
        id: 2,
        title: "Fatherhood",
        desc: "quotes that inspire father",
        imageUrl: "assets/images/fatherhood.svg",
        emoji: "👨‍👧",
        dbTag: "fatherhood"),
    CategoriesClass(
      id: 3,
      title: "Modern Life",
      desc: "motivational quotes about life",
      imageUrl: "assets/images/life.svg",
      emoji: "🏙️",
      dbTag: "life",
    ),
    CategoriesClass(
        id: 4,
        title: "Tasks",
        desc: "work motivation",
        imageUrl: "assets/images/tasks.svg",
        emoji: "📝",
        dbTag: "task"),
    CategoriesClass(
      id: 5,
      title: "Environment",
      desc: "inspiration to save our earth",
      imageUrl: "assets/images/env.svg",
      emoji: "🌍",
      dbTag: "env",
    ),
    CategoriesClass(
        id: 6,
        title: "Friendship",
        desc: "sunshine of life",
        imageUrl: "assets/images/friendship.svg",
        emoji: "👭",
        dbTag: "friendship"),
    CategoriesClass(
        id: 7,
        title: "Health",
        desc: "quotes values",
        imageUrl: "assets/images/health.svg",
        emoji: "🏥",
        dbTag: "health"),
    CategoriesClass(
        id: 8,
        title: "Relationships",
        desc: "spread love",
        imageUrl: "assets/images/relationships.svg",
        emoji: "👫",
        dbTag: "relations"),
  ];
}

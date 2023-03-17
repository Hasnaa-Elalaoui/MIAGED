class Cart {
  final String userId;
  final List<String> clothesIds;

  Cart({required this.userId, required this.clothesIds});

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'clothesIds': clothesIds,
    };
  }

  Cart.fromMap(Map<String, dynamic> clothMap)
      : userId = clothMap["userId"],
        clothesIds = List<String>.from(clothMap["clothesIds"]);
}
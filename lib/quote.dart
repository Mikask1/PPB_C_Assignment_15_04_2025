class Quote {
  String text;
  String author;
  String id;
  DateTime createdAt;
  DateTime updatedAt;
  
  Quote({ required this.text, required this.author, required this.id, required this.createdAt, required this.updatedAt });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'author': author,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory Quote.fromMap(Map<String, dynamic> map) {
    return Quote(
      id: map['id'],
      text: map['text'],
      author: map['author'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }
}
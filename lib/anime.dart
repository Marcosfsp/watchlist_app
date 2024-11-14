class Anime {
  int? id; 
  final String title;
  final String description;
  final String imageUrl;

  Anime({
    this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  
  factory Anime.fromMap(Map<String, dynamic> map) {
    return Anime(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      imageUrl: map['imageUrl'],
    );
  }
}

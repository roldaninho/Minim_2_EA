class SugerenciaPublication {
  final String id;
  final String username;
  final DateTime publicationDate;
  final String content;
  final List<dynamic> comments;
  final List<dynamic> likes;

  SugerenciaPublication(
    this.id,
    this.username,
    this.publicationDate,
    this.content,
    this.comments,
    this.likes,
  );

  factory SugerenciaPublication.fromMap(Map<String, dynamic> json) {
    return SugerenciaPublication(
      json['_id'],
      json['username'],
      DateTime.parse(json['publicationDate']),
      json['content'],
      json['comments'],
      json['likes'],
    );
  }

  Map<String, dynamic> toJSON() {
    Map<String, dynamic> newJSON = {
      '_id': this.id,
      'username': this.username,
      'publicationDate': this.publicationDate,
      'content': this.content,
      'comments': this.comments,
      'likes': this.likes,
    };
    return newJSON;
  }
}

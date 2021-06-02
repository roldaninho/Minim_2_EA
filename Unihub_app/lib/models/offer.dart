class OfferApp {
  final String username;
  final String title;
  final String university;
  final String subject;
  final String type;
  final String description;
  final int price;
  final List<dynamic> comments;
  final int buys;
  final List<dynamic> likes;

  OfferApp(this.title, this.username, this.university, this.subject, this.type,
      this.description, this.price, this.comments, this.buys, this.likes);

  factory OfferApp.fromMap(Map<String, dynamic> json) {
    return OfferApp(
      json['username'],
      json['title'],
      json['university'],
      json['subject'],
      json['type'],
      json['description'],
      json['price'],
      json['comments'],
      json['buys'],
      json['likes'],
    );
  }

  Map<String, dynamic> toJSON() {
    Map<String, dynamic> newJSON = {
      'username': this.username,
      'title': this.title,
      'university': this.university,
      'subject': this.subject,
      'type': this.type,
      'description': this.description,
      'price': this.price,
      'comments': this.comments,
      'buys': this.buys,
      'likes': this.likes,
    };
    return newJSON;
  }
}

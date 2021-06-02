class Degree {
  final String name;
  final List<dynamic> subjects;

  Degree(
    this.name,
    this.subjects,
  );

  factory Degree.fromMap(Map<String, dynamic> json) {
    return Degree(
      json['name'],
      json['subjects'],
    );
  }
}

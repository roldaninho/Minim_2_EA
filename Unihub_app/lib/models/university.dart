class University {
  final String name;
  final List<dynamic> schools;

  University(
    this.name,
    this.schools,
  );

  factory University.fromMap(Map<String, dynamic> json) {
    return University(
      json['name'],
      json['schools'],
    );
  }
}

class Faculty {
  final String name;
  final List<dynamic> degrees;

  Faculty(
    this.name,
    this.degrees,
  );

  factory Faculty.fromMap(Map<String, dynamic> json) {
    return Faculty(
      json['name'],
      json['degrees'],
    );
  }
}

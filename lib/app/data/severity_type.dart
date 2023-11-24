class SeverityType {
  late final String id;
  late final String name;

  SeverityType({
    required this.id,
    required this.name,
  });

  SeverityType.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String;
    name = json['name'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;

    return data;
  }
}

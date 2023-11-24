class StaffPorterCategory {
  late final int id;
  late final String name;

  StaffPorterCategory({
    required this.id,
    required this.name,
  });

  StaffPorterCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    name = json['name'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;

    return data;
  }
}

class TrainDetails {
  late final int id;
  late final String name;

  TrainDetails({
    required this.id,
    required this.name,
  });

  TrainDetails.fromJson(Map<String, dynamic> json) {
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

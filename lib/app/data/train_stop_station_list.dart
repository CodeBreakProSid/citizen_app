class TrainStopStationList {
  int? id;
  int? train;
  String? name;

  TrainStopStationList({
    required this.id,
    required this.train,
    required this.name,
  });

  TrainStopStationList.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    train = json['train'] as int;
    name = json['name'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['train'] = train;
    data['name'] = name;

    return data;
  }
}

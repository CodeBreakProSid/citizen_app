class Train {
  late final int trainId;
  late final String trainName;

  Train({
    required this.trainId,
    required this.trainName,
  });

  Train.fromJson(Map<String, dynamic> json) {
    trainId = json['train_id'] as int;
    trainName = json['train_name'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['train_id'] = trainId;
    data['train_name'] = trainName;

    return data;
  }
}

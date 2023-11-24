class SafetyTip {
  late final int id;
  late final String videoUrl;
  late final String? imagePoster;
  late final String topic;
  late final String? thumbnails;

  SafetyTip({
    required this.id,
    required this.videoUrl,
    this.imagePoster,
    required this.topic,
    this.thumbnails,
  });

  SafetyTip.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    videoUrl = json['video_url'] as String;
    imagePoster = json['image_poster'] as String?;
    topic = json['topic'] as String;
    thumbnails = json['thumbnails'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['video_url'] = videoUrl;
    data['image_poster'] = imagePoster;
    data['topic'] = topic;
    data['thumbnails'] = thumbnails;

    return data;
  }
}

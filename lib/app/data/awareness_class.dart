class AwarenessClass {
  late final int id;
  late final int awarenessClassTopic;
  late final String awarenessClassTopicLabel;
  late final String videoUrl;
  late final String? imagePoster;
  late final String? thumbnails;

  AwarenessClass({
    required this.id,
    required this.awarenessClassTopic,
    required this.awarenessClassTopicLabel,
    required this.videoUrl,
    this.imagePoster,
    this.thumbnails,
  });

  AwarenessClass.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    awarenessClassTopic = json['awareness_class_topic'] as int;
    awarenessClassTopicLabel = json['awareness_class_topic_label'] as String;
    videoUrl = json['video_url'] as String;
    imagePoster = json['image_poster'] as String?;
    thumbnails = json['thumbnails'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['awareness_class_topic'] = awarenessClassTopic;
    data['awareness_class_topic_label'] = awarenessClassTopicLabel;
    data['video_url'] = videoUrl;
    data['image_poster'] = imagePoster;
    data['thumbnails'] = thumbnails;

    return data;
  }
}

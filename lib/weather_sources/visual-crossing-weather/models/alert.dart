import 'dart:convert';

class Alert {
  String event;
  String headline;
  int endsEpoch;
  int onsetEpoch;
  String id;
  String language;
  String? link;
  String description;

  Alert({
    required this.event,
    required this.headline,
    required this.endsEpoch,
    required this.onsetEpoch,
    required this.id,
    required this.language,
    required this.link,
    required this.description,
  });

  factory Alert.fromMap(Map<String, dynamic> map) {
    return Alert(
      event: map['event'] ?? '',
      headline: map['headline'] ?? '',
      endsEpoch: map['endsEpoch']?.toInt() ?? 0,
      onsetEpoch: map['onsetEpoch']?.toInt() ?? 0,
      id: map['id'] ?? '',
      language: map['language'] ?? '',
      link: map['link'],
      description: map['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'event': event,
      'headline': headline,
      'endsEpoch': endsEpoch,
      'onsetEpoch': onsetEpoch,
      'id': id,
      'language': language,
      'link': link,
      'description': description,
    };
  }

  String toJson() => json.encode(toMap());

  factory Alert.fromJson(String source) => Alert.fromMap(json.decode(source));
}

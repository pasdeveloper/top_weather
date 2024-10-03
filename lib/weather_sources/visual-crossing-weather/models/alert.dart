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

  factory Alert.fromJson(String source) => Alert.fromMap(json.decode(source));
}

class MqttPermission {
  final String name;
  final int subscribeLimit;
  final int publishRateLimit;
  final List<String> publish;
  final List<String> subscribe;

  MqttPermission({
    required this.name,
    required this.subscribeLimit,
    required this.publishRateLimit,
    required this.publish,
    required this.subscribe,
  });

  factory MqttPermission.fromJson(Map<String, dynamic> json) {
    return MqttPermission(
      name: json['name'] as String,
      subscribeLimit: json['subscribeLimit'] as int,
      publishRateLimit: json['publishRateLimit'] as int,
      publish: List<String>.from(json['publish'] as List),
      subscribe: List<String>.from(json['subscribe'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'subscribeLimit': subscribeLimit,
      'publishRateLimit': publishRateLimit,
      'publish': publish,
      'subscribe': subscribe,
    };
  }
}
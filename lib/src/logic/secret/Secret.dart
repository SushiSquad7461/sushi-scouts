class Secret {
  Map<String, dynamic> jsonMap;

  Secret.fromJson(this.jsonMap);

  String getApiKey(String key) {
    return jsonMap[key];
  }
}

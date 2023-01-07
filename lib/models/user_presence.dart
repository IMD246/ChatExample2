class UserPresence {
  String? id;
  final DateTime stampTime;
  bool presence = false;
  UserPresence(
    this.id,
    this.stampTime,
    this.presence,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      'stamp_time': stampTime.millisecondsSinceEpoch,
      'presence': presence,
    };
  }

  factory UserPresence.fromMap(Map<String, dynamic> map, String id) {
    return UserPresence(
      id,
      DateTime.parse(map['stamp_time']),
      map['presence'] as bool,
    );
  }

  @override
  String toString() =>
      'UserPresence(stamp_time: $stampTime, presence: $presence)';
}

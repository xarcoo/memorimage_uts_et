class UserHighscore {
  String username = "";
  int score = 0;

  UserHighscore(
    this.username,
    this.score,
  );

  UserHighscore.fromMap(Map map)
      : this.username = map['username'],
        this.score = map['score'];

  Map toMap() {
    return {
      'username': this.username,
      'score': this.score,
    };
  }
}

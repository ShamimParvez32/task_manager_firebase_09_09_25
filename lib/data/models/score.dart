/*
class FootballScore {
  final String matchName;
  final String team1Name;
  final String team2Name;
  final int team1Score;
  final int team2Score;
  final String winnerTeam;
  final bool isRunning;

  FootballScore(
      {required this.matchName,
        required this.team1Name,
        required this.team2Name,
        required this.team1Score,
        required this.team2Score,
        required this.winnerTeam,
        required this.isRunning});

  factory FootballScore.fromJson(Map<String, dynamic> json, String matchName) {
    return FootballScore(
      team1Name: json['team1_name'],
      team2Name: json['team2_name'],
      team1Score: json['team1_score'],
      team2Score: json['team2_score'],
      winnerTeam: json['winner_team'] ?? '',
      isRunning: json['is_running'],
      matchName: matchName,
    );
  }
    Map<String, dynamic> toJson(){
    return{
      'team1_name': team1Name,
      'team2_name': team2Name,
      'team1_score': team1Score,
      'team2_score': team2Score,
      'winner_team': winnerTeam,
      'is_running': isRunning,

    };

}
}*/
class FootballScore {
  final String matchName;
  final String team1Name;
  final String team2Name;
  final int team1Score;
  final int team2Score;
  final String winnerTeam;
  final bool isRunning;

  FootballScore({
    required this.matchName,
    required this.team1Name,
    required this.team2Name,
    required this.team1Score,
    required this.team2Score,
    required this.winnerTeam,
    required this.isRunning,
  });

  factory FootballScore.fromJson(Map<String, dynamic> json, String docId) {
    return FootballScore(
      matchName: json['matchName'] ?? docId, // fallback to doc id
      team1Name: json['team1_name'] ?? "Unknown",
      team2Name: json['team2_name'] ?? "Unknown",
      team1Score: (json['team1_score'] ?? 0) as int,
      team2Score: (json['team2_score'] ?? 0) as int,
      winnerTeam: json['winner_team'] ?? "TBD",
      isRunning: (json['isRunning'] ?? false) as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "matchName": matchName,
      "team1": team1Name,
      "team2": team2Name,
      "team1_score": team1Score,
      "team2_score": team2Score,
      "winner_team": winnerTeam,
      "isRunning": isRunning,
    };
  }
}

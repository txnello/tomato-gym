class SessionData {
  static List<Exercise> elements = [];
}

class Exercise {
  String exerciseName = "";
  String sets = "";
  String reps = "";
  String initWeight = "";
  bool divider = false;
  Exercise({this.exerciseName = "", this.sets = "", this.reps = "", this.initWeight = "", this.divider = false});

  factory Exercise.fromJson(Map<String, dynamic> parsedJson) {
    return Exercise(
      exerciseName: parsedJson['exerciseName'] ?? "",
      sets: parsedJson['sets'] ?? "",
      reps: parsedJson['reps'] ?? "",
      initWeight: parsedJson['initWeight'] ?? "",
      divider: parsedJson['divider'] ?? false);
  }

  Map<String, dynamic> toJson() {
    return {
      "exerciseName": exerciseName,
      "sets": sets,
      "reps": reps,
      "initWeight": initWeight,
      "divider": divider
    };
  }
}

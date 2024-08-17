class SessionData {
  static DateTime dateIncrease = DateTime.now().add(const Duration(days: 50));
  static int daysDelta = -1;

  static List<Exercise> elements = [];
}

class Exercise {
  String exerciseName = "";
  String sets = "";
  String reps = "";
  String initWeight = "";
  String currentWeight = "";
  bool divider = false;
  Exercise({this.exerciseName = "", this.sets = "", this.reps = "", this.initWeight = "", this.currentWeight = "", this.divider = false});

  factory Exercise.fromJson(Map<String, dynamic> parsedJson) {
    return Exercise(
      exerciseName: parsedJson['exerciseName'] ?? "",
      sets: parsedJson['sets'] ?? "",
      reps: parsedJson['reps'] ?? "",
      initWeight: parsedJson['initWeight'] ?? "",
      currentWeight: parsedJson['currentWeight'] ?? "",
      divider: parsedJson['divider'] ?? false);
  }

  Map<String, dynamic> toJson() {
    return {
      "exerciseName": exerciseName,
      "sets": sets,
      "reps": reps,
      "initWeight": initWeight,
      "currentWeight": currentWeight,
      "divider": divider
    };
  }
}

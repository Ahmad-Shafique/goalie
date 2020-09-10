

class BasicGoal{
  int id;
  final String goalName;
  DateTime startTime;
  DateTime endTime;
  final DateTime lastUpdated;
  bool active;
  bool completed;

  BasicGoal({this.id, this.goalName, this.startTime, this.endTime, this.lastUpdated, this.active, this.completed});

  BasicGoal.fromSQLiteMap(Map<String, dynamic> map):
        assert(map["goalName"] != null),
        id=map["id"],
        goalName=map["goalName"],
        startTime=DateTime.tryParse(map["startTime"]),
        endTime=DateTime.tryParse(map["endTime"]),
        lastUpdated=DateTime.tryParse(map["lastUpdated"]),
        active=map["active"]==1?true:false,
        completed=map["completed"]==1?true:false;

  Map<String, dynamic> toSQLiteInsertMap() {
    return {
      "goalName": this.goalName,
      "startTime": this.startTime.toString(),
      "endTime": this.endTime.toString(),
      "lastUpdated": this.lastUpdated.toString(),
      "active": this.active?1:0,
      "completed": this.completed?1:0,
    };
  }
}
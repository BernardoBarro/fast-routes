class Invite {
  String key = "";
  final String driverUid;
  final String driverName;
  final String travelKey;
  final String travelName;
  final String travelWeekDays;
  final String passagerUid;

  Invite(
      {required this.driverUid,
      required this.driverName,
      required this.travelKey,
      required this.travelName,
      required this.travelWeekDays,
      required this.passagerUid});

  factory Invite.fromRTDB(Map<String, dynamic> data) {
    return Invite(
      driverUid: data["driverUid"],
      driverName: data["driverName"],
      travelKey: data["travelKey"],
      travelName: data["travelName"],
      travelWeekDays: data["travelWeekDays"],
      passagerUid: data["passagerUid"],
    );
  }

  void setKeys(String key) {
    this.key = key;
  }
}

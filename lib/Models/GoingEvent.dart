class GoingEvent {

  String id;
  String clubName;
  String imageUrl;
  String name;
  String day;
  String month;
  String year;

  GoingEvent({
    this.id,
    this.clubName,
    this.imageUrl,
    this.name,
    this.day,
    this.month,
    this.year
  });

  Map toMap() {
    var data = Map<String, dynamic>();
    data['eventClub'] = this.clubName;
    data['eventImageUrl'] = this.imageUrl;
    data['eventName'] = this.name;
    data['eventDay'] = this.day;
    data['eventMonth'] = this.month;
    data['eventYear'] = this.year;
    return data;
  }

  GoingEvent.fromMap(Map<String, dynamic> mapData, String documentId) {
    this.id = documentId;
    this.clubName = mapData['eventClub'];
    this.imageUrl = mapData['eventImageUrl'];
    this.name = mapData['eventName'];
    this.day = mapData['eventDay'];
    this.month = mapData['eventMonth'];
    this.year = mapData['eventYear'];
  }
}

class GoingEvent {

  String id;
  String clubName;
  String imageUrl;
  String name;
  String day;
  String month;
  String year;
  bool withList;
  bool withTicket;
  bool withVip;

  GoingEvent({
    this.id,
    this.clubName,
    this.imageUrl,
    this.name,
    this.day,
    this.month,
    this.year,
    this.withList,
    this.withTicket,
    this.withVip
  });

  Map toMap() {
    var data = Map<String, dynamic>();
    data['eventClub'] = this.clubName;
    data['eventImageUrl'] = this.imageUrl;
    data['eventName'] = this.name;
    data['eventDay'] = this.day;
    data['eventMonth'] = this.month;
    data['eventYear'] = this.year;
    data['withList'] = this.withList;
    data['withTicket'] = this.withTicket;
    data['withVip'] = this.withVip;
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
    this.withList = mapData['withList'];
    this.withTicket = mapData['withTicket'];
    this.withVip = mapData['withVip'];
  }
}

class FavoriteClub {

  String id;
  String imageUrl;
  String name;


  FavoriteClub({
    this.id,
    this.imageUrl,
    this.name,
  });

  Map toMap() {
    var data = Map<String, dynamic>();
    data['id'] = this.id;
    data['clubImageUrl'] = this.imageUrl;
    data['clubName'] = this.name;
    return data;
  }

  FavoriteClub.fromMap(Map<String, dynamic> mapData, String documentId) {
    this.id = documentId;
    this.imageUrl = mapData['clubImageUrl'];
    this.name = mapData['clubName'];
  }
}

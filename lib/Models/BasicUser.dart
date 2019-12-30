class BasicUser {

  String id;
  String imageUrl;
  String name;

  BasicUser({
    this.id,
    this.imageUrl,
    this.name,
  });

  Map toMap() {
    var data = Map<String, dynamic>();
    data['userImageUrl'] = this.imageUrl;
    data['userName'] = this.name;
    return data;
  }

  BasicUser.fromMap(Map<String, dynamic> mapData, String documentId) {
    this.id = documentId;
    this.imageUrl = mapData['userImageUrl'];
    this.name = mapData['userName'];
  }
}
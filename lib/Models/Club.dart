class Club {
  String id;
  String address;
  String cid;
  String city;
  String email;
  String description;
  String imageUrl;

  String latitude;
  String longitude;

  String name;
  String phone;
  List<String> searchNames;
  String web;

  String stars;


  Club.fromMap(Map<String, dynamic> mapData, String documentId) {
    this.id = documentId;
    this.address = mapData['address'];
    this.cid = mapData['cid'];
    this.city = mapData['city'];
    this.email = mapData['email'];
    this.description = mapData['description'];
    this.imageUrl = mapData['imageUrl'];
    this.latitude = mapData['latitude'].toString();
    this.longitude = mapData['longitude'].toString();
    this.name = mapData['name'];
    this.phone = mapData['phone'];
    this.stars = mapData['stars'].toString();

    if(mapData['searchNames'] != null ) this.searchNames = mapData['searchNames'].cast<String>();
    else this.searchNames = new List<String>();

    this.web = mapData['web'];

  }
}
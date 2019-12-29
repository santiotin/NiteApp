class User {

  String id;
  String age;
  String city;
  String email;
  String imageUrl;
  String name;
  String numEvents;
  String numFollowers;
  String numFollowing;
  String sex;
  String uid;

  List<String> phones;
  List<String> searchNames;



  User({
    this.id,
    this.age,
    this.city,
    this.email,
    this.imageUrl,
    this.name,
    this.numEvents,
    this.numFollowers,
    this.numFollowing,
    this.phones,
    this.searchNames,
    this.sex,
    this.uid
  });

  Map toMap(User user) {
    var data = Map<String, dynamic>();
    data['age'] = user.age;
    data['city'] = user.city;
    data['email'] = user.email;
    data['imageUrl'] = user.imageUrl;
    data['name'] = user.name;
    data['numEvents'] = user.numEvents;
    data['posts'] = user.numFollowers;
    data['numFollowers'] = user.numFollowing;
    data['phones'] = user.phones;
    data['searchNames'] = user.searchNames;
    data['uid'] = user.uid;
    data['sex'] = user.sex;
    return data;
  }

  User.fromMap(Map<String, dynamic> mapData, String documentId) {
    this.id = documentId;
    this.age = mapData['age'].toString();
    this.city = mapData['city'].toString();
    this.email = mapData['email'].toString();
    this.imageUrl = mapData['imageUrl'].toString();
    this.name = mapData['name'].toString();
    this.numEvents = mapData['numEvents'].toString();
    this.numFollowers = mapData['numFollowers'].toString();
    this.numFollowing = mapData['numFollowing'].toString();

    if(mapData['phones'] != null ) this.phones = mapData['phones'].cast<String>();
    else this.phones = new List<String>();

    if(mapData['searchNames'] != null ) this.searchNames = mapData['searchNames'].cast<String>();
    else this.searchNames = new List<String>();

    this.uid = mapData['uid'].toString();
    this.sex = mapData['sex'].toString();
  }
}

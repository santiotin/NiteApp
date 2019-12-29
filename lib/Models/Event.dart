import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String id;
  String address;
  String ageF;
  String ageM;
  String city;
  String clubId;
  String clubImageUrl;
  String clubName;
  String day;
  String description;
  String dressCode;
  String endHour;

  bool hasList;
  bool hasTicket;
  bool hasVip;
  bool isSponsored;

  String imageUrl;

  String latitude;

  String listPrice;
  String listDescr;

  String longitude;

  String month;
  List<String> musicType;
  String name;

  String numAssists;
  String priority;

  List<String> searchNames;
  String startHour;
  String ticketPrice;
  String ticketDescr;
  String vipPrice;
  String vipDescr;
  String webPay;
  String year;


  Event.fromMap(Map<String, dynamic> mapData, String documentId) {
    this.id = documentId;
    this.address = mapData['address'];
    this.ageF = mapData['ageF'];
    this.ageM = mapData['ageM'];
    this.city = mapData['city'];
    this.clubId = mapData['clubId'];
    this.clubImageUrl = mapData['clubImageUrl'];
    this.clubName = mapData['clubName'];
    this.day = mapData['day'];
    this.description = mapData['description'];
    this.dressCode = mapData['dressCode'];
    this.endHour = mapData['endHour'];
    this.hasList = mapData['hasList'];
    this.hasTicket = mapData['hasTicket'];
    this.hasVip = mapData['hasVip'];
    this.imageUrl = mapData['imageUrl'];
    this.isSponsored = mapData['isSponsored'];
    this.latitude = mapData['latitude'].toString();
    this.listPrice = mapData['listPrice'];
    this.listDescr = mapData['listText'];
    this.longitude = mapData['longitude'].toString();
    this.month = mapData['month'].toString();

    if(mapData['musicType'] != null ) this.musicType = mapData['musicType'].cast<String>();
    else this.musicType = new List<String>();

    this.name = mapData['name'];
    this.numAssists = mapData['numAssists'].toString();
    this.priority = mapData['priority'].toString();

    if(mapData['searchNames'] != null ) this.searchNames = mapData['searchNames'].cast<String>();
    else this.searchNames = new List<String>();

    this.startHour = mapData['startHour'];
    this.ticketPrice = mapData['ticketPrice'];
    this.ticketDescr = mapData['ticketText'];
    this.vipPrice = mapData['vipPrice'];
    this.vipDescr = mapData['vipText'];
    this.webPay = mapData['webPay'];
    this.year = mapData['year'];

  }

  List<Event> snapshotToEvents(List<DocumentSnapshot> documents) {
    List<Event> events = new List<Event>();
    for(int i = 0; i < documents.length; i++) {
      events.add(Event.fromMap(documents[i].data, documents[i].documentID));
    }
    return events;
  }
}
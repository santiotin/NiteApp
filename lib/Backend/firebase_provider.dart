import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:niteapp/Models/Club.dart';
import 'package:niteapp/Models/FavoriteClub.dart';
import 'package:niteapp/Models/BasicUser.dart';
import 'package:niteapp/Models/GoingEvent.dart';
import 'package:niteapp/Models/User.dart';
import 'package:niteapp/Models/Event.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseProvider {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;


  Future<int> signIn(String email, String password) async {
    bool error = false;
    AuthResult authResult = await _auth
        .signInWithEmailAndPassword(
          email: email,
          password: password)
        .catchError((value){
            error = true;
        });

    if(error) return -1;
    if(authResult == null) return -1;
    if(authResult.user != null){
      if(authResult.user.isEmailVerified)return 0;
      else return -2;
    }
    else return -1;
  }
  Future<void> signOut() async {
    return await _auth.signOut();
  }

  Future<bool> checkCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    if(currentUser != null) return true;
    else return false;
  }
  Future<bool> checkIfItsMe(String uid) async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    if(currentUser.uid == uid) return true;
    else return false;
  }
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    return currentUser;
  }
  Future<User> getCurrentUserDetails() async {
    FirebaseUser currentUser = await getCurrentUser();
    DocumentSnapshot _documentSnapshot = await _firestore.collection("users").document(currentUser.uid).get();
    return User.fromMap(_documentSnapshot.data, _documentSnapshot.documentID);
  }

  Future<void> updateCurrentUserName(String name, List<String> searchNames) async {
    FirebaseUser currentUser = await getCurrentUser();
    await _firestore.collection("users").document(currentUser.uid).updateData({
      "name": name,
      "searchNames": searchNames,
    });
  }
  Future<void> updateCurrentUserCity(String city) async {
    FirebaseUser currentUser = await getCurrentUser();
    await _firestore.collection("users").document(currentUser.uid).updateData({
      "city": city,
    });
  }
  Future<void> updateCurrentUserAge(String age) async {
    FirebaseUser currentUser = await getCurrentUser();
    await _firestore.collection("users").document(currentUser.uid).updateData({
      "age": age,
    });
  }
  Future<void> updateCurrentUserSex(String sex) async {
    FirebaseUser currentUser = await getCurrentUser();
    await _firestore.collection("users").document(currentUser.uid).updateData({
      "sex": sex,
    });
  }
  Future<void> updateCurrentUserPhone(List<String> phones ) async {
    FirebaseUser currentUser = await getCurrentUser();
    await _firestore.collection("users").document(currentUser.uid).updateData({
      "phones": phones,
    });
  }

  Future<bool> addUser(String email, String password, String name, String city, String age, String sex, List<String> searchNames, List<String> phones) async {
    bool firebaseUser;
    bool firestoreUser;
    await _auth
        .createUserWithEmailAndPassword(
          email: email,
          password: password )
        .whenComplete(() {
          firebaseUser = true;
        })
        .catchError((err) {
          print(err);
          firebaseUser = false;
        })
        .then((result) async {
           await _firestore
              .collection("users")
              .document(result.user.uid)
              .setData({
                "name": name,
                "email": email,
                "city": city,
                "age": age,
                "sex": sex,
                "numEvents": 0,
                "numFollowers": 0,
                "numFollowing": 0,
                "searchNames": searchNames,
                "phones": phones,
                "imageUrl": "https://firebasestorage.googleapis.com/v0/b/nitedevelopment-5e197.appspot.com/o/userPics%2FniteLogoBcn.png?alt=media&token=a92e534a-52c2-497e-b974-eb45e8bdd14b",
              })
              .whenComplete(() {
                firestoreUser = true;
              })
              .catchError((err) {
                print(err);
                firestoreUser = false;
              });
           await result.user.sendEmailVerification();
    });

    return firebaseUser && firestoreUser;

  }

  Future<bool> isFollower(String uid) async {
    FirebaseUser currentUser = await getCurrentUser();
    DocumentSnapshot documentSnapshot = await _firestore
        .collection('users').document(currentUser.uid)
        .collection('followers').document(uid)
        .get();

    if(documentSnapshot != null && documentSnapshot.exists) return true;
    else return false;
  }
  Future<bool> isFollowing(String uid) async {
    FirebaseUser currentUser = await getCurrentUser();
    DocumentSnapshot documentSnapshot = await _firestore
        .collection('users').document(currentUser.uid)
        .collection('following').document(uid)
        .get();

    if(documentSnapshot != null && documentSnapshot.exists) return true;
    else return false;
  }
  Future<bool> unFollowUser(String uid) async {
    bool result = false;
    FirebaseUser currentUser = await getCurrentUser();
    await _firestore
        .collection('users').document(currentUser.uid)
        .collection('following').document(uid)
        .delete()
        .whenComplete(() {
          result = true;
        })
        .catchError((err) {
          print(err);
          result = false;
        });

    return result;

  }
  Future<bool> followUser(User user) async {
    bool result = false;
    FirebaseUser currentUser = await getCurrentUser();
    BasicUser basicUser = new BasicUser(id: user.id, imageUrl: user.imageUrl, name: user.name);
    await _firestore
        .collection('users').document(currentUser.uid)
        .collection('following').document(user.id)
        .setData(basicUser.toMap())
        .whenComplete(() {
          result = true;
        })
        .catchError((err) {
          print(err);
          result = false;
        });

    return result;

  }


  Future<bool> isGoing(String eid) async {
    FirebaseUser currentUser = await getCurrentUser();
    DocumentSnapshot documentSnapshot = await _firestore
        .collection('users')
        .document(currentUser.uid)
        .collection('assistingEvents')
        .document(eid)
        .get();

    if(documentSnapshot != null && documentSnapshot.exists) return true;
    else return false;
  }
  Future<bool> deleteGoingEvent(String eid) async {
    bool result = false;
    FirebaseUser currentUser = await getCurrentUser();
    await _firestore
        .collection('users').document(currentUser.uid)
        .collection('assistingEvents').document(eid)
        .delete()
        .whenComplete(() {
          result = true;
        })
        .catchError((err) {
          print(err);
          result = false;
        });

    return result;

  }
  Future<bool> addGoingEvent(Event event) async {
    bool result = false;
    FirebaseUser currentUser = await getCurrentUser();
    GoingEvent goingEvent = new GoingEvent(id: event.id, clubName: event.clubName, imageUrl: event.imageUrl, name: event.name, day: event.day, month: event.month, year: event.year, withList: false, withTicket: false, withVip: false);
    await _firestore
        .collection('users').document(currentUser.uid)
        .collection('assistingEvents').document(event.id)
        .setData(goingEvent.toMap())
        .whenComplete(() {
          result = true;
        })
        .catchError((err) {
          print(err);
          result = false;
        });

    return result;

  }


  Future<bool> isFavoriteClub(String cid) async {
    FirebaseUser currentUser = await getCurrentUser();
    DocumentSnapshot documentSnapshot = await _firestore
        .collection('users')
        .document(currentUser.uid)
        .collection('favoriteClubs')
        .document(cid)
        .get();

    if(documentSnapshot != null && documentSnapshot.exists) return true;
    else return false;
  }
  Future<bool> deleteFavoriteClub(String cid) async {
    bool result = false;
    FirebaseUser currentUser = await getCurrentUser();
    await _firestore
        .collection('users').document(currentUser.uid)
        .collection('favoriteClubs').document(cid)
        .delete()
        .whenComplete(() {
          result = true;
        })
        .catchError((err) {
          print(err);
          result = false;
        });

    return result;

  }
  Future<bool> addFavoriteClub(String cid) async {
    bool result = false;
    FirebaseUser currentUser = await getCurrentUser();
    Club club = await getClub(cid);
    FavoriteClub favoriteClub = new FavoriteClub(id: club.id, imageUrl: club.imageUrl, name: club.name);
    await _firestore
        .collection('users').document(currentUser.uid)
        .collection('favoriteClubs').document(club.id)
        .setData(favoriteClub.toMap())
        .whenComplete(() {
          result = true;
        })
        .catchError((err) {
          print(err);
          result = false;
        });

    return result;

  }


  Future<bool> isInList(String eid) async {
    FirebaseUser currentUser = await getCurrentUser();
    DocumentSnapshot documentSnapshot = await _firestore
        .collection('events').document(eid)
        .collection('list').document(currentUser.uid)
        .get();

    if(documentSnapshot != null && documentSnapshot.exists) return true;
    else return false;
  }
  Future<bool> deleteOfList(String eid) async {
    bool result = false;
    FirebaseUser currentUser = await getCurrentUser();
    await _firestore
        .collection('events').document(eid)
        .collection('list').document(currentUser.uid)
        .delete()
        .whenComplete(() {
          result = true;
        })
        .catchError((err) {
          print(err);
          result = false;
        });

    await _firestore
        .collection('users').document(currentUser.uid)
        .collection('assistingEvents').document(eid)
        .updateData({
      "withList": false,
    });

    return result;

  }
  Future<bool> addToList(Event event) async {
    bool result = false;
    FirebaseUser currentUser = await getCurrentUser();
    User user = await getCurrentUserDetails();
    await _firestore
        .collection('events').document(event.id)
        .collection('list').document(currentUser.uid)
        .setData({
          'userName': user.name,
        })
        .whenComplete(() {
          result = true;
        })
        .catchError((err) {
          print(err);
          result = false;
        });

    await _firestore
          .collection('users').document(currentUser.uid)
          .collection('assistingEvents').document(event.id)
          .updateData({
            "withList": true,
    });

    return result;

  }

  Future<Club> getClub(String cid) async {
    DocumentSnapshot _documentSnapshot = await _firestore.collection("clubs").document(cid).get();
    return Club.fromMap(_documentSnapshot.data, _documentSnapshot.documentID);
  }

  Future<List<User>> getUsersInApp(List<String> phones) async {
    List<User> users = new List<User>();

    for(int i = 0; i < phones.length; i++) {
      QuerySnapshot querySnapshot = await _firestore.collection("users").where("phones", arrayContains: phones[i]).getDocuments();
      for(int i = 0; i < querySnapshot.documents.length; i++) {
        users.add(User.fromMap(querySnapshot.documents[i].data, querySnapshot.documents[i].documentID));
      }
    }
    return users;

  }

  Future<List<User>> getUserInApp(String phone) async {
    List<User> users = new List<User>();
    QuerySnapshot querySnapshot = await _firestore.collection("users").where("phones", arrayContains: phone).getDocuments();
    for(int i = 0; i < querySnapshot.documents.length; i++) {
      users.add(User.fromMap(querySnapshot.documents[i].data, querySnapshot.documents[i].documentID));
    }
    return users;
  }

  Future<bool> uploadPhoto(File image) async {
    FirebaseUser currentUser = await getCurrentUser();
    StorageTaskSnapshot storageTaskSnapshot = await _firebaseStorage.ref().child("userPics/" + currentUser.uid + ".png").putFile(image).onComplete;
    if(storageTaskSnapshot != null) return true;
    else return false;
  }


  //----------------------------------------------------------STREAMS-------------------------------------------------------------------


  Stream<QuerySnapshot> getEvents(String day, String month, String year) {
    return _firestore.collection("events")
        .where("year", isEqualTo: year)
        .where("month", isEqualTo: month)
        .where("day", isEqualTo: day)
        .snapshots();
  }
  Stream<QuerySnapshot> getSponsoredEvents(String day, String month, String year) {
    return _firestore.collection("events")
        .where("isSponsored", isEqualTo: true)
        .where("year", isEqualTo: year)
        .where("month", isEqualTo: month)
        .where("day", isEqualTo: day)
        .snapshots();
  }
  Stream<DocumentSnapshot> getEvent(String eid) {
    return _firestore
        .collection("events").document(eid)
        .snapshots();
  }

  Stream<QuerySnapshot> getGoingEvents(String uid) {
    return _firestore
        .collection("users").document(uid)
        .collection("assistingEvents")
        .orderBy("eventYear",descending: true)
        .orderBy("eventMonth",descending: true)
        .orderBy("eventDay", descending: true)
        .snapshots();
  }
  Stream<DocumentSnapshot> getGoingEvent(String uid, String eid) {
    return _firestore
        .collection("users").document(uid)
        .collection("assistingEvents").document(eid)
        .snapshots();
  }

  Stream<DocumentSnapshot> getUser(String uid) {
    return _firestore
        .collection("users").document(uid)
        .snapshots();
  }
  Stream<QuerySnapshot> getGoingUsers(String eid){
    return _firestore
        .collection("events").document(eid)
        .collection("assistingUsers")
        .orderBy("userName")
        .snapshots();
  }

  Stream<QuerySnapshot> getSearchEvents(String searchNames) {
    return _firestore
        .collection("events")
        .where("searchNames", arrayContains: searchNames.toLowerCase())
        .snapshots();
  }
  Stream<QuerySnapshot> getSearchUsers(String searchNames) {
    return _firestore
        .collection("users")
        .where("searchNames", arrayContains: searchNames.toLowerCase())
        .snapshots();
  }
  Stream<QuerySnapshot> getSearchClubs(String searchNames) {
    return _firestore
        .collection("clubs")
        .where("searchNames", arrayContains: searchNames.toLowerCase())
        .snapshots();
  }

  Stream<QuerySnapshot> getRequests(String uid) {
    return _firestore
        .collection("users").document(uid)
        .collection("notiFriendshipReq")
        .orderBy("time", descending: true)
        .snapshots();
  }
  Stream<QuerySnapshot> getActivity(String uid) {
    return _firestore
        .collection("users").document(uid)
        .collection("notiFriendEvent")
        .orderBy("time", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getFollowers(String uid) {
    return _firestore
        .collection("users").document(uid)
        .collection("followers")
        .orderBy("userName")
        .snapshots();
  }
  Stream<QuerySnapshot> getFollowings(String uid) {
    return _firestore
        .collection("users").document(uid)
        .collection("following")
        .orderBy("userName")
        .snapshots();
  }
  Stream<DocumentSnapshot> getFollowing(String uid, String fid) {
    return _firestore
        .collection("users").document(uid)
        .collection("following").document(fid)
        .snapshots();
  }

  Stream<QuerySnapshot> getFavoriteClubs(String uid) {
    return _firestore
        .collection("users").document(uid)
        .collection("favoriteClubs")
        .orderBy("clubName")
        .snapshots();
  }

  Stream<DocumentSnapshot> getFavoriteClub(String uid, String cid) {
    return _firestore
        .collection("users").document(uid)
        .collection("favoriteClubs").document(cid)
        .snapshots();
  }

  Stream<DocumentSnapshot> getClubStream(String cid) {
    return _firestore
        .collection("clubs").document(cid)
        .snapshots();
  }

  Stream<QuerySnapshot> getClubEvents(String cid) {
    return _firestore.collection("events")
        .where("clubId", isEqualTo: cid)
        .snapshots();
  }
}
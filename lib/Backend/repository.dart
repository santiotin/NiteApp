import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:niteapp/Backend/firebase_provider.dart';
import 'package:niteapp/Models/Club.dart';
import 'package:niteapp/Models/Event.dart';
import 'package:niteapp/Models/User.dart';

class Repository {

  final _firebaseProvider = FirebaseProvider();

  Future<bool> signIn(String email, String password) => _firebaseProvider.signIn(email, password);
  Future<void> signOut() => _firebaseProvider.signOut();

  Future<bool> checkCurrentUser() => _firebaseProvider.checkCurrentUser();
  Future<FirebaseUser> getCurrentUser() => _firebaseProvider.getCurrentUser();
  Future<User> getCurrentUserDetails() => _firebaseProvider.getCurrentUserDetails();
  Future<void> updateCurrentUserName(String name, List<String> searchNames) => _firebaseProvider.updateCurrentUserName(name, searchNames);
  Future<void> updateCurrentUserCity(String city) => _firebaseProvider.updateCurrentUserCity(city);
  Future<void> updateCurrentUserAge(String age) => _firebaseProvider.updateCurrentUserAge(age);
  Future<void> updateCurrentUserSex(String sex) => _firebaseProvider.updateCurrentUserSex(sex);
  Future<void> updateCurrentUserPhone(List<String> phones) => _firebaseProvider.updateCurrentUserPhone(phones);

  Future<bool> addUser(String email, String password, String name, String city, String age, String sex, List<String> searchNames, List<String> phones) => _firebaseProvider.addUser(email, password, name, city, age, sex, searchNames, phones);

  Future<bool> isFollower(String uid) => _firebaseProvider.isFollower(uid);
  Future<bool> isFollowing(String uid) => _firebaseProvider.isFollowing(uid);
  Future<bool> unFollowUser(String uid) => _firebaseProvider.unFollowUser(uid);
  Future<bool> followUser(User user) => _firebaseProvider.followUser(user);

  Future<bool> isGoing(String eid) => _firebaseProvider.isGoing(eid);
  Future<bool> deleteGoingEvent(String eid) => _firebaseProvider.deleteGoingEvent(eid);
  Future<bool> addGoingEvent(Event event) => _firebaseProvider.addGoingEvent(event);

  Future<bool> isFavoriteClub(String cid) => _firebaseProvider.isFavoriteClub(cid);
  Future<bool> deleteFavoriteClub(String cid) => _firebaseProvider.deleteFavoriteClub(cid);
  Future<bool> addFavoriteClub(String cid) => _firebaseProvider.addFavoriteClub(cid);

  Future<bool> isInList(String eid) => _firebaseProvider.isInList(eid);
  Future<bool> deleteOfList(String eid) => _firebaseProvider.deleteOfList(eid);
  Future<bool> addToList(Event event) => _firebaseProvider.addToList(event);

  Future<Club> getClub(String cid) => _firebaseProvider.getClub(cid);

  Future<bool> uploadPhoto(File image) => _firebaseProvider.uploadPhoto(image);


  //----------------------------------------------------------STREAMS-------------------------------------------------------------------


  Stream<QuerySnapshot> getEvents(String day, String month, String year) => _firebaseProvider.getEvents(day, month, year);
  Stream<QuerySnapshot> getSponsoredEvents(String day, String month, String year) => _firebaseProvider.getSponsoredEvents(day, month, year);
  Stream<QuerySnapshot> getGoingEvents(String uid) => _firebaseProvider.getGoingEvents(uid);
  Stream<DocumentSnapshot> getEvent(String eid) => _firebaseProvider.getEvent(eid);
  Stream<DocumentSnapshot> getGoingEvent(String uid, String eid) => _firebaseProvider.getGoingEvent(uid, eid);

  Stream<DocumentSnapshot> getUser(String uid) => _firebaseProvider.getUser(uid);
  Stream<QuerySnapshot> getGoingUsers(String eid) => _firebaseProvider.getGoingUsers(eid);

  Stream<QuerySnapshot> getSearchEvents(String searchNames) => _firebaseProvider.getSearchEvents(searchNames);
  Stream<QuerySnapshot> getSearchUsers(String searchNames) => _firebaseProvider.getSearchUsers(searchNames);
  Stream<QuerySnapshot> getSearchClubs(String searchNames) => _firebaseProvider.getSearchClubs(searchNames);

  Stream<QuerySnapshot> getRequests(String uid) => _firebaseProvider.getRequests(uid);
  Stream<QuerySnapshot> getActivity(String uid) => _firebaseProvider.getActivity(uid);

  Stream<QuerySnapshot> getFollowers(String uid) => _firebaseProvider.getFollowers(uid);
  Stream<QuerySnapshot> getFollowings(String uid) => _firebaseProvider.getFollowings(uid);
  Stream<DocumentSnapshot> getFollowing(String uid, String fid) => _firebaseProvider.getFollowing(uid, fid);

  Stream<QuerySnapshot> getFavoriteClubs(String uid) => _firebaseProvider.getFavoriteClubs(uid);
  Stream<DocumentSnapshot> getFavoriteClub(String uid, String cid) => _firebaseProvider.getFavoriteClub(uid, cid);



}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:niteapp/Backend/repository.dart';
import 'package:niteapp/Models/FavoriteClub.dart';
import 'package:niteapp/Ui/Lists/FavoriteClubList.dart';
import 'package:niteapp/Utils/Messages.dart';

class FavoriteClubsPage extends StatefulWidget {
  final String uid;

  const FavoriteClubsPage({Key key, this.uid}) : super(key: key);

  _FavoriteClubsPageState createState() => _FavoriteClubsPageState();
}

class _FavoriteClubsPageState extends State<FavoriteClubsPage> {

  var _repository = new Repository();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis clubs favoritos'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _repository.getFavoriteClubs(widget.uid),
          builder: (context, snapshot) {
            if(snapshot == null ||snapshot.connectionState == ConnectionState.waiting || snapshot.data == null) return LoadingView();
            else if(snapshot.hasError) return ErrorView();
            else if(snapshot.data.documents.isEmpty) return EmptyFavoriteClubs(msg: 'No tienes clubs favoritos',);
            else return FavoriteClubList(favoriteClubs: documentsToFavoriteClubs(snapshot.data.documents), uid: widget.uid,);
          }
      ),
    );
  }

  List<FavoriteClub> documentsToFavoriteClubs(List<DocumentSnapshot> documents) {
    List<FavoriteClub> favoriteClubs = new List<FavoriteClub>();
    for(int i = 0; i < documents.length; i++) {
      favoriteClubs.add(FavoriteClub.fromMap(documents[i].data, documents[i].documentID));
    }
    return favoriteClubs;
  }
}
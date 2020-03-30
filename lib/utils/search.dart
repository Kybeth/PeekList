import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  searchByEmail(String searchField) {
    return Firestore.instance.collection('users')
    .where('searchKey',
    isEqualTo: searchField.substring(0, 1).toLowerCase()).getDocuments();
  }
}
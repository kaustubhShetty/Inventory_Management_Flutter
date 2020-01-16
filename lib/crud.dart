import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class crudMethods {
  Future<void> addData(qrdata) async {
    Firestore.instance.collection('data').add(qrdata).catchError((e) {
      print(e);
    });

    }
  }

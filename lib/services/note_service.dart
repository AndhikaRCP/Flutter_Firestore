import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:notes/models/note.dart';
import 'package:path/path.dart' as path;

class NoteService {
  static final FirebaseFirestore _database = FirebaseFirestore.instance;
  static final CollectionReference _notesCollection =
      _database.collection('notes');
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // static agar dapat diakses
  static Future<String?> uploadImage(File imageFile) async {
    // <-- String? untuk bisa saja ketika kondisi nya null atau kosong
    try {
      String fileName = path.basename(imageFile.path);
      Reference ref = _storage
          .ref()
          .child('images/$fileName'); // <-- untuk reference lokasi upload
      UploadTask uploadTask;
      if (kIsWeb) {
        uploadTask = ref.putData(await imageFile.readAsBytesSync());
      } else {
        uploadTask = ref.putFile(imageFile); // <-- proses mengupload file
      }

      TaskSnapshot taskSnapshot =
          await uploadTask; // <-- menunggu upload file Selesai
      String downloadUrl = await taskSnapshot.ref
          .getDownloadURL(); // <-- mengambil url dari task Snapshot
      return downloadUrl; // <-- adalah nilai yang dimasukkan ke imageUrl
    } catch (e) {
      return null; // kalau berhasil maka return null
    }
  }

  static Future<void> addNote(Note note) async {
    Map<String, dynamic> newNote = {
      'title': note.title,
      'description': note.description,
      'image_url': note.imageUrl,
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
      'latitude': note.latitude,
      'longitude': note.longitude
    };
    await _notesCollection.add(newNote);
  }

  static Future<void> updateNote(Note note) async {
    Map<String, dynamic> updatedNote = {
      'title': note.title,
      'description': note.description,
      'image_url': note.imageUrl,
      'created_at': note.createdAt,
      'updated_at': FieldValue.serverTimestamp(),
      'latitude': note.latitude,
      'longitude': note.longitude
    };

    await _notesCollection.doc(note.id).update(updatedNote);
  }

  static Future<void> deleteNote(Note note) async {
    await _notesCollection.doc(note.id).delete();
  }

  static Future<QuerySnapshot> retrieveNotes() {
    return _notesCollection.get();
  }

  static Stream<List<Note>> getNoteList() {
    return _notesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Note(
          id: doc.id,
          title: data['title'],
          description: data['description'],
          imageUrl: data['image_url'],
          latitude: data['latitude'],
          longitude: data['longitude'],
          createdAt: data['created_at'] != null
              ? data['created_at'] as Timestamp
              : null,
          updatedAt: data['updated_at'] != null
              ? data['updated_at'] as Timestamp
              : null,
        );
      }).toList();
    });
  }
}

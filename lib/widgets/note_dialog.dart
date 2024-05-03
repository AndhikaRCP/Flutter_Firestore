import 'package:flutter/material.dart';
import 'package:notes/services/note_service.dart';

class NoteDialog extends StatelessWidget {
  final Map<String, dynamic>? note;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  NoteDialog({super.key, this.note}) {
    if (note != null) {
      _titleController.text = note!['title'];
      _descriptionController.text = note!['description'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(note == null ? 'Add Notes' : 'Update Notes'),
      // Content merupakan isi utama dari dialog
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Title:',
            textAlign: TextAlign.start,
          ),
          TextField(
            controller: _titleController,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              'Description:',
              textAlign: TextAlign.start,
            ),
          ),
          TextField(
            controller: _descriptionController,
          ),
        ],
      ),
      // Action berisi kumpulan button
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel')),
        ),
        ElevatedButton(
            onPressed: () {
              // Map<String, dynamic> updateNote = {};
              // ini adalah alternatif dari yang di atas
              // Map<String, dynamic> newNote =
              //     new Map<String, dynamic>();
              // updateNote['title'] = titlecontroller.text;
              // updateNote['description'] =
              //     descriptioncontroller.text;
              // FirebaseFirestore.instance
              //     .collection('notes')
              //     .doc(document.id)
              //     .update(updateNote)
              //     .whenComplete(() {
              //   Navigator.of(context).pop();
              // });
              if (note == null) {
                NoteService.addNote(
                        _titleController.text, _descriptionController.text)
                    .whenComplete(() {
                  Navigator.of(context).pop();
                });
                _titleController.clear();
                _descriptionController.clear();
              } else {
                NoteService.updateNote(note!['id'], _titleController.text,
                        _descriptionController.text)
                    .whenComplete(() => Navigator.of(context).pop());
                _titleController.clear();
                _descriptionController.clear();
              }
            },
            child: Text(note == null ? 'Add' : 'Update')),
      ],
    );
  }
}

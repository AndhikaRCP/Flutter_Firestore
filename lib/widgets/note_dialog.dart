import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes/models/note.dart';
import 'package:notes/services/note_service.dart';

class NoteDialog extends StatefulWidget {
  final Note? note; // <-- ini berada diclass widget

  const NoteDialog({super.key, this.note});

  @override
  State<NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<NoteDialog> {
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();
  File? _imageFile; // <-- nullable

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _descriptionController.text = widget.note!.description;
    }
  }

// _pickImage() proses untuk mengambil image dari gallery
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery); //<-- file sudah terambil dari gallery
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile
            .path); // <-- mengubah nilai dari imageFile berdasarkan image yang dipilih dari path
        // dan _imageFile sudah berisi data gambar dan bisa untuk dishow
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.note == null ? 'Add Notes' : 'Update Notes'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Title: ',
            textAlign: TextAlign.start,
          ),
          TextField(
            controller: _titleController,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              'Description: ',
            ),
          ),
          TextField(
            controller: _descriptionController,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              'Image: ',
            ),
          ),
          Expanded(
            child: _imageFile != null
                ? Image.file(
                    _imageFile!,
                    fit: BoxFit.cover,
                  )
                : (widget.note?.imageUrl != null &&
                        Uri.parse(widget.note!.imageUrl!).isAbsolute
                    ? Image.network(
                        widget.note!.imageUrl!,
                        fit: BoxFit.cover,
                      )
                    : Container()),
          ),
          _imageFile != null ? Image.file(_imageFile!) : Container(),
          TextButton(onPressed: _pickImage, child: const Text('Pick Image')),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            String? imageUrl;
            if (_imageFile != null) {
              imageUrl = await NoteService.uploadImage(
                  _imageFile!); // <-- cek apakah variabel ada atau belum, kalau ada do upload
            } else {
              imageUrl = widget.note?.imageUrl;
            }
            Note note = Note(
                id: widget.note?.id,
                title: _titleController.text,
                imageUrl: imageUrl,
                description: _descriptionController.text,
                createdAt: widget.note?.createdAt);

            if (widget.note == null) {
              NoteService.addNote(note).whenComplete(() {
                Navigator.of(context).pop();
              });
            } else {
              NoteService.updateNote(note)
                  .whenComplete(() => Navigator.of(context).pop());
            }
          },
          child: Text(widget.note == null ? 'Add' : 'Update'),
        ),
      ],
    );
  }
}

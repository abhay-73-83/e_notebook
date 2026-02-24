import 'dart:io';
import 'package:e_notebook/Widgets/Custom_Appbar/Custom_Appbar.dart';
import 'package:flutter/material.dart';
import '../../DBHelper/DBHelper.dart';

class ViewNote extends StatelessWidget {
  final Map<String, dynamic> note;

  const ViewNote({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    print('ViewNote received map: $note');

    final imagePath =
        (note[DBHelper.noteImg] ?? note['img'] ?? note['NoteImg'] ?? '')
            as String;
    final title =
        (note[DBHelper.noteTitle] ??
                note['title'] ??
                note['Title'] ??
                note['noteTitle'] ??
                note['NoteTitle'] ??
                "Untitled Note")
            as String;
    final subtitle =
        (note[DBHelper.noteSubTitle] ??
                note['subtitle'] ??
                note['NoteSubTitle'] ??
                '')
            as String;
    final description =
        (note[DBHelper.noteDescription] ??
                note['description'] ??
                note['noteDesc'] ??
                note['NoteDescription'] ??
                '')
            as String;

    final hasImage = imagePath.isNotEmpty && File(imagePath).existsSync();

    return Scaffold(
      appBar: CustomAppbar(appbarTitle: title, appbarcenterTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasImage)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(File(imagePath), fit: BoxFit.cover),
              )
            else
              Container(
                height: 200,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.image_not_supported,
                  size: 60,
                  color: Colors.grey,
                ),
              ),

            SizedBox(height: 20),

            Text(
              title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            if (subtitle.isNotEmpty)
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Colors.black54,
                ),
              ),

            SizedBox(height: 16),

            Text(description, style: TextStyle(fontSize: 16, height: 1.5)),
          ],
        ),
      ),
    );
  }
}

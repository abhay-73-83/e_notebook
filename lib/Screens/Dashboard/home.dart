import 'dart:io';
import 'package:e_notebook/Screens/Add_Note/Add_Note.dart';
import 'package:e_notebook/Screens/Update_Note/Update_Note.dart';
import 'package:e_notebook/Screens/View%20Note/viewNote.dart';
import 'package:e_notebook/Widgets/Custom_Appbar/Custom_Appbar.dart';
import 'package:e_notebook/Widgets/Custom_Loader/Custom_Loader.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../DBHelper/DBHelper.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> noteList = [];
  final dbHelper = DBHelper.instance;
  bool isLoading = true;

  Future<void> fetchNotes() async {
    setState(() => isLoading = true);
    final data = await dbHelper.viewNoteData();
    await Future.delayed( Duration(milliseconds: 800)); // shimmer delay
    setState(() {
      noteList = data;
      isLoading = false;
    });
  }

  Future<void> deleteNote(int id) async {
    await dbHelper.deleteNoteData(id);
    fetchNotes();
  }

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  /// Shimmer loading UI
  Widget buildShimmerGrid() {
    return GridView.builder(
      itemCount: 6,
      gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius:  BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 20,
                  margin:  EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Confirm delete dialog
  Future<void> confirmDelete(int id) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title:  Text("Delete Note"),
        content:  Text("Are you sure you want to delete this note?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child:  Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child:  Text("Delete"),
          ),
        ],
      ),
    );

    if (result == true) {
      await deleteNote(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        appbarTitle: 'E - Note',
        appbarcenterTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  AddNote()),
              );
              fetchNotes();
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: isLoading
          ? CustomLoader()
          : noteList.isEmpty
          ?  Center(child: Text("No notes available"))
          : Padding(
        padding:  EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: noteList.length,
          gridDelegate:
           SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            final note = noteList[index];
            final noteId = note[DBHelper.noteId] as int?;
            final imagePath = note[DBHelper.noteImg] as String?;
            final title = note[DBHelper.noteTitle] ?? "";
            // final subtitle = note[DBHelper.noteSubTitle] ?? "";
            // final description = note[DBHelper.noteDescription] ?? "";

            final hasImage = imagePath != null &&
                imagePath.isNotEmpty &&
                File(imagePath).existsSync();

            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius:  BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: hasImage
                          ? Image.file(File(imagePath),
                          fit: BoxFit.cover)
                          : Container(
                        color: Colors.grey[300],
                        alignment: Alignment.center,
                        child:  Icon(
                          Icons.image_not_supported,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            textAlign: TextAlign.center,
                            style:  TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'View') {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ViewNote(note: note),
                                ),
                              );
                            } else if (value == 'Edit') {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UpdateNote(note: note),
                                ),
                              );
                              if (result == true) fetchNotes();
                            } else if (value == 'Delete') {
                              if (noteId != null) {
                                confirmDelete(noteId);
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                   SnackBar(
                                    content: Text(
                                        "Error: Note ID is missing"),
                                  ),
                                );
                              }
                            }
                          },
                          itemBuilder: (context) => [
                             PopupMenuItem(
                              value: 'View',
                              child: Row(
                                children: [
                                  Icon(Icons.notes,
                                      color: Color(0xffF9D5E5)),
                                  SizedBox(width: 8),
                                  Text("View"),
                                ],
                              ),
                            ),
                             PopupMenuItem(
                              value: 'Edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit,
                                      color: Color(0xffF9D5E5)),
                                  SizedBox(width: 8),
                                  Text("Edit"),
                                ],
                              ),
                            ),
                             PopupMenuItem(
                              value: 'Delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete,
                                      color: Colors.red),
                                  SizedBox(width: 8),
                                  Text("Delete"),
                                ],
                              ),
                            ),
                          ],
                          icon:  Icon(Icons.more_vert),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:e_notebook/DBHelper/DBHelper.dart';
import 'package:e_notebook/Widgets/Common_Textfields/common_textfields.dart';
import 'package:e_notebook/Widgets/Custom_Appbar/Custom_Appbar.dart';
import 'package:e_notebook/Widgets/Custom_Button/Custom_Button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final _addNote = GlobalKey<FormState>();

  TextEditingController title = TextEditingController();
  TextEditingController subtitle = TextEditingController();
  TextEditingController note = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? imageFile;
  final dbHelper = DBHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(appbarTitle: 'Add Note', appbarcenterTitle: true),
      body: SingleChildScrollView(
        child: Form(
          key: _addNote,
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              children: [
                SizedBox(height: 15.0),
                InkWell(
                  onTap: () async {
                    final XFile? pickedImg = await _picker.pickImage(
                      source: ImageSource.gallery,
                    );

                    if (pickedImg != null) {
                      setState(() {
                        imageFile = File(pickedImg.path);
                      });
                    }
                  },
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color(0xffF9D5E5),
                          Color(0xffB8A9D9),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      image: imageFile != null
                          ? DecorationImage(
                              image: FileImage(imageFile!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: imageFile == null
                        ? Center(
                            child: Icon(
                              Icons.image,
                              color: Colors.white,
                              size: 40,
                            ),
                          )
                        : null,
                  ),
                ),

                SizedBox(height: 15.0),
                CommonTextField(
                  inputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  controller: title,
                  hintText: 'Enter Title',
                  labelText: 'Title',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15.0),
                CommonTextField(
                  inputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  controller: subtitle,
                  hintText: 'Enter Subtitle',
                  labelText: 'Subtitle',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter SubTitle';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15.0),
                CommonTextField(
                  inputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  controller: note,
                  hintText: 'Add Note',
                  labelText: 'Note',
                  maxLine: null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Note';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 50.0),
                CustomButton(
                  buttonText: 'Create Note',
                  onPressed: () async {
                    if (_addNote.currentState!.validate()) {
                      await _insertData();
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please fill all fields!')),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _insertData() async {
    final imagePath = imageFile?.path ?? '';

    Map<String, dynamic> row = {
      DBHelper.noteImg: imagePath,
      DBHelper.noteTitle: title.text,
      DBHelper.noteSubTitle: subtitle.text,
      DBHelper.noteDescription: note.text,
    };

    print('Insert Data in table');
    final id = await dbHelper.insertNoteData(row);
    print('Inserted row id: $id');
  }
}

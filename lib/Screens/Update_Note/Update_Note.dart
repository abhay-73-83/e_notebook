import 'dart:io';
import 'package:e_notebook/DBHelper/DBHelper.dart';
import 'package:e_notebook/Widgets/Common_Textfields/common_textfields.dart';
import 'package:e_notebook/Widgets/Custom_Appbar/Custom_Appbar.dart';
import 'package:e_notebook/Widgets/Custom_Button/Custom_Button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateNote extends StatefulWidget {
  final Map<String, dynamic> note;

  const UpdateNote({super.key, required this.note});

  @override
  State<UpdateNote> createState() => _UpdateNoteState();
}

class _UpdateNoteState extends State<UpdateNote> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late TextEditingController subtitleController;
  late TextEditingController descController;

  File? imageFile;
  final ImagePicker _picker = ImagePicker();
  final dbHelper = DBHelper.instance;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note[DBHelper.noteTitle]);
    subtitleController = TextEditingController(text: widget.note[DBHelper.noteSubTitle]);
    descController = TextEditingController(text: widget.note[DBHelper.noteDescription]);

    final imgPath = widget.note[DBHelper.noteImg];
    if (imgPath != null && imgPath.isNotEmpty) {
      imageFile = File(imgPath);
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateNote() async {
    final updatedNote = {
      DBHelper.noteId: widget.note[DBHelper.noteId],
      DBHelper.noteTitle: titleController.text.trim(),
      DBHelper.noteSubTitle: subtitleController.text.trim(),
      DBHelper.noteDescription: descController.text.trim(),
      DBHelper.noteImg: imageFile?.path ?? '',
    };
    await dbHelper.updateNoteData(updatedNote);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(appbarTitle: 'Edit Note', appbarcenterTitle: true),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding:  EdgeInsets.all(12.0),
            child: Column(
              children: [
                 SizedBox(height: 15.0),
                InkWell(
                  onTap: pickImage,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.shade800,
                          Colors.lightBlue.shade300,
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
                        ?  Center(
                      child: Icon(Icons.image, color: Colors.white, size: 40),
                    )
                        : null,
                  ),
                ),
                 SizedBox(height: 15.0),
                CommonTextField(
                  inputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  controller: titleController,
                  hintText: 'Enter Title',
                  labelText: 'Title',
                  validator: (value) => (value == null || value.isEmpty) ? 'Please Enter Title' : null,
                ),
                 SizedBox(height: 15.0),
                CommonTextField(
                  inputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  controller: subtitleController,
                  hintText: 'Enter Subtitle',
                  labelText: 'Subtitle',
                  validator: (value) => (value == null || value.isEmpty) ? 'Please Enter Subtitle' : null,
                ),
                 SizedBox(height: 15.0),
                CommonTextField(
                  inputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  controller: descController,
                  hintText: 'Add Note',
                  labelText: 'Note',
                  maxLine: null,
                  validator: (value) => (value == null || value.isEmpty) ? 'Please Enter Note' : null,
                ),
                 SizedBox(height: 50.0),
                CustomButton(
                  buttonText: 'Update Note',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _updateNote();
                      Navigator.pop(context, true);
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
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/notes.dart';
import 'package:flutter_app/utils/database_helper.dart';
import 'package:flutter_app/screens/note_detail.dart';
import 'package:sqflite/sqflite.dart';

class TaskDetail extends StatefulWidget {

  final String appBarTitle;
  final Note note;

  TaskDetail(this.note, this.appBarTitle);
  @override
  State<StatefulWidget> createState() {

    return NoteDetailState(this.note, this.appBarTitle);
  }
}

class AccentColorOverride extends StatelessWidget {
  const AccentColorOverride({Key key, this.color, this.child})
      : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      child: child,
      data: Theme.of(context).copyWith(
        accentColor: color,
        brightness: Brightness.dark,
      ),
    );
  }
}

class NoteDetailState extends State<TaskDetail> {
  DatabaseHelper helper = DatabaseHelper();
  String appBarTitle;
  Note note;
  NoteDetailState(this.note, this.appBarTitle);
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    titleController.text = note.title;
    descriptionController.text = note.description;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            appBarTitle,
            style: TextStyle(
              fontFamily: 'Product Sans',
              fontWeight: FontWeight.bold,
            )
        ),
        elevation: 0.0,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          children: <Widget>[
            SizedBox(height: 60.0),
            AccentColorOverride(
              color: Colors.deepPurple[200],
              child: TextField(
                style: TextStyle(
                  fontFamily: 'Product Sans',
                  fontWeight: FontWeight.bold,
                    color: Colors.black
                ),
                onChanged: (value) {
                  updateTitle();
                },
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'New Task',
                ),
              ),
            ),
            SizedBox(height: 12.0),
            AccentColorOverride(
              color: Colors.deepPurple[200],
              child: TextField(
                style: TextStyle(
                  fontFamily: 'Product Sans',
                  fontWeight: FontWeight.bold,
                    color: Colors.black
                ),
                onChanged: (value){
                  updateDescription();
                },
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
              ),
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: Text('Delete',
                  ),
                  onPressed: () {
                    setState(() {
                      titleController.clear();
                      descriptionController.clear();
                      _delete();
                    });
                  },
                ),
                RaisedButton(
                  child: Text('Save',
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),),
                  color: Colors.deepPurpleAccent,
                  onPressed: () {
                    setState(() {
                      _save();
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),

    );
  }


  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void updateTitle() {
    note.title = titleController.text;
  }

  void updateDescription () {
    note.description = descriptionController.text;
  }

  void _save() async {
    moveToLastScreen();
    note.date = DateTime.now().toString();
    int result;
    if (note.id != null){
      result = await helper.updateNote(note);
    } else {
      result = await helper.insertNote(note);
    }
    if (result !=0) {
      _showAlertDialog('Status', 'Saved');
    } else{
      _showAlertDialog('Status', 'Oops! Not Saved');
    }
  }

  void _showAlertDialog(String title, String message){

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message)
    );
    showDialog(context: context, builder:  (_) => alertDialog);
  }

  void _delete() async {
    moveToLastScreen();
    // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (note.id == null) {
      _showAlertDialog('Status', 'No Note was deleted');
      return;
    }

    // Case 2: User is trying to delete the old note that already has a valid ID.
    int result = await helper.deleteNote(note.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Deleted');
    } else {
      _showAlertDialog('Status', 'Error!');
    }
  }
}


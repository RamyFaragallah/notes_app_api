import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:notes_app_api/Models/Note.dart';
import 'package:notes_app_api/Models/note_insert.dart';
import 'package:notes_app_api/Services/NoteService.dart';

class ModifyNote extends StatefulWidget {
  Note note = new Note();
  ModifyNote({this.note});
  bool get isadding => note == null;

  @override
  _ModifyNoteState createState() => _ModifyNoteState();
}

class _ModifyNoteState extends State<ModifyNote> {
  NoteService get notesService => GetIt.I<NoteService>();

  String errorMessage;
  Note note;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  bool _isLoading = false;
  @override
  void initState() {
    if (!widget.isadding) {
      setState(() {
        _isLoading = true;
      });
      notesService.getNote(widget.note.noteID).then((response) {
        setState(() {
          _isLoading = false;
        });

        if (response.error) {
          errorMessage = response.errorMsg ?? 'An error occurred';
        }
        note = response.data;
        _titleController.text = note.noteTitle;
        _contentController.text = note.noteContent;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isadding ? "Add Note" : "Edit Note"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _titleController,
              decoration: InputDecoration(hintText: "Note Title"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _contentController,
              decoration: InputDecoration(hintText: "Note Content"),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: RaisedButton(
                onPressed: () async {
                  if (!widget.isadding) {
 setState(() {
                      _isLoading = true;
                    });
                    final note = NoteInsert(
                      noteTitle: _titleController.text,
                      noteContent: _contentController.text
                    );
                    final result = await notesService.updateNote(widget.note.noteID, note);
                    
                    setState(() {
                      _isLoading = false;
                    });

                    final title = 'Done';
                    final text = result.error ? (result.errorMsg ?? 'An error occurred') : 'Your note was updated';

                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(title),
                        content: Text(text),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Ok'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      )
                    )
                    .then((data) {
                      if (result.data) {
                        Navigator.of(context).pop();
                      }
                    });                  } else {
                    
                    setState(() {
                      _isLoading = true;
                    });
                    final note = NoteInsert(
                      noteTitle: _titleController.text,
                      noteContent: _contentController.text
                    );
                    final result = await notesService.createNote(note);
                    
                    setState(() {
                      _isLoading = false;
                    });

                    final title = 'Done';
                    final text = result.error ? (result.errorMsg ?? 'An error occurred') : 'Your note was created';

                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(title),
                        content: Text(text),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Ok'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      )
                    )
                    .then((data) {
                      if (result.data) {
                        Navigator.of(context).pop();
                      }
                    });
                  }
                },
                child: Text("Submet"),
              ))
        ],
      ),
    );
  }
}

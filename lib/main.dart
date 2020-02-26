import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'Models/ApiResponse.dart';
import 'Models/Note.dart';
import 'Screens/DeleteAlert.dart';
import 'Screens/ModifyNote.dart';
import 'Services/NoteService.dart';


void setupLocator() {
  GetIt.I.registerLazySingleton(() => NoteService());
}

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: MyHomePage(title: 'Notes list'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  NoteService get service => GetIt.I<NoteService>();

  ApiResponse<List<Note>> _apiResponse;
  bool _isLoading = false;
  @override
  void initState() {
    _fetchNotes();
    super.initState();
  }

  _fetchNotes() async {
    setState(() {
      _isLoading = true;
    });

    _apiResponse = await service.getNotesList();

    setState(() {
      _isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('List of notes')),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => ModifyNote())) .then((_) {
                  _fetchNotes();
                });
          },
          child: Icon(Icons.add),
        ),
        body: Builder(
          builder: (_) {
            if (_isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (_apiResponse.error) {
              return Center(child: Text("error ${_apiResponse.errorMsg}"));
            }

            return ListView.separated(
              separatorBuilder: (_, __) =>
                  Divider(height: 1, color: Colors.green),
              itemBuilder: (_, index) {
                return Dismissible(
                  key: ValueKey(_apiResponse.data[index].noteID),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {},
                  confirmDismiss: (direction) async {
                    final result = await showDialog(
                        context: context, builder: (_) => DeleteAlert());
                    if (result) {
                      var msg;
                      var deleteresult = await service.deleteNote(
                          _apiResponse.data[index].noteID);
                      if (deleteresult != null && deleteresult.data) {
                        msg = "The note was deleted successefully";
                      } else {
                        msg = "An error occured";
                      }
                      showDialog(context: (_),
                          builder: (context) =>
                              AlertDialog(
                                title: Text("Done"),
                                content: Text(msg),
                                actions: <Widget>[
                                  FlatButton(onPressed: () {
                                    Navigator.of(context).pop();
                                  }, child: Text("Dismiss"))
                                ],
                              ));
                      return deleteresult?.data ?? false;
                    }
                    print(result);
                    return result;
                  },
                  background: Container(
                    color: Colors.red,
                    padding: EdgeInsets.only(left: 16),
                    child: Align(
                      child: Icon(Icons.delete, color: Colors.white),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      _apiResponse.data[index].noteTitle,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    subtitle: Text(
                        'Last edited on ${formatDateTime(_apiResponse.data[index].editDate ?? _apiResponse.data[index].createDate)}'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => ModifyNote(
                               note: _apiResponse.data[index]),)).then((data) {
                                _fetchNotes();
                              });
                    },
                  ),
                );
              },
              itemCount: _apiResponse.data.length,
            );
          },
        ));
    }
  String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}

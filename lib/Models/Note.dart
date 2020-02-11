class Note{
  String noteID;
  String noteTitle;
  DateTime createDate;
  DateTime editDate;
  String noteContent;

  Note({this.noteID,this.noteTitle,this.createDate,this.editDate,this.noteContent});

  factory Note.fromJson(Map<String, dynamic> item) {
    return Note(
      noteID: item['noteID'],
      noteTitle: item['noteTitle'],
      noteContent: item['noteContent'],
      createDate: DateTime.parse(item['createDateTime']),
      editDate: item['latestEditDateTime'] != null
          ? DateTime.parse(item['latestEditDateTime'])
          : null,
    );
  }
}
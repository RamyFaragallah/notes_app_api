import 'package:flutter/material.dart';

class DeleteAlert extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Warning"),
      content: Text("Are you sure you wanna delete this note"),
      actions: <Widget>[
        FlatButton(onPressed: (){Navigator.pop(context,true);}, child: Text("Delete")),
        FlatButton(onPressed: (){Navigator.pop(context,false);}, child: Text("Not now"))
      ],
    );
  }

}
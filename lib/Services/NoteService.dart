import 'dart:convert';
import 'package:notes_app_api/Models/note_insert.dart';
import 'package:notes_app_api/Models/ApiResponse.dart';
import 'package:notes_app_api/Models/Note.dart';
import 'package:http/http.dart' as http;

class NoteService {
  static const API = 'http://api.notes.programmingaddict.com';
  static const headers = {'apiKey': '08d7ab12-eeab-2b46-9714-cd725770cc9b'
      ,'Content-Type': 'application/json'
};

  Future<ApiResponse<List<Note>>> getNotesList() {
    return http.get(API + '/notes', headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final notes = <Note>[];
        for (var item in jsonData) {
          notes.add(Note.fromJson(item));
        }
        return ApiResponse<List<Note>>(data: notes);
      }
      return ApiResponse<List<Note>>(
        error: true,
      );
    }).catchError((_) =>
        ApiResponse<List<Note>>(error: true, errorMsg: 'An error occured'));
  }

  Future<ApiResponse<Note>> getNote(String noteID) {
    return http.get(API + '/notes/' + noteID, headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        return ApiResponse<Note>(data: Note.fromJson(jsonData));
      }
      return ApiResponse<Note>(error: true, errorMsg: 'An error occured');
    }).catchError(
        (_) => ApiResponse<Note>(error: true, errorMsg: 'An error occured'));
  }

  Future<ApiResponse<bool>> createNote(NoteInsert item) {
    return http
        .post(API + '/notes',
            headers: headers, body: json.encode(item.toJson()))
        .then((data) {
      if (data.statusCode == 201) {
        return ApiResponse<bool>(data: true);
      }
      return ApiResponse<bool>(error: true, errorMsg: 'An error occured');
    }).catchError((_) =>
            ApiResponse<bool>(error: true, errorMsg: 'An error occured'));
  }
   Future<ApiResponse<bool>> updateNote(String noteID, NoteInsert item) {
    return http.put(API + '/notes/' + noteID, headers: headers, body: json.encode(item.toJson())).then((data) {
      if (data.statusCode == 204) {
        return ApiResponse<bool>(data: true);
      }
      return ApiResponse<bool>(error: true, errorMsg: 'An error occured');
    })
    .catchError((_) => ApiResponse<bool>(error: true, errorMsg: 'An error occured'));
   }

  Future<ApiResponse<bool>> deleteNote(String noteID) {
    return http.delete(API + '/notes/' + noteID, headers: headers).then((data) {
      if (data.statusCode == 204) {
        return ApiResponse<bool>(data: true);
      }
      return ApiResponse<bool>(error: true, errorMsg: 'An error occured');
    })
        .catchError((_) =>
        ApiResponse<bool>(error: true, errorMsg: 'An error occured'));
  }
}

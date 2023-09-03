import 'package:flutter/material.dart';
import 'package:providerstudentdb/controller/db_functions.dart';
import 'package:providerstudentdb/model/student_model.dart';

class SatateManager with ChangeNotifier {
  String imageNotifier = '';
  imageUpdator(String image) {
    imageNotifier = image;
    notifyListeners();
  }

  final db = DB();
  List<StudentModel> studentList = [];
  getFromDb() async {
    studentList = await db.getStudents();
    notifyListeners();
  }

  addToDb(StudentModel student) async {
    await db.addStudent(student);
    getFromDb();
  }

  editFromDb(StudentModel student, int id) async {
    await db.updateStudent(student, id);
    getFromDb();
  }

  deleteFromDb(int id) async {
    await db.deleteStudent(id);
    getFromDb();
  }
}

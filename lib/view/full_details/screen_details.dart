import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:providerstudentdb/view/full_details/widgets/second_section.dart';
import 'package:providerstudentdb/view/full_details/widgets/upper_section.dart';

import '../../constants/screen_size.dart';
import '../../controller/db_functions.dart';
import '../../model/student_model.dart';

class Details extends StatelessWidget {
  const Details({
    super.key,
    required this.student,
  });
  final StudentModel student;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: ScreenSize.screenHeight,
        child: ListView(
          children: [
            UpperSection(
              data: student,
            ),
            SecondSection(
              data: student,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: IconButton(
                  icon: const Icon(CupertinoIcons.delete_simple),
                  color: Colors.red,
                  onPressed: () async {
                    await DB.instance.deleteStudent(student.id!);
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:providerstudentdb/controller/state_controller/state_controller.dart';
import 'package:providerstudentdb/view/home/screen_home.dart';
import '../../constants/colors.dart';
import '../../constants/space.dart';

import '../../model/student_model.dart';
import '../../widgets/custom_textfield.dart';

List<String> fieldNames = [
  'Name',
  'Batch',
  'Phone Number',
  'Mail id',
  'Address',
];

class EditScreen extends StatelessWidget {
  EditScreen({Key? key, required this.student}) : super(key: key);

  final StudentModel student;
  XFile? imagePiked;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final studentController =
        Provider.of<SatateManager>(context, listen: false);
    //String imageToUpdate = student.image;
    studentController.imageNotifier = student.image;
    List<dynamic> currentValues = [
      student.name,
      student.batch,
      student.phone,
      student.mail,
      student.address,
      student.id,
    ];
    return Scaffold(
        appBar: AppBar(
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(
                CupertinoIcons.pencil_ellipsis_rectangle,
                size: 35,
              ),
            )
          ],
          backgroundColor: themeColor,
          title: const Text('Edit Details'),
        ),
        body: SafeArea(
          child: Column(
            children: [
              kHeight10,
              Stack(
                children: [
                  Consumer<SatateManager>(builder: (context, value, _) {
                    return CircleAvatar(
                      radius: 70,
                      backgroundImage: FileImage(File(value.imageNotifier)),
                    );
                  }),
                  Positioned(
                    bottom: 0,
                    left: 90,
                    child: IconButton(
                      onPressed: () async {
                        imagePiked = await _pickImage();
                        if (imagePiked != null) {
                          studentController.imageUpdator(imagePiked!.path);
                          //imageToUpdate = imagePiked!.path;
                        }
                      },
                      icon: const Icon(
                        Icons.add_a_photo_outlined,
                        size: 35,
                        color: themeColor,
                      ),
                    ),
                  )
                ],
              ),
              kHeight10,
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView.builder(
                    itemCount: fieldNames.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: CustomTextField(
                          hintTextToDisplay: fieldNames[index],
                          initialMessage: currentValues[index],
                          onSavedCallback: (value) {
                            currentValues[index] = value!;
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: themeColor,
          onPressed: () async {
            if (!_formKey.currentState!.validate()) {
              return;
            }
            _formKey.currentState!.save();

            if (studentController.imageNotifier.isEmpty) {
              return;
            }
            final student = StudentModel(
                name: currentValues[0],
                batch: currentValues[1],
                phone: currentValues[2],
                mail: currentValues[3],
                address: currentValues[4],
                image: studentController.imageNotifier,
                id: currentValues[5]);

            //await DB.instance.updateStudent(student, student.id!);
            await studentController.editFromDb(student, student.id!);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                duration: Duration(seconds: 3),
                content: Text('Data Updated Successfully'),
                backgroundColor: Colors.green,
              ),
            );
            // ignore: use_build_context_synchronously
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
                (route) => false);
          },
          child: const Icon(Icons.check),
        ));
  }

  _pickImage() async {
    try {
      final pick = await picker.pickImage(source: ImageSource.gallery);
      if (pick == null) {
        return Exception('no image selected');
      }
      return pick;
    } catch (e) {
      return Exception(e);
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../constants/space.dart';
import '../../controller/state_controller/state_controller.dart';
import '../../model/student_model.dart';
import '../../widgets/circle_add.dart';
import '../../widgets/custom_textfield.dart';

List<String> fieldNames = [
  'Name',
  'Batch',
  'Phone Number',
  'Mail id',
  'Address',
];

class AddScreen extends StatelessWidget {
  AddScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final List<String> toSaveValues =
      List.generate(fieldNames.length, (index) => '');

  @override
  Widget build(BuildContext context) {
    //final studentController = context.read<SatateManager>();
    final studentController =
        Provider.of<SatateManager>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              studentController.imageUpdator('');
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(
                CupertinoIcons.person_add,
                size: 35,
              ),
            )
          ],
          backgroundColor: themeColor,
          title: const Text('Add Student'),
        ),
        body: SafeArea(
          child: Column(
            children: [
              kHeight10,
              CircleAvatarWithAddButton(),
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
                          onSavedCallback: (value) {
                            toSaveValues[index] = value!;
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Image required'),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 3),
                ),
              );

              return;
            }
            final student = StudentModel(
              name: toSaveValues[0],
              batch: toSaveValues[1],
              phone: toSaveValues[2],
              mail: toSaveValues[3],
              address: toSaveValues[4],
              image: studentController.imageNotifier,
            );

            // await DB.instance.addStudent(student);
            await studentController.addToDb(student);
            studentController.imageNotifier = '';
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                duration: Duration(seconds: 3),
                content: Text('User Registered Successfully'),
                backgroundColor: Colors.green,
              ),
            );

            _formKey.currentState!.reset();
            Navigator.pop(context);
          },
          child: const Icon(Icons.check),
        ));
  }
}

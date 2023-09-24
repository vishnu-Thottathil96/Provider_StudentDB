import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:providerstudentdb/controller/state_controller/state_controller.dart';
import 'package:providerstudentdb/view/home/widgets/card.dart';

import '../../constants/colors.dart';
import '../../constants/screen_size.dart';
import '../../constants/space.dart';

import '../../model/student_model.dart';
import '../add/screen_add.dart';

ValueNotifier<List<StudentModel>> studentListNotifier = ValueNotifier([]);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final studentController =
        Provider.of<SatateManager>(context, listen: false);
    studentController.getFromDb();
    TextEditingController searchController = TextEditingController();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeColor,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddScreen(),
              ));
        },
        child: const Icon(
          CupertinoIcons.person_badge_plus,
          size: 40,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
        padding: EdgeInsets.all(ScreenSize.screenHeight / 70),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: ScreenSize.screenHeight / 17,
                child: CupertinoSearchTextField(
                  controller: searchController,
                  onChanged: (query) {
                    if (query.isNotEmpty) {
                      studentController.searchHelper(query);
                      print("Search query: $query");
                      print(
                          "Filtered student list: ${studentController.studentList}");
                    } else {
                      studentController.getFromDb();
                    }
                  },
                ),
              ),
              kHeight20,
              Consumer<SatateManager>(builder: (context, value, _) {
                return Expanded(
                  child: GridView.builder(
                    itemCount: value.studentList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: ScreenSize.screenHeight / 70,
                      crossAxisSpacing: ScreenSize.screenHeight / 70,
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (context, index) {
                      return CardWidget(student: value.studentList[index]);
                    },
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}

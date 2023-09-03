import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:providerstudentdb/constants/colors.dart';
import 'package:providerstudentdb/controller/state_controller/state_controller.dart';

XFile? pickedImage;

class CircleAvatarWithAddButton extends StatelessWidget {
  CircleAvatarWithAddButton({
    Key? key,
  }) : super(key: key);
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final studentController =
        Provider.of<SatateManager>(context, listen: false);
    return Stack(
      children: [
        Consumer<SatateManager>(builder: (context, value, _) {
          return Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: value.imageNotifier.isEmpty
                    ? const DecorationImage(
                        image: AssetImage('assets/images/defaultprofile.png'),
                        fit: BoxFit.cover)
                    : DecorationImage(
                        image: FileImage(File(value.imageNotifier)),
                        fit: BoxFit.cover)),
          );
        }),
        Positioned(
          bottom: -5,
          left: 90,
          child: IconButton(
            onPressed: () async {
              pickedImage = await _pickImage();
              if (pickedImage != null) {
                studentController.imageUpdator(pickedImage!.path);
              }
            },
            icon: const Icon(
              Icons.add_a_photo_outlined,
              size: 35,
              color: themeColor,
            ),
          ),
        ),
      ],
    );
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

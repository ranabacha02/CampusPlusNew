import 'package:campus_plus/controller/data_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:profanity_filter/profanity_filter.dart';
import '../controller/post_controller.dart';
import '../model/user_model.dart';
import '../utils/app_colors.dart';
import '../widgets/image_file_picker.dart';
import 'edit_account_screen.dart';


class MainPostForm extends StatefulWidget {
  const MainPostForm({Key? key}) : super(key: key);

  @override
  State<MainPostForm> createState() => _MainPostFormState();
}

class _MainPostFormState extends State<MainPostForm> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: ()=> Navigator.pop(context),
        ),
        title: Text(
          "CAMPUS+",
          style: TextStyle(
            fontSize: 30,
            color: AppColors.aubRed,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: const MyCustomForm(),
      ),
    );
  }
}

enum TagsFilter { study, food, fun, sports}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  final _eventController = TextEditingController();
  late PostController postController;
  late DataController dataController;
  late final MyUser userInfo;
  final filter = ProfanityFilter();
  final List<String> _tags = <String>[];
  final ImagePicker _picker = ImagePicker();
  late XFile? _selectedImage;


  @override
  void dispose(){
    //not sure if others have to be disposed
    _eventController.dispose();
    _selectedImage = null;
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
    postController = Get.put(PostController());
    dataController = Get.put(DataController());
    userInfo = dataController.getLocalData();
  }

  Future<XFile?> getImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
    );
    return pickedFile;
  }

  Future<XFile?> getImageFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 800,
      maxHeight: 800,
    );
    return pickedFile;
  }
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () async {
                        XFile? photo = await getImageFromGallery();
                        if (photo != null) {
                          setState(() {
                            _selectedImage = photo;
                          });
                        }
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () async {
                      XFile? photo = await getImageFromCamera();
                      if (photo != null) {
                        setState(() {
                          _selectedImage = photo;
                        });
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _eventController,
              decoration: const InputDecoration(
                  labelText: "What's happening ?",
                  border: OutlineInputBorder()
              ),
              minLines:2,
              maxLines: 4,
              maxLength: 200,
              validator: (value) {
                if(value?.isEmpty ?? true){
                  return 'Please enter some text';
                }
                if(filter.hasProfanity(value ?? "")){
                  return 'No cursing';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            IconButton(
              icon: Icon(Icons.photo_camera),
              color: Colors.black,
              onPressed: () {
                _showPicker(context);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Text("Tags"),
                const SizedBox(width: 40),
                buildTagFilterChip(),
              ],
            ),



            Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              side: const BorderSide(width: 1, color: Color(0xFF550000),
                                style: BorderStyle.solid),
                          ),
                          onPressed: () {
                              postController.uploadPostPic(_selectedImage!);
                              postController.createPost(event: _eventController.text, dateCreated: DateTime.now(), tags: _tags, imageUrl: _selectedImage!.path);
                              Navigator.pop(context);

                          },
                          child: const Text('Create'),
                        ),
                      ),
                    ],
                  ),
                )
            ),
          ],
        )
    );
  }





  Wrap buildTagFilterChip() {
    return Wrap(
      spacing: 5.0,
      children: TagsFilter.values.map((TagsFilter tag){
        return FilterChip(
            label: Text(tag.name),
            selected: _tags.contains(tag.name),
            onSelected: (bool value){
              setState(() {
                if (value) {
                  if (!_tags.contains(tag.name)) {
                    _tags.add(tag.name);
                  }
                } else {
                  _tags.removeWhere((String name) {
                    return name == tag.name;
                  });
                }
              });
            });
      }).toList(),
    );
  }
}




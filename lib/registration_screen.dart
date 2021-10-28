import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'home_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController sNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController schoolController = TextEditingController();

  String stud_name = '',age = '', school = '';
  Object gSelected = 'Male';
  bool _validate1 = false;
  bool _validate2 = false;
  bool _validate3 = false;
  final formKey = GlobalKey<FormState>();
  File? MyFile;
  late String fileName;
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  void imageStore(String imagePath) async {
    fileName = basename(imagePath);
    Reference reference = _storage.ref().child("assets/$fileName");
    UploadTask uploadTask = reference.putFile(MyFile!);
    TaskSnapshot taskSnapshot = uploadTask.snapshot;
    await taskSnapshot.ref.getDownloadURL();
  }

  Future getImageFromGallery() async {
    var file = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      MyFile = File(file!.path);
    });
  }

  Future getImageFromCamera() async {
    var file = await _picker.pickImage(source: ImageSource.camera);
      setState(() {
        MyFile = File(file!.path);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text('Student Registration'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(12),
              child: Center(
                child: InkWell(
                    child: CircleAvatar(
                      backgroundColor: Colors.deepPurpleAccent,
                      radius: 50,
                      child: MyFile == null
                          ? Image.asset("assets/user_image.png")
                          : Image.file(MyFile!,fit: BoxFit.fill),
                    ),
                    onTap: () {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          buttonPadding: EdgeInsets.all(15),
                          title:
                              Center(child: Text("Choose Camera OR Gallery")),
                          actions: <Widget>[
                            Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  FloatingActionButton(
                                    child: Icon(Icons.photo),
                                    onPressed: () => getImageFromGallery(),
                                  ),
                                  FloatingActionButton(
                                    child: Icon(Icons.camera),
                                    onPressed: () => getImageFromCamera(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: sNameController,
                autofocus: false,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Student Name',
                  labelText: 'Student Name',
                  errorText: _validate1 ? 'Student Name Required' : null,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: ageController,
                autofocus: false,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Age',
                  labelText: 'Age',
                  errorText: _validate2 ? 'Age Required' : null,
                ),
              ),
            ),
            FormField(
                key: formKey,
                builder: (FormFieldState<FormState> field) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text('Gender : '),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text('Male'),
                      ),
                      Radio(
                        value: 'Male',
                        groupValue: gSelected,
                        activeColor: Colors.blue,
                        onChanged: (value) {
                          setState(() {
                            gSelected = value!;
                          });
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text('Female'),
                      ),
                      Radio(
                        value: 'Female',
                        groupValue: gSelected,
                        activeColor: Colors.blue,
                        onChanged: (value) {
                          setState(() {
                            gSelected = value!;
                          });
                        },
                      ),
                    ],
                  );
                }),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: schoolController,
                autofocus: false,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter School Name',
                  labelText: 'School Name',
                  errorText: _validate3 ? 'School Name Required' : null,
                ),
              ),
            ),
            Container(
              width: 200,
              height: 50,
              margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                ),
                onPressed: () {
                  setState(() {
                    if (sNameController.text.isEmpty) {
                      _validate1 = true;
                    } else if (sNameController.text.isNotEmpty &&
                        ageController.text.isEmpty) {
                      _validate1 = false;
                      _validate2 = true;
                    } else if (ageController.text.isNotEmpty &&
                        schoolController.text.isEmpty) {
                      _validate2 = false;
                      _validate3 = true;
                    } else {
                      _validate3 = false;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()));
                    }
                  });
                },
                child: const Text(
                  'Registration',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

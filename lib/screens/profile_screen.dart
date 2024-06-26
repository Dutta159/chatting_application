import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_messenger/models/chat_user.dart';
import '../api/apis.dart';
import '../helper/dialogs.dart';
import '../main.dart';
import 'auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formkey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          //This is the app_bar
          appBar: AppBar(
            title: const Text(
              "Profile Screen",
            ),
          ),
          //This is the bottom floating action button to add new user
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 5),
            //The extended button allows us to add label along with the icon
            child: FloatingActionButton.extended(
              onPressed: () async {
                //for showing progress dialog
                Dialogs.showProgressBar(context);
                //for sign out
                await APIs.auth.signOut().then((value) async {
                  await GoogleSignIn().signOut().then((value) {
                    //for hiding progress dialog
                    Navigator.pop(context);
                    //This wil pop out our profile screen and display the main screen
                    Navigator.pop(context);
                    //No the push replacement will replace the home screen with the login screen
                    Navigator.pushReplacement(
                        context, //this is used to replace the current screen with the login screen after logging out
                        MaterialPageRoute(
                            builder: (_) => const login_screen()));
                  });
                });
              },
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
            ),
          ),
          body: Form(
            key: _formkey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //Size box is used for adding the empty space on the screen
                    SizedBox(width: mq.width, height: mq.height * 0.03),
                    Stack(
                      //used to add teh edit button over the profile picture
                      children: [
                        //profile picture
                        _image != null
                            ?
                            //local image
                            ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(mq.height * 0.1),
                                child: Image.file(
                                  File(_image!),
                                  width: mq.height * 0.2,
                                  height: mq.height * 0.2,
                                  fit: BoxFit.fill,
                                ),
                              )
                            :
                            //server image
                            ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(mq.height * 0.1),
                                child: CachedNetworkImage(
                                  width: mq.height * 0.2,
                                  height: mq.height * 0.2,
                                  fit: BoxFit.fill,
                                  imageUrl: widget.user.image,
                                  errorWidget: (context, url, error) =>
                                      const CircleAvatar(
                                    child: Icon(CupertinoIcons.person),
                                  ),
                                ),
                              ),
                        //profile picture edit image button
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: MaterialButton(
                            onPressed: () {
                              _showBottomSheet();
                            },
                            color: Colors.white70,
                            shape: const CircleBorder(),
                            child: const Icon(Icons.edit),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: mq.height * 0.03),
                    Text(widget.user.email,
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 16)),

                    SizedBox(height: mq.height * 0.05),
                    //This displays the Name of the user
                    TextFormField(
                      initialValue: widget.user.name,
                      onSaved: (val) => APIs.me.name = val ??
                          "", //this  will return an empty string if the val is null
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required Field',
                      decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.person_2,
                            color: Colors.deepPurple,
                          ),
                          hintText: "Eg. Yashraj Haridas",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          label: const Text("Name")),
                    ),

                    SizedBox(height: mq.height * 0.02),
                    //This displays the about
                    TextFormField(
                      initialValue: widget.user.about,
                      onSaved: (val) => APIs.me.about = val ??
                          "", //this  will return an empty string if the val is null
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required Field',
                      decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.info_outline,
                            color: Colors.deepPurple,
                          ),
                          hintText: "Eg. Feeling happy",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          label: const Text("About")),
                    ),
                    SizedBox(height: mq.height * 0.05),

                    //This is the button for updating the profile details
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(mq.width * 0.5, mq.height * .06)),
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            _formkey.currentState!
                                .save(); //This wil save data after the update button is pressed
                            log("Inside validator");
                            APIs.updateUserInfo().then((value) {
                              Dialogs.showSnackBar(
                                  context, "Profile SuccessFully updated");
                            });
                          }
                        },
                        icon: const Icon(
                          Icons.edit,
                          size: 28,
                        ),
                        label: const Text("Update"))
                  ],
                ),
              ),
            ),
          )),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        builder: (_) {
          return ListView(
            shrinkWrap:
                true, //This will only show the part as much as the content is present
            padding:
                EdgeInsets.only(top: mq.height * .02, bottom: mq.height * .05),
            children: [
              const Text(
                "Pick profile picture",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: mq.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
// Pick an image.
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery,
                            imageQuality:
                                80); //Image quality is used to save server space it will reduce the image quality
                        if (image != null) {
                          log('image Path: ${image.path}-- mine type: ${image.mimeType}');
                          setState(() {
                            _image = image.path;
                          });
                          APIs.updateProfilePicture(File(_image!));
                          //for hiding bottom sheet
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('images/gallery.png')),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
// Pick an image.
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 80);
                        if (image != null) {
                          log('image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });
                          APIs.updateProfilePicture(File(_image!));
                          //for hiding bottom sheet
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('images/photo.png')),
                ],
              )
            ],
          );
        });
  }
}

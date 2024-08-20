import 'dart:html' as html;
import 'dart:typed_data';
import 'package:chatapp/widget/storage_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isAccount = true;
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredName = '';
  html.File? _pickedImage;
  bool _isUploading = false;

  void _pickedImageFn(html.File image) {
    _pickedImage = image;
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    if (!mounted) return; // Check if widget is still mounted

    setState(() {
      _isUploading = true;
    });

    try {
      if (isAccount) {
        final user = await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
        print(user);
      } else {
        if (_pickedImage == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Please pick an image')),
            );
          }
          return;
        }

        final user = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );

        final reader = html.FileReader();
        reader.readAsArrayBuffer(_pickedImage!);

        reader.onLoadEnd.listen((_) async {
          final bytes = reader.result as Uint8List?;

          if (bytes == null) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to read image data')),
              );
            }
            return;
          }

          try {
            final storageRef = FirebaseStorage.instance
                .ref()
                .child('user_images/${user.user!.uid}.jpg');

            final uploadTask = storageRef.putData(bytes);

            final snapshot = await uploadTask.whenComplete(() => null);
            final imageUrl = await snapshot.ref.getDownloadURL();
            print('Image uploaded successfully: $imageUrl');
            FirebaseFirestore.instance
                .collection('users')
                .doc(user.user!.uid)
                .set({
              'username': _enteredName,
              'email': _enteredEmail,
              'image': imageUrl.toString(),
            });

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Account Created')),
              );
            }
          } catch (e) {
            if (mounted) {
              print('Failed to upload image: $e');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to upload image: $e')),
              );
            }
          } finally {
            if (mounted) {
              setState(() {
                _isUploading = false;
              });
            }
          }
        });
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Authentication failed')),
        );
      }
    }
  }

  @override
  void dispose() {
    // Cancel any ongoing work or listeners here
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                child: Image.asset('assets/images/chat.png'),
                width: 200,
              ),
              Card(
                margin: const EdgeInsets.all(20),
                color: Colors.transparent,
                elevation: 0,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        if (!isAccount)
                          UserImagePicker(imagePickFn: _pickedImageFn),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.black),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains('@')) {
                              return 'Email is required';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredEmail = value!;
                          },
                        ),
                        if(!isAccount)
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Username',
                            labelStyle: TextStyle(color: Colors.black),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return 'Username is required';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredName = value!;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.black),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.trim().length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredPassword = value!;
                          },
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _submit,
                          child: Text(isAccount ? 'Log In' : 'Submit'),
                        ),
                        SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isAccount = !isAccount;
                            });
                          },
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.black),
                          child: Text(isAccount
                              ? 'Don\'t have an account? Create one'
                              : 'Already have an account? Log In'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

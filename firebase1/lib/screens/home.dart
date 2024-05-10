import 'package:firebase1/Widget/support_widget/controllers.dart';
import 'package:firebase1/Widget/support_widget/sized_box.dart';
import 'package:firebase1/Widget/utils/all_management.dart';
import 'package:firebase1/Widget/utils/exit_confirm.dart';
import 'package:firebase1/screens/add_note.dart';
import 'package:firebase1/verify_screens/auth/Email/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class MyHome extends StatefulWidget {
  const MyHome({
    super.key,
  });

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final _auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(
            height: 40,
            width: 40,
            child: Image.asset(
              'assets/images/app_logo.png',
              fit: BoxFit.contain,
            )),
        automaticallyImplyLeading: false,
        title: Text(
          StringManger().appName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.pink.withOpacity(0.8),
                offset: Offset(1.0, 1.0),
                blurRadius: 3.0,
              ),
            ],
          ),
        ),
        actions: [
          Row(
            children: [
              Text(username.text.toString()),
              IconButton(
                onPressed: () => _confirmLogout(),
                icon: const Icon(
                  Icons.logout,
                ),
              ),
            ],
          ),
          addHorizontalSpace(10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            const ExitConfirmationDialog(),
            Expanded(
              child: FirebaseAnimatedList(
                  defaultChild: SizedBox(
                    height: 100,
                    width: 100,
                    child: LoadingIndicator(
                      indicatorType: Indicator.ballRotate,
                      colors: [
                        Colors.red,
                        Colors.blue,
                        Colors.pink,
                        Colors.cyan,
                      ],
                      strokeWidth: 1,
                    ),
                  ),
                  query: ref.child('UserData').child(_auth.currentUser!.uid),
                  itemBuilder: (context, snapshot, animation, index) {
                    return ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      tileColor: Colors.grey[900],
                      leading:
                          Icon(Icons.note_add_rounded, color: Colors.purple),
                      isThreeLine: true,
                      title: Text(
                        snapshot.child('Note').value.toString(),
                      ),
                      subtitle: Text(
                        snapshot.child('Date').value.toString(),
                      ),
                      trailing: SizedBox(
                        width: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.edit, color: Colors.blue),
                            Icon(Icons.delete_forever, color: Colors.red),
                          ],
                        ),
                      ),
                      hoverColor: Colors.blue[100],
                    );
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const MyPostScreen();
          }));
        },
        child: const Icon(Icons.post_add),
      ),
    );
  }

  //exit confirmation msg
  Future<void> _confirmLogout() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: AlertDialog(
            shadowColor: Colors.red,
            iconColor: Colors.black,
            backgroundColor: Colors.white,
            titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20),
            icon: const Icon(Icons.cancel_presentation_sharp),
            title: const Text(
              "Confirm Logout",
            ),
            content: const Text(
              "Are you sure you want to logout?",
            ),
            contentTextStyle: TextStyle(color: Colors.black),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();

                  await _auth.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                },
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

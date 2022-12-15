import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stepform/home_page.dart';

class MyDetailHome extends StatefulWidget {
  const MyDetailHome({super.key});

  @override
  State<MyDetailHome> createState() => _MyDetailHomeState();
}

class _MyDetailHomeState extends State<MyDetailHome> {
  final Query notesRef =
      FirebaseDatabase.instance.ref().child('Biodata').orderByChild('nama');
  Widget listDetail({required Map biodata}) {
    return SingleChildScrollView(
      child: Card(
        color: Colors.lightBlue,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(
                top: 10,
                left: 5,
                right: 5,
              ),
              child: Column(
                children: [
                  const Text("Nama : "),
                  Text(biodata['name']),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 10,
                left: 5,
                right: 5,
              ),
              child: Column(
                children: [
                  const Text("Nomor Telepon : "),
                  Text(biodata['phone']),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 10,
                left: 5,
                right: 5,
              ),
              child: Column(
                children: [
                  const Text("Email Address : "),
                  Text(biodata['email']),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 10,
                left: 5,
                right: 5,
              ),
              child: Column(
                children: [
                  const Text("Umur : "),
                  Text(biodata['age']),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Data"),
      ),
      body: FirebaseAnimatedList(
          query: notesRef,
          itemBuilder: ((context, snapshot, animation, index) {
            Map biodata = snapshot.value as Map;
            biodata['key'] = snapshot.key;
            return listDetail(biodata: biodata);
          })),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (builder) => const MyApp(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}

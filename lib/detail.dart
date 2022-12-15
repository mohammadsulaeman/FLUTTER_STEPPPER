import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stepform/home_page.dart';
import 'package:flutter_stepform/style.dart';

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
      child: Container(
        width: MediaQuery.of(context).size.width * 1.0,
        height: MediaQuery.of(context).size.height * 0.4,
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 15,
          bottom: 5,
        ),
        child: Card(
          elevation: 60,
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
                    Text(
                      "Nama : ",
                      style: judulstyletext,
                    ),
                    Text(
                      biodata['name'],
                      style: subjudulstyletext,
                    ),
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
                    Text(
                      "Nomor Telepon : ",
                      style: judulstyletext,
                    ),
                    Text(
                      biodata['phone'],
                      style: subjudulstyletext,
                    ),
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
                    Text(
                      "Email Address : ",
                      style: judulstyletext,
                    ),
                    Text(
                      biodata['email'],
                      style: subjudulstyletext,
                    ),
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
                    Text(
                      "Umur : ",
                      style: judulstyletext,
                    ),
                    Text(
                      biodata['age'],
                      style: subjudulstyletext,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Data",
          style: judulstyletext,
        ),
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

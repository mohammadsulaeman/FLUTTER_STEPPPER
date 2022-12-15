import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stepform/detail.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyAppScreenMode();
  }
}

class MyData {
  String name = "";
  String phone = "";
  String email = "";
  String age = "";
}

//screenmode
class MyAppScreenMode extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Steppers',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.black12,
            ),
          ),
        ),
        body: const StepperBody(),
      ),
    );
  }
}

class StepperBody extends StatefulWidget {
  const StepperBody({super.key});

  @override
  State<StepperBody> createState() => _StepperBodyState();
}

class _StepperBodyState extends State<StepperBody> {
  int currStep = 0;
  static var _focusNode = FocusNode();
  GlobalKey<FormState> fromKey = GlobalKey<FormState>();
  static MyData data = MyData();
  static DatabaseReference reference = FirebaseDatabase.instance.ref();
  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        print('Has focus : ${_focusNode.hasFocus}');
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }

  List<Step> steps = [
    Step(
      title: const Text('Name'),
      isActive: true,
      state: StepState.indexed,
      content: TextFormField(
        focusNode: _focusNode,
        keyboardType: TextInputType.name,
        autocorrect: false,
        onSaved: ((newValue) {
          data.name = newValue.toString();
        }),
        maxLines: 1,
        validator: (value) {
          if (value!.isEmpty || value.length < 1) {
            return 'Please enter name';
          }
        },
        decoration: const InputDecoration(
            labelText: 'Enter your name',
            hintText: 'Enter name',
            icon: Icon(Icons.person),
            labelStyle: TextStyle(decorationStyle: TextDecorationStyle.solid)),
      ),
    ),
    Step(
      title: const Text('Phone'),
      isActive: true,
      state: StepState.indexed,
      content: TextFormField(
        keyboardType: TextInputType.phone,
        autocorrect: false,
        validator: (value) {
          if (value!.isEmpty || value.length < 11) {
            return 'Please Enter your phone number';
          }
        },
        onSaved: (newValue) {
          data.phone = newValue.toString();
        },
        maxLines: 1,
        decoration: const InputDecoration(
          labelText: 'Enter your phone number',
          hintText: 'Enter Phone Number',
          icon: Icon(Icons.phone_android),
          labelStyle: TextStyle(decorationStyle: TextDecorationStyle.solid),
        ),
      ),
    ),
    Step(
      title: const Text('Email'),
      isActive: true,
      state: StepState.indexed,
      content: TextFormField(
        keyboardType: TextInputType.emailAddress,
        autocorrect: false,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter valid email';
          }
        },
        onSaved: (newValue) {
          data.email = newValue.toString();
        },
        maxLines: 1,
        decoration: const InputDecoration(
          labelText: 'Enter your email address',
          hintText: 'Enter a email address',
          icon: Icon(Icons.email_outlined),
          labelStyle: TextStyle(decorationStyle: TextDecorationStyle.solid),
        ),
      ),
    ),
    Step(
      title: const Text('Age'),
      isActive: true,
      state: StepState.indexed,
      content: TextFormField(
        keyboardType: TextInputType.number,
        autocorrect: false,
        validator: (value) {
          if (value!.isEmpty || value.length > 2) {
            return 'Please enter valid age';
          }
        },
        maxLines: 1,
        onSaved: (newValue) {
          data.age = newValue.toString();
        },
        decoration: const InputDecoration(
          labelText: 'Enter your age',
          hintText: 'Enter age',
          icon: Icon(Icons.explicit_outlined),
          labelStyle: TextStyle(decorationStyle: TextDecorationStyle.solid),
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    void showSnackBarMessage(String message,
        [MaterialColor color = Colors.red]) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }

    void _submitDetails() {
      final FormState formState = fromKey.currentState!;
      if (!formState.validate()) {
        showSnackBarMessage('Please enter correct data');
      } else {
        formState.save();
        print('Nama = ${data.name}');
        print('Phone = ${data.phone}');
        print('Email = ${data.email}');
        print('Age = ${data.age}');

        showDialog(
          context: context,
          builder: ((context) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        Map<String, Object> biodata = {
                          "name": data.name,
                          "phone": data.phone,
                          "email": data.email,
                          "age": data.age
                        };
                        reference.child("Biodata").push().set(biodata).then(
                              (value) => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (builder) => const MyDetailHome(),
                                ),
                              ),
                            );
                      },
                      child: const Text('OK'),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      }
    }

    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Form(
        key: fromKey,
        child: ListView(
          children: [
            Stepper(
              steps: steps,
              type: StepperType.vertical,
              currentStep: currStep,
              onStepContinue: () {
                setState(() {
                  if (currStep < steps.length - 1) {
                    currStep = currStep + 1;
                  } else {
                    currStep = 0;
                  }
                });
              },
              onStepCancel: () {
                setState(() {
                  if (currStep > 0) {
                    currStep = currStep - 1;
                  } else {
                    currStep = 0;
                  }
                });
              },
              onStepTapped: (value) {
                setState(() {
                  currStep = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: _submitDetails,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
              ),
              child: const Text('Save Detail'),
            )
          ],
        ),
      ),
    );
  }
}

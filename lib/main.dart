import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "GPA Calculate",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.blue,
          accentColor: Colors.blue.shade500,
          fontFamily: 'Secular'),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String lessonName;
  int lessonCredit = 1;
  double lessonGpa = 4;
  List<Lesson> allLesson;
  double avarage = 0;
  static int say = 0;

  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    allLesson = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("GPA Calculate"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
          }
        },
        child: Icon(Icons.add),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return gpaGovde();
          } else {
            return gpaGovdeLandScape();
          }
        },
      ),
    );
  }

  Widget gpaGovde() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          //Static Form Container
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            //color: Colors.lightGreen.shade200,
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.red.shade500, width: 2)),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.blue.shade500, width: 2)),
                      labelText: "Lesson Name",
                      labelStyle:
                          TextStyle(fontSize: 18, fontFamily: 'Secular'),
                      hintText: "Enter Lesson Name ",
                      hintStyle: TextStyle(fontSize: 30, fontFamily: 'Secular'),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(
                              color: Colors.pink.shade500, width: 2)),
                    ),
                    validator: (value) {
                      if (value.length > 0) {
                        return null;
                      } else {
                        return "Lesson Name Not Entered!";
                      }
                    },
                    onSaved: (value) {
                      lessonName = value;
                      setState(() {
                        allLesson.add(Lesson(lessonName, lessonGpa,
                            lessonCredit, rndColorCreate()));
                        avarage = 0;
                        avarageCalculate();
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.pink.shade500, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            items: lessonCre(),
                            value: lessonCredit,
                            onChanged: (selectedGrade) {
                              setState(() {
                                lessonCredit = selectedGrade;
                              });
                            },
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.pink.shade500, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<double>(
                            items: lessonGradesItems(),
                            value: lessonGpa,
                            onChanged: (selectedCredit) {
                              setState(() {
                                lessonGpa = selectedCredit;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.red,
                    height: 15,
                    indent: 2,
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 70,
            margin: EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.blue,
              // border: BorderDirectional(
              //   top: BorderSide(color: Colors.red.shade300, width: 2),
              //   bottom: BorderSide(color: Colors.red.shade300, width: 2),
              // ),
            ),
            child: Center(
                child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: allLesson.length == 0
                        ? "Please Add Lesson"
                        : "Avarage: ",
                    style: TextStyle(
                      fontSize: 38,
                      color: Colors.white,
                      fontFamily: 'Secular',
                    ),
                  ),
                  TextSpan(
                      text: allLesson.length == 0
                          ? " "
                          : "${avarage.toStringAsFixed(2)}",
                      style: TextStyle(
                          fontSize: 38,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Secular')),
                ],
              ),
            )),
          ),
          //Dynamic List Container
          Expanded(
            child: Container(
              child: ListView.builder(
                itemBuilder: _listElementCreate,
                itemCount: allLesson.length,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget gpaGovdeLandScape() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  //color: Colors.lightGreen.shade200,
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.red.shade500, width: 2)),
                            disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blue.shade500, width: 2)),
                            labelText: "Lesson Name",
                            labelStyle: TextStyle(fontSize: 18),
                            hintText: "Enter Lesson Name ",
                            hintStyle: TextStyle(fontSize: 30),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                    color: Colors.pink.shade500, width: 2)),
                          ),
                          validator: (value) {
                            if (value.length > 0) {
                              return null;
                            } else {
                              return "Lesson Name Not Entered!";
                            }
                          },
                          onSaved: (value) {
                            lessonName = value;
                            setState(() {
                              allLesson.add(Lesson(lessonName, lessonGpa,
                                  lessonCredit, rndColorCreate()));
                              avarage = 0;
                              avarageCalculate();
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.pink.shade500, width: 2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  items: lessonCre(),
                                  value: lessonCredit,
                                  onChanged: (selectedGrade) {
                                    setState(() {
                                      lessonCredit = selectedGrade;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.pink.shade500, width: 2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<double>(
                                  items: lessonGradesItems(),
                                  value: lessonGpa,
                                  onChanged: (selectedCredit) {
                                    setState(() {
                                      lessonGpa = selectedCredit;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.red,
                          height: 15,
                          indent: 2,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      // border: BorderDirectional(
                      //   top: BorderSide(color: Colors.red.shade300, width: 2),
                      //   bottom: BorderSide(color: Colors.red.shade300, width: 2),
                      // ),
                    ),
                    child: Center(
                        child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: allLesson.length == 0
                                ? "Please Add Lesson"
                                : "Avarage: ",
                            style: TextStyle(
                              fontSize: 38,
                              color: Colors.white,
                            ),
                          ),
                          TextSpan(
                              text: allLesson.length == 0
                                  ? " "
                                  : "${avarage.toStringAsFixed(2)}",
                              style: TextStyle(
                                  fontSize: 38,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )),
                  ),
                ),
              ],
            ),
            flex: 1,
          ),
          Expanded(
            child: Container(
              child: ListView.builder(
                itemBuilder: _listElementCreate,
                itemCount: allLesson.length,
              ),
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<int>> lessonCre() {
    List<DropdownMenuItem<int>> credits = [];
    for (var i = 1; i <= 10; i++) {
      credits.add(DropdownMenuItem<int>(
        value: i,
        child: Text(
          "$i Credits",
          style: TextStyle(fontSize: 25),
        ),
      ));
    }
    return credits;
  }

  List<DropdownMenuItem<double>> lessonGradesItems() {
    List<DropdownMenuItem<double>> grades = [];

    grades.add(DropdownMenuItem(
        child: Text("A, A+", style: TextStyle(fontSize: 20)), value: 4.0));
    grades.add(DropdownMenuItem(
        child: Text("A-", style: TextStyle(fontSize: 20)), value: 3.7));
    grades.add(DropdownMenuItem(
        child: Text("B+", style: TextStyle(fontSize: 20)), value: 3.3));
    grades.add(DropdownMenuItem(
        child: Text("B", style: TextStyle(fontSize: 20)), value: 3.0));
    grades.add(DropdownMenuItem(
        child: Text("B-", style: TextStyle(fontSize: 20)), value: 2.7));
    grades.add(DropdownMenuItem(
        child: Text("C+", style: TextStyle(fontSize: 20)), value: 2.3));
    grades.add(DropdownMenuItem(
        child: Text("C", style: TextStyle(fontSize: 20)), value: 2.0));
    grades.add(DropdownMenuItem(
        child: Text("C-", style: TextStyle(fontSize: 20)), value: 1.7));
    grades.add(DropdownMenuItem(
        child: Text("D+", style: TextStyle(fontSize: 20)), value: 1.3));
    grades.add(DropdownMenuItem(
        child: Text("D", style: TextStyle(fontSize: 20)), value: 1.0));
    grades.add(DropdownMenuItem(
        child: Text("D-", style: TextStyle(fontSize: 20)), value: 0.7));
    grades.add(DropdownMenuItem(
        child: Text("F", style: TextStyle(fontSize: 20)), value: 0));

    return grades;
  }

  Widget _listElementCreate(BuildContext context, int index) {
    say++;

    // Color rndColor = rndColorCreate();
    return Dismissible(
      key: Key(say.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        setState(() {
          allLesson.removeAt(index);
          avarageCalculate();
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: allLesson[index].colors, width: 3),
          borderRadius: BorderRadius.circular(15),
        ),
        margin: EdgeInsets.all(10),
        child: ListTile(
          leading: Icon(
            Icons.done_outline,
            size: 28,
            color: allLesson[index].colors,
          ),
          trailing: Icon(Icons.keyboard_arrow_right),
          title: Text(allLesson[index].name),
          subtitle: Text(allLesson[index].credits.toString() +
              "\n" +
              allLesson[index].gradeInc.toString()),
        ),
      ),
    );
  }

  void avarageCalculate() {
    double tNot = 0;
    double tCredits = 0;
    for (var nowLesson in allLesson) {
      var credi = nowLesson.credits;
      var gpaD = nowLesson.gradeInc;

      tNot = tNot + (gpaD * credi);
      tCredits = tCredits + credi;
    }
    avarage = tNot / tCredits;
  }

  Color rndColorCreate() {
    return Color.fromARGB(
      200 + Random().nextInt(255),
      105 + Random().nextInt(255),
      105 + Random().nextInt(255),
      105 + Random().nextInt(255),
    );
  }
}

class Lesson {
  String name;
  double gradeInc;
  int credits;
  Color colors;

  Lesson(this.name, this.gradeInc, this.credits, this.colors);
}

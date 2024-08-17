// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, use_build_context_synchronously

import "dart:convert";
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tomato_gym/settings/sessionData.dart';
import 'package:tomato_gym/settings/utils.dart';
import 'package:tomato_gym/widgets/customButton.dart';
import 'package:tomato_gym/widgets/customTextField.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info/package_info.dart';

class ManagePlan extends StatefulWidget {
  const ManagePlan({super.key});

  @override
  State<ManagePlan> createState() => _ManagePlanState();
}

class _ManagePlanState extends State<ManagePlan> {
  bool loadPlan = false;
  bool isSaving = false;
  bool isLoading = true;

  List<TextEditingController> exerciseNameList = [];
  List<TextEditingController> setsList = [];
  List<TextEditingController> repsList = [];
  List<TextEditingController> initWeightList = [];

  List<TextEditingController> currentWeightList = [];

  String version = "";

  @override
  void initState() {
    super.initState();

    loadSessionData();
  }

  // #region SETUP THE ENVIRONMENT
  loadSessionData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // retrieve elements
    final elements = await sharedPreferences.getStringList('elements');

    if (elements == null) {
      SessionData.elements = [];
    } else {
      for (int i = 0; i < elements.length; i++) {
        SessionData.elements.add(Exercise.fromJson(jsonDecode(elements[i])));
      }
    }

    // retrieve date
    final dateIncrease = await sharedPreferences.getString('dateIncrease');

    if (dateIncrease != null) {
      SessionData.dateIncrease = DateFormat("yyyy-MM-dd").parse(dateIncrease);
    }

    // retrieve days delta
    final daysDelta = await sharedPreferences.getString('daysDelta');

    if (daysDelta != null) {
      SessionData.daysDelta = int.parse(daysDelta);
    }

    // unlock loading
    setState(() {
      isLoading = false;
    });

    initDataSources();
    initUtils();
  }

  initUtils() async {
    // show app version
    final packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      version = packageInfo.version;
    });

    // show weights alert
    if (DateTime.now().difference(SessionData.dateIncrease).inSeconds >= 0) {
      SessionData.dateIncrease = DateTime.now().add(Duration(days: SessionData.daysDelta));
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString('dateIncrease', DateFormat("yyyy-MM-dd").format(SessionData.dateIncrease));

      Utils().showInfoAlertDialog(context, Utils().translate(context, "generic_remember") + '!', Utils().translate(context, "increase_weights_alert") + SessionData.daysDelta.toString());
    }
  }

  initDataSources() {
    exerciseNameList = [];
    setsList = [];
    repsList = [];
    initWeightList = [];
    currentWeightList = [];

    for (var el in SessionData.elements) {
      setState(() {
        exerciseNameList.add(TextEditingController());
        setsList.add(TextEditingController());
        repsList.add(TextEditingController());
        initWeightList.add(TextEditingController());
        currentWeightList.add(TextEditingController());

        // init fields data
        exerciseNameList.last.text = el.exerciseName;
        setsList.last.text = el.sets;
        repsList.last.text = el.reps;
        initWeightList.last.text = el.initWeight;
        currentWeightList.last.text = el.currentWeight;
      });
    }
  }
  // #endregion

  // #region USEFUL FUNCTIONS
  addExercise() {
    setState(() {
      exerciseNameList.add(TextEditingController());
      setsList.add(TextEditingController());
      repsList.add(TextEditingController());
      initWeightList.add(TextEditingController());
      currentWeightList.add(TextEditingController());
    });
  }

  deleteExercise(int i) {
    setState(() {
      SessionData.elements.removeAt(i);

      // delete divider if it is the first element of the list
      if (SessionData.elements.isNotEmpty && SessionData.elements[0].divider) {
        deleteExercise(0);
      }

      exerciseNameList.removeAt(i);
      setsList.removeAt(i);
      repsList.removeAt(i);
      initWeightList.removeAt(i);
      currentWeightList.removeAt(i);
    });
  }

  editPlan() {
    setState(() {
      loadPlan = true;
    });
  }

  copyPlan() async {
    try {
      String textCopy = "";

      for (var el in SessionData.elements) {
        if (el.divider) {
          textCopy += "-----------------------------\n";
          textCopy += "\n";
        } else {
          textCopy += Utils().translate(context, "exercise_name") + ": " + el.exerciseName + "\n";
          textCopy += Utils().translate(context, "sets") + " X " + Utils().translate(context, "reps") + ": " + el.sets + " X " + el.reps + "\n";
          textCopy += Utils().translate(context, "init_weight") + ": " + el.initWeight + "\n";
          textCopy += Utils().translate(context, "current_weight") + ": " + el.currentWeight + "\n";
          textCopy += "\n";
        }
      }

      await Clipboard.setData(ClipboardData(text: textCopy));

      Utils().successMessage(context, "copy_success");
    } catch (e) {
      Utils().errorMessage(context, "copy_failure");
    }
  }

  createNewPlan() {
    Utils().showBooleanAlertDialog(context, Utils().translate(context, "generic_warning") + '!', Utils().translate(context, "reset_confirmation"), () {
      resetData();

      Navigator.pop(context);
    });
  }

  resetData() async {
    copyPlan();

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setStringList('elements', []);
    sharedPreferences.setString('dateIncrease', DateFormat("yyyy-MM-dd").format(DateTime.now().add(const Duration(days: 50))));
    sharedPreferences.setString('daysDelta', "-1");

    setState(() {
      SessionData.elements = [];

      initDataSources();
    });
  }
  // #endregion

  // #region UI GENERATORS
  Widget welcomePage() {
    return
        // if no plan has been found
        Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 150),

        // welcome
        Text(
          Utils().translate(context, "welcome"),
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
        ),

        SizedBox(height: 50),

        // message
        Container(
          width: 200,
          child: Text(
            Utils().translate(context, "no_plan_found"),
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
          ),
        ),

        SizedBox(height: 20),

        // button
        Center(
            child: CustomButton(
                text: Utils().translate(context, "create_new_plan"),
                icon: Icons.arrow_right,
                onTap: () {
                  TextEditingController daysController = TextEditingController();

                  Utils().showInputAlertDialog(context, Utils().translate(context, "increase_weights_alert_title"), daysController, Utils().translate(context, "generic_days"), maxLength: 3, textAlignCenter: true, numbersOnly: true, () async {
                    // check if input is a number
                    if (int.tryParse(daysController.text) == null) {
                      Utils().errorMessage(context, "increase_weights_alert_error");
                      return;
                    }

                    DateTime dateIncrease = DateTime.now().add(Duration(days: int.parse(daysController.text)));

                    setState(() {
                      // next page
                      loadPlan = true;

                      SessionData.dateIncrease = dateIncrease;
                      SessionData.daysDelta = int.parse(daysController.text);
                    });

                    // save days in local storage
                    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                    sharedPreferences.setString('dateIncrease', DateFormat("yyyy-MM-dd").format(dateIncrease));
                    sharedPreferences.setString('daysDelta', daysController.text);

                    Navigator.pop(context);
                  });
                })),
      ],
    );
  }

  Widget exerciseForm(int i) {
    if (SessionData.elements[i].divider) {
      return Divider(
        color: Colors.red,
        thickness: 3,
      );
    }

    return Column(
      children: [
        if (i > 0 && !SessionData.elements[i - 1].divider)
          Divider(
            color: Colors.grey[800],
          ),
        SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // exercise name
            Expanded(
              child: CustomTextField(
                hintText: Utils().translate(context, "exercise_name"),
                controller: exerciseNameList[i],
              ),
            ),

            SizedBox(width: 10),

            // delete button
            CustomButton(
              onTap: () {
                deleteExercise(i);
              },
              text: "",
              icon: Icons.delete,
              verticalPadding: 13,
              horizontalPadding: 13,
            )
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            // sets
            Expanded(
              child: CustomTextField(
                hintText: Utils().translate(context, "sets"),
                controller: setsList[i],
                maxLength: 3,
                numbersOnly: true,
                textAlignCenter: true,
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: Text("X"),
            ),

            // repetitions
            Expanded(
              child: CustomTextField(
                hintText: Utils().translate(context, "reps"),
                controller: repsList[i],
                maxLength: 3,
                numbersOnly: true,
                textAlignCenter: true,
              ),
            ),

            SizedBox(width: 10),

            // start weight
            Expanded(
              child: CustomTextField(
                hintText: Utils().translate(context, "init_weight"),
                controller: initWeightList[i],
                maxLength: 3,
                numbersOnly: true,
                textAlignCenter: true,
              ),
            )
          ],
        ),
        SizedBox(height: 5),
      ],
    );
  }

  Widget loadEditablePlan() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          for (int i = 0; i < SessionData.elements.length; i++) exerciseForm(i),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // add exercise
                CustomButton(
                    onTap: () {
                      setState(() {
                        SessionData.elements.add(Exercise());
                      });

                      addExercise();
                    },
                    text: Utils().translate(context, "exercise"),
                    icon: Icons.add),

                SessionData.elements.isNotEmpty && SessionData.elements.last.divider
                    ?
                    // remove split
                    CustomButton(
                        onTap: () {
                          setState(() {
                            SessionData.elements.removeLast();
                          });
                        },
                        text: Utils().translate(context, "delete_split_workout"),
                        icon: Icons.remove_circle)
                    :
                    // add split
                    CustomButton(
                        onTap: () {
                          if (SessionData.elements.isNotEmpty) {
                            setState(() {
                              Exercise newExercise = Exercise();
                              newExercise.divider = true;

                              SessionData.elements.add(newExercise);
                              addExercise();
                            });
                          }
                        },
                        text: Utils().translate(context, "split_workout"),
                        icon: Icons.horizontal_split,
                        buttonColor: SessionData.elements.isEmpty ? Colors.grey : Colors.red,
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget loadReadOnlyPlan() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          for (int i = 0; i < SessionData.elements.length; i++)
            SessionData.elements[i].divider
                // show divider
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Divider(
                      color: Colors.red,
                      thickness: 5,
                    ),
                  )
                : Column(
                    children: [
                      if (i > 0 && !SessionData.elements[i - 1].divider)
                        Divider(
                          color: Colors.grey[800],
                        ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 150,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // exercise name
                                Text(
                                  SessionData.elements[i].exerciseName.toUpperCase(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                ),

                                // sets x reps
                                Row(
                                  children: [
                                    Text(SessionData.elements[i].sets),
                                    Text(" × "),
                                    Text(SessionData.elements[i].reps),
                                  ],
                                )
                              ],
                            ),
                          ),

                          // initial weight
                          Container(
                            width: 80,
                            child: Center(
                              child: Text(
                                "🏋️ " + SessionData.elements[i].initWeight,
                                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),

                          // current weight
                          Expanded(
                            child: CustomTextField(
                              hintText: Utils().translate(context, "current_weight"),
                              controller: currentWeightList[i],
                              maxLength: 3,
                              numbersOnly: true,
                              textAlignCenter: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
        ],
      ),
    );
  }
  // #endregion

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: GestureDetector(
          onDoubleTap: () {
            Utils().successMessage(context, version, translate: false);
          },
          child: Text(
            "🍅 Tomato Gym",
            style: TextStyle(color: Colors.black),
          ),
        ),
        actions: SessionData.elements.isNotEmpty && !loadPlan
            ? [
                GestureDetector(
                  onTap: () {
                    editPlan();
                  },
                  child: Icon(
                    Icons.edit,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                      onTap: () {
                        copyPlan();
                      },
                      child: Icon(
                        Icons.copy_all,
                        color: Colors.black,
                        size: 30,
                      )),
                ),
                GestureDetector(
                    onTap: () {
                      createNewPlan();
                    },
                    child: Icon(
                      Icons.add_box_rounded,
                      color: Colors.black,
                      size: 30,
                    )),
                SizedBox(width: 10)
              ]
            : [],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            )
          : SessionData.elements.isEmpty && !loadPlan
              ? welcomePage()
              : loadPlan
                  ? SingleChildScrollView(child: loadEditablePlan())
                  : SingleChildScrollView(child: loadReadOnlyPlan()),
      floatingActionButton: !isLoading && SessionData.elements.isEmpty && !loadPlan || SessionData.elements.isEmpty
          ? SizedBox()
          : FloatingActionButton(
              onPressed: () async {
                setState(() {
                  isSaving = true;
                });

                bool emptyFields = false;

                // retrieve data
                for (int i = 0; i < SessionData.elements.length; i++) {
                  if (!SessionData.elements[i].divider && (exerciseNameList[i].text == "" || setsList[i].text == "" || repsList[i].text == "" || initWeightList[i].text == "")) {
                    emptyFields = true;
                  }

                  SessionData.elements[i].exerciseName = exerciseNameList[i].text;
                  SessionData.elements[i].sets = setsList[i].text;
                  SessionData.elements[i].reps = repsList[i].text;
                  SessionData.elements[i].initWeight = initWeightList[i].text;
                  SessionData.elements[i].currentWeight = currentWeightList[i].text;
                }

                if (emptyFields) {
                  Utils().errorMessage(context, "empty_fields_message");

                  setState(() {
                    isSaving = false;
                  });

                  return;
                }

                // save data
                try {
                  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                  List<String> elementEncoded = SessionData.elements.map((element) => jsonEncode(element.toJson())).toList();
                  await sharedPreferences.setStringList('elements', elementEncoded);

                  // success message
                  Utils().successMessage(context, "save_success");
                } catch (e) {
                  // error message
                  Utils().errorMessage(context, "save_failure");

                  setState(() {
                    isSaving = false;
                  });

                  return;
                }

                setState(() {
                  isSaving = false;
                  loadPlan = false;
                });
              },
              backgroundColor: Colors.red,
              child: isSaving
                  ? CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Icon(Icons.save),
            ),
    );
  }
}

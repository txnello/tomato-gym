// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tomato_gym/settings/sessionData.dart';
import 'package:tomato_gym/settings/utils.dart';
import 'package:tomato_gym/widgets/customButton.dart';
import 'package:tomato_gym/widgets/customTextField.dart';

class ManagePlan extends StatefulWidget {
  const ManagePlan({super.key});

  @override
  State<ManagePlan> createState() => _ManagePlanState();
}

class _ManagePlanState extends State<ManagePlan> {
  bool newPlan = false;

  List<TextEditingController> exerciseNameList = [];
  List<TextEditingController> setsList = [];
  List<TextEditingController> repsList = [];
  List<TextEditingController> initWeightList = [];

  @override
  void initState() {
    super.initState();

    initDataSources();
  }

  initDataSources() {
    for (var el in SessionData.elements) {
      setState(() {
        exerciseNameList.add(TextEditingController());
        setsList.add(TextEditingController());
        repsList.add(TextEditingController());
        initWeightList.add(TextEditingController());
      });
    }
  }

  deleteExercise(int i) {
    setState(() {
      SessionData.elements.removeAt(i);
      exerciseNameList.removeAt(i);
    });
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
              ),
            ),

            SizedBox(width: 10),

            // start weight
            Expanded(
              child: CustomTextField(
                hintText: Utils().translate(context, "init_weight"),
                controller: initWeightList[i],
              ),
            )
          ],
        ),
        SizedBox(height: 5),
      ],
    );
  }

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
                  setState(() {
                    newPlan = true;
                  });
                })),
      ],
    );
  }

  Widget loadPlan() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
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

                      initDataSources();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("🍅 Tomato Gym", style: TextStyle(color: Colors.black),),
      ),
      body: SessionData.elements.isEmpty && !newPlan
          ? welcomePage()
          : newPlan
              ? SingleChildScrollView(child: loadPlan())
              : Center(child: Text("aa")),
    );
  }
}

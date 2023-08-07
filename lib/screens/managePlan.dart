// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tomato_gym/settings/plan.dart';
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

  List<Map<String, String>> elements = [
    {"a": "b"},
    {"a": "b"}
  ];

  //final TextEditingController exerciseName = TextEditingController();
  List<TextEditingController> exerciseNameList = [];

  @override
  void initState() {
    super.initState();

    initDataSources();
  }

  initDataSources() {
    for (var el in elements) {
      setState(() {
        exerciseNameList.add(TextEditingController());
      });
    }
  }

  deleteExercise(int i) {
    setState(() {
      elements.removeAt(i);
      exerciseNameList.removeAt(i);
    });
  }

  Widget exerciseForm(int i) {
    return Column(
      children: [
        SizedBox(height: 5),
        Row(
          children: [
            // exercise name
            Expanded(
              child: CustomTextField(
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
                controller: exerciseNameList[i],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: Text("X"),
            ),

            // repetitions
            Expanded(
              child: CustomTextField(
                controller: exerciseNameList[i],
              ),
            ),

            SizedBox(width: 10),

            // start weight
            Expanded(
              child: CustomTextField(
                controller: exerciseNameList[i],
              ),
            )
          ],
        ),
        SizedBox(height: 5),
        Divider(
          color: Colors.grey[800],
        ),
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
          for (int i = 0; i < elements.length; i++) exerciseForm(i),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomButton(
                  onTap: () {
                    setState(() {
                      elements.add({"a": "b"});
                    });

                    initDataSources();
                  },
                  text: "add",
                  icon: Icons.add),
              CustomButton(onTap: () {}, text: "new ex", icon: Icons.add),
            ],
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
      ),
      body: Plan().data.isEmpty && !newPlan
          ? welcomePage()
          : newPlan
              ? SingleChildScrollView(child: loadPlan())
              : Center(child: Text("aa")),
    );
  }
}

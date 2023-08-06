// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:tomato_gym/settings/plan.dart';
import 'package:tomato_gym/settings/utils.dart';

class ManagePlan extends StatefulWidget {
  const ManagePlan({super.key});

  @override
  State<ManagePlan> createState() => _ManagePlanState();
}

class _ManagePlanState extends State<ManagePlan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Plan().data.isEmpty ?

      // if no plan has been found
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // welcome
          Text(Utils().translate(context, "welcome"),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40
            ),
          ),

          SizedBox(height: 50),

          // message
          Container(
            width: 200,
            child: Text(Utils().translate(context, "no_plan_found"),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 23
              ),
            ),
          ),

          SizedBox(height: 20),

          // button
          Center(
            child: GestureDetector(
              onTap: () {
                
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Text(Utils().translate(context, "create_new_plan"),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18
                    ),
                  ),
                ),
              ),
            )
          ),
        ],
      )
      :
      Center(child: Text("aa")),
    );
  }
}

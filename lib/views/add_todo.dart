import 'dart:ui';
import 'package:hive/hive.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
// ignore: unused_import
import "package:googleapis_auth/auth_io.dart";
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:url_launcher/url_launcher.dart';
// import 'package:googleapis/calendar/v3.dart';

import 'package:todo/adapters/todo_adapter.dart';

import '../CalendarClient.dart';

class AddTodo extends StatefulWidget {
  final formkey = GlobalKey<FormState>();
  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  CalendarClient calendarClient = CalendarClient();
  DateTime _start = DateTime.now();
  DateTime _end = DateTime.now().add(Duration(hours: 1));
  String title = 'No title';
  String description = 'No description';

  submitData() async {
    if (widget.formkey.currentState.validate()) {
      Box<Todo> todoBox = Hive.box<Todo>('todos');
      todoBox.add(
        Todo(
          title: title,
          description: description,
          start: _start,
          end: _end,
        ),
      );
      Navigator.of(context).pop();
      calendarClient.insert(
        title,
        _start,
        _end,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text(
          "Add task",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
      ),
      body: Container(
        child: Form(
          key: widget.formkey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              TextFormField(
                decoration: InputDecoration(hintText: 'Add title'),
                onChanged: (value) {
                  setState(() {
                    title = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(hintText: 'Add description'),
                onChanged: (value) {
                  setState(() {
                    description = value;
                  });
                },
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _start == null
                        ? 'Start : '
                        : 'Start : ' + _start.toString(),
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.yellow),
                    onPressed: () {
                      DatePicker.showDateTimePicker(context,
                              showTitleActions: true,
                              minTime: DateTime.now(),
                              maxTime: DateTime.now().add(Duration(days: 364)),
                              currentTime: DateTime.now(),
                              locale: LocaleType.en)
                          .then((value) {
                        setState(() {
                          _start = value;
                        });
                      });
                    },
                    child: Icon(
                      Icons.date_range_outlined,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _end == null ? 'End : ' : 'End : ' + _end.toString(),
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.yellow),
                      onPressed: () {
                        DatePicker.showDateTimePicker(context,
                                showTitleActions: true,
                                minTime: DateTime.now(),
                                maxTime:
                                    DateTime.now().add(Duration(days: 365)),
                                currentTime:
                                    DateTime.now().add(Duration(hours: 1)),
                                locale: LocaleType.en)
                            .then((value) {
                          setState(() {
                            _end = value;
                          });
                        });
                      },
                      child: Icon(
                        Icons.date_range_outlined,
                        color: Colors.black,
                      )),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.yellow),
                onPressed: submitData,
                child: Text(
                  'Add',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              Text(' Tip: You can long press on an item to delete it!'),
            ],
          ),
        ),
      ),
    );
  }
}

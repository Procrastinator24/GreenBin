import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormWidget extends StatefulWidget{
  const FormWidget({super.key});

  @override
  State<FormWidget> createState() => _FormWidget();
}

class _FormWidget extends State<FormWidget>{
  
  TextEditingController searchControl = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              onChanged: (value) => (),
              controller: searchControl,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xffDEEFF3),
                prefixIcon: Icon(Icons.search, color: Colors.black),
                suffixIcon: IconButton(
                  onPressed: () => searchControl.clear(),
                  icon: Icon(Icons.clear, color: Color(0xff005e63)) ),
                hintText: 'Поиск',
                hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none
                )
              ),
            )
          ],
        )
      ),
    );
  }
}
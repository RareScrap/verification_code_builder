import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verification_code_builder/verification_code_builder.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VerificationCode example app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('VerificationCode'),
        ),
        body: Center(
          child: VerificationCode(
            length: 6,
            onCompleted: (String value) {
              print("Code is $value");
            },
            builder: (index, focus, textEditingController, pasteMethod) {
              return _generateSingleDigit(index, focus, textEditingController, pasteMethod);
            },
          ),
        )
    );
  }

  Widget _generateSingleDigit(int i, FocusNode focus, TextEditingController textEditingController, PasteMethod pasteMethod) {
    return Container(
      height: 48,
      width: 48,
      margin: EdgeInsets.only(left: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Colors.grey),
      child: Center(
        child: TextField(
          controller: textEditingController,
          focusNode: focus,
          autofocus: i == 0,
          selectionControls: VerificationSelectionControls.create(pasteMethod),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(1)],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
          onChanged: (str) => {
            // if (str.isNotEmpty) {
              i == 5 ? FocusScope.of(context).unfocus() : focus.nextFocus() // TODO: Слетает фокус при стирании последней ячейки
            // }
          },
        ),
      ),
    );
  }
}
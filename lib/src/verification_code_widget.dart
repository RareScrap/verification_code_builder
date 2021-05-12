import 'package:flutter/widgets.dart';

import 'backspace_text_editing_controller.dart';

typedef void PasteMethod(String str);

class VerificationCode extends StatefulWidget { // TODO: Stateless?

  final ValueChanged<String> onCompleted;

  final int length;

  final bool enableHorizontalScroll;

  final MainAxisAlignment mainAxisAlignment;

  final Widget Function(int index, FocusNode focus, TextEditingController textEditingController, PasteMethod pasteMethod) builder;

  VerificationCode({
    this.builder, // TODO: required
    this.onCompleted,
    this.length = 4,
    this.enableHorizontalScroll = true,
    this.mainAxisAlignment = MainAxisAlignment.center,
  });

  @override
  _VerificationCodeState createState() => _VerificationCodeState();
}

class _VerificationCodeState extends State<VerificationCode> {
  final List<FocusNode> _listFocusNode = <FocusNode>[];
  final List<BackspaceTextEditingController> _listControllerText = <BackspaceTextEditingController>[];
  String _code = ""; // To prevent false onComplete firing

  @override
  void initState() {
    for (var i = 0; i < widget.length; i++) {
      _listFocusNode.add(FocusNode());
      var tec = BackspaceTextEditingController(() => {
        if (i > 0) _listFocusNode[i-1].requestFocus()
      });
      // tec.value = new TextEditingValue(text: " ");
      tec.addListener(() {

        // var index = _listControllerText.indexOf(tec);
        // if (tec.text.isEmpty && index > 0) {
        //   tec.value = new TextEditingValue(text: " ");
        //   _listFocusNode[index-2].requestFocus();
        // }


        if (_code != code && isInputComplete) {
          widget.onCompleted(code);
          _code = code;
        }
      });
      _listControllerText.add(tec);
    }

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final content = Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: widget.mainAxisAlignment,
          children: _buildListWidget(),
        ),
      ],
    );

    if (widget.enableHorizontalScroll) {
      return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: content);
    } else {
      return content;
    }
  }

  @override
  void dispose() {
    _listFocusNode.forEach((element) { element.dispose(); });
    _listFocusNode.clear();
    _listControllerText.forEach((element) { element.dispose(); });
    _listControllerText.clear();
    super.dispose();
  }

  String get code {
    String verifyCode = ""; // TODO: use accumulation func
    for (var i = 0; i < widget.length; i++) {
      verifyCode += _listControllerText[i].text;
    }
    return verifyCode;
  }

  bool get isInputComplete => _listControllerText.firstWhere(
          (element) => element.text.isEmpty, orElse: () => null) == null;

  // TODO: Не учитывает inputFormatters (особенно LengthLimitingTextInputFormatter(2))
  void paste(String str) { // TODO: Не срабатывает при пасте из гугл-клавиатуры
    _listControllerText.forEach((element) { element.enableListeners = false; });

    for (int i = 0; i < widget.length; i++) {
      _listControllerText[i].text = i < str.length ? str[i] : "";
    }
    // Переводим фукус на последнию цифру в вставленной строке
    _listFocusNode[str.length >= widget.length ? widget.length-1 : str.length-1].requestFocus();

    _listControllerText.forEach((element) {
      element.enableListeners = true;
      element.notifyListeners();
    });
  }

  List<Widget> _buildListWidget() {
    List<Widget> listWidget = [];
    for (int index = 0; index < widget.length; index++) {
      // var next = index+1 < _listFocusNode.length ? _listFocusNode[index+1] : null;
      listWidget.add(widget.builder(index, _listFocusNode[index], _listControllerText[index], paste));
    }
    return listWidget;
  }
}
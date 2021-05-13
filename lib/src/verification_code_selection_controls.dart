import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'verification_code_widget.dart';

class VerificationSelectionControls {
  // TODO: Как правильно чекать платформу?
  static TextSelectionControls create(PasteMethod pasteMethod) =>
      Platform.isIOS
        ? CupertinoVerificationSelectionControls(pasteMethod)
        : MaterialVerificationSelectionControls(pasteMethod);
}

class MaterialVerificationSelectionControls extends MaterialTextSelectionControls {

  final PasteMethod pasteMethod;

  MaterialVerificationSelectionControls(this.pasteMethod);

  @override
  Future<void> handlePaste(TextSelectionDelegate delegate) async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text?.isNotEmpty ?? false) pasteMethod(data!.text!);
  }

  @override
  bool canSelectAll(TextSelectionDelegate delegate) => false;

  @override
  bool canCut(TextSelectionDelegate delegate) => false;

  @override
  bool canCopy(TextSelectionDelegate delegate) => false;
}

class CupertinoVerificationSelectionControls extends CupertinoTextSelectionControls {

  final PasteMethod pasteMethod;

  CupertinoVerificationSelectionControls(this.pasteMethod);

  @override
  Future<void> handlePaste(TextSelectionDelegate delegate) async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text?.isNotEmpty ?? false) pasteMethod(data!.text!);
  }

  @override
  bool canSelectAll(TextSelectionDelegate delegate) => false;

  @override
  bool canCut(TextSelectionDelegate delegate) => false;

  @override
  bool canCopy(TextSelectionDelegate delegate) => false;
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BackspaceTextEditingController extends TextEditingController {

  final Function() onLimitBackspacePressed; // TODO: Переименовать и перестать различать крайние бэкспейсы с обычными?

  BackspaceTextEditingController(this.onLimitBackspacePressed);

  bool enableListeners = true;

  @override
  set value(TextEditingValue newValue) {

    // Попытка хандлить softkeyboard backspace, нажатый на пустом текстфилде.
    // Данный метод будет вызван извне при любом изменении текстфилда. Что
    // особенно важно - движок флаттера не проверяет отличается ли новое
    // значение от старого. Именно этим мы и воспользуемся! Логика проста -
    // если новое значение == старому, то вероятнее всего юзер пытается нажать
    // backspace на пустом текстфилде. Однако нужно учитывать пару ньюансов...

    // при попытке двигать ручки селекшона за пределы текстфилда будет каждый фрейм
    // происходить сеттинг нового значения, которое == старому! Флаг ниже проверяет
    // выделен ли текст, чтобы избежать сеттинга одинаковых значений, когда по факту
    // с текстфилдом НИЧЕГО НЕ ПРОИСХОДИТ.
    bool isInSelection = newValue.selection.start != newValue.selection.end;
    // Также проверяем похожую ситуацию, но когда у селекшона только один ханлд
    // bool isMovingSingleSelection = TODO: Сейчас я хз как это проверить

    // Передосим фокус назад, если стерли последний символ
    if (value.text != newValue.text && newValue.text.isEmpty) {
      super.value = const TextEditingValue(selection: TextSelection.collapsed(offset: 0));
      onLimitBackspacePressed();
      return;
    }

    // TODO: Если контент ячейки выделен селекшоном, то новый текст должен заменять контент. Сейчас же он очищается а фокус передается предыдущей ячейке.

    if (value == newValue && value.selection.baseOffset == 0 && !isInSelection) {
      onLimitBackspacePressed();
    } else {
      super.value = newValue;
    }
  }

  @override
  void clearComposing() {
    // clearComposing() имеет свойство вызываться даже когда все и так очищено.
    // Пресекаем подобное поведение.
    var newValue = value.copyWith(composing: TextRange.empty);
    if (newValue != value) value = newValue;
  }

  @override
  void notifyListeners() {
    if (enableListeners) super.notifyListeners();
  }
}
import 'dart:async';
import 'package:flutter/cupertino.dart';

import 'const.dart';
import 'expression.dart';

class MainState with ChangeNotifier {
  List<Expression> field = List();
  Timer timer;
  static const int period_start = 500;
  int period = 500;
  int score = 0;
  int miss = 0;
  int answer;

  MainState() {
    startTimeout();
  }

  void startTimeout() {
    timer = Timer.periodic(Duration(milliseconds: period), updatePosition);
  }

  void stopTimeout() {
    timer.cancel();
  }

  void toggleTimeout() {
    if (timer.isActive) {
      stopTimeout();
    } else {
      startTimeout();
    }
  }

  void addExpression() {
    field.add(Expression());
    notifyListeners();
  }

  void addAnswer(int newKey) {
    if (answer == null) {
      answer = newKey;
    } else {
      answer = int.parse(answer.toString() + newKey.toString());
    }
    notifyListeners();
  }

  void clearAnswer() {
    answer = null;
    notifyListeners();
  }

  void checkExpression() {
    if (answer == null) {
      return;
    }

    int item = field.indexWhere((element) => element.isCorrect(answer));
    if (item != -1) {
      field.removeAt(item);
      ++score;
      notifyListeners();
    } else {
      ++miss;
      notifyListeners();
    }

    clearAnswer();
  }

  void updatePosition(timer) {
    addExpression();
    for (var i = 0; i < field.length; i++) {
      field[i].updatePosition();
      if (field[i].positionY > FIELD_HEIGHT) {
        field.removeAt(i);
        ++miss;
      }
    }
    notifyListeners();
  }

  void clearAll() {
    stopTimeout();
    field = List();
    score = 0;
    miss = 0;
    answer = null;
    period = MainState.period_start;
  }
}
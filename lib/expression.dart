import 'dart:math';

class Expression {
  num _answer;
  Operators _factor;
  num _term1;
  num _term2;
  num positionX;
  num positionY;

  Expression() {
    _factor = getRandomFromList(operatorsList);
    List<int> randomItems = List();
    if (_factor == Operators.DIVIDE) {
      randomItems.add(getRandomFromList(dividedListTerm1));
      randomItems.add(getRandomFromList(dividedListTerm2));
    } else {
      randomItems.add(getRandomFromList(numberList));
      randomItems.add(getRandomFromList(numberList));
      randomItems.sort((a, b) => b - a);
    }
    _term1 = randomItems[0];
    _term2 = randomItems[1];
    _answer = operatorsFunc[_factor](_term1, _term2);
//   TODO if (_answer is not int) return Expression();
    positionX = getRandomFromMax(300);
    positionY = 0;
    // set random positionXRR
  }

  bool isCorrect(int a) {
    return a == _answer;
  }

  void updatePosition() {
    positionY += 10;
  }

  String get string =>
      _term1.toString() + ' ' + operatorsStr[_factor] + ' ' + _term2.toString();
}

enum Operators {
  ADD,
  SUBTRACT,
  DIVIDE,
  MULTIPLY,
}

final List<int> numberList = [
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10,
  11,
  12,
  13,
  14,
  15
];

final List<int> dividedListTerm1 = [
  4,
  8,
  12,
];

final List<int> dividedListTerm2 = [
  1,
  2,
  4,
];

final Map<Operators, String> operatorsStr = {
  Operators.ADD: '+',
  Operators.SUBTRACT: '-',
  Operators.DIVIDE: '/',
  Operators.MULTIPLY: '*',
};

final List<Operators> operatorsList = [
  Operators.ADD,
  Operators.SUBTRACT,
  Operators.DIVIDE,
  Operators.MULTIPLY
];

final Map<Operators, Function> operatorsFunc = {
  Operators.ADD: (num a, num b) => a + b,
  Operators.SUBTRACT: (num a, num b) => a - b,
  Operators.DIVIDE: (num a, num b) => a / b,
  Operators.MULTIPLY: (num a, num b) => a * b,
};

T getRandomFromList<T>(List<T> list) {
  final _random = Random();
  return list[_random.nextInt(list.length)];
}

int getRandomFromMax(int max) {
  final _random = Random();
  return _random.nextInt(max);
}
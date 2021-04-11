import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'const.dart';
import 'expression.dart';
import 'state.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => MainState(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPage('count it'),
    );
  }
}

class MainPage extends StatelessWidget {
  final String title;

  MainPage(this.title);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return Consumer<MainState>(builder: (context, data, child) {
              return IconButton(
                icon: const Icon(Icons.menu),
                tooltip: 'Menu',
                onPressed: () async {
                  data.stopTimeout();
                  await showDialog(
                      context: context,
                      builder: (_) => SimpleDialog(
                            title: Text('Count it'),
                            children: <Widget>[
                              IconButton(
                                alignment: Alignment.centerLeft,
                                icon: const Icon(Icons.play_circle_outline),
                                tooltip: 'Start',
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              IconButton(
                                alignment: Alignment.centerLeft,
                                icon: const Icon(Icons.play_circle_outline),
                                tooltip: 'New Game',
                                onPressed: () {
                                  data.clearAll();
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          ));
                  data.startTimeout();
                },
              );
            });
          },
        ),
        title: Text(title),
        actions: <Widget>[
          Consumer<MainState>(builder: (context, data, child) {
            return Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: Row(
                  children: [
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: Text(data.miss.toString(),
                            style: TextStyle(
                                fontSize: 10, color: Colors.red[900]))),
                    Text(data.score.toString(),
                        style:
                            TextStyle(fontSize: 30, color: Colors.green[900])),
                  ],
                ));
          })
        ],
      ),
      body: Consumer<MainState>(builder: (context, data, child) {
        return Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                width: MediaQuery.of(context).size.width,
                height: FIELD_HEIGHT,
                decoration: BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: Colors.red, width: 5))
//                    border: Border.all(color: Colors.red, width: 5)
                    ),
                child: Stack(children: getExpressionListWidget(data.field))),
            Container(
                child: Text(data.answer == null ? '' : data.answer.toString())),
            Column(
              children: getKeyboard(context, data),
            )
          ],
        );
      }),
    );
  }
}

Widget getExpressionWidget(Expression item) {
  return Positioned(
//    duration: Duration(seconds: 1),
    top: item.positionY.toDouble(),
    left: item.positionX.toDouble(),
    child: Text(item.string, style: TextStyle(color: Colors.blueAccent)),
  );
}

List<Widget> getExpressionListWidget(List<Expression> items) {
  List<Widget> list = List<Widget>();
  for (var i = 0; i < items.length; i++) {
    list.add(getExpressionWidget(items[i]));
  }
  return list;
}

List<Widget> getKeyboard(context, MainState data) {
  List<String> keys = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '0',
    'Enter'
  ];

  List<Widget> buttonsKeys = keys
      .map((el) => ButtonTheme(
          minWidth: MediaQuery.of(context).size.width / 3.2,
          child: RaisedButton(
            child: Text(el),
            onPressed: () {
              if (el == 'Enter') {
                pressEnter(data);
              } else {
                pressKey(data, el);
              }
            },
          )))
      .toList();

  List<int> rows = [0, 3, 6, 9];

  return rows.map((index) {
    int to = index + 3;
    if (to > buttonsKeys.length) {
      to = buttonsKeys.length;
    }
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      buttonPadding: EdgeInsets.fromLTRB(2, 2, 2, 2),
      children: buttonsKeys.sublist(index, to),
    );
  }).toList();
}

void pressKey(MainState data, String key) {
  data.addAnswer(int.parse(key));
}

void pressEnter(MainState data) {
  data.checkExpression();
}

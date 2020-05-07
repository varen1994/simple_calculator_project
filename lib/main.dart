import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String textFieldValue = "";
  var lastOperation = "";
  var lastValue = "";

  final allrows = [
                   //   "mc","m+","m-","mr",
                      "AC","√x","%","/",
                      "7","8","9","X",
                      "4","5","6","-",
                      "1","2","3","+",
                      "0",".","+/-","=",
                   //   "pie","x²","R2","R0"
                  ];

  var acceptableOperations = ["AC","+","-","/","X","=","%"];
  final prohibitedOperations = ["√x","+/-"];

  void showAlert(String alertTitle) {
     showDialog(context: context,
        barrierDismissible: true,
       builder: (BuildContext context) {
         return AlertDialog(
           title: Text(alertTitle),
           actions: <Widget>[
             FlatButton(
               textColor: Colors.blue,
               child: Text('Cancel'),
               onPressed: () {
                 Navigator.of(context).pop();
               },
             ),

           ],
         );
       }
     );
  }

  void clickedOnButton(String value) {
    var newValue = "";
    if(value == "AC")  {
      lastOperation =  "";
      lastValue = "";
      setState(() {
        textFieldValue = newValue;
      });
      return ;
    }

    if(acceptableOperations.contains(value)) {
         if(lastOperation == "" && value != "=") {
          lastValue = textFieldValue;
          lastOperation = value;
        } else if (textFieldValue.length == 0 && lastOperation != "" && value != "=") {
            lastOperation = value;
         } else if (value == "=" && lastValue.length == 0) {
           newValue = textFieldValue;
         } else
         {
         print("------------ third case --------------");
         switch(lastOperation) {
             case ("%"): {
               double result = double.parse(lastValue) % double.parse(textFieldValue);
               if((result - result.toInt()) == 0.0) {
                 newValue = "${result.toInt()}";
               } else {
                 newValue = "${result}";
               }
               break;
             }
             case ("+"): {
               double result = double.parse(lastValue) + double.parse(textFieldValue);
               if((result - result.toInt()) == 0.0) {
                 newValue = "${result.toInt()}";
               } else {
                 newValue = "${result}";
               }
               break;
             }
             case ("-"): {
               double result = double.parse(lastValue) - double.parse(textFieldValue);
               if((result - result.toInt()) == 0.0) {
                 newValue = "${result.toInt()}";
               } else {
                 newValue = "${result}";
               }
               break;
             }
             case ("X"): {
               double result = double.parse(lastValue) * double.parse(textFieldValue);
               if((result - result.toInt()) == 0.0) {
                 newValue = "${result.toInt()}";
               } else {
                 newValue = "${result}";
               }
               break;
             }
             case ("/"): {
               if(double.parse(textFieldValue) == 0.0) {
                 showAlert("Operation Not allowed");
               } else {
                 double result = double.parse(lastValue) / double.parse(textFieldValue);
                 if((result - result.toInt()) == 0.0) {
                   newValue = "${result.toInt()}";
                 } else {
                   newValue = "${result}";
                 }
               }
               break;
             }
         };

         if(value != "=") {
           lastOperation = value;
           newValue = "";
         } else {
           lastOperation = "";
         }
         lastValue = "";
      }
    } else {
      if(value != ".") {
        newValue = textFieldValue + value;
      } else {
        if(textFieldValue.contains(".") == false) {
          newValue = textFieldValue + value;
        } else {
          newValue = textFieldValue;
        }
      }
    }

    setState(() {
      textFieldValue = newValue;
    });
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
     return Scaffold(
       appBar: AppBar(
         backgroundColor: Colors.blue,
         title: Text("Calculator App"
         ),
       ),
       body: Column(
         children: <Widget>[
           Container(
             padding: EdgeInsets.all(20.0),
             decoration: BoxDecoration(
               border: Border.all(color: Colors.blue,width: 2.0)
             ),
             child: Center(
               child: Text(this.textFieldValue,
                 textAlign: TextAlign.right,
                 style: TextStyle(
                   fontSize: 30.0,
                 ),
               ),
             ),
             height: size.height * 0.28,
             width: size.width,
           )
           ,Container(
             child: GridView.count(crossAxisCount: 4,
               childAspectRatio: 1.35,
               children: List.generate(allrows.length, (index) {
                 if(prohibitedOperations.contains(allrows[index])) {
                   return SizedBox(
                     height: 100,
                     child: Center(
                         child: OutlineButton(
                           child: Text(
                             allrows[index],
                             style: TextStyle(
                                 color: Colors.red,
                                 fontSize: 20.0
                             ),
                           ),
                           borderSide: BorderSide(
                               color: Colors.red,
                               width: 2.0
                           ),
                           padding: EdgeInsets.all(0.0),
                         )
                     ),
                   );
                 } else {
                   return SizedBox(
                     height: 100,
                     child: Center(
                         child: OutlineButton(
                           onPressed: () {
                             if (prohibitedOperations.contains(
                                 allrows[index]) == false) {
                               clickedOnButton(allrows[index]);
                             }
                           },
                           child: Text(
                             allrows[index],
                             style: TextStyle(
                                 color: Colors.blue,
                                 fontSize: 20.0
                             ),
                           ),
                           borderSide: BorderSide(
                               color: Colors.blue,
                               width: 2.0
                           ),
                           padding: EdgeInsets.all(0.0),
                         )
                     ),
                   );
                 }
               }),
             ),
             height: size.height * 0.6,
             width: size.width,
             decoration: BoxDecoration(
               color: Colors.grey.withAlpha(30)
             ),
           )
         ],
       )
     );
  }
}

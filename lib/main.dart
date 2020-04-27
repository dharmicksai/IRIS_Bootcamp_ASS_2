import 'package:flutter/material.dart';
import 'loader.dart';
import 'strings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Homepage() ,
      routes: {
    "/home": (BuildContext context) => HomeScreen(),
    },

    );

  }
}
class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.lightGreenAccent,Colors.blue],
              begin: Alignment.topLeft,
              end:Alignment.bottomRight
          )
        ),
        child: Center(

            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Hola ',style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),),
                  SizedBox(
                    height: 30.0,
                  ),
                  loader(),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text('Please Wait Loading',style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w300,
                  ),),
                ],
              ),
            )),
      )
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int day = DateTime.now().day;
  int month = DateTime.now().month;
  int year = DateTime.now().year;



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
         title: Text('$day ${months[month]} $year'),
          centerTitle: true,
        ),
        body: buildList(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){
            if(curlindex<strings.length)
              {
                showDialog(

                    context: context,
                    builder:(BuildContext context){
                      return Dialog(


                        backgroundColor: Colors.blue,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text('Hi',style: TextStyle(
                              fontSize: 20.0
                            ),),
                            Text('Do u want to add event:',style:TextStyle(
                              fontSize: 20.0
                            ),),
                            Text(' ${events[strings[curlindex]]}',style: TextStyle(
                              fontSize: 20
                            ),),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                FlatButton(
                                    color: Colors.lightGreenAccent,
                                    onPressed: (){
                                      data.add(strings[curlindex]);
                                      curlindex++;
                                      setState(() {});
                                      Navigator.pop(context);

                                    },
                                    child: Text('yes',style: TextStyle(
                                      fontSize: 20.0
                                    ),)
                                ),
                                FlatButton(
                                  onPressed: (){
                                    Navigator.pop(context);
                                  },
                                  child:Text('No') ,
                                  color: Colors.red,
                                ),
                              ],
                            )


                          ],
                        ),

                      );
                    }
                );
                setState(() {});
              } else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Alert'),
                      content: Text('End of list!'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  });
            }

          },

        ),
        backgroundColor: Colors.lightGreenAccent,
      ),
    );

  }
}
List<String>data = [
  '26 Jan',
  '10 Mar',
  '25 Mar',
  '1 May',
  '7 May',
  '25 May',
  '1 Aug',
  '3 Aug',
  '12 Aug',
];

int curlindex=6;

Widget buildList() {
  return ListView.builder(
    itemCount: data.length,
    itemBuilder: (BuildContext context, int index) {
      return Container(
        padding: EdgeInsets.symmetric(vertical:10.0,horizontal:50.0),
        child: ExpansionTile(
          title: Text(data[index]+" : "+ events[data[index]]),
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical:10.0,horizontal: 80.0),
                child:FlatButton(
                    onPressed:() async{
                      if (await canLaunch(url[data[index]])) {
                        await launch(url[data[index]]);
                      } else {
                        print('could not launch');
                        throw 'Could not launch url';
                      }

                    },
                    child: Icon(Icons.launch)),
              ),
            ),
          ],
        ),
      );
    },
  );
}





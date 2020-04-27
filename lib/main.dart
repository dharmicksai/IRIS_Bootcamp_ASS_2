import 'package:flutter/material.dart';
import 'loader.dart';
import 'strings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
void main() => runApp(MyApp()); //runs My App

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Homepage() ,//sets home page to splash screen
      routes: {  //giving Navigator routes
       "/home": (BuildContext context) => HomeScreen(),
    },

    );

  }
}
class Homepage extends StatefulWidget { //splash screen sorry for not nameing properly
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container( //sending Contanier for body
        decoration: BoxDecoration(    //decorations
          gradient: LinearGradient(   //seting Background colour using gradient of colors
              colors: [Colors.lightGreenAccent,Colors.blue],  //set staring colour to green and end color to blue
              begin: Alignment.topLeft, //starting point is top left corner of screen
              end:Alignment.bottomRight//ending point is bottom right corner
          )
        ),
        child: Center( //placing contents in center

            child: SafeArea( //making sure widgets dont go to places where they might get over laped
              child: Column(  //initialising column
                mainAxisAlignment: MainAxisAlignment.center,  //alignig children to center
                children: <Widget>[
                  Text('Hola ',style: TextStyle(  // text widget
                    fontSize: 40.0, //set font size
                    fontWeight: FontWeight.bold, //set font weight to bold
                  ),),
                  SizedBox(
                    height: 30.0, //sized Box to give space between loader and text
                  ),
                  loader(), //loader is imported from lib/loader.dart see here for more details
                  SizedBox(
                    height: 30.0, //empty box to give space between loader and sized box
                  ),
                  Text('Please Wait Loading',style: TextStyle(
                    fontSize: 15.0, //setting font size
                    fontWeight: FontWeight.w300, //setting font weight
                  ),),
                ],
              ),
            )),
      )
    );
  }
}

class HomeScreen extends StatefulWidget { //actual home page
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int day = DateTime.now().day; //provides day number
  int month = DateTime.now().month; //provides month number
  int year = DateTime.now().year; //provides year number



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(  //setting app bar
         title: Text('$day ${months[month]} $year'), //title: day Month_name year
          centerTitle: true, //title to be in center
        ),
        body: buildList(), //list view
        floatingActionButton: FloatingActionButton(  //floating acttion button
          child: Icon(Icons.add),  //icon add is given to button
          onPressed: (){ //providing on press action
            if(curlindex<strings.length)  // checking if all elemnts are added to screen
              {
                showDialog(  //adding dialog

                    context: context, //context of diaalog
                    builder:(BuildContext context){  //builder of dialog box
                      return Dialog( //dialog to ask wether to add data


                        backgroundColor: Colors.blue, //background color
                        child: Column( //column for widgets
                          mainAxisSize: MainAxisSize.min, //size of column should be as minimum as possible
                          children: <Widget>[
                            Text('Hi,',style: TextStyle( // text widget
                              fontSize: 20.0 //font size
                            ),),
                            Text('Do u want to add event:',style:TextStyle(
                              fontSize: 20.0 //font size
                            ),),
                            Text(' ${events[strings[curlindex]]}',style: TextStyle(
                              fontSize: 20 //font size
                            ),),
                            Row( //row of buttons
                              mainAxisAlignment: MainAxisAlignment.center, //placeing buttons in center
                              children: <Widget>[
                                FlatButton(//add button
                                    color: Colors.lightGreenAccent,//button color
                                    onPressed: (){ //on pressed action
                                      data.add(strings[curlindex]); //adding data from strings
                                      curlindex++; //incrimenting length of data
                                      setState(() {}); //implemnting changes
                                      Navigator.pop(context); //removing dialog

                                    },
                                    child: Text('yes',style: TextStyle(
                                      fontSize: 20.0//font size
                                    ),)
                                ),
                                FlatButton(//dont add button
                                  onPressed: (){
                                    Navigator.pop(context);//remove dialog
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
              } else { //dialog to show end of file
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Alert'),
                      content: Text('End of list!'),
                      actions: <Widget>[
                        FlatButton(//button to remove allert dialog
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.pop(context);//removing dialog
                          },
                        )
                      ],
                    );
                  });
            }

          },

        ),
        backgroundColor: Colors.lightGreenAccent,//setting back ground color to light green
      ),
    );

  }
}
List<String>data = [ //data off app
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
  return ListView.builder( //list view
    itemCount: data.length, //length of list view
    itemBuilder: (BuildContext context, int index) { // widget builder
      return Container(
        padding: EdgeInsets.symmetric(vertical:10.0,horizontal:50.0),
        child: ExpansionTile( //adding expansion on clicking
          title: Text(data[index]+" : "+ events[data[index]]),
          children: <Widget>[ //children r shown when pressed on widget
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical:10.0,horizontal: 80.0),
                child:FlatButton(//button to launch url
                    onPressed:() async{
                      if (await canLaunch(url[data[index]])) { //check if it can launch url
                        await launch(url[data[index]]); //launch url
                      } else { //else throw exception
                        print('could not launch');
                        throw 'Could not launch url';
                      }

                    },
                    child: Icon(Icons.launch)),//icon for launching
              ),
            ),
          ],
        ),
      );
    },
  );
}





import 'dart:math';

import 'package:flutter/material.dart';
import 'loader.dart';
import 'strings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'note.dart';


void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  final directory = await getApplicationDocumentsDirectory(); //finding directory path
  Hive.init(directory.path); //initialisising hive
  Hive.registerAdapter(NoteAdapter()); //registering adapter for note
  runApp(MyApp()); //runs My App
}
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Homepage() ,//sets home page to splash screen
      routes: {  //giving Navigator routes
       "/home": (BuildContext context) => StartPage(),
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

      body: Container(                                  //sending Contanier for body
        decoration: BoxDecoration(                      //decorations
          gradient: LinearGradient(                      //seting Background colour using gradient of colors
              colors: [Colors.black,Colors.white],        //set staring colour to green and end color to blue
              begin: Alignment.topCenter,                 //starting point is top left corner of screen
              end:Alignment.bottomCenter                  //ending point is bottom right corner
          )
        ),
        child: Center( //placing contents in center

            child: SafeArea(                                   //making sure widgets dont go to places where they might get over laped
              child: Column(                                  //initialising column
                mainAxisAlignment: MainAxisAlignment.center,  //alignig children to center
                children: <Widget>[
                  Text('To Do',style: TextStyle(  // text widget
                    fontFamily: 'Lobster',         //specifing font family
                    fontSize: 40.0,               //set font size
                    fontWeight: FontWeight.bold,  //set font weight to bold
                  ),),
                  SizedBox(
                    height: 30.0,                //sized Box to give space between loader and text
                  ),
                  loader(),                      //loader is imported from lib/loader.dart see here for more details
                  SizedBox(
                    height: 30.0,                //empty box to give space between loader and sized box
                  ),
                  Text('Please Wait Loading',style: TextStyle(
                    fontSize: 15.0,               //setting font size
                    fontWeight: FontWeight.w300,  //setting font weight
                  ),),
                ],
              ),
            )),
      )
    );
  }
}

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Hive.openBox('notes'),                             //opening hive box
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.connectionState == ConnectionState.done){    //checks if box is open
            if(snapshot.hasError)                                  //checks if it has error
              {
                return Text(snapshot.error.toString());            //shows error
              }else{

              return HomeScreen();                                 //returns home screen
            }
          }else{
            return Scaffold();                                      //return scaffold till box is opened
          }
        }
    );
  }
  @override
  void dispose(){                 //while closing app Box is closed
    Hive.close();
    super.dispose();
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
  TextEditingController txtcontroller = TextEditingController(); //text controller


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(//setting app bar

         title: Text('$day  ${months[month]}  $year',
         style: TextStyle(
           color: Colors.black87,
           fontSize: 50.0,    //font size
           fontFamily: "Bangers",  //font family
         ),
         ), //title: day Month_name year
          centerTitle: true, //title to be in center
        ),
        body: buildList(), //list view
        floatingActionButton: FloatingActionButton(  //floating acttion button
          child: Icon(Icons.add),  //icon add is given to button
          onPressed: (){       //action onpressed
            showDialog(
                context: context,
               builder: (BuildContext context,){   //Dialog builder
                  String title;
                  String description;

                  return Dialog(
                    child: Form(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,  //keeping size minimum
                          crossAxisAlignment: CrossAxisAlignment.center,     //placing widgets in center
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: TextFormField(                //input text feild
                                decoration: InputDecoration(
                                  labelText: 'todo'
                                ),

                                onChanged:(input) {    //when adding input input is saved in titlle
                                      title = input;

                                  },

                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'description'
                                ),
                                onChanged:(input) {
                                  description = input;   //input for description

                                },

                              ),
                            ),
                            RaisedButton(
                                onPressed: (){
                                  if ((title != null) && (description != null)&&(title!=' ')&&(description!=' ')&&(title!=' ')&&(description!=' ')) {  //checking for title and description not to be null
                                    final newnote = Note(title, description); // creating note

                                    final db = Hive.box('notes');
                                    db.add(newnote);                                    //adding note

                                    Navigator.pop(context);                           //removingDialog
                                  }else{
                                    showDialog(
                                        context: context,                             //showing alert dialog
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Alert'),
                                            content: Text('Invalid Title or Description'),
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
                              child: Text('Create TODO'),
                            )
                          ],
                        )
                    )
                  );
               }
            );

          }

        ),
        backgroundColor: Colors.lightGreenAccent,//setting back ground color to light green


      ),
    );

  }
}

Widget buildList() {
  return
    Stack(                            //using stack for animations
      children: <Widget>[                  //here background image is behind list view
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("image/avengers.jpg"),      //providing background image
                fit: BoxFit.cover,                           //covering entire screen

            )
          ),

        ),
        ValueListenableBuilder(                              //listeneable builder which rebuilds when Box is changed

          valueListenable: Hive.box('notes').listenable(),       //listening to notes
          builder: ( context , Box notes, _){

            return ListView.builder( //list view
              itemCount: notes.length, //length of list view
              itemBuilder: (BuildContext context, int index) {// widget builder
                final note = notes.getAt(index);



                return Column(
                  children: <Widget>[
                    Opacity(
                      opacity: 0.8,              //setting opacity for visibility of background
                      child: Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius:BorderRadius.all(Radius.circular(10.0)),    //providing circular edges
                          border: Border.all(
                            width: 1.0,
                            color: Colors.black,
                           ),
                          color: Colors.orangeAccent
                          ),


                        key: Key(note.title), //providing key
                        padding: EdgeInsets.symmetric(vertical:10.0,horizontal:50.0),
                        child: Column(
                          children: <Widget>[
                            ExpansionTile(                  //adding expansion on clicking
                              title: Text(note.title,
                                style: TextStyle(
                                  fontFamily: 'Bangers',  //font family for style
                                  fontSize: 30.0

                                ),
                              ),


                              children: <Widget>[       //widgets opened on clicking
                                Text("description : "+note.description.toString(),
                                  style: TextStyle(
                                    fontFamily: 'Satisfy',
                                    fontSize: 20.0,
                                    fontWeight:FontWeight.w700,

                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    IconButton(         //button for update
                                        onPressed: (){
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context,){  //dialog builder
                                                String title;
                                                String description;

                                                return Dialog(
                                                    child: Form(
                                                        child: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: <Widget>[
                                                            Padding(
                                                              padding: const EdgeInsets.all(16.0),
                                                              child: TextFormField(        //input for title
                                                                decoration: InputDecoration(
                                                                  labelText: 'todo',


                                                                ),

                                                                onChanged:(input) {        //saving title
                                                                  title = input;

                                                                },

                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.all(16.0),
                                                              child: TextFormField(
                                                                decoration: InputDecoration(   //input for description
                                                                    labelText: 'description'
                                                                ),
                                                                onChanged:(input) {        //saving description
                                                                  description = input;

                                                                },

                                                              ),
                                                            ),
                                                            RaisedButton(
                                                              onPressed: (){
                                                                if(title!=null &&description!=null) { //checking for validation
                                                                  final newnote = Note(
                                                                      title,                //creating note
                                                                      description);
                                                                  print(newnote
                                                                      .title);
                                                                  final db = Hive
                                                                      .box(
                                                                      'notes');
                                                                  db.putAt(
                                                                      index,          //updating box
                                                                      newnote);
                                                                  print(
                                                                      'added');
                                                                  Navigator.pop(        //going back
                                                                      context);
                                                                }else{      //alert dialog
                                                                  showDialog(
                                                                      context: context,
                                                                      builder: (BuildContext context) {
                                                                        return AlertDialog(
                                                                          title: Text('Alert'),
                                                                          content: Text('Invalid Title or Description'),
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
                                                              child: Text('Update TODO'),
                                                            )
                                                          ],
                                                        )
                                                    )
                                                );
                                              }
                                          );

                                        },
                                        icon: Icon(Icons.refresh)  //refresh icon
                                    ),
                                    IconButton(
                                      onPressed: (){
                                        notes.deleteAt(index);  //deleting Box
                                      },
                                      icon: Icon(Icons.delete),
                                    )
                                  ],
                                ),

                              ],

                            ),

                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    )
                  ],
                );
              },
            );
          }
  ),
      ],
    );
}





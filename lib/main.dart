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
  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(NoteAdapter());
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

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Hive.openBox('notes'),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasError)
              {
                return Text(snapshot.error.toString());
              }else{
              print('opend box');
              return HomeScreen();
            }
          }else{
            return Scaffold();
          }
        }
    );
  }
  @override
  void dispose(){
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
  TextEditingController txtcontroller = TextEditingController();


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
          onPressed: (){
            showDialog(
                context: context,
               builder: (BuildContext context,){
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
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'todo'
                                ),

                                onChanged:(input) {
                                      title = input;
                                      print(title);
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
                                  description = input;
                                  print(description);
                                },

                              ),
                            ),
                            RaisedButton(
                                onPressed: (){
                                  
                                  final newnote= Note(title,description);
                                  print(newnote.title);
                                  final db = Hive.box('notes');
                                  db.add(newnote);
                                  print('added');
                                  Navigator.pop(context);

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
  return ValueListenableBuilder(
      valueListenable: Hive.box('notes').listenable(),
      builder: ( context , Box notes, _){
        return ListView.builder( //list view
          itemCount: notes.length, //length of list view
          itemBuilder: (BuildContext context, int index) {// widget builder
            final note = notes.getAt(index);
            return Container(
              padding: EdgeInsets.symmetric(vertical:10.0,horizontal:50.0),
              child: ExpansionTile( //adding expansion on clicking
                title: Text(note.title),

                children: <Widget>[
                  Text(note.description.toString()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                          onPressed: (){
                            showDialog(
                                context: context,
                                builder: (BuildContext context,){
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
                                                child: TextFormField(
                                                  decoration: InputDecoration(
                                                      labelText: 'todo',


                                                  ),

                                                  onChanged:(input) {
                                                    title = input;
                                                    print(title);
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
                                                    description = input;
                                                    print(description);
                                                  },

                                                ),
                                              ),
                                              RaisedButton(
                                                onPressed: (){

                                                  final newnote= Note(title,description);
                                                  print(newnote.title);
                                                  final db = Hive.box('notes');
                                                  db.putAt(index,
                                                      newnote);
                                                  print('added');
                                                  Navigator.pop(context);

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
                          child: Icon(Icons.update)
                      ),
                      FlatButton(
                        onPressed: (){
                          notes.deleteAt(index);
                        },
                        child: Icon(Icons.delete),
                      )
                    ],
                  ),

                ],

              ),
            );
          },
        );
      }
  );
}





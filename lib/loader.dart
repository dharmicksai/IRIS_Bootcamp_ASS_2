import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';


class loader extends StatefulWidget {
  @override
  _loaderState createState() => _loaderState();
}

class _loaderState extends State<loader> with SingleTickerProviderStateMixin{
  AnimationController controller;
  Animation<double> animation_rotation;
  Animation<double> animation_radius_in;
  Animation<double> animation_radius_out;
  double initialradius = 30 ;
  double radius=0.0;

  @override
  void initState(){
    super.initState();
    Timer(Duration(seconds: 7), (){
      Navigator.pop(context);
      Navigator.pushNamed(context, '/home');} );
    controller=AnimationController(vsync: this,duration: Duration(seconds: 5));

    animation_rotation = Tween<double>(
      begin: 0.0,
      end: -1.0,
    ).animate(CurvedAnimation(parent: controller, curve: Interval(0.0,1.0,curve: Curves.linear)));


    animation_radius_in = Tween<double>(
      begin: 1.0,
      end:0.0,

    ).animate(CurvedAnimation(parent: controller, curve: Interval(0.75, 1,curve: Curves.elasticIn)));
    animation_radius_out = Tween<double>(
      begin: 0.0,
      end:1.0,

    ).animate(CurvedAnimation(parent: controller, curve: Interval(0.0, 0.25,curve: Curves.elasticOut)));
    controller.addListener((){
      setState(() {
        if(controller.value>=0.75&&controller.value<=1.0)
        {
          radius=initialradius*animation_radius_in.value;
        }else if(controller.value>=0.0&&controller.value<=0.25)
        {
          radius=initialradius*animation_radius_out.value;
        }
      });

    });
    controller.repeat();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 100.0,
      child: Center(
        child: RotationTransition(
          turns: animation_rotation,
          child: Stack(
            children: <Widget>[
              Dot(
                radius:20.0,
                color: Colors.white,
              ),
              Transform.translate(
                offset: Offset(radius*cos(pi/4), radius*sin(pi/4)),
                child: Dot(
                  radius: 10.0,
                  color: Colors.black12,
                ),
              ),
              Transform.translate(
                offset: Offset(radius*cos(pi/2), radius*sin(pi/2)),
                child: Dot(
                  radius: 10.0,
                  color: Colors.blue,
                ),
              ),
              Transform.translate(
                offset: Offset(radius*cos(3*pi/4), radius*sin(3*pi/4)),
                child: Dot(
                  radius: 10.0,
                  color: Colors.greenAccent,
                ),
              ),
              Transform.translate(
                offset: Offset(radius*cos(pi), radius*sin(pi)),
                child: Dot(
                  radius: 10.0,
                  color: Colors.yellow,
                ),
              ),
              Transform.translate(
                offset: Offset(radius*cos(5*pi/4), radius*sin(5*pi/4)),
                child: Dot(
                  radius: 10.0,
                  color: Colors.orange,
                ),
              ),
              Transform.translate(
                offset: Offset(radius*cos(3*pi/2), radius*sin(3*pi/2)),
                child: Dot(
                  radius: 10.0,
                  color: Colors.deepOrangeAccent,
                ),
              ),
              Transform.translate(
                offset: Offset(radius*cos(7*pi/4), radius*sin(7*pi/4)),
                child: Dot(
                  radius: 10.0,
                  color: Colors.red,
                ),
              ),
              Transform.translate(
                offset: Offset(radius*cos(2*pi), radius*sin(2*pi)),
                child: Dot(
                  radius: 10.0,
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Dot extends StatelessWidget {

  final double radius;
  final Color color;

  const Dot({ this.radius, this.color}) ;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: this.radius,
        height: this.radius,
        decoration: BoxDecoration(
          color: this.color,
          shape: BoxShape.circle,
        ),

      ),
    );
  }
}

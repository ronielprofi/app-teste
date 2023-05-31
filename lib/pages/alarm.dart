import 'package:flutter/material.dart';

class Alarm_page extends StatefulWidget {
  const Alarm_page({Key? key}) : super(key: key);

  @override
  State<Alarm_page> createState() => _Alarm_pageState();
}

class _Alarm_pageState extends State<Alarm_page> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Alarm"),
        centerTitle: true,
      ),
      backgroundColor: Colors.white38,
      
    );
  }
}

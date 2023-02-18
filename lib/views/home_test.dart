import 'package:find_my_anbesa/utils/connection_util.dart';
import 'package:flutter/material.dart';

class HomeTest extends StatefulWidget {
  const HomeTest({Key? key}) : super(key: key);

  @override
  _HomeTestState createState() => _HomeTestState();
}

class _HomeTestState extends State<HomeTest> {

  bool connected = false;
  Color backgroundColor = Color(0xffF5F7FA);
  Color cardColor = Color(0xffDFDADA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Find My Anbesa', style: TextStyle(color: Colors.black),),
        backgroundColor: backgroundColor,
        iconTheme: IconThemeData(color: Colors.black, size: 35),
        elevation: 0,
      ),
      backgroundColor: backgroundColor ,
      body: FutureBuilder(
          future: ConnectionUtil.checkConnection(),
          builder: (context, snapshot) {
            if(snapshot.connectionState==ConnectionState.done){
              connected = snapshot.data as bool;
              return RefreshIndicator(
                onRefresh: () async{

                  WidgetsBinding.instance!.addPostFrameCallback((_) => setState((){
                    connected = ConnectionUtil.checkConnection() as bool;
                  }));

                },
                child: connected ? ListView():Stack(
                  children: <Widget>[ListView(), const Center(child: Icon(Icons.cloud_off, size: 100,color: Colors.grey))],
                ),
              );
            }else{
              return const CircularProgressIndicator();
            }
          }
      ),
    );
  }

}



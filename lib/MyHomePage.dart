import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:bubble/bubble.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  final messageInsert = TextEditingController();
  List<Map> messsages = List();
  void response(query) async {
    AuthGoogle authGoogle = await AuthGoogle(
            fileJson: "lib/src/assets/robota-jwgi-4b81d63a822f.json")
        .build();
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.spanish);
    AIResponse aiResponse = await dialogflow.detectIntent(query);
    setState(() {
      messsages.insert(0, {
        "data": 0,
        "message": aiResponse.getListMessage()[0]["text"]["text"][0].toString()
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage('lib/src/image/fondo.jpg'),fit: BoxFit.cover) ),
      child:Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Robotina Chatbot'),
          backgroundColor: Colors.teal[300],
          actions: <Widget>[
            IconButton(icon: Icon(Icons.adb, color: Colors.green[800],), onPressed: null)
          ]
        ),
        body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
                child: ListView.builder(
                    reverse: true,
                    itemCount: messsages.length,
                    itemBuilder: (context, index) => chat(
                        messsages[index]["message"].toString(),
                        messsages[index]["data"]))),
            Divider(
              height: 20.0,
              color: Colors.teal,
              thickness: 10,
              indent: 10,
              endIndent: 10,
            ),
            Container(
              padding: EdgeInsets.only(left: 30.0, right: 10.0),
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: TextField(
                    controller: messageInsert,
                    decoration: InputDecoration.collapsed(
                        hintText: "Escribe un mensaje...",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0)),
                  )),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    child: IconButton(
                        icon: Icon(
                          Icons.send,
                          size: 30.0,
                          color: Colors.teal[300],
                        ),
                        onPressed: () {
                          if (messageInsert.text.isEmpty) {
                            Fluttertoast.showToast(
                                msg: "Mensaje vacio",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.grey[300],
                                textColor: Colors.black,
                                fontSize: 16.0
                            );
                          } else {
                            setState(() {
                              messsages.insert(0,
                                  {"data": 1, "message": messageInsert.text});
                            });
                            response(messageInsert.text);
                            messageInsert.clear();
                          }
                        }),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15.0,
            )
          ],
        ),
      ),
    )
   );
  }
  Widget chat(String message, int data) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Bubble(
          radius: Radius.circular(15.0),
          color: data == 0 ? Colors.purple[300] : Colors.purple[100],
          elevation: 0.0,
          alignment: data == 0 ? Alignment.topLeft : Alignment.topRight,
          nip: data == 0 ? BubbleNip.leftBottom : BubbleNip.rightTop,
          child: Padding(
            padding: EdgeInsets.all(2.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(data==0? Icons.adb:Icons.person,color: data==0?Colors.green:Colors.pink),
                SizedBox(
                  width: 10.0,
                ),
                Flexible(
                    child: Text(
                  message,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold,fontSize: 20),
                ))
              ],
            ),
          )),
    );
  }
}

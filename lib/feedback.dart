import 'package:flutter/material.dart';

class FeedbackPop extends StatelessWidget {
  @override
  Widget build(BuildContext context)  {
    return Scaffold(
        appBar: AppBar(
          /*  elevation: 2.0,
          centerTitle: true,*/
          title: Text("Feedback", style: TextStyle(
              color: Colors.black, fontWeight:  FontWeight.bold
          ))),
              body: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment:  CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 10.0),
                      Text("Please enter your feedback",
                          style: TextStyle(color: Color(0xffc5c5c5) )),
                      SizedBox(height: 25.0),
                    ],
                  )
              )
          );

  }

  buildNumberField(){
    return TextField(
      style: TextStyle(
        color: Colors.black,
      ),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(5.0),
          prefixIcon: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget> [
              Container(
                decoration: BoxDecoration(border: Border(
                    right: BorderSide(width: 1.0, color: Color(0xc5c5c5))
                )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget> [
                    SizedBox(width: 10.0),
                    Text("+91",style:TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xc5c5c5),
                    ),
                    ),
                    Icon(Icons.arrow_drop_down, color: Colors.cyan,),
                    SizedBox(width: 10.0),

                  ],
                ),
              ),
              SizedBox(width: 10.0),
            ],
          ),
          hintStyle:  TextStyle(
            fontSize: 14.0,
            color: Color(0xfc5c5c5),
          )
      ),
    );
  }


  buildFeedbackForm() {
    return Container(
        height: 300.0,
        child: Stack(
          children: <Widget>[
            TextField(
                maxLines: 10,
                decoration: InputDecoration(
                  hintText: "Kindly Briefly describe the issue",
                )
            )
          ],
        )
    );
  }
}
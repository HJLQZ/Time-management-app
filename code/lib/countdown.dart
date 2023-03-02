// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'timer.dart';
class Countdown extends StatefulWidget
{

  Countdown({super.key,required this.taskName,this.taskColor,this.colorDescription,required this.theme});
  Color theme;
  Color? taskColor=Colors.lightBlue;
  int? colorDescription=0x01FFFFFF;
  String taskName="";
  @override
  // ignore: no_logic_in_create_state
  CountdownState createState() => CountdownState(taskName,taskColor,colorDescription,theme);
}

class CountdownState extends State<Countdown>
{
  num nowHour=0;
  num nowMinute=0;
  Color theme;
  Color? taskColor=Colors.lightBlue;
  int? colorDescription=0x01FFFFFF;
  String taskName;
  CountdownState(this.taskName,this.taskColor,this.colorDescription,this.theme);
  final GlobalKey<FormState> _formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: theme,
          title:Text('timer'),
        ),
        body:Center(
            child:Column(
                children:[
                  SizedBox(height: 20,),
                  Text('请输入你的任务时长',
                      style:TextStyle(
                        fontSize:23,
                        color:Colors.black,
                      )
                  ),
                  SizedBox(height: 15,),
                  Form(
                    key:_formKey,
                    child:Column(
                      children: [
                        Row(
                            children:[
                              Spacer(flex:4),
                              Expanded(
                                flex:2,
                                child: TextFormField(
                                    decoration:InputDecoration(
                                      hintText:'00',
                                      hintStyle:TextStyle(
                                        fontSize:23,
                                        color:Colors.black12,
                                      ),
                                    ),
                                    style:TextStyle(
                                      fontSize:23,
                                      color:Colors.black,
                                    ),
                                    onChanged: (value){setState(
                                            (){
                                          nowHour=int.parse(value);
                                        });},
                                    validator:(value){
                                      RegExp reg=RegExp(r'^[0-9]{1,2}$');
                                      if(!reg.hasMatch(value??'0'))
                                      {return '';}
                                      return null;
                                    }
                                ),
                              ),
                              Expanded(
                                  flex:1,
                                  child:Text('时', textAlign:TextAlign.center,//style: TextStyle(),
                                  )
                              ),
                              Expanded(
                                  flex:1,
                                  child:Text(':',
                                    textAlign:TextAlign.center,
                                  )
                              ),
                              Expanded(
                                flex:2,
                                child: TextFormField(
                                    decoration:InputDecoration(
                                      hintText:'00',
                                      hintStyle:TextStyle(
                                        fontSize:23,
                                        color:Colors.black12,
                                      ),
                                    ),
                                    style:TextStyle(
                                      fontSize:23,
                                      color:Colors.black,
                                    ),
                                    onChanged: (value){setState(
                                            (){
                                          nowMinute=int.parse(value);
                                        });},
                                    validator:(value){
                                      RegExp reg=RegExp(r'^([0-5]?[0-9])$');
                                      if(!reg.hasMatch(value??'0'))
                                      {return '';}
                                      return null;
                                    }
                                ),
                              ),
                              Expanded(
                                  flex:1,
                                  child:Text('分', textAlign:TextAlign.center,
                                  )
                              ),
                              Spacer(flex:4),
                            ]
                        ),
                        SizedBox(height:50),
                        Row(
                            children:[
                              Spacer(flex:4),
                              Expanded(
                                  flex:5,
                                  child: ElevatedButton(
                                      onPressed:() {
                                        if (_formKey.currentState!.validate()&&
                                            (nowMinute+nowHour)!=0) {
                                          setState(()
                                          {
                                            Navigator.pop(context);
                                            if(colorDescription==0x01FFFFFF){
                                              Navigator.push(context,MaterialPageRoute(
                                                  builder: (context) =>
                                                      Timer(nowHour:nowHour,nowMinute:nowMinute,
                                                          colorDescription: 0x01FFFFFF,
                                                          nowColor:taskColor,nowName:taskName,theme: theme,
                                                      )));
                                            }
                                            else{
                                              Navigator.push(context,MaterialPageRoute(
                                                  builder: (context) =>
                                                      Timer(nowHour:nowHour,nowMinute:nowMinute,
                                                          colorDescription:colorDescription,
                                                          nowName:taskName,theme: theme,
                                                      )));
                                            }
                                          });
                                        }
                                        else {
                                          showDialog<Null>(
                                            context: context,
                                            barrierDismissible: true,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                  title: Text('错误'),
                                                  content: Text('输入的时间非法！'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          Navigator.pop(context);
                                                        });
                                                      },
                                                      child: Text('确定'),
                                                    ),
                                                  ]
                                              );
                                            },
                                          );
                                        }
                                      },
                                      child:Text('确定',
                                        style:TextStyle(
                                          fontSize:24,
                                        ),
                                      )
                                  )
                              ),
                              Spacer(flex:4),
                            ]
                        )
                      ],
                    ),
                  )
                ]
            )
        )
    );
  }
}
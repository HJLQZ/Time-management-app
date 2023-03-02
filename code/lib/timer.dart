// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'dart:async';
import 'main.dart';
import 'storage.dart';

class Timer extends StatefulWidget{
  Timer({super.key, required this.nowHour, required this.nowMinute,
    required this.nowName, this.nowColor, this.colorDescription,required this.theme});
  num nowHour;
  num nowMinute;
  Color theme;
  Color? nowColor=Colors.lightBlue;
  String nowName="";
  int? colorDescription=0x01FFFFFF;
  @override
  // ignore: no_logic_in_create_state
  TimerState createState() => TimerState(nowHour,nowMinute,nowName,nowColor,colorDescription,theme);

}

class TimerState extends State<Timer>
{
  Color theme;
  num nowHour=0;
  num nowMinute=0;
  String nowName="";
  Color? nowColor=Colors.lightBlue;
  int? colorDescription=0x01FFFFFF; //如果是0x01FFFFFF，说明用的是nowColor

  TimerState(this.nowHour,this.nowMinute,this.nowName,this.nowColor,this.colorDescription,this.theme);
  Stopwatch watch=Stopwatch();
  bool countDown=false;
  List<num> countDownTime=[0,0,0];
  String countTime='00:00:00';
  String remainTime='00:00:00';
  DateTime finishTime=DateTime.now();
  String finalTime="";
  @override
  void initState()
  {
    if(nowMinute!=-6) countDown=true;
    countDownTime=[nowHour,nowMinute,0];
    super.initState();
    countTime = countDown?(toReactTime(toMilliseconds(countDownTime))):'00:00:00';
    setTime();
  }

  toMilliseconds(List<num> reactTime)
  {
    num ans=reactTime[0]*3600+reactTime[1]*60+reactTime[2];
    return ans*1000;
  }

  toReactTime(int milliseconds)
  {
    int seconds=(milliseconds/1000).truncate()%60;
    int minutes=(milliseconds/60000).truncate()%60;
    int hours=(milliseconds/3600000).truncate();
    String hour=hours.toString().padLeft(2,'0');
    String minute=minutes.toString().padLeft(2,'0');
    String second=seconds.toString().padLeft(2,'0');
    return '$hour:$minute:$second';
  }


  setTime()
  {
    var timePassed = watch.elapsedMilliseconds;
    setState(() {

      if(nowMinute==-6){
        remainTime=toReactTime(timePassed);
      }
      else{
        remainTime=toReactTime(toMilliseconds(countDownTime)-timePassed);
        if(remainTime=='00:00:00')
        {
          watch.stop();
          showDialog<Null>(
              context:context,
              barrierDismissible:true,
              builder:(BuildContext context) {
                return AlertDialog(
                    title: Text('结束任务'),
                    content: Text('任务规定的时间$countTime已经完成！'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            finishTime=DateTime.now();
                            finalTime=finishTime.toString().substring(0,19);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            //Navigator.pushNamed(context,'home');
                            Navigator.push(context,MaterialPageRoute(builder: (context) => Home(title:'',co:theme)));
                            HomeState(theme).currentIndex=1;
                            if(colorDescription==0x01FFFFFF)
                            {
                              Storage(
                                  nowColor,nowName,countTime,
                                  finalTime.substring(0,10),
                                  finalTime.substring(11,19)
                              );
                            }
                            else
                            {
                              Storage.dynamicColor(
                                  colorDescription,nowName,countTime,
                                  finalTime.substring(0,10),
                                  finalTime.substring(11,19)
                              );
                            }
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.greenAccent,
                          ),
                        ),
                        child: Text('确定'),
                      ),
                    ]
                );
              }
          );
          timeGetter=false;
        }
      }
    });
  }

  bool timeGetter=false;
  timeStart() async
  {
    timeGetter=true;
    watch.start();
    while(timeGetter)
    {
      await Future.delayed(const Duration(milliseconds: 100));
      setTime();
    }
  }

  timePause()
  {
    timeGetter=false;
    watch.stop();
    setTime();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: theme,
          title:Text('timer',style: TextStyle(fontFamily:"Regular",),),
        ),
        body:Container(
            padding: EdgeInsets.all(20.0),
            child:Column(
                children: <Widget>[
                  Text('当前的任务:\n$nowName',
                      style:TextStyle(
                        color:(colorDescription==0x01FFFFFF)?nowColor:Color(colorDescription!),
                        fontSize:28,
                      )),
                  SizedBox(height:40.0),
                  Text(remainTime, style: TextStyle(fontSize: 25.0)),
                  SizedBox(height: 20.0),
                  Flex(
                    direction:Axis.horizontal,
                    children:[
                      Spacer(flex:2),
                      Expanded(
                        flex:3,
                        child:ElevatedButton(
                            style:ButtonStyle(
                                backgroundColor:MaterialStateProperty.all(
                                  Colors.greenAccent,
                                ),
                                shape:MaterialStateProperty.all(
                                    CircleBorder(
                                        side:BorderSide(
                                          color:Colors.white70,
                                          width:2,
                                        )
                                    )
                                ),
                                minimumSize: MaterialStateProperty.all(
                                  Size(75,75),
                                )
                            ),
                            onPressed: timeStart,
                            child: Icon(Icons.play_arrow)
                        ),
                      ),
                      Spacer(flex:2),
                      Expanded(
                        flex:3,
                        child:ElevatedButton(
                            style:ButtonStyle(
                                backgroundColor:MaterialStateProperty.all(
                                  Colors.blueAccent,
                                ),
                                shape:MaterialStateProperty.all(
                                    CircleBorder(
                                        side:BorderSide(
                                          color:Colors.white70,
                                          width:2,
                                        )
                                    )
                                ),
                                minimumSize: MaterialStateProperty.all(
                                  Size(75,75),
                                )
                            ),
                            onPressed: timePause,
                            child: Icon(Icons.pause)
                        ),
                      ),
                      Spacer(flex:2),
                      Expanded(
                        flex:3,
                        child:ElevatedButton(
                            style:ButtonStyle(
                                backgroundColor:MaterialStateProperty.all(
                                  Colors.redAccent,
                                ),
                                shape:MaterialStateProperty.all(
                                    CircleBorder(
                                        side:BorderSide(
                                          color:Colors.white70,
                                          width:2,
                                        )
                                    )
                                ),
                                minimumSize: MaterialStateProperty.all(
                                  Size(75,75),
                                )
                            ),
                            onPressed:()
                            {
                              timeGetter=false;
                              watch.stop();
                              setTime();
                              showDialog<Null>(
                                  context:context,
                                  barrierDismissible:true,
                                  builder:(BuildContext context) {
                                    return AlertDialog(
                                        title: Text('结束任务'),
                                        content: Text('此任务已经进行了${
                                            toReactTime(watch.elapsedMilliseconds)},确定结束吗？'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                finishTime=DateTime.now();
                                                finalTime=finishTime.toString().substring(0,19);
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                Navigator.push(context,MaterialPageRoute(builder: (context) => Home(title:'',co:theme)));
                                                HomeState(theme).currentIndex=1;
                                                if(colorDescription==0x01FFFFFF)
                                                {
                                                  Storage(
                                                      nowColor,nowName,
                                                      toReactTime(watch.elapsedMilliseconds),
                                                      finalTime.substring(0,10),
                                                      finalTime.substring(11,19)
                                                  );
                                                }
                                                else
                                                {
                                                  Storage.dynamicColor(
                                                      colorDescription,nowName,
                                                      toReactTime(watch.elapsedMilliseconds),
                                                      finalTime.substring(0,10),
                                                      finalTime.substring(11,19)
                                                  );
                                                }
                                              });
                                            },
                                            style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all(
                                                Colors.greenAccent,
                                              ),
                                            ),
                                            child: Text('确定'),
                                          ),
                                          TextButton(
                                            onPressed: () {Navigator.pop(context);},
                                            child: Text('取消'),
                                          ),
                                        ]
                                    );
                                  }
                              );
                            },
                            child: Icon(Icons.stop)
                        ),
                      ),
                      Spacer(flex:2),
                    ],
                  )
                ]
            )
        )
    );
  }
}
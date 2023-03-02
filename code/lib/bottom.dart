// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'timer.dart';
import 'countdown.dart';
import 'dart:math';
class Bottom extends StatefulWidget{
  List<String> category=[];
  Color theme;
  Bottom({required this.category,required this.theme});
  @override
  BottomState createState() => BottomState(category,theme);
}

class BottomState extends State<Bottom>
{
  List<String> category=[];
  Color theme;
  BottomState(this.category,this.theme);
  var radioGroupValue = '正计时';
  var inputLength=0;
  TextEditingController controller = TextEditingController();
  FocusNode focusnode = FocusNode();
  String currentName="";
  int currentColorDescription=0x01FFFFFF;
  Color currentColor=Colors.lightBlue;//此任务在圆圈统计图里的颜色

  int random(int min,int max)
  {
    final _random=Random();
    return min+_random.nextInt(max-min+1);
  }


  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
        appBar: AppBar(
          title: Text(''),
          backgroundColor: theme,
          centerTitle:true,
        ),
        body: Column(
          children: [
            Container(
              padding:EdgeInsets.all(20),
              child:TextField(showCursor: true,
                controller: controller,
                focusNode: focusnode,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 17.0,color: Colors.black),
                maxLength: 50,
                decoration: InputDecoration(
                    isCollapsed: false,
                    labelText: "Enter a Task",
                    labelStyle: TextStyle(fontFamily:"Regular",),
                    helperText: "请输入本次计时任务名称",
                    helperStyle: TextStyle(fontSize: 15.0,color: Colors.black54),
                    counterText: "$inputLength/50",counterStyle: TextStyle(color: Colors.blue),
                    contentPadding: EdgeInsets.all(15.0),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.red))
                ),

                textInputAction: TextInputAction.search,
                onChanged: (content) {
                  setState(() {
                    currentName=content;
                    inputLength=content.length;
                  });
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.centerLeft,
              child:Text(
                "选择统计图中任务颜色",
                style:TextStyle(
                  fontSize: 17.0, fontWeight: FontWeight.bold,fontFamily: "Regular",
                  color: currentColor,
                ),
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width:8,
                ),
                IconButton(
                  icon: Icon(Icons.circle),color: Colors.lightBlue,iconSize: 30.0,
                  onPressed: () { setState((){currentColor=Colors.lightBlue;currentColorDescription=0x01FFFFFF;}); },
                  tooltip: category[0],
                ),
                IconButton(
                  icon: Icon(Icons.circle),color: Colors.lightGreen,iconSize: 30.0,
                  onPressed: () { setState((){currentColor=Colors.lightGreen;currentColorDescription=0x01FFFFFF;}); },
                  tooltip: category[1],
                ),
                IconButton(
                  icon: Icon(Icons.circle),color: Colors.grey,iconSize: 30.0,
                  onPressed: () { setState((){currentColor=Colors.grey;currentColorDescription=0x01FFFFFF;}); },
                  tooltip: category[2],
                ),
                IconButton(
                  icon: Icon(Icons.circle),color: Colors.redAccent,iconSize: 30.0,
                  onPressed: () { setState((){currentColor=Colors.redAccent;currentColorDescription=0x01FFFFFF;}); },
                  tooltip: category[3],
                ),
                IconButton(
                  icon: Icon(Icons.circle),color: Colors.amber,iconSize: 30.0,
                  onPressed: () { setState((){currentColor=Colors.amber;currentColorDescription=0x01FFFFFF;}); },
                  tooltip: category[4],
                ),
                IconButton(
                  icon: Icon(Icons.circle),color: Colors.teal,iconSize: 30.0,
                  onPressed: () { setState((){currentColor=Colors.teal;currentColorDescription=0x01FFFFFF;}); },
                  tooltip: category[5],
                ),
                IconButton(
                  icon: Icon(Icons.question_mark_outlined),color: Colors.blueGrey,iconSize: 27.0,
                  onPressed: () { setState((){
                    currentColorDescription=16777216*random(150,255)+ //透明度
                        65536*random(0,255)+256*random(0,255)+random(0,255);//RGB
                    currentColor=Color(currentColorDescription);
                  }); },
                  tooltip: '其他类型(随机颜色)',
                ),
              ],
            ),
            SizedBox(
              height:10,
            ),
            Row(
              children: [
                SizedBox(width:25),
                const Text("计时类型：", style: TextStyle(fontSize: 15, color: Colors.blue),),
                Flexible(
                  child: RadioListTile(
                    title: const Text('正计时',style: TextStyle(fontFamily:"Regular",),),
                    value: '正计时',
                    groupValue: radioGroupValue,
                    onChanged: (value)
                    {
                      setState(() { radioGroupValue = value.toString();} );
                    },
                  ),
                ),
                SizedBox(width:25),
              ],
            ),
            Row(
                children:[
                  SizedBox(width:100),
                  Flexible(
                      child: RadioListTile(
                        title: const Text('倒计时',style: TextStyle(fontFamily:"Regular",),),
                        value: '倒计时',
                        groupValue: radioGroupValue,
                        onChanged: (value) {
                          setState(() { radioGroupValue = value.toString();});
                        },
                      )
                  ),
                  SizedBox(width:25),
                ]
            ),
            SizedBox(height:30),
            Flex(
              direction:Axis.horizontal,
              children:[
                Spacer(
                  flex:30,
                ),
                Expanded(
                  flex:37,
                  child:ElevatedButton(
                    style:ButtonStyle(
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
                    onPressed: () {setState((){Navigator.pop(context);});},
                    child:Text(
                        '取消',
                        style:TextStyle(
                          fontSize:17,
                        )
                    ),
                  ),
                ),
                Spacer(
                  flex:46,
                ),
                Expanded(
                  flex:37,
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
                    onPressed: () {
                      if(radioGroupValue=='正计时'){
                        setState((){
                          Navigator.pop(context);
                          if(currentColorDescription==0x01FFFFFF) {
                            print('${currentColor.toString()} $currentName');
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) =>
                                    Timer(nowHour:0,nowMinute:-6,
                                      nowColor:currentColor,
                                      colorDescription:0x01FFFFFF,
                                      nowName:currentName,
                                      theme:theme,
                                    )));
                          }
                          else {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) =>
                                    Timer(nowHour:0,nowMinute:-6,
                                        colorDescription:currentColorDescription,
                                        nowName:currentName,
                                      theme:theme,
                                    )));
                          }
                        });
                      }
                      else{
                        setState((){
                          Navigator.pop(context);
                          if(currentColorDescription==0x01FFFFFF) {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) =>
                                    Countdown(taskColor: currentColor,
                                      taskName: currentName,
                                      colorDescription: 0x01FFFFFF,theme: theme,)));
                          }
                          else{
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) =>
                                    Countdown(colorDescription: currentColorDescription,
                                        taskName: currentName,theme: theme,)));
                          }
                        });
                      }
                    },

                    child:Text(
                        '开始',
                        style:TextStyle(
                          fontSize:17,
                        )
                    ),
                  ),
                ),
                Spacer(
                  flex:30,
                ),
              ],
            )
          ],
        )
    );
  }
}
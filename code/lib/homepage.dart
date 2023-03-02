// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'storage.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class PieSales
{
  int day;
  String task;
  int mins;
  charts.Color color;
  PieSales(this.day, this.task,this.mins,this.color);
}

class HomePage extends StatefulWidget{
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>
{
  Storage storage=Storage.read();
  List<String> category=[];
  List<String> record=[];
  List<PieSales> pieSales=[];
  @override
  void initState()
  {
    super.initState();
    readList.clear();
    sumTime='00:00:00';
    readStr=Storage.read().getString();
    for(int i=1;i<readStr.length;i++)
    {
      List<String> thisLine=readStr[i].split(" ");
      bool isDynamicColor=(thisLine[0]=='1');
      int colorType=(int.parse(thisLine[1]));
      String taskName=thisLine[2];
      String taskDuring=thisLine[3];
      String taskDate=thisLine[4];
      String taskTime=thisLine[5];
      if(taskDate==DateTime.now().toString().substring(0,10))
      {
        readList.add(
            ListTile(
              leading: CircleAvatar(
                backgroundColor: isDynamicColor?Color(colorType):colorTypes[colorType],
                radius: 20,
              ),
              title: Text(taskName,
                  style:TextStyle(
                    color: isDynamicColor?Color(colorType):colorTypes[colorType],
                  )),
              subtitle: Text('$taskTime  任务时长:$taskDuring',
                  style:TextStyle(
                    color: isDynamicColor?Color(colorType):colorTypes[colorType],
                  )),
            )
        );
        readList.add(Divider(thickness:2));
        sumTime=timeMerge(sumTime,taskDuring);
      }
    }
    sumAction=readList.length~/2;
    Storage storage=Storage.read();
    category=storage.getCategory();
    record=storage.getString();
    pieSales=
    [
      PieSales(0,category[0],0,charts.ColorUtil.fromDartColor(Colors.lightBlue)),
      PieSales(1,category[1],0,charts.ColorUtil.fromDartColor(Colors.lightGreen)),
      PieSales(2,category[2],0,charts.ColorUtil.fromDartColor(Colors.grey)),
      PieSales(3,category[3],0,charts.ColorUtil.fromDartColor(Colors.redAccent)),
      PieSales(4,category[4],0,charts.ColorUtil.fromDartColor(Colors.amber)),
      PieSales(5,category[5],0,charts.ColorUtil.fromDartColor(Colors.teal)),
    ];
    for(int i=1;i<record.length;i++)
    {
      //0 4 pro1 00:00:04 2023-01-21 03:50:33
      List<String> information=record[i].split(' ');
      String type=information[0];
      int colorType=int.parse(information[1]);
      String taskName=information[2];
      int time=toMinutes(information[3]);
      bool isToday=(information[4]==DateTime.now().toString().substring(0,10));
      if(isToday&&(type=='1'))
      {
        pieSales.add(
            PieSales(pieSales.length,taskName,time,charts.ColorUtil.fromDartColor(Color(colorType)))
        );
      }
      if(isToday&&(type=='0'))
      {
        pieSales[colorType].mins+=time;
      }
    }
  }
  Widget donut()
  {

    var data = pieSales;
    List<charts.Series<PieSales, int>> seriesList = [charts.Series<PieSales, int>
      (
      id: 'today',
      domainFn: (PieSales today, _) => today.day,
      measureFn: (PieSales today, _) => today.mins,
      colorFn: (PieSales today, _) => today.color,
      data: data,
      labelAccessorFn: (PieSales row, _) => '${row.task}: ${row.mins}min',)
    ];

    return charts.PieChart(
      seriesList,//(seriesList as List<charts.Series>)?.map((e) => e as charts.Series<Object>)?.toList(),
      animate: true,
      defaultRenderer: charts.ArcRendererConfig<Object>(
          arcWidth: 90,
          arcRendererDecorators: [charts.ArcLabelDecorator()]
      ),
    );
  }
  @override
  Widget build(BuildContext context){
    return Column(
      children:[
        Expanded(
            flex:37,
            child:Container(
              height: 240,
              child: donut(),
            )
        ),
        Expanded(
          flex:6,
          child:Text("今日共记录了$sumAction次任务\n总时长$sumTime",style: TextStyle(fontFamily:"Regular",),),
        ),
        Expanded(
            flex:23,
            child:ListView(
              physics: BouncingScrollPhysics(),
              children:readList,
            )
        )
      ],
    );
  }
  List<String> readStr=[];
  List<Widget> readList=[];
  String sumTime='00:00:00';
  Map<int,Color> colorTypes={
    0:Colors.lightBlue,
    1:Colors.lightGreen,
    2:Colors.grey,
    3:Colors.redAccent,
    4:Colors.amber,
    5:Colors.teal,
  };
  int sumAction=0;

  String timeMerge(String time1, String time2)
  {
    int h1,m1,s1,h2,m2,s2,h,m,s;
    h1=int.parse(time1.substring(0,2));
    m1=int.parse(time1.substring(3,5));
    s1=int.parse(time1.substring(6));
    h2=int.parse(time2.substring(0,2));
    m2=int.parse(time2.substring(3,5));
    s2=int.parse(time2.substring(6));
    h=h1+h2;m=m1+m2;s=s1+s2;
    m+=s~/60;s%=60;h+=m~/60;m%=60;
    String hh,mm,ss;
    hh=h<10?'0$h':'$h';
    mm=m<10?'0$m':'$m';
    ss=s<10?'0$s':'$s';
    hh=hh=='0'?'00':hh;
    mm=mm=='0'?'00':mm;
    ss=ss=='0'?'00':ss;
    return('$hh:$mm:$ss');
  }

  int toMinutes(String time)
  {
    //xx:xx:xx
    int h,m,s;
    h=int.parse(time.substring(0,2));
    m=int.parse(time.substring(3,5));
    s=int.parse(time.substring(6));
    return (3600*h+60*m+s+30)~/60;
  }
}
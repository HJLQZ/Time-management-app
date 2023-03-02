// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'storage.dart';
import 'homepage.dart';
import 'package:charts_flutter/flutter.dart' as charts;

String sumTime = '00:00:00';
Storage storage = Storage.read();
List<String> category = [];
List<String> record = [];
List<List<PieSales>> pieSales = [];
List<int> typeTime=[0,0,0,0,0,0,0];
List<List<String>> dateDetail=[];
class PieSales
{
  int color;
  int mins;
  PieSales(this.color,this.mins);
}

class Chart extends StatefulWidget
{
  @override
  ChartState createState() => ChartState();
}
class ChartState extends State<Chart>
{


  int judgeWeek(String date,String today/* as YYYY-MM-DD */)
  {
    List<String> ymd=date.split('-');
    String s=today;
    List<String> nowymd=s.split('-');
    if(date==s) return 6;
    String std='${int.parse(ymd[0])}-${int.parse(ymd[1])}-${int.parse(ymd[2])}';
    int year=int.parse(nowymd[0]);
    int month=int.parse(nowymd[1]);
    int day=int.parse(nowymd[2]);
    List<int> dayInMonth=[-6,31,28,31,30,31,30,31,31,30,31,30,31];
    for(int i=1;i<=6;i++)
    {
      if(day==1)
      {
        if(month==1)
        {
          month=12;year-=1;day=31;
        }
        else
        {
          day=dayInMonth[month-1];month-=1;
        }
      }
      else
      {
        day-=1;
      }
      String d='$year-$month-$day';
      if(d==std) return 6-i;
    }
    return -45;
  }
  String findPriorDay(String Date /* as YYYY-MM-DD */)
  {
    String s=Date;
    List<String> nowymd=s.split('-');
    int year=int.parse(nowymd[0]);
    int month=int.parse(nowymd[1]);
    int day=int.parse(nowymd[2]);
    List<int> dayInMonth=[-6,31,28,31,30,31,30,31,31,30,31,30,31];
    if(day==1)
    {
      if(month==1)
      {
        month=12;year-=1;day=31;
      }
      else
      {
        day=dayInMonth[month-1];month-=1;
      }
    }
    else
    {
      day-=1;
    }
    String d='$year-$month-$day';
    return d;
  }
  String findNextDay(String Date /* as YYYY-MM-DD */)
  {
    String s=Date;
    List<String> nowymd=s.split('-');
    int year=int.parse(nowymd[0]);
    int month=int.parse(nowymd[1]);
    int day=int.parse(nowymd[2]);
    List<int> dayInMonth=[-6,31,28,31,30,31,30,31,31,30,31,30,31];
    if(day==dayInMonth[month])
    {
      if(month==12) {year+=1;month=1;day=1;}
      else {month+=1;day=1;}
    }
    else{day+=1;}
    String d='$year-$month-$day';
    return d;
  }
  void initialize(String nowDate)
  {
    typeTime=[0,0,0,0,0,0,0];
    category = storage.getCategory();
    record = storage.getString();
    sumTime = '00:00:00';
    pieSales =
    [
      [PieSales(0, 0),PieSales(1, 0),PieSales(2, 0),PieSales(3, 0),PieSales(4, 0),PieSales(5, 0),PieSales(6, 0)],
      [PieSales(0, 0),PieSales(1, 0),PieSales(2, 0),PieSales(3, 0),PieSales(4, 0),PieSales(5, 0),PieSales(6, 0)],
      [PieSales(0, 0),PieSales(1, 0),PieSales(2, 0),PieSales(3, 0),PieSales(4, 0),PieSales(5, 0),PieSales(6, 0)],
      [PieSales(0, 0),PieSales(1, 0),PieSales(2, 0),PieSales(3, 0),PieSales(4, 0),PieSales(5, 0),PieSales(6, 0)],
      [PieSales(0, 0),PieSales(1, 0),PieSales(2, 0),PieSales(3, 0),PieSales(4, 0),PieSales(5, 0),PieSales(6, 0)],
      [PieSales(0, 0),PieSales(1, 0),PieSales(2, 0),PieSales(3, 0),PieSales(4, 0),PieSales(5, 0),PieSales(6, 0)],
      [PieSales(0, 0),PieSales(1, 0),PieSales(2, 0),PieSales(3, 0),PieSales(4, 0),PieSales(5, 0),PieSales(6, 0)],
    ];
    for (int i = 1; i < record.length; i++) {
      //0 4 pro1 00:00:04 2023-01-21 03:50:33
      List<String> information = record[i].split(' ');
      String type = information[0];
      int colorType = int.parse(information[1]);
      String taskName = information[2];
      int time = HomePageState().toMinutes(information[3]);
      String date = information[4];
      bool isWeek = (judgeWeek(date,nowDate)!=-45);
      if (isWeek && (type == '1')) {
        pieSales[judgeWeek(date,nowDate)][6].mins+=time;
        typeTime[6]+=time;
      }
      if (isWeek && (type == '0')) {
        pieSales[judgeWeek(date,nowDate)][colorType].mins += time;
        typeTime[colorType]+=time;
      }
    }
    chartTmp.add(_stacked());
    chartTmp.add(simpleBar());
    strTmp=['七天内各天使用时间的统计图','七天内各类型的使用时间统计图'];
  }
  String nowDate='';int dateCount=0;
  @override
  void initState() {
    super.initState();
    nowDate=DateTime.now().toString().substring(0, 10);
    initialize(nowDate);

  }
  List<Widget> chartTmp=[];
  List<String> strTmp=[];
  int index=0;
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      //appBar: AppBar(title: Text("柱形图")),
      body: Column(
          children:[SizedBox(height:20),
            Container(
                height:30,
                child:Text(strTmp[index],
                    style:TextStyle(
                        fontSize:17,fontFamily: "heiti"
                    )
                )
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children:[
                Spacer(
                    flex:170
                ),
                Expanded(
                    flex:250,
                    child:OutlinedButton(
                        child:Text('变更统计图',style:TextStyle(color:Colors.black87,fontFamily: "heiti",fontSize: 15)),
                        style:ButtonStyle(
                          shape:MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                              )
                          ),
                          backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(250,235,255,235),
                          ),),

                        onPressed:(){setState(() {
                          index=-(index-1);
                        });}
                    )
                ),
                Spacer(
                    flex:170
                ),
              ],
            ),

            Container(height: 240,
              padding: const EdgeInsets.all(10.0),
              margin: const EdgeInsets.all(10.0),
              child: chartTmp[index],
            ),
            SizedBox(height: 60),
          ]
      ),
    );
  }
}

Widget _stacked()
{
  dateDetail.clear();
  String nowDate=DateTime.now().toString().substring(0, 10);
  for(int i=0;i<=6;i++) {List<String> w=['','','','','','','',];dateDetail.add(w);}
  for(int j=0;j<=6;j++){dateDetail[j][0]=(ChartState().findNextDay(ChartState().findPriorDay(nowDate)).substring(5));
  for(int i=1;i<=6;i++) {dateDetail[j][i]=(ChartState().findPriorDay(nowDate).substring(5));nowDate=ChartState().findPriorDay(nowDate);}
  nowDate=DateTime.now().toString().substring(0, 10);}
  print(dateDetail);
  List<stacked> _0Data =
  [
    stacked(dateDetail[0][6],pieSales[0][0].mins),
    stacked(dateDetail[0][5],pieSales[1][0].mins),
    stacked(dateDetail[0][4],pieSales[2][0].mins),
    stacked(dateDetail[0][3],pieSales[3][0].mins),
    stacked(dateDetail[0][2],pieSales[4][0].mins),
    stacked(dateDetail[0][1],pieSales[5][0].mins),
    stacked(dateDetail[0][0],pieSales[6][0].mins),
  ];
  List<stacked> _1Data =
  [
    stacked(dateDetail[1][6],pieSales[0][1].mins),
    stacked(dateDetail[1][5],pieSales[1][1].mins),
    stacked(dateDetail[1][4],pieSales[2][1].mins),
    stacked(dateDetail[1][3],pieSales[3][1].mins),
    stacked(dateDetail[1][2],pieSales[4][1].mins),
    stacked(dateDetail[1][1],pieSales[5][1].mins),
    stacked(dateDetail[1][0],pieSales[6][1].mins),
  ];
  List<stacked> _2Data =
  [
    stacked(dateDetail[2][6],pieSales[0][2].mins),
    stacked(dateDetail[2][5],pieSales[1][2].mins),
    stacked(dateDetail[2][4],pieSales[2][2].mins),
    stacked(dateDetail[2][3],pieSales[3][2].mins),
    stacked(dateDetail[2][2],pieSales[4][2].mins),
    stacked(dateDetail[2][1],pieSales[5][2].mins),
    stacked(dateDetail[2][0],pieSales[6][2].mins),
  ];
  List<stacked> _3Data =
  [
    stacked(dateDetail[3][6],pieSales[0][3].mins),
    stacked(dateDetail[3][5],pieSales[1][3].mins),
    stacked(dateDetail[3][4],pieSales[2][3].mins),
    stacked(dateDetail[3][3],pieSales[3][3].mins),
    stacked(dateDetail[3][2],pieSales[4][3].mins),
    stacked(dateDetail[3][1],pieSales[5][3].mins),
    stacked(dateDetail[3][0],pieSales[6][3].mins),
  ];
  List<stacked> _4Data =
  [
    stacked(dateDetail[4][6],pieSales[0][4].mins),
    stacked(dateDetail[4][5],pieSales[1][4].mins),
    stacked(dateDetail[4][4],pieSales[2][4].mins),
    stacked(dateDetail[4][3],pieSales[3][4].mins),
    stacked(dateDetail[4][2],pieSales[4][4].mins),
    stacked(dateDetail[4][1],pieSales[5][4].mins),
    stacked(dateDetail[4][0],pieSales[6][4].mins),
  ];
  List<stacked> _5Data =
  [
    stacked(dateDetail[5][6],pieSales[0][5].mins),
    stacked(dateDetail[5][5],pieSales[1][5].mins),
    stacked(dateDetail[5][4],pieSales[2][5].mins),
    stacked(dateDetail[5][3],pieSales[3][5].mins),
    stacked(dateDetail[5][2],pieSales[4][5].mins),
    stacked(dateDetail[5][1],pieSales[5][5].mins),
    stacked(dateDetail[5][0],pieSales[6][5].mins),
  ];
  List<stacked> _otherData =
  [
    stacked(dateDetail[6][6],pieSales[0][6].mins),
    stacked(dateDetail[6][5],pieSales[1][6].mins),
    stacked(dateDetail[6][4],pieSales[2][6].mins),
    stacked(dateDetail[6][3],pieSales[3][6].mins),
    stacked(dateDetail[6][2],pieSales[4][6].mins),
    stacked(dateDetail[6][1],pieSales[5][6].mins),
    stacked(dateDetail[6][0],pieSales[6][6].mins),
  ];
  var seriesList =
  [
    charts.Series<stacked, String>(
      id: '蓝的',//Id好像没用，根本没地方显示它
      colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.lightBlue[300]!),
      domainFn: (stacked sales, _) => sales.day,
      measureFn: (stacked sales, _) => sales.times,
      labelAccessorFn: (stacked sales, _) => '${sales.times.toString()}min',
      data: _0Data,
    ),
    charts.Series<stacked, String>(
      id: '绿的',
      colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.lightGreen[400]!),
      domainFn: (stacked sales, _) => sales.day,
      measureFn: (stacked sales, _) => sales.times,
      labelAccessorFn: (stacked sales, _) => '${sales.times.toString()}min',
      data: _1Data,
    ),
    charts.Series<stacked, String>(
      id: '灰的',
      colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.grey),
      domainFn: (stacked sales, _) => sales.day,
      measureFn: (stacked sales, _) => sales.times,
      labelAccessorFn: (stacked sales, _) => '${sales.times.toString()}min',
      data: _2Data,
    ),
    charts.Series<stacked, String>(
      id: '红的',
      colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.red[400]!),
      domainFn: (stacked sales, _) => sales.day,
      measureFn: (stacked sales, _) => sales.times,
      labelAccessorFn: (stacked sales, _) => '${sales.times.toString()}min',
      data: _3Data,
    ),
    charts.Series<stacked, String>(
      id: '黄的',
      colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.amber[400]!),
      domainFn: (stacked sales, _) => sales.day,
      measureFn: (stacked sales, _) => sales.times,
      labelAccessorFn: (stacked sales, _) => '${sales.times.toString()}min',
      data: _4Data,
    ),
    charts.Series<stacked, String>(
      id: '还是绿的',
      colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.teal[300]!),
      domainFn: (stacked sales, _) => sales.day,
      measureFn: (stacked sales, _) => sales.times,
      labelAccessorFn: (stacked sales, _) => '${sales.times.toString()}min',
      data: _5Data,
    ),
    charts.Series<stacked, String>(
      id: '其他',
      colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color.fromARGB(255,255,220,210)),
      domainFn: (stacked sales, _) => sales.day,
      measureFn: (stacked sales, _) => sales.times,
      labelAccessorFn: (stacked sales, _) => '${sales.times.toString()}min',
      data: _otherData,
    ),
  ];
  return charts.BarChart(
    seriesList,
    animate: true,
    vertical: false,
    barGroupingType: charts.BarGroupingType.stacked,
    //barRendererDecorator: charts.BarLabelDecorator<String>(),
  );
}

class stacked
{
  final String day;
  final int times;
  stacked(this.day, this.times);
}


Widget simpleBar()
{
  Storage st=Storage.read();
  List<String> names=st.getCategory();
  var data = [ //第一个用作柱子下面标注的时间，第二个是当天计时几分钟
    sumtime(names[0], typeTime[0],Colors.lightBlue),
    sumtime(names[1], typeTime[1],Colors.lightGreen),
    sumtime(names[2], typeTime[2],Colors.grey),
    sumtime(names[3], typeTime[3],Colors.redAccent),
    sumtime(names[4], typeTime[4],Colors.amber),
    sumtime(names[5], typeTime[5],Colors.teal),
    sumtime('其他', typeTime[6],Color.fromARGB(255,255,220,210)),
  ];
  var seriesList =
  [
    charts.Series<sumtime, String>
      (
        id: 'Sales',
        colorFn: (sumtime sales, _) => charts.ColorUtil.fromDartColor(sales.color),
        domainFn: (sumtime sales, _) => sales.type,
        measureFn: (sumtime sales, _) => sales.times,
        data: data,
        labelAccessorFn: (sumtime sales, _) => '${sales.times.toString()}min'
    )
  ];
  return charts.BarChart
    (
    seriesList,
    animate: true,
    vertical: true,
    barRendererDecorator: charts.BarLabelDecorator<String>(),
  );
}

class sumtime
{
  String type;
  int times;
  Color color;
  sumtime(this.type, this.times, this.color);
}
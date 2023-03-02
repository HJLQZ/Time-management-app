// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'dart:math';
import 'storage.dart';
import 'homepage.dart';
class Statistics extends StatefulWidget
{
  const Statistics({Key? key}) : super(key: key);
  @override
  StatisticsState createState() => StatisticsState();
}

class StatisticsState extends State<Statistics>
{
  int M= DateTime.now().month;
  int D=DateTime.now().day;
  int _year = DateTime.now().year;
  int _month = DateTime.now().month;
  int _day = DateTime.now().day;
  List<CalendarModel> _datas = [];
  List<CalendarModel> _list_datas = [];
  List<String> information=[];
  List<List<List<Widget>>> datInfo=[[[]]];
  String dateTimeNow="";
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      /*appBar: AppBar(
          backgroundColor: const Color(0xFF1AC98E),
          centerTitle: true,
          title: const Text(
            "日历",
            style: TextStyle(fontSize: 18.0, color: Color(0xFFFFFFFF)),
          ),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white,),
          automaticallyImplyLeading: false,
        ),*/
        body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(20.0),
                  decoration: const BoxDecoration(
                    //color: Color(0xFFFFFFFF),
                    color: Color(0xFFECEFF1),
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),//四周边框
                  ),
                  child: Column(
                    children: [
                      _yearHeader(),
                      _weekHeader(),
                      _everyDay(),
                    ],
                  ),
                ),
                Container(//点击日出现的东西
                    height:260,
                    child:ListView(children:datInfo[M][D],)
                ),
              ],
            )
        )
    );
  }

  @override
  void initState()
  {
    for(int i=1;i<=12;i++)
    {
      List<List<Widget>> w=[[]];
      datInfo.add(w);
      for(int j=1;j<=31;j++)
      {
        List<Widget> ww=[];
        datInfo[i].add(ww);
      }
    }
    Storage s=Storage.read();
    information=s.getString();

    for(int i=1;i<information.length;i++)
    {
      //0 4 pro1 00:00:04 2023-01-21 03:50:33
      List<String> dateData=information[i].split(' ');
      String type=dateData[0];
      int colorType=int.parse(dateData[1]);
      String taskName=dateData[2];
      String dd=dateData[3];
      String dt=dateData[4];
      String taskTime=dateData[5];
      List<String> div=dt.split('-');
      int y=int.parse(div[0]);int m=int.parse(div[1]);int d=int.parse(div[2]);
      bool isDynamicColor=(type=='1');
      setState(()
      {
        datInfo[m][d].add(
          ListTile(
            leading: CircleAvatar(
              backgroundColor: isDynamicColor
                  ? Color(colorType)
                  : HomePageState().colorTypes[colorType],
              radius: 20,
            ),
            title:
            Text(taskName,
                style: TextStyle(
                  color: isDynamicColor
                      ? Color(colorType)
                      : HomePageState().colorTypes[colorType],
                )
            ),
            subtitle: Text('$taskTime  任务时长:$dd',
                style: TextStyle(
                  color: isDynamicColor
                      ? Color(colorType)
                      : HomePageState().colorTypes[colorType],
                )
            ),
          ),
        );
        datInfo[m][d].add(Divider(thickness: 2));
      });
      build(context);
    }
    _setDatas(year: _year, month: _month);
    _loadAttendanceMonthRecord( "$_year-$_month");
    _loadAttendanceDayRecord("$_year-$_month-$_day");
    super.initState();
  }

  _loadAttendanceMonthRecord(String dateTime)   //加载月历事件
  {
    var rand=Random();//临时是有三个状态，但不知道每个颜色应该代表什么意义
    int days=_getCurrentMonthDays(year:_year,month: _month);
    for(int i=1;i<=days;i++)
    {
      CalendarModel bean=CalendarModel(year: _year,month: _month,day: i,work_type: datInfo[_month][i].isEmpty?'0':'2');
      _list_datas.add(bean);
    }
    setState(()
    {
      for (int i = 0; i < _datas.length; i++)
      {
        for (int j = 0; j < _list_datas.length; j++)
        {
          if (_datas[i].year== _list_datas[j].year && _datas[i].month == _list_datas[j].month && _datas[i].day == _list_datas[j].day)
          {
            _datas[i].work_type = _list_datas[j].work_type;
          }
        }
      }
    });
  }

  _loadAttendanceDayRecord(String dateTime) //加载日事件
  {
    print("点击的是$dateTime");
    List<String> l=dateTime.split('-');
    int m=int.parse(l[1]);int d=int.parse(l[2]);
    setState(()
    {
      M=m; D=d;
    });
    print(datInfo[M][D].length);
  }

  Widget _yearHeader() //最上方年头
  {
    return Container(
      height: 30,
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {_lastMonth();},
            child: Container(
              margin: const EdgeInsets.only(left: 20.0),
              child: const Icon(Icons.chevron_left,color: Colors.grey,),
            ),
          ),
          Text(
            "$_year   年   $_month   月",
            style: const TextStyle(fontSize: 16.0,
                fontFamily:"Regular",
                //fontWeight:FontWeight.w500,
                color: Color(0xFF3C3E43)
            ),
          ),
          GestureDetector(
            onTap: () {_nextMonth();},
            child: Container(
              margin: const EdgeInsets.only(right: 20.0),
              child: const Icon(Icons.chevron_right,color: Colors.grey,),
            ),
          ),
        ],
      ),
    );
  }

  Widget _weekHeader() //中部周头
  {
    var array = ["一", "二", "三", "四", "五", "六", "日"];
    return Container(
      height: 30,
      child: GridView.builder(
        padding: const EdgeInsets.only(left: 10, right: 10,top: 10),
        itemCount: array.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 2),
        itemBuilder: (context, index)
        {
          return Container(
              alignment: Alignment.center,
              child: Text(
                array[index],
                style: TextStyle(
                    color: index == 5 || index == 6 ? const Color(0xFFC4C8D0) : const Color(0xFF3C3E43),
                    fontSize: 13.0,
                    fontFamily: "Regular",
                    fontWeight: FontWeight.w500
                ),
              ));
        },
      ),
    );
  }

  Widget _everyDay() //每一天组件
  {
    return Container(
      child: GridView.builder(
        padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
        itemCount: _getRowsForMonthYear(year: _year, month: _month) * 7,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 1,//子组件宽高长度比例
        ),
        itemBuilder: (context, index)
        {
          return GestureDetector(
            onTap: ()
            {
              setState(()
              {
                if (_datas[index].month == _month) //只对当前月点击的日期做处理
                    {
                  for (int i = 0; i < _datas.length; i++)
                  {
                    if (i == index) //切换至选中的日期
                    {
                      _day = _datas[i].day!;
                      _datas[i].is_select = true;
                      _loadAttendanceDayRecord( "${_datas[i].year}-${_datas[i].month}-${_datas[i].day}");
                    }
                    else
                    {
                      _datas[i].is_select = false;
                    }
                  }
                }
                else
                {
                  _datas[index].is_select=false;
                }
              });
            },
            child: Container(
              child: Column(
                children: [
                  Container(
                    width: 25.0,
                    height: 25.0,
                    //底部背景
                    decoration: _datas[index].is_select! ? BoxDecoration(
                      color: const Color(0xFF2C91F6).withOpacity(0.4),
                      shape: BoxShape.circle,
                    ) : const BoxDecoration(),
                    child: Center(
                      child: Text(
                        _datas[index].month == _month ? _datas[index].day.toString() : "",
                        //选中字体颜色，以及周末和工作日颜色
                        style: _datas[index].is_select! ? const TextStyle(fontSize: 16.0, color: Color(0xFFFFFFFF))
                            : (index % 7 == 5 || index % 7 == 6 ?
                        const TextStyle(fontSize: 16.0, color: Color(0xFFC4C8D0)) : const TextStyle(fontSize: 16.0, color: Color(0xFF3C3E43))),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  //底部小圆点，非当前月的不显示，设置为透明，其余的根据状态判断显示
                  _datas[index].month == _month && _datas[index].work_type != "" && _datas[index].work_type != "0" ?
                  Container(
                    height: 8.0,
                    width: 8.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _datas[index].work_type == "1" ? const Color(0xFFF48835) : const Color(0xFF2C91F6)),
                  ) : Container(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  int _getRowsForMonthYear({int? year, int? month}) //日历行数
  {
    var _currentMonthDays = _getCurrentMonthDays(year: year, month: month);
    var _placeholderDays = _getPlaceholderDays(year: year, month: month);
    int rows=(_currentMonthDays + _placeholderDays) ~/ 7;
    int remainder=(_currentMonthDays + _placeholderDays) % 7;
    if (remainder>0) rows++;
    return rows;
  }
  int _getPlaceholderDays({int? year, int? month}) //这个月的第一天是星期几
  {
    return DateTime(year!, month!).weekday - 1 % 7;
  }
  int _getCurrentMonthDays({int? year, int? month}) //本月天数
  {
    if (month == 2)
    {
      if (((year!%4==0) && (year%100!=0))||(year%400==0)) {return 29;}
      else {return 28;}
    }
    else if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12)
    {
      return 31;
    }
    else {return 30;}
  }

  _setDatas({int? year, int? month})/// 获取展示信息
  {

    /// 上个月占位
    var lastYear = year;
    var lastMonth = month! - 1;
    if (month == 1)
    {
      lastYear = year! - 1;
      lastMonth = 12;
    }
    var placeholderDays = _getPlaceholderDays(year: year, month: month);
    var lastMonthDays = _getCurrentMonthDays(year: lastYear, month: lastMonth);
    var firstDay = lastMonthDays - placeholderDays;
    for (var i = 0; i < placeholderDays; i++)
    {
      _datas.add(CalendarModel
        (
        year: lastYear!,
        month: lastMonth,
        day: firstDay + i + 1,
        is_select: false,
        work_type: "",
      )
      );
    }

    /// 本月显示
    var currentMonthDays = _getCurrentMonthDays(year: year, month: month);
    for (var i = 0; i < currentMonthDays; i++)
    {
      if (i == _day - 1)
      {
        _datas.add(CalendarModel(
          year: year!,
          month: month,
          day: i + 1,
          is_select: true,
          work_type: "",
        )
        );
      }
      else
      {
        _datas.add(CalendarModel(
            year: year!,
            month: month,
            day: i + 1,
            is_select: false,
            work_type: "")
        );
      }
    }

    /// 下个月占位
    var nextYear = year;
    var nextMonth = month + 1;
    if (month == 12)
    {
      nextYear = year! + 1;
      nextMonth = 1;
    }
    var nextPlaceholderDays = _getPlaceholderDays(year: nextYear, month: nextMonth);
    for (var i = 0; i < 7 - nextPlaceholderDays; i++)
    {
      _datas.add(CalendarModel(
          year: nextYear!,
          month: nextMonth,
          day: i + 1,
          is_select: false,
          work_type: "")
      );
    }
  }

  _lastMonth()
  {
    setState(()
    {
      if (_month==1)
      {
        _year --;
        _month=12;
      }
      else {_month--;}
      _day=1; //查看上一个月时，默认选中第一天
      _datas.clear();
      _setDatas(year: _year, month: _month);
      _loadAttendanceMonthRecord( "$_year-$_month");
      _loadAttendanceDayRecord("$_year-$_month-$_day");
    });
  }

  /*_nextMonth()//不显示当前月之后的月份
  {
    if(_month==12)
    {
      if(DateTime.now().year>=_year+1)
      {
        _setNextMonthData();
      }
    }
    else
    {
      if(DateTime.now().month>=_month+1)
      {
        _setNextMonthData();
      }
    }
  }*/
  _nextMonth() =>_setNextMonthData();//不限制往后月份

  _setNextMonthData()
  {
    setState(()
    {
      if (_month == 12)
      {
        _year++;
        _month=1;
      }
      else {_month++;}
      if (_month == DateTime.now().month)
      {
        _day = DateTime.now().day;
      }
      else
      {
        _day = 1;
      }
      _datas.clear();
      _setDatas(year: _year, month: _month);
      _loadAttendanceMonthRecord( "$_year-$_month");
      _loadAttendanceDayRecord("$_year-$_month-$_day");
    });
  }
}

class CalendarModel //日历bean
{
  int? year;
  int? month;
  int? day;
  String? work_type = "";//日期事件，0：无色，1：橙色，2：蓝色
  bool? is_select = false;
  CalendarModel({this.year, this.month, this.day, this.is_select, this.work_type});
}
// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'chart.dart';
import 'statistics.dart';
import 'bottom.dart';
import 'storage.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  while(StaticMethod.file.path.isEmpty)
  {
    await StaticMethod.setFile();
  }
  runApp(const MyApp());
}


class MyApp extends StatelessWidget
{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      title: 'manage',
      theme: ThemeData(fontFamily: "heiti"),
      home: Home(title:" ",co:Colors.blue),
      routes:{
        'home':(context)=>Home(title:'',co: Colors.blue,),
      },
      initialRoute: 'home',
    );
  }
}

class Home extends StatefulWidget
{
  Home({super.key, required this.title,required this.co});

  final String title;
  Color co;

  @override
  State<Home> createState() => HomeState(co);
}

class HomeState extends State<Home>
{
  Color co;
  HomeState(this.co);
  int theme=0;

  List<Color> themes=[
    Colors.blue,Colors.green,Colors.redAccent,Colors.amber,
  ];
  List<Color?> drawers=[
    Colors.lightBlueAccent,Colors.lightGreen,Colors.red[200],Colors.yellow[300],
  ];
  int currentIndex=0;
  int tempindex=0;
  bool transform=false;
  @override
  void initState()
  {
    super.initState();
    currentIndex=0;
    Storage st=Storage.read();
    names=st.getCategory();
    setState(() {
      if(co==Colors.green) {theme=1;}
      else if(co==Colors.redAccent) theme=2;
      else if(co==Colors.amber) theme=3;
    });
    setState(()
    {
      tempindex=currentIndex;
      if(currentIndex!=0) currentIndex=0;
      else if(currentIndex!=1) currentIndex =1;
    });
    setState(()
    {
      currentIndex=tempindex;
    });
  }

  void _changePage(int index)
  {
    if(index!=currentIndex)
    {
      setState((){currentIndex=index;});
    }
  }

  List<BottomNavigationBarItem> nvi0 =[
      BottomNavigationBarItem(
        icon:Icon(Icons.home),
        label:'Homepage',
        backgroundColor: Colors.blueAccent,
      ),
      BottomNavigationBarItem(
        icon:Icon(Icons.show_chart),
        label:'Chart',
        backgroundColor: Colors.blueAccent,
      ),
      BottomNavigationBarItem(
        icon:Icon(Icons.table_view),
        label:'Statistics',
        backgroundColor: Colors.blueAccent,
      ),
    ];
  List<BottomNavigationBarItem> nvi1 =[
    BottomNavigationBarItem(
      icon:Icon(Icons.home),
      label:'Homepage',
      backgroundColor: Colors.green,//themes[0],
    ),
    BottomNavigationBarItem(
      icon:Icon(Icons.show_chart),
      label:'Chart',
      backgroundColor: Colors.green,
    ),
    BottomNavigationBarItem(
      icon:Icon(Icons.table_view),
      label:'Statistics',
      backgroundColor: Colors.green,
    ),
  ];
  List<BottomNavigationBarItem> nvi2 =[
  BottomNavigationBarItem(
  icon:Icon(Icons.home),
  label:'Homepage',
  backgroundColor: Colors.redAccent,
  ),
  BottomNavigationBarItem(
  icon:Icon(Icons.show_chart),
  label:'Chart',
  backgroundColor: Colors.redAccent,
  ),
  BottomNavigationBarItem(
  icon:Icon(Icons.table_view),
  label:'Statistics',
  backgroundColor: Colors.redAccent,
  ),
  ];
  List<BottomNavigationBarItem> nvi3 =[
    BottomNavigationBarItem(
      icon:Icon(Icons.home),
      label:'Homepage',
      backgroundColor: Colors.amber,
    ),
    BottomNavigationBarItem(
      icon:Icon(Icons.show_chart),
      label:'Chart',
      backgroundColor: Colors.amber,
    ),
    BottomNavigationBarItem(
      icon:Icon(Icons.table_view),
      label:'Statistics',
      backgroundColor: Colors.amber,
    ),
  ];

  final List<Widget> pages =
  [
    //HomePage(),stackedChart(),CalPage(),
    HomePage(),Chart(),Statistics(),
  ];

  var inputText;
  TextEditingController controller = TextEditingController();
  FocusNode focusnode = FocusNode();


  List<String> names= [
    '学习','运动','上课','摸鱼','社交','工作',
  ];

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: themes[theme],
        centerTitle:true,
        actions: [
          IconButton(
            icon: const Icon(Icons.color_lens_outlined),
            tooltip: '更换主题颜色',
            onPressed: ()
            {
              theme++;
              if(theme==themes.length) theme=0;
              //print(theme);
              setState(()
              {
                tempindex=currentIndex;
                if(currentIndex!=0) currentIndex=0;
                else if(currentIndex!=1) currentIndex =1;
              });
              setState(()
              {
                currentIndex=tempindex;
              });
            },
          ),
        ],
      ),
      body: pages[currentIndex],
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children:[
            DrawerHeader(
              decoration: BoxDecoration(
                //color: Colors.lightBlueAccent,
                color: drawers[theme],
              ),
              child: Center(
                child: SizedBox(
                  width: 80.0,
                  height: 80.0,
                  child: CircleAvatar(
                    //backgroundColor: Colors.blue,
                    backgroundColor: themes[theme],
                    child: Text('类别',style: TextStyle(fontSize:22.0,color: Colors.white),),

                  ),
                ),
              ),
            ),
            Flex(direction:Axis.horizontal,
              children: <Widget>[
                SizedBox(height: 10,),
                Icon(Icons.edit,color: Colors.transparent,size: 10.0,),
                Icon(Icons.edit,color: Colors.grey,size: 20.0,),
                Expanded(
                  flex: 5,
                  child: TextButton(
                      onPressed: ()
                      {
                        showDialog(context: context,
                            builder: (BuildContext context)
                            {
                              return AlertDialog(
                                  title: Text('修改此分组名称'),
                                  content: TextField(
                                      showCursor: true,
                                      controller: controller,
                                      focusNode: focusnode,
                                      keyboardType: TextInputType.text,
                                      style: TextStyle(fontSize: 17.0,color: Colors.black),
                                      maxLength: 10,
                                      decoration: InputDecoration(
                                        isCollapsed: false,
                                        labelText: "",
                                        helperText: "输入新的分组名称",
                                        helperStyle: TextStyle(fontSize: 15.0,color: Colors.blue),
                                        contentPadding: EdgeInsets.all(15.0),
                                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                                      ),
                                      onSubmitted: (str)
                                      {
                                        setState(() {inputText=str;});
                                      },
                                      textInputAction: TextInputAction.done,
                                      onChanged: (content)
                                      {
                                        setState(() {inputText=content;});
                                      }
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text('确认'),
                                      onPressed: ()
                                      {
                                        setState(()
                                        {
                                          names[0]=inputText;
                                          Storage.storeCategory(names);
                                          controller.clear();
                                          Navigator.pop(context);
                                        });
                                      },
                                    ),
                                    TextButton(
                                      child: Text('取消'),
                                      onPressed: () {controller.clear();Navigator.pop(context);},
                                    ),
                                  ]
                              );
                            }
                        );
                      },
                      child: Text(names[0],style: TextStyle(color: Colors.blue,fontSize: 16.0,fontWeight: FontWeight.bold))
                  ),),
              ],
            ),
            Flex(direction: Axis.horizontal,
              children: <Widget>[
                SizedBox(height: 10,),
                Icon(Icons.edit,color: Colors.transparent,size: 10.0,),
                Icon(Icons.sports_basketball,color: Colors.grey,size: 20.0,),
                Expanded(
                  flex: 5,
                  child: TextButton(
                      onPressed: ()
                      {
                        showDialog(
                            context: context,
                            builder: (BuildContext context)
                            {
                              return AlertDialog(
                                  title: Text('修改此分组名称'),
                                  content: TextField(
                                      showCursor: true,
                                      controller: controller,
                                      focusNode: focusnode,
                                      keyboardType: TextInputType.text,
                                      style: TextStyle(fontSize: 17.0,color: Colors.black),
                                      maxLength: 10,
                                      decoration: InputDecoration(
                                        isCollapsed: false,
                                        labelText: "",
                                        helperText: "输入新的分组名称",
                                        helperStyle: TextStyle(fontSize: 15.0,color: Colors.blue),
                                        contentPadding: EdgeInsets.all(15.0),
                                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                                      ),
                                      onSubmitted: (str)
                                      {
                                        setState(() {inputText=str;});
                                      },
                                      textInputAction: TextInputAction.done,
                                      onChanged: (content)
                                      {
                                        setState(() {inputText=content;});
                                      }
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text('确认'),
                                      onPressed: ()
                                      {
                                        setState(()
                                        {
                                          names[1]=inputText;
                                          Storage.storeCategory(names);
                                          controller.clear();
                                          Navigator.pop(context);
                                        });
                                      },
                                    ),
                                    TextButton(
                                      child: Text('取消'),
                                      onPressed: () {controller.clear();Navigator.pop(context);},
                                    ),
                                  ]
                              );
                            }
                        );
                      },
                      child: Text(names[1],style: TextStyle(color: Colors.lightGreen,fontSize: 16,fontWeight: FontWeight.bold))
                  ),),
              ],
            ),
            Flex(direction: Axis.horizontal,
              children: <Widget>[
                SizedBox(height: 10,),
                Icon(Icons.edit,color: Colors.transparent,size: 10.0,),
                Icon(Icons.book_outlined,color: Colors.grey,size: 20.0,),
                Expanded(
                  flex: 5,
                  child: TextButton(
                      onPressed: ()
                      {
                        showDialog(
                            context: context,
                            builder: (BuildContext context)
                            {
                              return AlertDialog(
                                  title: Text('修改此分组名称'),
                                  content: TextField(
                                      showCursor: true,
                                      controller: controller,
                                      focusNode: focusnode,
                                      keyboardType: TextInputType.text,
                                      style: TextStyle(fontSize: 17.0,color: Colors.black),
                                      maxLength: 10,
                                      decoration: InputDecoration(
                                        isCollapsed: false,
                                        labelText: "",
                                        helperText: "输入新的分组名称",
                                        helperStyle: TextStyle(fontSize: 15.0,color: Colors.blue),
                                        contentPadding: EdgeInsets.all(15.0),
                                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                                      ),
                                      onSubmitted: (str)
                                      {
                                        setState(() {inputText=str;});
                                      },
                                      textInputAction: TextInputAction.done,
                                      onChanged: (content)
                                      {
                                        setState(() {inputText=content;});
                                      }
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text('确认'),
                                      onPressed: ()
                                      {
                                        setState(()
                                        {
                                          names[2]=inputText;
                                          Storage.storeCategory(names);
                                          controller.clear();
                                          Navigator.pop(context);
                                        });
                                      },
                                    ),
                                    TextButton(
                                      child: Text('取消'),
                                      onPressed: () {controller.clear();Navigator.pop(context);},
                                    ),
                                  ]
                              );
                            }
                        );
                      },
                      child: Text(names[2],style: TextStyle(color: Colors.grey,fontSize: 16,fontWeight: FontWeight.bold))
                  ),),
              ],
            ),
            Flex(direction: Axis.horizontal,
              children: <Widget>[
                SizedBox(height: 10,),
                Icon(Icons.edit,color: Colors.transparent,size: 10.0,),
                Icon(Icons.star_outline,color: Colors.grey,size: 20.0,),
                Expanded(
                  flex: 5,
                  child: TextButton(
                      onPressed: ()
                      {
                        showDialog(
                            context: context,
                            builder: (BuildContext context)
                            {
                              return AlertDialog(
                                  title: Text('修改此分组名称'),
                                  content: TextField(
                                      showCursor: true,
                                      controller: controller,
                                      focusNode: focusnode,
                                      keyboardType: TextInputType.text,
                                      style: TextStyle(fontSize: 17.0,color: Colors.black),
                                      maxLength: 10,
                                      decoration: InputDecoration(
                                        isCollapsed: false,
                                        labelText: "",
                                        helperText: "输入新的分组名称",
                                        helperStyle: TextStyle(fontSize: 15.0,color: Colors.blue),
                                        contentPadding: EdgeInsets.all(15.0),
                                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                                      ),
                                      onSubmitted: (str)
                                      {
                                        setState(() {inputText=str;});
                                      },
                                      textInputAction: TextInputAction.done,
                                      onChanged: (content)
                                      {
                                        setState(() {inputText=content;});
                                      }
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text('确认'),
                                      onPressed: ()
                                      {
                                        setState(()
                                        {
                                          names[3]=inputText;
                                          Storage.storeCategory(names);
                                          controller.clear();
                                          Navigator.pop(context);
                                        });
                                      },
                                    ),
                                    TextButton(
                                      child: Text('取消'),
                                      onPressed: () {controller.clear();Navigator.pop(context);},
                                    ),
                                  ]
                              );
                            }
                        );
                      },
                      child: Text(names[3],style: TextStyle(color: Colors.redAccent,fontSize: 16,fontWeight: FontWeight.bold))
                  ),),
              ],
            ),
            Flex(direction: Axis.horizontal,
              children: <Widget>[
                SizedBox(height: 10,),
                Icon(Icons.edit,color: Colors.transparent,size: 10.0,),
                Icon(Icons.grass,color: Colors.grey,size: 20.0,),
                Expanded(
                  flex: 5,
                  child: TextButton(
                      onPressed: ()
                      {
                        showDialog(
                            context: context,
                            builder: (BuildContext context)
                            {
                              return AlertDialog(
                                  title: Text('修改此分组名称'),
                                  content: TextField(
                                      showCursor: true,
                                      controller: controller,
                                      focusNode: focusnode,
                                      keyboardType: TextInputType.text,
                                      style: TextStyle(fontSize: 17.0,color: Colors.black),
                                      maxLength: 10,
                                      decoration: InputDecoration(
                                        isCollapsed: false,
                                        labelText: "",
                                        helperText: "输入新的分组名称",
                                        helperStyle: TextStyle(fontSize: 15.0,color: Colors.blue),
                                        contentPadding: EdgeInsets.all(15.0),
                                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                                      ),
                                      onSubmitted: (str)
                                      {
                                        setState(() {inputText=str;});
                                      },
                                      textInputAction: TextInputAction.done,
                                      onChanged: (content)
                                      {
                                        setState(() {inputText=content;});
                                      }
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text('确认'),
                                      onPressed: ()
                                      {
                                        setState(()
                                        {
                                          names[4]=inputText;
                                          Storage.storeCategory(names);
                                          controller.clear();
                                          Navigator.pop(context);
                                        });
                                      },
                                    ),
                                    TextButton(
                                      child: Text('取消'),
                                      onPressed: () {controller.clear();Navigator.pop(context);},
                                    ),
                                  ]
                              );
                            }
                        );
                      },
                      child: Text(names[4],style: TextStyle(color: Colors.amber,fontSize: 16,fontWeight: FontWeight.bold))
                  ),),
              ],
            ),
            Flex(direction: Axis.horizontal,
              children: <Widget>[
                SizedBox(height: 10,),
                Icon(Icons.edit,color: Colors.transparent,size: 10.0,),
                Icon(Icons.task_alt_outlined,color: Colors.grey,size: 20.0,),
                Expanded(
                  flex: 5,
                  child: TextButton(
                      onPressed: ()
                      {
                        showDialog(
                            context: context,
                            builder: (BuildContext context)
                            {
                              return AlertDialog(
                                  title: Text('修改此分组名称'),
                                  content: TextField(
                                      showCursor: true,
                                      controller: controller,
                                      focusNode: focusnode,
                                      keyboardType: TextInputType.text,
                                      style: TextStyle(fontSize: 17.0,color: Colors.black),
                                      maxLength: 10,
                                      decoration: InputDecoration(
                                        isCollapsed: false,
                                        labelText: "",
                                        helperText: "输入新的分组名称",
                                        helperStyle: TextStyle(fontSize: 15.0,color: Colors.blue),
                                        contentPadding: EdgeInsets.all(15.0),
                                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                                      ),
                                      onSubmitted: (str)
                                      {
                                        setState(() {inputText=str;});
                                      },
                                      textInputAction: TextInputAction.done,
                                      onChanged: (content)
                                      {
                                        setState(() {inputText=content;});
                                      }
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text('确认'),
                                      onPressed: ()
                                      {
                                        setState(()
                                        {
                                          names[5]=inputText;
                                          Storage.storeCategory(names);
                                          controller.clear();
                                          Navigator.pop(context);
                                        });
                                      },
                                    ),
                                    TextButton(
                                      child: Text('取消'),
                                      onPressed: () {controller.clear();Navigator.pop(context);},
                                    ),
                                  ]
                              );
                            }
                        );
                      },
                      child: Text(names[5],style: TextStyle(color: Colors.teal,fontSize: 16,fontWeight: FontWeight.bold))
                  ),),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: TextStyle(fontFamily: "Regular"),
          items:theme<=1? (theme==0?nvi0:nvi1):(theme==2?nvi2:nvi3),
          currentIndex:currentIndex,
          type:BottomNavigationBarType.shifting,
          onTap:(index){
            _changePage(index);
          }
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: themes[theme],
        onPressed:()
        {
          setState(()
          {
            Navigator.push(context,MaterialPageRoute(
                builder: (context) => Bottom(category:names,theme:themes[theme]))
            );
          }
          );
        },
        child:Icon(Icons.add),
      ),
    );
  }
}

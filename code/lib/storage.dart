// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
class StaticMethod
{
  static File file=File('');
  static File file1=File('');
  static setFile() async
  {
    if(Platform.isAndroid) {
      Directory dir = await getApplicationSupportDirectory();
      file = File(('${dir.path}/storage.txt'));
      file1 = File(('${dir.path}/storage1.txt'));
      //手机端使用
    }
    else {
      file = File('lib/local/test.txt');
      file1 = File('lib/local/settings.txt');
    }
    //电脑端使用

    //--------------------------------------------------------
    //初始化-创建文件
    if(!await file.exists())
    {
      await file.create(recursive:true);
    }

    if(!await file1.exists())
    {
      await file1.create(recursive:true);
    }
  }
}

class Storage
{
  Map<Color?,int> colorType=
  {
    Colors.lightBlue:0,
    Colors.lightGreen:1,
    Colors.grey:2,
    Colors.redAccent:3,
    Colors.amber:4,
    Colors.teal:5,
  };

  Color? taskColor=Colors.lightBlue;
  int colorIndex=0;
  int? colorDescription=0x00000000;
  String taskName="";
  String duration="";
  String finishedDate="";
  String finishedTime="";
  String s='';
  File file=StaticMethod.file;
  File file1=StaticMethod.file1;


  readFile(File f)
  {
    final str=f.readAsStringSync();
    return str;
  }
  connectString(int typo)
  {
    s=readFile(file);
    String s1=(typo==0)?
    '0 $colorIndex $taskName $duration $finishedDate $finishedTime':
    '1 $colorDescription $taskName $duration $finishedDate $finishedTime';
    final st='$s\n$s1';
    return st;
  }
  void writeFile(int typo)
  {
    String context=connectString(typo);
    file.writeAsString(context);
  }


  Storage (this.taskColor,this.taskName,this.duration,this.finishedDate,this.finishedTime)
  {
    colorIndex=colorType[taskColor]!;
    writeFile(0);
  }

  Storage.dynamicColor(this.colorDescription,this.taskName,this.duration,this.finishedDate,this.finishedTime)
  {
    writeFile(1);
  }
  Storage.storeCategory(List<String> category)
  {
    String s=category[0];
    for(int i=1;i<=5;i++)
    {
      s='$s]${category[i]}';
    }
    file1.writeAsString(s);
  }
  Storage.read();
  List<String> getString()
  {
    String s=file.readAsStringSync();
    List<String> ss=s.split('\n');
    return ss;
  }
  List<String> getCategory()
  {
    String s=file1.readAsStringSync();
    if(s=="") {s="学习]运动]上课]摸鱼]社交]工作";}
    List<String> ss=s.split(']');
    return ss;
  }
}
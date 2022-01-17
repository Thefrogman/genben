
import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
class GenderStorage {
  Future<String?> get _localPath async {
    final directory = await getExternalStorageDirectory();
    return directory?.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<String> readCounter(value) async {
    try {
      final file = await _localFile;
      // Read the file
      final contents = await file.readAsString();
      List<String> lines = contents.split('\n');
      return lines[value];
    } catch (e) {
      // If encountering an error, return 0
      return "";
    }
  }
   Future<String> readCounterFull() async {
    try {
      final file = await _localFile;
      // Read the file
      final contents = await file.readAsString();
      
      List<String> lines = contents.split('\n');
      String result = ""; 
      for(String line in lines) {
        result += line + "\n";
      }
      
      return result;
    } catch (e) {
      // If encountering an error, return 0
      return "";
    }
  }
    Future<String> readCounterFullFrom(int from) async {
    try {
      int comp = 0;
      final file = await _localFile;
      // Read the file
      final contents = await file.readAsString();
      List<String> lines = contents.split('\n');
      String result = ""; 
      for(String line in lines) {
        if(comp >= from) {
        result += line + "\n";
       
        }
         comp++;
      }
      return result;
    } catch (e) {
      // If encountering an error, return 0
      return "";
    }
  }
  Future<String> readCounterFullTo(int to) async {
    try {
      int comp = 0;
      final file = await _localFile;
      // Read the file
      final contents = await file.readAsString();
      List<String> lines = contents.split('\n');
      String result = ""; 
      for(String line in lines) {
        if(comp <= to) {
        result += line + "\n";
       
        }
         comp++;
      }
      
      return result;
    } catch (e) {
      // If encountering an error, return 0
      return "";
    }
  }
  Future<File> writeCounter(String data,int mode) async {
    final file = await _localFile;
    if(mode == 0) {
    return file.writeAsString(data);
    }
    else {
      return file.writeAsString(data,mode:FileMode.append,flush: false);
    }
  }
}
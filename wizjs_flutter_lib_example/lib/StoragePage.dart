/*
 * @FilePath     : /wizjs_flutter_lib/wizjs_flutter_lib_example/lib/StoragePage.dart
 * @Date         : 2021-07-22 18:03:56
 * @Author       : jawa0919 <jawa0919@163.com>
 * @Description  : 数据存储
 */

import 'dart:convert';

import 'package:dio_log/dio_log.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoragePage extends StatefulWidget {
  const StoragePage({Key? key}) : super(key: key);

  @override
  _StoragePageState createState() => _StoragePageState();
}

class _StoragePageState extends State<StoragePage> {
  List<String> _ky = [];
  late SharedPreferences _sp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("sp数据 -- ${_ky.length}条")),
      body: FutureBuilder<SharedPreferences>(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return SizedBox();
            _sp = snapshot.data!;
            _ky = _sp.getKeys().toList();
            return ListView.builder(
              itemCount: _ky.length,
              padding: EdgeInsets.only(top: 8),
              itemBuilder: (BuildContext c, int i) => ListTile(
                leading: InkWell(
                  child: Icon(Icons.delete),
                  onTap: () async {
                    await _sp.remove(_ky[i]);
                    _ky = _sp.getKeys().toList();
                    setState(() {});
                  },
                ),
                title: Text(_ky[i], style: TextStyle(fontSize: 20)),
                trailing: InkWell(child: Icon(Icons.navigate_next)),
                onTap: () {
                  final obj = _sp.get(_ky[i]);
                  String value = obj is String ? obj : obj.toString();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => valueJsonView(context, value),
                    ),
                  );
                },
              ),
            );
          }),
    );
  }

  Widget valueJsonView(BuildContext context, String value) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: JsonView(
              json: jsonDecode(value),
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}

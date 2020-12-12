import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mathquestionapp/apilink/apilink.dart';

class Api {
  String name;

  String _url = ApiLink.url;

  Api(this.name) {

    _url += '/' + this.name;
  }

  Future<List<dynamic>> get() async {

    final data = await http.get(
      _url,
      headers: {
        'content-type': 'application/json',
      },
    );

    List<dynamic> listMap = jsonDecode(data.body);

    return listMap;
  }


  Future<String> post(Map<String, dynamic> jsonBody) async {
    final data = await http.post(
      _url + '/',
      headers: {
        'content-type': 'application/json',
      },
      body: jsonEncode(jsonBody),
    );
    return data.body;
  }

  Future<String> put(Map<String, dynamic> jsonBody, String columnId) async {
    final data = await http.put(
      _url + '/' + columnId,
      headers: {
        'content-type': 'application/json',
      },
      body: jsonEncode(jsonBody),
    );
    return data.body;
  }

  Future<int> delete(String valueId) async {
    final data = await http.delete(
      _url + '/' + valueId,
      headers: {
        'content-type': 'application/json',
      },
    );
    return data.statusCode;
  }
}

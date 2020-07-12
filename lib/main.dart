import 'package:flutter/material.dart';
import 'package:agendapessoal/ui/home_page.dart';
import 'package:agendapessoal/ui/contact_page.dart';
//sqflite: ^1.1.5
//url_launcher: ^5.0.2
//image_picker: ^0.6.0+3

void main(){
  runApp(MaterialApp(
    title: "Agenda",
    home: Homepage(),
    debugShowCheckedModeBanner: false,//tira a faixa de debug chata
  ));
}
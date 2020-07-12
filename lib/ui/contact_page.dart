import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:agendapessoal/contact_help.dart';
import 'package:image_picker/image_picker.dart';
class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});//construtor
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _nameFocus = FocusNode();
  Contact _editedContact;
  bool _userEdited = false;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.contact==null){ //conta como atributo
      _editedContact = Contact();
    }else{
      _editedContact = Contact.fromMap(widget.contact.toMap());


      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;






    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(_editedContact.name?? "Novo Contato"),//se for em branco fica novo contato senao fica o nome normal
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            if(_editedContact.name!=null && _editedContact.name.isNotEmpty){
              Navigator.pop(context,_editedContact);//o pop remove a tela e volta pra anterior
            }else{
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          child: Icon(
            Icons.save,
          ),
          backgroundColor: Colors.red,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(

            children: <Widget>[
              GestureDetector(
                child:  Container(

                  height: 140,
                  width: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,//imagem circular
                        image:_editedContact.img!=null ?
                        FileImage(File(_editedContact.img)):
                        AssetImage("images/original.jpg")
                    ),


                  ),
                ),
                onTap: (){
                  ImagePicker.pickImage(source: ImageSource.camera).then((file){
                    if(file==null) return;
                       setState(() {
                        _editedContact.img = file.path;//se a imagem for nula salva o caminho da imagem
                      });


                  });//ponte de imagens
                },
              ),
              TextField(
                focusNode: _nameFocus,// o Focus é um alvo central de direçoes
                controller: _nameController,
                onChanged: (text){
                  _userEdited = true;
                  setState(() {
                    _editedContact.name = text;
                  });
                },
                decoration: InputDecoration(
                  labelText: "Nome",
                ),
              ),
              TextField(
                controller: _emailController,
                onChanged: (text){
                  _userEdited = true;

                  _editedContact.email = text;

                },
                decoration: InputDecoration(
                  labelText: "email",
                ),
              ),
              TextField(
                controller: _phoneController,
                onChanged: (text){
                  _userEdited = true;

                  _editedContact.phone = text;

                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "phone",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<bool> _requestPop(){
    if(_userEdited){
      showDialog(context: context,
        builder: (context) {
            return AlertDialog(
              title: Text("Descartar alterações?"),
              content: Text('Se sair as alterações serão perdidas'),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Sim"),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
        }
      );
      return Future.value(false);//sai automaticamente
    }else{
      return Future.value(true);//nao sai automaticamente
    }
  }
}

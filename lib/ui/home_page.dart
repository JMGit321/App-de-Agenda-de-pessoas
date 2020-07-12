import 'dart:io';
import 'package:async/async.dart';
import 'package:agendapessoal/ui/contact_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../contact_help.dart';
import 'package:url_launcher/url_launcher.dart';

enum OrderOptions{orderaz,orderza}

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  ContactHelper helper = ContactHelper();
  List<Contact> contacts = List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllContact();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Contatos'),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar de A-Z"),
                value: OrderOptions.orderaz,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar de Z-A"),
                value: OrderOptions.orderza,
              ),
            ],
            onSelected: _OrderList,
          )
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed:(){
          _ShowContactPage();
        } ,
        child: Icon(
          Icons.add,
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: contacts.length,
        itemBuilder: (context,index){
          return _contactCard(context, index);
        },

      ),
    );
  }
  Widget _contactCard(BuildContext context, int index){
    return GestureDetector(//permite que as coisas possam ser tocadas
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  image: DecorationImage(
                      fit: BoxFit.cover,
                    image: contacts[index].img!=null ?
                    FileImage(

                      File(contacts[index].img)):
                    AssetImage("images/original.jpg")
                  ),


                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(contacts[index].name ?? "",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(contacts[index].email ?? "",
                      style: TextStyle(
                        fontSize: 18,

                      ),
                    ),
                    Text(contacts[index].phone ?? "",//verifica se está vazio
                      style: TextStyle(
                        fontSize: 18,

                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: (){
        _ShowOptions(context,index);

      },
    );
  }
  void _ShowOptions(BuildContext contex, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context){
          return BottomSheet(
            onClosing: (){},
            builder: (context){
              return Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,//diminui o tamanho da tela com os botoes
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
                      child:FlatButton(
                        child: Text("Ligar",
                          style: TextStyle(
                            color: Colors.red,fontSize: 20,
                          ),
                        ),
                        onPressed: (){//fazer ligação
                          launch("tel:${contacts[index].phone}");
                          Navigator.pop(context);
                        },
                      ) ,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child:FlatButton(
                        child: Text("Editar",
                          style: TextStyle(
                            color: Colors.red,fontSize: 20,
                          ),
                        ),
                        onPressed: (){
                          Navigator.pop(context);//pop é voltar e push é avançar
                          _ShowContactPage(contact: contacts[index]);
                        },
                      ) ,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child:FlatButton(
                        child: Text("Excluir",
                          style: TextStyle(
                            color: Colors.red,fontSize: 20,
                          ),
                        ),
                        onPressed: (){
                          helper.deleteContact(contacts[index].id);

                          setState(() {
                            contacts.removeAt(index);
                            Navigator.pop(context);
                          });
                        },
                      ) ,
                    ),


                  ],
                ),
              );
            },
          );
        });
  }
 void _ShowContactPage({Contact contact}) async{//parametro opcional
    final recontact = await Navigator.push(context,MaterialPageRoute(builder: (context) => ContactPage(contact:  contact,)));
     if(recontact!=null){
       if(contact!=null){
         await helper.updateContact(recontact);

       }else{
         print(recontact);
         await helper.saveContact(recontact);
       }
       _getAllContact();
     }
 }
 void _getAllContact(){
   helper.getAllContact().then((list){
     setState(() {
       contacts = list;
     });

   });
 }
 void _OrderList(OrderOptions result){
    switch(result){
      case OrderOptions.orderaz:
        contacts.sort((a,b){
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());//tamanho de caractere nao interferem
        });
        break;
      case OrderOptions.orderza:
        contacts.sort((a,b){
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());//tamanho de caractere nao interferem
        });
        break;
    }
    setState(() {

    });
 }
}

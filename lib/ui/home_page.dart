import 'dart:io';

import 'package:flutter/material.dart';
import 'package:listadecontatos/helpers/contact_helper.dart';
import 'package:listadecontatos/ui/contact_page.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ContactHelper helper = ContactHelper();

  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: contacts.length,
          itemBuilder: (context, Index){
            return _contactCard(context, Index);
          }
      ),
    );
  }

  Widget _contactCard(BuildContext context, int index){
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children:<Widget> [
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: contacts[index].img != null ?
                        FileImage(File(contacts[index].img!)) :
                          AssetImage("images/megaman-x.jpg") as ImageProvider
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:<Widget>[
                    Text(contacts[index].name ?? "",
                    style: TextStyle(fontSize: 22.0,
                        fontWeight: FontWeight.bold),
                    ),
                    Text(contacts[index].email ?? "",
                      style: TextStyle(fontSize: 18.0,),
                    ),
                Text(contacts[index].phone ?? "",
                  style: TextStyle(fontSize: 18.0,),
                )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: (){
        _showOptions(context, index);
      },
    );
  }
  void _showOptions(BuildContext context, int index){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return BottomSheet(
              onClosing: (){},
              builder: (context){
                return Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child:    TextButton(
                          child: Text("ligar",
                            style: TextStyle(color: Colors.red, fontSize: 20.0),
                          ),
                          onPressed: (){
                            launchUrl(Uri.parse("tel:${contacts[index].phone}"));
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child:    TextButton(
                          child: Text("Editar",
                            style: TextStyle(color: Colors.red, fontSize: 20.0),
                          ),
                          onPressed: (){
                            Navigator.pop(context);
                            _showContactPage(contact: contacts[index]);
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child:    TextButton(
                          child: Text("Excluir",
                            style: TextStyle(color: Colors.red, fontSize: 20.0),
                          ),
                          onPressed: (){
                            helper.deleteContact(contacts[index].id!);
                            setState(() {
                              contacts.removeAt(index);
                              Navigator.pop(context);
                            });
                          },
                        ),
                      ),
                   ],
                  ),
                );
              });
        }
    );
  }

  void _showContactPage({Contact? contact}) async {
    print(contact);
   final recContact = await Navigator.push(context,
      MaterialPageRoute(builder: (context) => ContactPage(contact: contact,))
    );
   if(recContact != null){
     if(contact != null){
       print("atualizar");
       await helper.updateContact(recContact);
       _getAllContacts();
     }else{
       await helper.saveContact(recContact);
       _getAllContacts();
     }
   }
  }
  void _getAllContacts(){
    helper.getAllContact().then((list){
      setState(() {
        contacts = list.cast<Contact>();
      });
    });
  }
}

import 'package:chat_mobile/flavors/globals.dart';
import 'package:chat_mobile/ui/widgets/common_ui.dart';
import 'package:chat_models/chat_models.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {

  @override _AccountPageState createState() => _AccountPageState();

}

class _AccountPageState extends State<AccountPage> {

  User user;

  @override void initState() {
    user = currentUser;
    super.initState();
  }

  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        centerTitle: true,
        actions: [
          LogoutButton()
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          bottom: true,
          child: Padding(
            padding: EdgeInsets.all(16).copyWith(bottom: 24),
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      shape: BoxShape.circle
                  ),
                  child: Center(
                    child: Text('${user.realName.isEmpty ? 'U' : user.realName[0]}'
                        '${user.realSurname.isEmpty ? 'N' : user.realSurname[0]}',
                      style: TextStyle(fontSize: 24, color: Colors.black),),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 16)),
                Text('Мой id: ${user.id}', style: Theme.of(context).textTheme.bodyText1,),
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: TextEditingController(
                              text: user.realName
                          ),
                          decoration: InputDecoration(
                              hintText: 'Real Name',
                              labelText: 'Enter your name'
                          ),
                        ),
                        TextFormField(
                          controller: TextEditingController(
                              text: user.realSurname
                          ),
                          decoration: InputDecoration(
                              hintText: 'Real Surname',
                              labelText: 'Enter your Surname'
                          ),
                        ),
                        TextFormField(
                          controller: TextEditingController(
                              text: user.name
                          ),
                          decoration: InputDecoration(
                              hintText: 'Phone',
                              labelText: 'Enter your phone number'
                          ),
                        ),
                        TextFormField(
                          controller: TextEditingController(
                              text: user.email
                          ),
                          decoration: InputDecoration(
                              hintText: 'E-mail',
                              labelText: 'Enter your e-mail'
                          ),
                        ),
                      ],
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
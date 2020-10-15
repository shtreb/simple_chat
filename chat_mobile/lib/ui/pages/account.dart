import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:chat_models/chat_models.dart';
import 'package:chat_api_client/chat_api_client.dart';

import 'package:chat_mobile/ui/widgets/common_ui.dart';
import 'package:chat_mobile/data/cases/api_client.dart';
import 'package:chat_mobile/data/cases/validates/validate-phone.dart';
import 'package:chat_mobile/flavors/globals.dart';
import 'package:chat_mobile/generated/i18n.dart';

class AccountPage extends StatefulWidget {
  @override _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  User user;
  ValueNotifier<bool> showButton;

  @override void initState() {
    resetUser();
    showButton = ValueNotifier(false);
    super.initState();
  }

  @override Widget build(BuildContext context) {
    return ValueListenableProvider<bool>.value(
      value: showButton,
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).account),
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
                  Text(S.of(context).account_id(user.id), style: Theme.of(context).textTheme.bodyText1,),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: TextEditingController(text: user.realName)
                              ..selection = TextSelection.collapsed(offset: user.realName.length),
                            decoration: InputDecoration(
                                hintText: S.of(context).account_name,
                                labelText: S.of(context).account_enter_name,
                            ),
                            onChanged: (value) {
                              user.realName = value;
                              checkChanges();
                            },
                          ),
                          TextFormField(
                            controller: TextEditingController(text: user.realSurname)
                              ..selection = TextSelection.collapsed(offset: user.realSurname.length),
                            decoration: InputDecoration(
                                hintText: S.of(context).account_surname,
                                labelText: S.of(context).account_enter_surname
                            ),
                            onChanged: (value) {
                              user.realSurname = value;
                              checkChanges();
                            },
                          ),
                          TextFormField(
                            controller: TextEditingController(text: user.name)
                              ..selection = TextSelection.collapsed(offset: user.name.length),
                            decoration: InputDecoration(
                                hintText: S.of(context).account_phone,
                                labelText: S.of(context).account_enter_phone,
                                prefix: Text('+')
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(11),
                              PhoneFormat(RegExp('[0-9]+\$')),
                            ],
                            onChanged: (value) {
                              user.name = value;
                              checkChanges();
                            },
                          ),
                          TextFormField(
                            controller: TextEditingController(text: user.email)
                              ..selection = TextSelection.collapsed(offset: user.email.length),
                            decoration: InputDecoration(
                                hintText: S.of(context).account_email,
                                labelText: S.of(context).account_enter_email
                            ),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              bool res = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
                              if(res)
                                user.email = value;
                              checkChanges();
                            },
                          ),
                        ],
                      )
                  ),
                  Consumer<bool>(
                    builder: (_, value, __) => value ? Column(
                      children: [
                        FlatButton(
                            child: Text(S.of(context).account_save),
                            minWidth: MediaQuery.of(context).size.width-64,
                            color: Theme.of(context).buttonColor,
                            onPressed: () async {
                              try {
                                UsersClient usersClient = UsersClient(MobileApiClient());
                                usersClient.update(user);
                              } catch(e) {
                                debugPrint(e.toString());
                              }
                            }
                        ),
                        CupertinoButton(
                            child: Text(S.of(context).account_reset,
                              style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),),
                            onPressed: () {
                              resetUser();
                              checkChanges();
                              setState(() {});
                            }
                        )
                      ],
                    ) : SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }

  void checkChanges() {
    showButton.value = user.name != currentUser.name ||
        user.realName != currentUser.realName ||
        user.realSurname != currentUser.realSurname ||
        user.email != currentUser.email;
  }

  void resetUser() {
    user = User();
    user.id = currentUser.id;
    user.name = currentUser.name;
    user.realName = currentUser.realName;
    user.realSurname = currentUser.realSurname;
    user.email = currentUser.email;
    user.password = currentUser.password;
  }

}
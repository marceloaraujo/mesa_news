import 'package:flutter/material.dart';
import 'package:mesa_news/screens/login/LoginPage.dart';
import 'package:mesa_news/screens/login/NewUserPage.dart';
import 'package:mesa_news/screens/news/NewsPage.dart';
import 'package:mesa_news/utils/ColorUtils.dart';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitialPage extends StatefulWidget {
  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {

  _openLogin() {
    Navigator.push(context,
      MaterialPageRoute(
        builder: (_) => LoginPage()
      )
    );
  }

  _openNewUserPage() {
    Navigator.push(context, 
      MaterialPageRoute(builder: (_) => NewUserPage())
    );
  }

  _doLoginFacebook() async {
    final result = await FacebookAuth.instance.login(
      permissions: ['email']
    );
    if(result != null) {
      /**
       * O token retornado pelo Facebook não poderá ser usado para 
       * autenticação na API da Mesa, então, usarei um token válido para autenticar.
       */
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', 'eyJhbGciOiJIUzI1NiJ9.eyJpZCI6NjA0LCJlbWFpbCI6Im1hcmNlbG8ucmRhcmF1am8xOTkxQGdtYWlsLmNvbSJ9.CM7osWE7mj4U0TQpo0xIyvVGWcKUfGtxtyzKgzKdU1c');
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_)  => NewsPage()), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.getColorFromHex('#010A53'),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [

            Column(
              children: [
                Image.asset(
                  'images/logo.png',
                  width: 130,
                  fit: BoxFit.fill,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Image.asset(
                    'images/news.png',
                    width: 90,
                    fit: BoxFit.fill,
                  ),
                )
              ],
            ),

            Column(
              children: [

                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: FlatButton(
                    color: Colors.white,
                    minWidth: double.infinity,
                    height: 50,
                    onPressed: _doLoginFacebook, 
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.white,
                        width: 1,
                        style: BorderStyle.solid
                      ),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Text(
                      'Entrar com Facebook',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.blue
                      ),
                    )
                  )
                ),
                
                FlatButton(
                  minWidth: double.infinity,
                  height: 50,
                  onPressed: _openLogin, 
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.white,
                      width: 1,
                      style: BorderStyle.solid
                    ),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Text(
                    'Entrar com e-mail',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white
                    ),
                  )
                ),

                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Não tenho conta. ',
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                      FlatButton(
                        onPressed: _openNewUserPage,
                        child: Text(
                          'Cadastrar',
                          style: TextStyle(
                            color: Colors.blue
                          ),
                        )
                      )
                    ],
                  ),
                )

                

              ],
            )

          ],
        ),
      )
    );
  }
}

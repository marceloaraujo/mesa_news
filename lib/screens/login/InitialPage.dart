import 'package:flutter/material.dart';
import 'package:mesa_news/screens/login/LoginPage.dart';
import 'package:mesa_news/screens/login/NewUserPage.dart';
import 'package:mesa_news/utils/ColorUtils.dart';

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

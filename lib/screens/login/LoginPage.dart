import 'package:flutter/material.dart';
import 'package:mesa_news/utils/ColorUtils.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                Image.asset('images/logo.png'),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Image.asset('images/news.png'),
                )
              ],
            ),

            Column(
              children: [
                
                FlatButton(
                  minWidth: double.infinity,
                  height: 50,
                  onPressed: (){}, 
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
                        onPressed: () {},
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

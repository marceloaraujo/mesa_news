import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:mesa_news/api/LoginApi.dart';
import 'package:mesa_news/api/MesaResponse.dart';
import 'package:mesa_news/screens/login/NewUserPage.dart';
import 'package:mesa_news/screens/news/NewsPage.dart';
import 'package:mesa_news/utils/ColorUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {

  String email;

  LoginPage({this.email});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();

  _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 3))
    );
  }

  _validateFields() {
    if(_controllerEmail.text == '' ||
       _controllerSenha.text == '') {
      return false;
    }
    return true;
  }

  _openNewUserPage() {
    Navigator.push(context, 
      MaterialPageRoute(builder: (_) => NewUserPage())
    );
  }

  _doLogin() async {
    if(_validateFields()) {
      MesaResponse response = await LoginApi().signin(
        _controllerEmail.text, 
        _controllerSenha.text
      );
      if(response.getStatusCode() != 200) {
        _showSnackbar(response.getMessage());
      } else {
        /**
         * Salva o token no shared_preferences e 
         * direciona o usuário para a tela principal
         */
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.getData());
        /**
         * O código abaixo elimina as telas anteriores
         * e direciona para a tela principal, de modo que,
         * se o usuário clicar em voltar (no Android, que tem botão voltar físico/virtual),
         * o app não irá voltar para a tela de cadastro de usuário/login
         */
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => NewsPage()), 
          (route) => false);
      }
    } else {
      _showSnackbar('Campos marcados com * são obrigatórios.');
    }
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
      appBar: AppBar(
        title: Text(
          'Entrar com e-mail'
        ),
      ),
      body: Center(
        child: Container(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Image.asset(
                  'images/img_login.png',
                  width: 100,
                  fit: BoxFit.fill
                ),

                Padding(padding: EdgeInsets.only(bottom: 40)),

                Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [

                      TextField(
                        controller: _controllerEmail,
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: ColorUtils.getColorFromHex('#010A53'),
                        decoration: InputDecoration(
                          labelText: 'E-mail *',
                          prefixIcon: Icon(
                            Icons.email,
                            color: ColorUtils.getColorFromHex('#010A53')
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Colors.grey)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: ColorUtils.getColorFromHex('#010A53'))
                          )
                        ),
                      ),

                      Padding(padding: EdgeInsets.only(top: 16)),

                      TextField(
                        controller: _controllerSenha,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: true,
                        cursorColor: ColorUtils.getColorFromHex('#010A53'),
                        decoration: InputDecoration(
                          labelText: 'Senha *',
                          prefixIcon: Icon(
                            Icons.vpn_key,
                            color: ColorUtils.getColorFromHex('#010A53')
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Colors.grey)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: ColorUtils.getColorFromHex('#010A53'))
                          )
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 16),
                        child: FlatButton(
                          height: 50,
                          color: ColorUtils.getColorFromHex('#010A53'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white
                            )
                          ),
                          onPressed: _doLogin,
                        ),
                      ),

                      FlatButton(
                        minWidth: double.infinity,
                        height: 50,
                        onPressed: _doLoginFacebook, 
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: ColorUtils.getColorFromHex('#010A53'),
                            width: 1,
                            style: BorderStyle.solid
                          ),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Text(
                          'Entrar com Facebook',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: ColorUtils.getColorFromHex('#010A53')
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
                                color: ColorUtils.getColorFromHex('#010A53')
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
                  ),
                ),

              ],
            )
          ),
        )
      ),
    );
  }
}

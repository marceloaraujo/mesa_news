import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mesa_news/api/LoginApi.dart';
import 'package:mesa_news/api/MesaResponse.dart';
import 'package:mesa_news/screens/news/NewsPage.dart';
import 'package:mesa_news/utils/ColorUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';



class NewUserPage extends StatefulWidget {
  @override
  _NewUserPageState createState() => _NewUserPageState();
}

class _NewUserPageState extends State<NewUserPage> {

  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPass = TextEditingController();
  TextEditingController _controllerConfirmPass = TextEditingController();
  TextEditingController _controllerDate = TextEditingController();

  DateTime _selectedDate;

  showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 3))
    );
  }

  _validateFields() {
    if(
      _controllerName.text == '' ||
      _controllerEmail.text == '' ||
      _controllerPass.text == '' ||
      _controllerConfirmPass.text == ''
    ) {
      return false;
    }
    return true;
  }

  _validatePassConfirmation() {
    if(_controllerPass.text == _controllerConfirmPass.text) {
      return true;
    } 
    return false;
  }

  _signup() async {
    if(_validateFields()) {
      if(!_validatePassConfirmation()) {
        showSnackbar('A confirmação da senha não bate com a senha fornecida. Por favor, tente novamente.');
        return;
      }
      MesaResponse response = await LoginApi().signup(
        _controllerName.text,
        _controllerEmail.text,
        _controllerPass.text
      );
      if(response.getStatusCode() != 201) {
        showSnackbar(response.getMessage());
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
      showSnackbar('Campos marcados com * são obrigatórios');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar'),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              TextField(
                controller: _controllerName,
                keyboardType: TextInputType.text,
                cursorColor: ColorUtils.getColorFromHex('#010A53'),
                decoration: InputDecoration(
                  labelText: 'Nome *',
                  prefixIcon: Icon(
                    Icons.person,
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
                padding: EdgeInsets.only(top: 20),
                child: TextField(
                  controller: _controllerEmail,
                  keyboardType: TextInputType.text,
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
              ),

              Padding(
                padding: EdgeInsets.only(top: 20),
                child: TextField(
                  controller: _controllerPass,
                  obscureText: true,
                  keyboardType: TextInputType.text,
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
              ),

              Padding(
                padding: EdgeInsets.only(top: 20),
                child: TextField(
                  controller: _controllerConfirmPass,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  cursorColor: ColorUtils.getColorFromHex('#010A53'),
                  decoration: InputDecoration(
                    labelText: 'Confirmar senha *',
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
              ),

              Padding(
                padding: EdgeInsets.only(top: 20),
                child: GestureDetector(
                  onTap: (){
                    showDatePicker(
                      context: context, 
                      initialDate: _selectedDate == null ? DateTime.now() : _selectedDate, 
                      firstDate: DateTime(1970), 
                      lastDate: DateTime(2022)
                    ).then((date)  {
                      setState(() {
                        _selectedDate = date;
                        String formatted = DateFormat('dd/MM/yyyy').format(date);
                        _controllerDate.text = formatted;
                      });
                    });
                  },
                  child: TextField(
                    enabled: false,
                    controller: _controllerDate,
                    keyboardType: TextInputType.text,
                    cursorColor: ColorUtils.getColorFromHex('#010A53'),
                    decoration: InputDecoration(
                      labelText: 'Data de nascimento (opcional)',
                      prefixIcon: Icon(
                        Icons.calendar_today_rounded,
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
                )
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
                    'Cadastrar',
                    style: TextStyle(
                      color: Colors.white
                    )
                  ),
                  onPressed: _signup,
                ),
              ),

            ],


          ),
        ),
      ),
    );
  }
}
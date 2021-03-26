import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:mesa_news/api/MesaResponse.dart';

class LoginApi {

  final String BASE_URL = 'https://mesa-news-api.herokuapp.com';

  Future<MesaResponse> signin(String email, String pass) async {
    Map<String, dynamic> body = Map();
    body['email'] = email;
    body['password'] = pass;

    http.Response response = await http.post(
      '$BASE_URL/v1/client/auth/signin',
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body)
    );

    MesaResponse mResponse = MesaResponse();
    mResponse.setStatusCode(response.statusCode);
    Map<String, dynamic> tokenJson = json.decode(response.body);
    
    if(response.statusCode != 200) {
      mResponse.setData(null);
      mResponse.setCode('INVALID_CREDENTIALS');
      mResponse.setMessage('Credenciais inválidas. Verifique os dados informados e tente novamente.');
    } else {
      mResponse.setData(tokenJson['token']);
      mResponse.setCode('OK');
      mResponse.setMessage('Login efetuado com sucesso!');
    }
    return mResponse;
  }

  Future<MesaResponse> signup(String name, String email, String pass) async {
    Map<String, dynamic> body = Map();
    body['name'] = name;
    body['email'] = email;
    body['password'] = pass;

    http.Response response = await http.post(
      '$BASE_URL/v1/client/auth/signup',
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body)
    );

    MesaResponse mResponse = MesaResponse();
    mResponse.setStatusCode(response.statusCode);
    Map<String, dynamic> tokenJson = json.decode(response.body);
    
    /**
     * Pelo que percebi, o único erro possível aqui é o de 
     * usuário já cadastrado, então vou verificar o status code
     * da requisição. Se for o código diferente de 201,
     * retorno o objeto MesaResponse com a mensagem de que 
     * já existe um usuário cadastrado na base. Se não,
     * retorno o objeto MesaResponse com os dados retornados.
     */
    if(response.statusCode != 201) {
      mResponse.setData(null);
      mResponse.setCode('TAKEN');
      mResponse.setMessage('Já existe um usuário com esse e-mail. Por favor, tente novamente');
    } else {
      mResponse.setData(tokenJson['token']);
      mResponse.setCode('OK');
      mResponse.setMessage('Cadastro efetuado com sucesso!');
    }
    return mResponse;
  }

}
class MesaResponse {

  int _statusCode;
  String _code;
  dynamic _data;
  String _message;

  void setStatusCode(int statusCode) {
    this._statusCode = statusCode;
  }

  int getStatusCode() {
    return _statusCode;
  }

  void setCode(String code) {
    this._code = code;
  }

  String getCode() {
    return _code;
  }

  void setData(dynamic data) {
    this._data = data;
  }

  dynamic getData() {
    return _data;
  }

  void setMessage(String message) {
    this._message = message;
  }

  String getMessage() {
    return _message;
  }

}
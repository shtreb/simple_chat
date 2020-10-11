class Credential {
  String login;
  String password;

  Credential(this.login, this.password);

  factory Credential.fromJson(json) => json == null ?
    null :
    Credential(
      json['login'],
      json['password']
    );

  Map<String, dynamic> get json => {
    'login': login,
    'password': password,
  };
}
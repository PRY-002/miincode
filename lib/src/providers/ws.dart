//   https://miincode.herokuapp.com/api/usuarios/search_email

final String _puerto        = '2800';
//final String _url           = 'http://192.168.1.112:' + _puerto;
//final String _url           = 'http://192.168.0.100:' + _puerto;
final String _url           = 'https://miincode.herokuapp.com';
final String _urlCodigos    = _url + '/api/codigos';
final String _urlUsuarios   = _url + '/api/usuarios';
final String _list          = '/list';
final String _create        = '/create';
final String _update        = '/update';
final String _searchEmail        = '/search';
final String _delete        = '/delete';
final String _user          = '/user';
final String _login          = '/login';

final String urlCodigosListXIdUsuario = _urlCodigos + _list + _user + '/';
final String urlUsuarioXId = _urlUsuarios + _list + _user + '/';
final String urlCodigosListAll = _urlCodigos + _list;
final String urlCodigosCreate =_urlCodigos + _create;
final String urlLogin = _urlUsuarios + _login;
final String urlRegisterUser = _urlUsuarios + _create;
final String urlSearchUserByEmail = _urlUsuarios + _searchEmail + '/';

//  http://localhost:2800/api/codigos/list
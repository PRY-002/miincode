import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';


String _email = '';
final String _url = 'https://miincode.firebaseio.com/';

var logger = Logger( printer: PrettyPrinter() );
var loggerNoStack = Logger( printer: PrettyPrinter(methodCount: 0) );


void main() => runApp(ProductosProvider());

class ProductosProvider extends StatefulWidget{

  @override
  _ProductosProviderState createState() => _ProductosProviderState();
  /*
  Future<bool> crearProducto( ProductoModel  producto) async {
    try {
      final url = '$_url/productos.json';
      final resp = await http.post( url, body: productoModelToJson(producto) );
      final decodedData = json.decode(resp.body);
      return true;      
    } catch (e) {
      logger.w(e.toString());
    }
  }

  Future<bool> editarProducto( ProductoModel producto ) async {
    try {
      final url = '$_url/productos/${ producto.id }.json';
      final resp = await http.put( url, body: productoModelToJson(producto) );
      final decodedData = json.decode(resp.body);
      return true;      
    } catch (e) {
      logger.w(e.toString());
    }
  }

  Future<List<ProductoModel>> cargarProductos() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    final _varEmail = await sp.getString(spEmail);
    UsuarioModel um = new UsuarioModel();

    final url  = '$_url/productos.json';
    final resp = await http.get(url);
    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<ProductoModel> productos = new List();
    
    DatabaseHelper.db.getUsuarioPorEmail(_varEmail).then((_idUsuario){

      if ( decodedData == null ) return [];
      decodedData.forEach( ( id, prod ){
        final prodTemp = ProductoModel.fromJson(prod);
        if ( prodTemp.idUsuario == _idUsuario.id) {
          prodTemp.id = id;
          productos.add( prodTemp );        
        }
      });

    });
    return productos;
  }

  Future<List<ProductoModel>> cargarProductos2(String _email) async {

    try {
      final url  = '$_url/productos.json';
      final resp = await http.get(url);
      final Map<String, dynamic> decodedData = json.decode(resp.body);
      final List<ProductoModel> productos = new List();
    if (resp.statusCode < 200 || resp.statusCode > 400 || json == null) {
        logger.w(throw new Exception("ERROR! El servicio de Firebase presento un error en la conexión: " +resp.statusCode.toString() ));
      }

    int i = 0;
    decodedData.forEach( ( id, prod ){
        final prodTemp = ProductoModel.fromJson(prod);
              productos.add( prodTemp );        
        i = i + 1;      
      });
      return productos;
    } catch (e) {
      logger.w('ERROR {cargarProductos2}' + e.toString());
    }
    
  }

  Future<int> borrarProducto( String id ) async { 
    try {
      final url  = '$_url/productos/$id.json';
      final resp = await http.delete(url);
      return 1;      
    } catch (e) {
      logger.w(e.toString());
    }
  }

  Future<String> subirImagen(File imagen) async {

    try {
      final url = Uri.parse('https://api.cloudinary.com/v1_1/dfdy5e4tt/image/upload?upload_preset=h86ampvf');
      final mimeType = mime(imagen.path).split('/');

      final imageUploadRequest = http.MultipartRequest('POST', url);

      final file = await http.MultipartFile.fromPath('file', 
      imagen.path, contentType: MediaType(mimeType[0], mimeType[1])
      );

      imageUploadRequest.files.add(file);

      final streamResponse = await imageUploadRequest.send();
      final resp = await http.Response.fromStream(streamResponse);

      if ( resp.statusCode != 200 && resp.statusCode != 201) {
        return null;
      } else {
        final respData = json.decode(resp.body);
        return respData['secure_url'];
      }
    } catch (e) {
      logger.w(e.toString());
    }
  }
*/

}

class _ProductosProviderState extends State<ProductosProvider> {
  
    @override
  initState()  {
    super.initState();
    _loadDatos();
  }

  _loadDatos() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
     _email = (sp.getString('spEmail')); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return null;
  }  

}
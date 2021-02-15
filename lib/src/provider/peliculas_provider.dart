
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class PeliculasProvider {

  String _apiKey = '7a4fced1c7975ff60d794d6077d578fb';
  String _url = 'api.themoviedb.org';
  String _languaje = 'es-ES'; 
  
  int _popularesPage = 0;

  bool _cargando = false;

  List<Pelicula> _populares =List();

//el broadcast me sirve para que funcione con varios listener 
//muchos pueden escuchar esto
  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();

//la funcion es lo que tiene que cumplir este metodo para que funcione correctamente
//es decir le decimos que tiene que recibir una lista de peliculas si no que lance error
  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;

  void dispose(){
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async{

      final respuesta =  await http.get( url );
      //if(respuesta.statusCode ==200)
      final decodeData = json.decode(respuesta.body);
      final peliculas = Peliculas.fromJsonList(decodeData['results']);
      return peliculas.items;

  }


  Future<List<Pelicula>> getEncines() async {
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key': _apiKey , 
      'languaje': _languaje
    });
       return await _procesarRespuesta(url);
  }


   Future<List<Pelicula>> getPopular() async {

     if(_cargando) return [];
     _cargando = true;

    _popularesPage++;
    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apiKey , 
      'languaje': _languaje,
      'page': _popularesPage.toString(),
    });

    final resp = await _procesarRespuesta(url);
    _populares.addAll(resp);
    popularesSink(_populares);
    _cargando = false;
    
    return resp;

  }


  Future<List<Actor>> getCast(String peliId) async{

    final url  = Uri.https(_url, '3/movie/$peliId/credits',{
      'api_key': _apiKey , 
      'languaje': _languaje,
    });

    final resp = await http.get(url);

    final decodedData = json.decode(resp.body);

    final cast = new Cast.fromJsonList(decodedData['cast']);

    return cast.actores;

  }

  Future<List<Pelicula>> bucarPelicula(String query) async {
    final url = Uri.https(_url, '3/search/movie', {
      'api_key': _apiKey , 
      'languaje': _languaje,
      'query':query
    });
       return await _procesarRespuesta(url);
  }

}
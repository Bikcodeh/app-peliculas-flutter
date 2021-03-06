import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:peliculas/src/models/actores_model.dart';
import 'dart:convert';
import 'package:peliculas/src/models/pelicula_model.dart';

class PeliculasProvider {

  String _apiKey = '4662e7a7fe13c9d91c80552e10a09dc1';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';
  int _popularesPage = 0;
  List<Pelicula> _populares = new List();
  bool _cargando = false;

  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();

  // para agregar peliculas
  Function(List<Pelicula>) get popularesSink => _popularesStreamController.add;

  //para escuchar esas peliculas
  Stream<List<Pelicula>>get popularesStream => _popularesStreamController.stream;

  void disposeStreams() {
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> _procesarRespuesta( Uri url) async {

    final resp = await http.get( url );
    final decodedData = json.decode(resp.body);
    final peliculas = new Peliculas.fromJsonList(decodedData['results']);

    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key': _apiKey,
      'language': _language
    });

    return await _procesarRespuesta(url);
  }

  Future<List<Pelicula>> getPopulares() async {

    if(_cargando) return[];

    _cargando = true; 

    _popularesPage++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key' : _apiKey,
      'language': _language,
      'page'    :  _popularesPage.toString()
    });

    final resp = await _procesarRespuesta(url);

    _populares.addAll(resp);
    popularesSink( _populares );
    _cargando = false;
    return resp;
  }

  Future<List<Actor>> getCast( String peliId ) async {
    final url = Uri.https(_url, '3/movie/$peliId/credits', {
      'api_key': _apiKey,
      'language': _language
    });

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final cast = new Cast.fromJsonList(decodedData['cast']);

    return cast.actores;
  }

  Future<List<Pelicula>> buscarPelicula(String query) async {
    final url = Uri.https(_url, '3/search/movie', {
      'api_key' : _apiKey,
      'language': _language,
      'query'   : query
    });

    return await _procesarRespuesta(url);
  }

}
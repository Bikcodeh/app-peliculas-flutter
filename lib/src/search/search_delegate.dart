import 'package:flutter/material.dart';

import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class DataSearch extends SearchDelegate {

  final peliculas = [
    'avengers',
    'aquaman',
    'batman',
    'shazam',
    'porky',
    'disney',
  ];

  final peliculasRecientes = [
    'spiderman',
    'capitan america'
  ];

  final peliculasProvider = new PeliculasProvider();

  @override
  List<Widget> buildActions(BuildContext context) {
    // Son las acciones de nuestro appbar,como el de limpiar por ejemplo
    return [
      IconButton(
        icon: Icon(Icons.clear), 
        onPressed: () {
          query = '';
        }
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del appbar, como el de la lupa
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        }
      );
  }

  @override
  Widget buildResults(BuildContext context) {
    // crea los resultados que se van a mostrar
    return null;
  }
/* 
  @override
  Widget buildSuggestions(BuildContext context) {
    // las sugerencias que aparecen cuando la persona escribe

    final listaSugerida = ( query.isEmpty ) 
                            ? peliculasRecientes
                            : peliculas.where((p) => p.toLowerCase().startsWith(query.toLowerCase())
                            ).toList();


    return ListView.builder(
      itemCount: listaSugerida.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.movie),
          title: Text(listaSugerida[index]),
          onTap: () {}
        );
      }
    ); 
  } */

  
  @override
  Widget buildSuggestions(BuildContext context) {
    // las sugerencias que aparecen cuando la persona escribe
    if ( query.isEmpty ) {
      return Container();
    }

    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if( snapshot.hasData ) {

          final peliculas = snapshot.data;
          return ListView(
            children: 
              peliculas.map((pelicula) {
                return ListTile(
                  leading: FadeInImage(
                    image: NetworkImage(pelicula.getPosterImg()),
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    width: 50.0,
                    fit: BoxFit.cover,
                  ),
                  title: Text(pelicula.title),
                  subtitle: Text(pelicula.originalTitle),
                  onTap: () {
                    close(context, null);
                    pelicula.uniqueId = '';
                    Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                  },
                );
              }).toList(),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

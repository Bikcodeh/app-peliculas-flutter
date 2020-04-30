import 'package:flutter/material.dart';

class DataSearch extends SearchDelegate {
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
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // las sugerencias que aparecen cuando la persona escribe
    return Container();
  }
}

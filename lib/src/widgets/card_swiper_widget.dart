import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class CardSwiper extends StatelessWidget {
  final List<Pelicula> listaItems;

  CardSwiper({@required this.listaItems});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: new Swiper(
        layout: SwiperLayout.STACK,
        itemWidth: _screenSize.width * 0.7,
        itemHeight: _screenSize.height * 0.5,
        itemBuilder: (BuildContext context, int index) {

          listaItems[index].uniqueId = '${listaItems[index].id}-tarjeta';

          return Hero(
            tag: listaItems[index].uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: GestureDetector(
                onTap:  () => Navigator.pushNamed(context, 'detalle', arguments: listaItems[index]),
                              child: FadeInImage(
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    image: NetworkImage(listaItems[index].getPosterImg()),
                    fit: BoxFit.fill),
              ),
            ),
          );
        },
        itemCount: listaItems.length,
        // pagination: new SwiperPagination(),
        // control: new SwiperControl(),
      ),
    );
  }
}

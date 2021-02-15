import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/models/pelicula_model.dart';


class CardSwiper extends StatelessWidget {

  final List<Pelicula> peliculas ;

  CardSwiper({ @required this.peliculas });

  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size; // esto me trae el tamaño de la pantalla del dispositivo

    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Swiper( //tenemos que meter el swiper dentro de un contenedor para que no nos de errores despues ya que no sabe sus dimensiones que indicamos en el contendor
          layout: SwiperLayout.STACK,
          itemWidth: _screenSize.width * 0.7,//usa el 70 % de la pantalla
          itemHeight: _screenSize.height * 0.5,
          itemBuilder: (BuildContext context,int index){
            
            peliculas[index].uniqueId = '${peliculas[index].id}-tarjeta';
            
            return Hero(
              tag: peliculas[index].uniqueId,
                          child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, 'detalle',arguments: peliculas[index]);
                    },
                    child: FadeInImage(
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    image: NetworkImage( peliculas[index].getPosterImg()),
                    fit: BoxFit.cover,
                    ),
                ),
              ),
            );
            
          },
          itemCount: 10,
          //pagination: new SwiperPagination(), //esto me indica con puntitos el numero de paginas que tengo
         //control: new SwiperControl(),// esta es una flechita que me indica que puedo pasar a la otra pagina
        ),
    );


  }
}

/*

RUTAS QUE NECESITO SI O SI LUEGO
//IMAGENES DE PRUEBA
https://image.tmdb.org/t/p/w500/jIIjsExCEv6lsfQGHTXDPk3Q0M5.jpg

//ENDPOINT
https://api.themoviedb.org/3/movie/now_playing?api_key=7a4fced1c7975ff60d794d6077d578fb&language=es-ES&page=1

//BUSCA RUTAS
https://developers.themoviedb.org/3/movies/get-now-playing


*/
import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {

  final _pageController = new PageController(
          initialPage: 1,
          viewportFraction: 0.3
  );

  final Function siguientePagina;

  final List<Pelicula> peliculas;

  MovieHorizontal({@required this.peliculas , @required this.siguientePagina});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    
    _pageController.addListener(() { 

      if(_pageController.position.pixels >= _pageController.position.maxScrollExtent - 200)
      siguientePagina();
    });

      return Container(
      height: _screenSize.height * 0.2,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
       // children:_tarjetas(context),
       itemCount: peliculas.length,
        itemBuilder: (context, i) {



          return _tarjeta(context, peliculas[i]) ;
        },
      ),
    );

  }

  Widget _tarjeta(BuildContext context , Pelicula pelicula){

    pelicula.uniqueId = '${pelicula.id }-poster';

     final  tarjeta = Container(
      margin: EdgeInsets.only(right: 15),
      child: Column(
        children: [
          Hero(
            tag: pelicula.uniqueId,
                      child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
                        child: FadeInImage(
                placeholder: AssetImage('assets/img/no-image.jpg'),
                image: NetworkImage(pelicula.getPosterImg()),
                fit: BoxFit.cover,
                height: 130,
                ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(pelicula.title,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );

    return GestureDetector(
      child: tarjeta,
      onTap: (){
        //mandamos todos los detalles de la pelicula en arguments
          Navigator.pushNamed(context, 'detalle' ,arguments: pelicula);
      },
    );
  }

//esta no se esta usando
List<Widget> _tarjetas(BuildContext context){

  return peliculas.map((pelicula){

    return Container(
      margin: EdgeInsets.only(right: 15),
      child: Column(
        children: [
          ClipRRect(
          borderRadius: BorderRadius.circular(20),
           child: FadeInImage(
            placeholder: AssetImage('assets/img/no-image.jpg'),
            image: NetworkImage(pelicula.getPosterImg()),
            fit: BoxFit.cover,
            height: 130,
            ),
            ),
          SizedBox(
            height: 5,
          ),
          Text(pelicula.title,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );

  }).toList();

}
}

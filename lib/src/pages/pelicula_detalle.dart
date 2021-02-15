import 'dart:math';

import 'package:flutter/material.dart';
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/provider/peliculas_provider.dart';

class PeliculaDetalle extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _crearAppbar(pelicula),
          SliverList(delegate: SliverChildListDelegate(
            [
              SizedBox(height: 10,),
              _posterTitulo(pelicula , context),
              _descripcion(pelicula),
              _descripcion(pelicula),
              _descripcion(pelicula),
              _descripcion(pelicula),
              _descripcion(pelicula),
              _descripcion(pelicula),
              _crearCasting(pelicula),
            ]
          ),)
        ],
      ),
    );
}
  Widget _crearAppbar(Pelicula pelicula){
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(pelicula.title ,
        style: TextStyle(color: Colors.white , fontSize: 16.0),),
        background: FadeInImage(
          image: NetworkImage(pelicula.getBackgroundImg(),), 
          placeholder: AssetImage('assets/img/loading.gif'),
          fadeInDuration: Duration(seconds: 1),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitulo(Pelicula pelicula ,BuildContext context){


    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(image: NetworkImage(pelicula.getPosterImg()) ,height: 150,)),
          ),
          SizedBox(width :20.0),
          Flexible(
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pelicula.title , style: Theme.of(context).textTheme.headline6 , overflow: TextOverflow.ellipsis,),
                Text(pelicula.originalTitle  ,style: Theme.of(context).textTheme.subtitle1, overflow: TextOverflow.ellipsis,),
                Row(
                  children: [
                    Icon(Icons.star_border),
                    Text(pelicula.voteAverage.toString(),style: Theme.of(context).textTheme.subtitle1)
                  ],
                )
              ],
              ) )
        ],
      ),
    );
  }

  Widget _descripcion(Pelicula pelicula){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10 , vertical: 20),
      child: Text(pelicula.overview,
      textAlign: TextAlign.justify,),
    );
  }

  Widget _crearCasting(Pelicula pelicula){

    final peliProvider = new PeliculasProvider();

    return FutureBuilder(
      future: peliProvider.getCast(pelicula.id.toString()),
      builder: ( context, AsyncSnapshot<List> snapshot) {

        if(snapshot.hasData){
          return _crearActoresPageView(snapshot.data);
        }else{
          return Center(child: CircularProgressIndicator());
        }

      },
    );

  }

  Widget _crearActoresPageView(List<Actor> actores){
    return SizedBox(height: 200,
    child: PageView.builder(
      pageSnapping: false,
      controller: PageController(
        viewportFraction: 0.3,
        initialPage: 1,
      ),
      itemCount: actores.length,
      itemBuilder: (context, index) => _actorTarjeta(actores[index]),
      ),
    );
  }

  Widget _actorTarjeta(Actor actor){

    return Container(
      child: Column(
        children :[
          ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
              placeholder: AssetImage('assets/img/no-image.jpg'), 
              image: NetworkImage(actor.getFoto(),),
              height: 150.0,
              fit:BoxFit.cover ,
              ),
          ),
          Text(actor.name , overflow: TextOverflow.ellipsis,)
        ]
      ),
    );

  }

}

/*

    final  aleatorio = new Random();

codigo para probar que funcionaba todo bien

  List<Color> colores = [
      Colors.black,
      Colors.green,
      Colors.yellow,
      Colors.blueAccent,
      Colors.white,
      Colors.brown,
      Colors.greenAccent
    ];

final List<Widget> items = List.generate(100, (index) => Container(
      width: double.infinity , height: 200,color: colores[aleatorio.nextInt(this.colores.length)],
    ));


 SliverList(delegate: SliverChildListDelegate(items),)
 */
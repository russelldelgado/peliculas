import 'package:flutter/material.dart';
import 'package:peliculas/src/provider/peliculas_provider.dart';
import 'package:peliculas/src/search/search_delegate.dart';

import 'package:peliculas/src/widgets/card_swiper_widget.dart';
import 'package:peliculas/src/widgets/movie_orizontal.dart';

class HomePage extends StatelessWidget {
    final peliculasProvider = PeliculasProvider();


  @override
  Widget build(BuildContext context) {

    peliculasProvider.getPopular();

    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('PELICULAS EN CINES'), 
          backgroundColor: Colors.indigoAccent,
          actions: [
            IconButton(
              icon: Icon( Icons.search),
              onPressed: (){
                showSearch(context: context , delegate: DataSearch(),
                //query:'hola' 
                );
              },
              )
          ],
          ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _swiperTarjetas(),
              _footer(context),
            ],
          ),
        )
      ),
    );
  }

  Widget _swiperTarjetas(){

    return FutureBuilder(
      future: peliculasProvider.getEncines(),
      builder: (context,AsyncSnapshot<List> snapshot) {

        if(snapshot.hasData)
        return CardSwiper( peliculas: snapshot.data );
        else return Container(
          height: 400,
          child: Center( 
            child: CircularProgressIndicator()
            )
          );
    },);

  }
  Widget _footer(BuildContext context){
    return Container(
      width: double.infinity,

      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 20),
            child: Text('POPULARES' , style : Theme.of(context).textTheme.subtitle1,)),
          SizedBox(height: 10,),

          StreamBuilder(
            stream: peliculasProvider.popularesStream,
            builder: (context, AsyncSnapshot<List> snapshot) {
             return (snapshot.hasData) ? MovieHorizontal(peliculas: snapshot.data, 
               siguientePagina: (){
               peliculasProvider.getPopular();
             },) : Center(child: CircularProgressIndicator(),);
            },
            
            )
        ],
      ) ,
    );
  }
}
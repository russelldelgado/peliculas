import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/provider/peliculas_provider.dart';

class DataSearch extends SearchDelegate {

  final peliculasProvider = new PeliculasProvider();

  final peliculas = [
    'spierman',
    'aquaman',
    'batmane',
    'shazam',
    'irom man',
    'catipan america 2',
    'catipan america 3 ',
    'catipan america 4',
    'iron man 2'
  ];


  final peliculasRecientes = [
    'spiderman' , 'capitan america'
  ];


  String seleccion = '';


  @override
  List<Widget> buildActions(BuildContext context) {
    //acciones de nuestro appbar
    return [
      IconButton(
        icon: Icon(Icons.clear), 
        onPressed: () {
          print('CLICK!!!');
          //todo lo que la persona escriba esta en una variable interna llamada query
          query='';
        },)
    ];
    }
  
    @override
    Widget buildLeading(BuildContext context) {
      return IconButton(
        icon: AnimatedIcon(
          progress:transitionAnimation ,
          icon: AnimatedIcons.menu_arrow,
        ), 
        onPressed: () {
          print('leading Icons');
          close(context, null);
        },);
    }
  
    @override
    Widget buildResults(BuildContext context) {
      // builder que crea los resultado que vamos a mostrar
      return Center(child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.yellow,
        child: Text(seleccion),
      ));
      
    }
  
    @override
    Widget buildSuggestions(BuildContext context) {
    // muestra las sugerencias que aparecen cuando la persona escribe

    if(query.isEmpty)return Container();


    return FutureBuilder(
      future: peliculasProvider.bucarPelicula(query),
      builder: (context, AsyncSnapshot<List<Pelicula>> snapshot) {
        
        if(snapshot.hasData){

          final peliculas = snapshot.data;

          return ListView(

            children: peliculas.map((pelicula){
              return ListTile(
                  leading: FadeInImage(
                    image: NetworkImage(pelicula.getBackgroundImg()),
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    width: 50,
                    fit: BoxFit.cover,
                    
                  ),
                  title: Text(pelicula.title),
                  subtitle: Text(pelicula.originalTitle),
                  onTap: () {
                    close(context, null);
                    pelicula.uniqueId = '';
                    Navigator.pushNamed(context,'detalle', arguments: pelicula);
                  },
              );
            }).toList(),
            
          ) ;
        }else{
          return Center(child: CircularProgressIndicator());
        }

      },);
  }

}

/*



    final listaSugerida = (query.isEmpty) 
                            ? peliculasRecientes
                            : peliculas.where((p) =>
                              p.toLowerCase().startsWith(query.toLowerCase())
                              ).toList();


      return ListView.builder(
        itemCount: listaSugerida.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.movie),
            title: Text(listaSugerida[index]),
            onTap: (){
              seleccion = listaSugerida[index];
              //showResults(context); no vamos a trabajr con este pero esto serive para llamar a los resultado que es el metodo de arriba
            },
          );
        },
      );

 */
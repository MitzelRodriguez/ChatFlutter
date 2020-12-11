import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final String ruta;

  const Labels({
    Key key,
    @required this.ruta,
    @required this.titulo,
    @required this.subtitulo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          this.titulo,
          style: TextStyle(
            color: Colors.black54,
            fontSize: 15,
            fontWeight: FontWeight.w300,
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        GestureDetector(
          child: Text(
            this.subtitulo,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {
            Navigator.pushReplacementNamed(context, this.ruta);
          },
        ),
      ],
    );
  }
}

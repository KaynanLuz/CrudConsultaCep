
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class TelaListagem extends StatelessWidget {
  final List<String> dados; // Você pode ajustar o tipo de dados conforme necessário

  TelaListagem(this.dados);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listagem de Dados'),
      ),
      body: ListView.builder(
        itemCount: dados.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(dados[index]),
          );
        },
      ),
    );
  }
}







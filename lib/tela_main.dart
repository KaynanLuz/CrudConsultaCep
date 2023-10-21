import 'package:crud_cep/main.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configurar as chaves e a URL do Back4App
  final keyApplicationId = 'i9SaQVN2XKpzimQex5sPpyq3mL9iesk5gvEOcEDL';
  final keyClientKey = 'kS6jesKhCKGV4ay857JKfqMnHCwvz79MILi9DF3O';
  final keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);

  runApp(MaterialApp(
    home: TelaPrincipal(),
    debugShowCheckedModeBanner: false,
    
  ));
}

class TelaPrincipal extends StatefulWidget {
  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  final _idController = TextEditingController();

  void _pesquisarCEP() async {
    final id = _idController.text;

    // Realize a pesquisa no Back4App com base no ID
    final query = QueryBuilder(ParseObject('CEP'))..whereEqualTo('objectId', id);
    final response = await query.query();

    if (response.success && response.results != null && response.results!.isNotEmpty) {
      final cepObject = response.results![0];
      final rua = cepObject['rua'];
      final numero = cepObject['numero'];
      final bairro = cepObject['bairro'];

      final valorPesquisado = 'Rua: $rua, Número: $numero, Bairro: $bairro';

      // Navegue para a tela de detalhes com o valor pesquisado
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TelaDetalhes(valorPesquisado),
        ),
      );
    } else {
      // ID não encontrado
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('ID de Endereço não encontrado'),
            content: Text('Não foi possível encontrar o endereço com o ID fornecido. Cadastre um endereço novo.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tela Principal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _idController,
              decoration: InputDecoration(labelText: 'ID do Valor'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pesquisarCEP,
              child: Text('Pesquisar'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: (){
                Navigator.push(context,
              MaterialPageRoute(
                builder: (builder) => MyApp(),
                ),
              );
            }, child: Text('Novo'),
            )
          ],
        ),
      ),
    );          
  }
}

class TelaDetalhes extends StatelessWidget {
  final String valorPesquisado;

  TelaDetalhes(this.valorPesquisado);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Pesquisa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Valor Pesquisado:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              valorPesquisado,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



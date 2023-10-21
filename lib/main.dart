import 'package:crud_cep/tela_listagem.dart';
import 'package:crud_cep/tela_main.dart';
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
    // Iniciar o aplicativo na tela principal
  ));
}

class MyApp extends StatelessWidget {
  final _ruaController = TextEditingController();
  final _numeroController = TextEditingController();
  final _bairroController = TextEditingController();

  void _cadastrarNoBack4App() async {
    final rua = _ruaController.text;
    final numero = _numeroController.text;
    final bairro = _bairroController.text;

    // Certifique-se de substituir 'CEP' pelo nome correto da classe no Back4App
    final cepObject = ParseObject('CEP')
      ..set('rua', rua)
      ..set('numero', numero)
      ..set('bairro', bairro);

    final response = await cepObject.save();

    if (response.success) {
      print('Cadastro no Back4App bem-sucedido!');
      // Limpar os campos após o cadastro
      _ruaController.clear();
      _numeroController.clear();
      _bairroController.clear();
    } else {
      print('Erro ao cadastrar no Back4App: ${response.error!.message}');
    }
  }

  Future<List<String>> _listarNoBack4App(BuildContext context) async {
  final query = QueryBuilder(ParseObject('CEP'));
  final response = await query.query();

  if (response.success && response.results != null) {
    final dados = response.results!
        .map((cepObject) {
          final rua = cepObject.get<String>('rua');
          final numero = cepObject.get<String>('numero');
          final bairro = cepObject.get<String>('bairro');
          return 'Rua: $rua, Número: $numero, Bairro: $bairro';
        })
        .toList();

    return dados;
  } else {
    print('Erro ao listar no Back4App: ${response.error!.message}');
    return []; // Retorna uma lista vazia em caso de erro
  }
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Cadastro de CEP'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _ruaController,
                decoration: InputDecoration(labelText: 'Rua'),
              ),
              TextField(
                controller: _numeroController,
                decoration: InputDecoration(labelText: 'Número'),
              ),
              TextField(
                controller: _bairroController,
                decoration: InputDecoration(labelText: 'Bairro'),
              ),
              SizedBox(height: 20),
              Row(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: _cadastrarNoBack4App,
                    child: Text('Cadastrar'),
                  ),
                
                 SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () async {
                    final dadosDoBanco = await _listarNoBack4App(context);
                    Navigator.push(context,
                    MaterialPageRoute(
                builder: (context) => TelaListagem(dadosDoBanco),
                ),
              );
            }, child: Text('Listar'),
            )
                ],
              ),
              // Adicione aqui um widget para exibir os dados listados
            ],
          ),
        ),
      ),
    );
  }
}

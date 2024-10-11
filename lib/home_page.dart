import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'product_add_screen.dart'; // Certifique-se de ter criado este arquivo

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<dynamic> _data = []; // Para armazenar os dados recebidos da API
  bool _isLoading = true; // Para controlar o carregamento

  @override
  void initState() {
    super.initState();
    _fetchData(); // Chama a função para buscar os dados ao iniciar
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true; // Indica que a requisição está em andamento
    });

    try {
      final response = await http.get(Uri.parse(
          'http://10.14.6.86:5000/produtos')); // Certifique-se de que o IP está correto

      if (response.statusCode == 200) {
        List<dynamic> produtos = json.decode(response.body);
        setState(() {
          _data = produtos; // Atualiza a lista de produtos
          _isLoading = false; // Para o carregamento após sucesso
        });
      } else {
        throw Exception('Erro ao carregar produtos: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showAddProductDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductAddScreen()),
    ).then((result) {
      if (result == true) {
        _fetchData(); // Atualiza a lista de produtos após adicionar um novo produto
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dados da API'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed:
                  _showAddProductDialog, // Exibe a tela para adicionar um novo produto
              child: Text('Adicionar novo produto'), // Altera o texto do botão
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(
                    child:
                        CircularProgressIndicator(), // Indicador de carregamento
                  )
                : ListView.builder(
                    itemCount: _data.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                            _data[index]['nome']), // Exibe o nome do produto
                        subtitle: Text(_data[index]['preco']
                            .toString()), // Exibe o preço do produto
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

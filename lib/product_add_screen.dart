import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductAddScreen extends StatefulWidget {
  @override
  _ProductAddScreenState createState() => _ProductAddScreenState();
}

class _ProductAddScreenState extends State<ProductAddScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  bool _isLoading = false;

  Future<void> _saveProduct() async {
    final String name = nameController.text;
    final String price = priceController.text;

    if (name.isEmpty || price.isEmpty) {
      // Validação simples para garantir que os campos não estão vazios
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos!')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Substitui a vírgula por ponto para permitir valores decimais
      final String formattedPrice = price.replaceAll(',', '.');

      final response = await http.post(
        Uri.parse('http://10.14.6.86:5000/produtos'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nome': name,
          'preco': double.parse(formattedPrice), // Converte o preço para double
        }),
      );

      if (response.statusCode == 201) {
        // Produto cadastrado com sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Produto cadastrado com sucesso!')),
        );
        nameController.clear();
        priceController.clear();

        // Retorna para a tela anterior e indica que o produto foi salvo
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar produto!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nome do Produto',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: priceController,
              decoration: InputDecoration(
                labelText: 'Preço',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _saveProduct,
                    child: Text('Salvar'),
                  ),
          ],
        ),
      ),
    );
  }
}

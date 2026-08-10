import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(MaterialApp(home: Calculatrice()));
}

class Calculatrice extends StatefulWidget {
  @override
  State<Calculatrice> createState() => _CalculatriceState();
}

class _CalculatriceState extends State<Calculatrice> {
  static const List<List<String>> touches = [
    ['7', '8', '9', '/'],
    ['4', '5', '6', '*'],
    ['1', '2', '3', '-'],
    ['0', '.', '=', '+'],
    ['AC', 'C'],
  ];

  final _expr = TextEditingController(text: '0');
  final _res = TextEditingController(text: '0');

  @override
  void dispose() {
    _expr.dispose();
    _res.dispose();
    super.dispose();
  }

  void _appuyer(String touche) {
    debugPrint(touche);
    if (touche == 'AC') {
      _expr.text = '0';
      _res.text = '0';
    } else if (touche == 'C') {
      _supprimerDernier();
    } else if (touche == '=') {
      _res.text = _evaluer(_expr.text);
    } else {
      _ajouter(touche);
    }
  }

  void _ajouter(String touche) {
    if (_expr.text == '0' && touche != '.') {
      _expr.text = touche;
    } else {
      _expr.text += touche;
    }
  }

  void _supprimerDernier() {
    if (_expr.text.length <= 1) {
      _expr.text = '0';
    } else {
      _expr.text = _expr.text.substring(0, _expr.text.length - 1);
    }
  }

  String _evaluer(String texte) {
    try {
      final valeur = RealEvaluator().evaluate(
        ShuntingYardParser().parse(texte),
      );
      if (!valeur.isFinite) {
        return 'Error';
      }
      return _formater(valeur);
    } catch (_) {
      return 'Error';
    }
  }

  String _formater(num valeur) {
    if (valeur == valeur.truncateToDouble() && valeur.abs() < 1e21) {
      return valeur.toStringAsFixed(0);
    }
    return valeur.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calculator')),
      body: Column(
        children: [
          TextField(
            readOnly: true,
            textAlign: TextAlign.right,
            controller: _expr,
          ),
          TextField(
            readOnly: true,
            textAlign: TextAlign.right,
            controller: _res,
          ),
          for (final ligne in touches)
            Expanded(
              child: Row(
                children: [
                  for (final touche in ligne)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _appuyer(touche),
                        child: Text(touche),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

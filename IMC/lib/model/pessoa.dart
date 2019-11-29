import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Pessoa{

  static const _masculino = 1;
  static const _feminino = 2;

  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  int genero; // (1) Masculino | (2) Feminino

  Color color;
  String imcText;
  String imcSituationText;

  Pessoa(){
    imcText = '-';
    weightController.text = '';
    heightController.text = '';
    
    imcSituationText = 'Informe os dados';
    color = Colors.blueAccent;
    genero = null;
  }

  void calculateImc() {

    double weight = double.parse(weightController.text);
    double height = double.parse(heightController.text) / 100.0;
    double imc = weight / (height * height);


    imcText = "IMC = ${imc.toStringAsPrecision(2)}\n";

    if(genero == _masculino){
      imcMasculino(imc);
    }
    else if(genero == _feminino){
      imcFeminino(imc);
    }
    else{ 
      imcText = '-';
      imcSituationText = "Genero Não definido";
    }
  }

  void imcMasculino(double imc){

    if (imc < 20.7){
      color = Colors.blue[300];
      imcSituationText = "Abaixo do peso";
    }
    else if (imc <= 26.4){
      color = Colors.green[300];
      imcSituationText = "Peso ideal";
    }
    else if (imc <= 27.8){
      color = Colors.orange[300];
      imcSituationText = "Levemente acima do peso";
    }
    else if (imc <= 31.1){
      color = Colors.orange[800];
      imcSituationText = "Acima do peso";
    }
  else{
      color = Colors.red[300];
      imcSituationText = "Obesidade"; 
    }
  }

  void imcFeminino(double imc){
    if (imc < 19.1){
      color = Colors.blue[300];
      imcSituationText = "Abaixo do peso";
    }
    else if (imc <= 25.8){
      color = Colors.green[300];
      imcSituationText = "Peso ideal";
    }
    else if (imc <= 27.3)
    {
      color = Colors.orange[300];
      imcSituationText = "Levemente acima do peso";
    }
    else if (imc <= 32.3){
      color = Colors.orange[800];
      imcSituationText = "Acima do peso";
    }
    else{
      color = Colors.red[300];
      imcSituationText = "Obesidade";
    }
  }
}
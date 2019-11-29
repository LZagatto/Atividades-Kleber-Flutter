import 'package:roguelike/mundo.dart';
import 'package:roguelike/personagem.dart';
import 'package:roguelike/ponto_2d.dart';

class Carneiro extends Personagem{

  static final String SIMBOLO_CRIATURA = "C";

  // Construtor
  Carneiro(Ponto2D posicao, String simbolo) : super(posicao, simbolo);

  @override
  void atualizar(Mundo mundo) {
    
    // Mover na direção oposta do jogador
    // O carneiro anda na diagonal sim! hehehe
    mover(mundo, comparaPosicao(mundo.jogador.posicao.x, posicao.x),comparaPosicao(mundo.jogador.posicao.y, posicao.y ));
  }

  int comparaPosicao(int posicaoJogador, int posicaoLobo){
    if(posicaoJogador - posicaoLobo > 0 ){
      return -1;
    }
    else if(posicaoJogador - posicaoLobo < 0 ){
      return 1;
    }
    else{ // se não, é igual
      return 0;
    }
  } 
}
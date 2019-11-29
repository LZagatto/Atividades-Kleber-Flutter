import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marcador_truco/models/player.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _playerOne = new Player(name: 'Nós', score: 0, victories: 0);
  var _playerTwo = new Player(name: 'Eles', score: 0, victories: 0);
  final _nameController = TextEditingController();

  void _resetScore(Player player, bool resetVictories) {
    setState(() {
      player.score = 0;
      player.victories = resetVictories ? 0 : player.victories;
    });
  }

  void _resetPlayers(bool resetVictories) {
    _resetScore(_playerOne, resetVictories);
    _resetScore(_playerTwo, resetVictories);
  }

  @override
  void initState() {
    super.initState();
    _resetPlayers(true);
  }

  Widget _buildBoardPlayers(){
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _buildBoardPlayer(_playerOne),
        _buildBoardPlayer(_playerTwo),
      ],
    );
  }

  Widget _buildBoardPlayer(Player player){
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _showPlayerName(player),
          _showPlayerScore(player.score),
          _showPlayerVictories(player.victories),
          _showScoreButtons(player)
        ],
        ),
    );
  }

  Widget _showPlayerName(Player player) {
    return FlatButton(
      child: new Text(
        player.name,
        style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.w500,
            color: Colors.deepOrange)
      ),
      onPressed: (){
        _buildNameDialog(player);
      },
    );
  }

  void _buildNameDialog(Player player){

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context){
        return SingleChildScrollView(
          child: AlertDialog(
            title: Text("Insira o nome"),
            content: 
              Column(
                children: <Widget>[
                  _buildtextField(controller:_nameController, labelText: "Nome", validatorMessage: "msg"),
                ],
            ),
            actions: <Widget>[
              _buildCancelButton(),
              _buildConfirmButton(action: (){ _setPlayerName(player); }, title: Text("OK")),
            ],
          ),
        );
      }
    );
  }

  Widget _buildtextField({TextEditingController controller, String labelText, String validatorMessage}){

    controller.clear();
    return 
      TextFormField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        controller: controller,
        decoration: InputDecoration(labelText: labelText),
        autofocus: true,
        validator: (text) {
          return text.isEmpty ? validatorMessage : null;
        }
      ); 
  }

  Widget _showPlayerScore(int score){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 52.00),
      child: Text("$score", style: TextStyle(fontSize: 120.0),)
    );
  }

  Widget _showPlayerVictories(int victories){
    return Text("vitórias ($victories)",
    style: TextStyle(fontWeight: FontWeight.w300));
  }

  Widget _showScoreButtons(Player player){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
          _buildRoundedButton(
            label: '-1',
            color: Colors.black.withOpacity(0.1),
            onTap: (){
              setState(() {
                if(player.score > 0){
                  player.score--;
                }
              });
            }
          ),
          _buildRoundedButton(
            label: '+1',
            color: Colors.deepOrange,
            onTap: (){
              setState(() {
                if(player.score < 12){
                  player.score++;
                }
              });
              if(player.score == 12){
                _showDialog(
                  title: 'Fim de Jogo',
                  message: '${player.name} ganhou!',
                  actions: <Widget>[
                    _buildConfirmButton(action: (){ setState(() { player.score--; });}, title: Text("Cancelar") ),
                    _buildConfirmButton(action: (){ setState(() { player.victories++; }); _resetPlayers(false);}, title: Text("Ok") ),
                  ],
                );
              }
              else if(_playerOne.score == 11 && _playerTwo.score == 11){
                _showDialog(
                  title: 'Mão de Ferro!',
                  message: 'Todos os jogadores recebem as cartas “cobertas”, deverão jogar com elas viradas para baixo.',
                  actions: <Widget>[
                    _buildConfirmButton(action:(){}, title: Text("Ok") )
                  ],
                );
              }
            }
          )
      ],
    );
  }

  Widget _buildRoundedButton({String label, Color color, Function onTap, double size = 52.0}){

    return GestureDetector(
      onTap: onTap,
      child: ClipOval(
        child: Container(
          height: size,
          width: size,
          color: color,
          child: Center(
            child: Text(label, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog({String title, String message, List<Widget> actions}){

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text(title ?? ""),
          content: Text(message ?? ""),
          actions: actions,
        );
      }
    );
  }

  Widget _buildCancelButton(){
    return
    FlatButton(
      child: Text("Cancelar"),
      onPressed: (){
        Navigator.of(context).pop();
      }
    );
  }

  Widget _buildConfirmButton({Function action, Text title}){
    return FlatButton(
      child: title,
      onPressed: (){
        setState(() {
          action();
          Navigator.of(context).pop();
        });
      },
    );
  }

  void _setPlayerName(Player player){
    player.name = _nameController.value.text == "" ? player.name : _nameController.value.text;
  }

  Widget _buildAppBar(){
    return AppBar(
      title: Text('Marcador de Truco'),
      actions: <Widget>[
        IconButton(
          onPressed: (){
            _showDialog(
              title: 'Fim :)',
              message: 'Deseja encerrar a partida ou o jogo?',
              actions: 
              <Widget>[
                _buildCancelButton(),
                _buildConfirmButton(action: (){ _resetPlayers(false);}, title: Text("Partida") ),
                _buildConfirmButton(action: (){ _resetPlayers(true);}, title: Text("Jogo") ),
              ] 
            );
          },
          icon: Icon(Icons.refresh)
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBoardPlayers()
    ); 
  }
}

import 'package:chatbot/models/chat_message.dart';
import 'package:chatbot/widgets/chat_message_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _messageList = <ChatMessage>[];
  final _controllerText = new TextEditingController();
  DateFormat dateFormat = DateFormat("HH:mm");

  @override
  void dispose() {
    super.dispose();
    _controllerText.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Chatbot'),
      ),
      body: Column(
        children: <Widget>[
          _buildList(),
          Divider(height: 1.0),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildList() {
    return Flexible(
      child: ListView.builder(
        padding: EdgeInsets.all(8.0),
        reverse: true,
        itemBuilder: (_, int index) =>
            ChatMessageListItem(chatMessage: _messageList[index]),
        itemCount: _messageList.length,
      ),
    );
  }

  Future _dialogFlowRequest({String query}) async {
   
    _addMessage(
        name: 'Teste',
        text: 'Escrevendo...',
        type: ChatMessageType.received,
        date: dateFormat.format(DateTime.now()).toString());

    
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/credentials.json").build();
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: "pt-BR");
    AIResponse response = await dialogflow.detectIntent(query);

    
    setState(() {
      _messageList.removeAt(0);
    });

    
    _addMessage(
        name: 'Teste2',
        text: response.getMessage() ?? '',
        type: ChatMessageType.received,
        date:  dateFormat.format(DateTime.now()).toString());
  }

  
  void _sendMessage({String text}) {
    _controllerText.clear();
    _addMessage(name: 'pessoa 1', text: text, type: ChatMessageType.sent, date: dateFormat.format(DateTime.now()).toString());
  }

  
  void _addMessage({String name, String text, ChatMessageType type, String date}) {
    var message = ChatMessage(text: text, name: name, type: type, date: date);
    setState(() {
      _messageList.insert(0, message);
    });

    if (type == ChatMessageType.sent) {
      _dialogFlowRequest(query: message.text);
    }
  }

  Widget _buildTextField() {
    return new Flexible(
      child: Container(
        padding: EdgeInsets.all(6.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            border: Border.all(width: 1.0)),
        child: new TextField(
          controller: _controllerText,
          decoration: new InputDecoration.collapsed(
            hintText: "Enviar",
          ),
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    return new Container(
      margin: new EdgeInsets.only(left: 8.0),
      child: new IconButton(
          icon: new Icon(Icons.send, color: Theme.of(context).accentColor),
          onPressed: () {
            if (_controllerText.text.isNotEmpty) {
              _sendMessage(text: _controllerText.text);
            }
          }),
    );
  }

  Widget _buildUserInput() {
    return Container(
      color: Colors.white30,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: new Row(
        children: <Widget>[
          _buildTextField(),
          _buildSendButton(),
        ],
      ),
    );
  }
}

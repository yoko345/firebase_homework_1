import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  TextEditingController chatEditingController = TextEditingController();

  void addChat() async {
    FirebaseFirestore.instance.collection('chats').add({
      'chat': chatEditingController.text,
      'id': widget.userId,
      'date': DateTime.now().toString(),
    });
    chatEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot> (
            stream: FirebaseFirestore.instance.collection('chats').orderBy('date').snapshots(),
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                List<DocumentSnapshot> chatsData = snapshot.data!.docs;
                return Expanded(
                  child: ListView.builder(
                    itemCount: chatsData.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> chatData = chatsData[index].data()! as Map<String, dynamic>;
                      return chatCard(chatData);
                    }
                  ),
                );
              }
            return const Center(
              child: CircularProgressIndicator(),
            );
            }
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: Row(
              children: [
                Flexible(
                  child: SingleChildScrollView(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 10,
                      controller: chatEditingController,
                      decoration: const InputDecoration(border: OutlineInputBorder()),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: IconButton(
                    onPressed: () {
                      addChat();
                    },
                    icon: Icon(Icons.send),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget chatCard(Map<String, dynamic> chatData) {
    Color backgroundCardColor = Colors.white;
    if(widget.userId == chatData['id']) {
      backgroundCardColor = Colors.lightGreenAccent;
    }
    return Card(
      color: backgroundCardColor,
      child: ListTile(
        title: Text(chatData['chat']),
      ),
    );
  }

}

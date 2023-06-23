import 'package:chatapp/Auth/auth_service.dart';
import 'package:chatapp/Screens/chatScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF81B1FA),
        elevation: 0,
        centerTitle: true,
        title:const Text('ChatMate',
          style: TextStyle(
            fontFamily: 'Times New Roman',
            letterSpacing: 2,
            fontStyle: FontStyle.italic
          ),
        ),
        actions: [IconButton(onPressed: signOut, icon: Icon(Icons.logout))],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFFA0B5EB),Color(0xFFC9F0E4)])
        ),
        child: _buildUserList()
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error Fetching Data');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text('Loading....'),);
        }
        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildUserListItem(doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    if (_auth.currentUser!.email != data['email']) {
      return ListTile(
        title: Text(data['email']),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatPage(
                        receiverUserEmail: data['email'],
                        receiverUserID: data['uid'],
                      )));
        },
      );
    } else {
      return Container();
    }
  }
}

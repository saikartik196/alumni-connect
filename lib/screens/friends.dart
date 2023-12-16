import 'package:alumni_connect/constant/gloabalvariable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';

import '../helper/dialogs.dart';
import '../models/chat_user.dart';
import '../api/apis.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  List<Map<String, dynamic>> _list = [];
  final List<Map<String, dynamic>> _searchList = [];

  String yearFilter = 'All';
  String branchFilter = 'All';

  bool _isSearching = false;

  void _makeList(List<QueryDocumentSnapshot<Object?>> users, String yearFilter,
      String branchFilter) {
    _list.clear();

    for (var userDoc in users) {
      var userData = userDoc.data() as Map<String, dynamic>;
      var userEmail = userData['email'] as String;

      var year = userEmail.substring(0, 2);
      var branch = userEmail.substring(2, 5);

      bool matchesYear = yearFilter == 'All' || year == yearFilter.substring(2);
      bool matchesBranch = branchFilter == 'All' ||
          branch == 'b${branchFilter.toLowerCase().substring(0, 2)}';
      print('######');
      print(yearFilter);
      print(branchFilter);

      if (matchesYear && matchesBranch) {
        _list.add(userData);
      }
    }
  }

  void _changeFilter(String newYearFilter, String newBranchFilter) {
    setState(() {
      if (newYearFilter != '') yearFilter = newYearFilter;
      if (newBranchFilter != '') branchFilter = newBranchFilter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Transform.scale(
          scale: 0.6,
          child: SvgPicture.asset('assets/icons/members.svg'),
        ),
        elevation: 0,
        backgroundColor: GlobalVariables.mainColor,
        shape: const Border(
          bottom: BorderSide(
            width: 1,
            color: GlobalVariables.secondaryColor,
          ),
          top: BorderSide(
            width: 1,
            color: GlobalVariables.secondaryColor,
          ),
        ),
        title: _isSearching
            ? TextField(
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'Name, Email, ...'),
                autofocus: true,
                style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
                //when search text changes then updated search list
                onChanged: (val) {
                  //search logic
                  _searchList.clear();

                  for (var i in _list) {
                    if (i['name'].toLowerCase().contains(val.toLowerCase()) ||
                        i['email'].toLowerCase().contains(val.toLowerCase())) {
                      _searchList.add(i);
                      setState(() {
                        _searchList;
                      });
                    }
                  }
                },
              )
            : const Text(
                'Friends',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
        actions: [
          //search user button
          IconButton(
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                });
              },
              icon: Icon(
                  _isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search,
                  color: Colors.white)),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      backgroundColor: GlobalVariables.secondaryColor,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final users = snapshot.data!.docs;
            ChatUser loggedInUser = APIs.me;
            _makeList(users, yearFilter, branchFilter);

            return Column(
              children: [
                // FilterBar(changeFilter: _changeFilter),
                _list.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          // itemCount: users.length,
                          itemCount:
                              _isSearching ? _searchList.length : _list.length,
                          itemBuilder: (context, index) {
                            var userData =
                                users[index].data() as Map<String, dynamic>;
                            var userId = _isSearching
                                ? _searchList[index]['id']
                                : _list[index]['id'];
                            var name = _isSearching
                                ? _searchList[index]['name']
                                : _list[index]['name'];
                            var email = _isSearching
                                ? _searchList[index]['email']
                                : _list[index]['email'];
                            var about = _isSearching
                                ? _searchList[index]['about']
                                : _list[index]['about'];
                            var image = _isSearching
                                ? _searchList[index]['image']
                                : _list[index]['image'];

                            print(name);
                            print(loggedInUser.name);

                            if (userId == loggedInUser.id) {
                              return const SizedBox();
                            }
                            return Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: Container(
                                      color: GlobalVariables.cardColor,
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor:
                                              GlobalVariables.cardColor,
                                          backgroundImage: NetworkImage(image),
                                        ),
                                        title: Text(
                                          name,
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        subtitle: Text(about),
                                        trailing: IconButton(
                                          onPressed: () async {
                                            await APIs.addChatUser(email)
                                                .then((value) {
                                              if (!value) {
                                                Dialogs.showSnackbar(context,
                                                    'User does not Exists!');
                                              } else {
                                                Dialogs.showSnackbar(context,
                                                    'Created a New Chat in Messages Tab');
                                              }
                                            });
                                          },
                                          icon: const ColorFiltered(
                                              colorFilter: ColorFilter.mode(
                                                GlobalVariables.mainColor,
                                                BlendMode.srcIn,
                                              ),
                                              child: Icon(
                                                  CupertinoIcons.person_add)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Divider(
                                  indent: 10,
                                  endIndent: 10,
                                  thickness: 1,
                                ),
                              ],
                            );
                          },
                        ),
                      )
                    : const Center(
                        child: Text('No Other Members Found!',
                            style: TextStyle(fontSize: 20)),
                      ),
              ],
            );
          }
        },
      ),
    );
  }
}

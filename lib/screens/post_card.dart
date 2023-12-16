import 'package:alumni_connect/constant/gloabalvariable.dart';
import 'package:alumni_connect/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostCard extends StatefulWidget {
  final Post post;

  PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool showFullDescription = false;

  @override
  Widget build(BuildContext context) {
    String truncatedDescription =
        _truncateDescription(widget.post.description, 8, showFullDescription);
    return Card(
      // color: GlobalVariables.secondaryColor,
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.2), // Border color
          width: 0.5, // Border width
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.post.imageUrl != null)
            Image.network(
              widget.post.imageUrl!,
              fit: BoxFit.cover,
              width: double.infinity,
              // height: 200,
            ),
          Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.grad,
            ),
            child: ListTile(
              splashColor: GlobalVariables.mainColor,
              // tileColor: GlobalVariables.grad,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              leading: CircleAvatar(
                radius: 24.0,
                backgroundImage: widget.post.userProfileImageUrl != null
                    ? NetworkImage(widget.post.userProfileImageUrl!)
                    : const AssetImage('assets/images/userImageIcon.png')
                        as ImageProvider,
              ),
              title: Text(
                widget.post.userName,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              // subtitle: Text(
              //   // 'Posted on: $widget.post.',
              //   widget.post.,
              //   style: const TextStyle(
              //     color: Colors.grey,
              //   ),
              // ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    widget.post.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        truncatedDescription,
                        style: const TextStyle(fontSize: 16),
                      ),
                      if (widget.post.description.length > 50)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showFullDescription = !showFullDescription;
                            });
                          },
                          child: Container(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              showFullDescription ? 'See Less' : 'See More',
                              style: const TextStyle(
                                color: GlobalVariables.mainColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      Text(
                        DateFormat.MMMEd()
                            .add_jms()
                            .format(DateTime.parse(widget.post.postedDate)),
                        style: const TextStyle(
                          color: Color.fromARGB(255, 138, 137, 137),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _truncateDescription(String description, int maxWords, bool showFull) {
    if (showFull) {
      return description;
    } else {
      List<String> words = description.split(' ');
      if (words.length > maxWords) {
        return words.take(maxWords).join(' ') + '...';
      } else {
        return description;
      }
    }
  }
}

import '../models/comment_data.dart';
import '../models/post_data.dart';
import '../models/user_data.dart';

final List<PostData> dummyPosts = [
  PostData(
      id: 'post1',
      user: UserData(
          name: 'Hana Tamer',
          score: 120,
          uid: 'user1',
          picture: 'https://example.com/user1.jpg',
          eventPermission: 'Read'),
      createdAt: DateTime.now().subtract(Duration(days: 2)),
      title: 'I have a crush on the boy with green hoodie and a short beard',
      body:
          'I saw this boy at C5 and he was wearing a green hoodie and was with his friends. I just want to say I LOOOOOOOVE YOU <3',
      tags: ['Crush', 'Rant', 'Help'],
      likes: [],
      dislikes: [],
      score: 70,
      type: "confession",
      picture: "",
      comments: [
        CommentData(
          id: 'comment1',
          user: UserData(
            eventPermission: 'Read',
            name: 'John Doe',
            picture: 'https://example.com/user1.jpg',
            score: 120,
            uid: 'user1',
          ),
          body: 'This is a great post!',
          createdAt: DateTime.now().subtract(Duration(days: 2)),
          likes: [],
          dislikes: [],
        ),
        CommentData(
          id: 'comment2',
          user: UserData(
            eventPermission: 'Write',
            name: 'Alice Smith',
            picture: 'https://example.com/user2.jpg',
            score: 80,
            uid: 'user2',
          ),
          body: 'Oh my god you are so real for that. go get him girl.',
          createdAt: DateTime.now().subtract(Duration(days: 2)),
          likes: [],
          dislikes: [],
        ),
        CommentData(
          id: 'comment3',
          user: UserData(
            eventPermission: 'Write',
            name: 'Alice Smith',
            picture: 'https://example.com/user2.jpg',
            score: 80,
            uid: 'user2',
          ),
          body: 'He looked pretty average to me idk what you talking about',
          createdAt: DateTime.now().subtract(Duration(days: 2)),
          likes: [],
          dislikes: [],
        ),
        CommentData(
          id: 'comment4',
          user: UserData(
            eventPermission: 'Write',
            name: 'Alice Smith',
            picture: 'https://example.com/user2.jpg',
            score: 80,
            uid: 'user2',
          ),
          body: 'this uni is doomed i swear to god',
          createdAt: DateTime.now().subtract(Duration(days: 2)),
          likes: [],
          dislikes: [],
        ),
        CommentData(
          id: 'comment5',
          user: UserData(
            eventPermission: 'Write',
            name: 'Alice Smith',
            picture: 'https://example.com/user2.jpg',
            score: 80,
            uid: 'user2',
          ),
          body:
              'I can\'t believe this what our uni has come to. I\'m leaving this place. I hope you find him though. Good luck!',
          createdAt: DateTime.now().subtract(Duration(days: 2)),
          likes: [],
          dislikes: [],
        ),
        // Add more dummy comments as needed
      ]),
  PostData(
      id: 'post2',
      user: UserData(
          name: 'Ali Omar',
          score: 120,
          uid: 'user1',
          picture: 'https://example.com/user1.jpg',
          eventPermission: 'Read'),
      createdAt: DateTime.now().subtract(Duration(hours: 12)),
      title: 'FLUSH AFTER YOU ARE DONE',
      body:
          'You guys are disgusting. I went to the bathroom and there was poop everywhere. Please flush after you are done.',
      tags: ['Help', 'Rant'],
      likes: [],
      dislikes: [],
      score: 10,
      type: "confession",
      picture: "",
      comments: []),
  // Add more dummy data as needed
];

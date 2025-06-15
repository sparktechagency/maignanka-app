class HelperData {
  static final List<Map<String, String>> goalOptions = [
    {'value': 'just', 'title': 'Just here to explore'},
    {'value': 'chat', 'title': 'Here to chat and vibe'},
    {'value': 'nothing', 'title': 'Nothing serious'},
    {'value': 'serious', 'title': 'Looking for something serious'},
  ];


  static final List<String> allInterests = [
    "Traveling", "Movie", "Sports", "Fishing", "Yoga", "Dancing",
    "Singing", "Reading", "Driving", "Gardening", "Games", "GYM",
    "Drawing", "Chess", "Writing", "Racing", "Arts", "Coding",
    "Drinks", "Hockey", "Karate", "Golf", "Boxing", "Tennis",
    "Boat", "Skating", "Circus"
  ];

  static final List<String> interests = [
    "Traveling", "Movie", "Sports", "Fishing", "Yoga",

  ];


  /// fake data
  static final List<Map<String, dynamic>> notifications = [
    {'name': 'Annette Black', 'message': 'Match request', 'date': DateTime.now(), 'type': 'request'},
    {'name': 'Annette Black', 'message': 'Commented on your post', 'date': DateTime.now(), 'type': 'comment'},
    {'name': 'Annette Black', 'message': 'Match request', 'date': DateTime.now().subtract(Duration(days: 1)), 'type': 'request'},
  ];


  static final List<Map<String, dynamic>> historyData = [
    {
      'title': 'Asifur send a flower',
      'date': '22-July-2024',
      'points': 100,
    },
    {
      'title': 'Withdraw',
      'date': '22-July-2024',
      'points': 100,
    },
    {
      'title': 'You send flower to Hasif',
      'date': '22-July-2024',
      'points': 100,
    },
    {
      'title': 'Asifur send a Ring',
      'date': '22-July-2024',
      'points': 400,
    },
    {
      'title': 'Withdraw',
      'date': '22-July-2024',
      'points': 100,
    },
  ];


  static List<Map<String, dynamic>> messages = [
    {
      'text': 'Hey, how are you?',
      'isMe': true,
      'time': DateTime.now().subtract(Duration(minutes: 5)),
      'status': 'seen',
    },
    {
      'text': 'I am good, thanks! What about you?',
      'isMe': false,
      'time': DateTime.now().subtract(Duration(minutes: 3)),
      'status': 'seen',
    },
    {
      'text': 'I am doing great, working on a new project.',
      'isMe': true,
      'time': DateTime.now().subtract(Duration(minutes: 1)),
      'status': 'seen',
    },
    {
      'text': 'That sounds interesting!',
      'isMe': false,
      'time': DateTime.now(),
      'status': 'delivered',
    },
  ];



  // Fake data
  static final List<Map<String, String>> fakeData = [
    {
      'image': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=800&q=80',  // new 1st image
      'title': 'Alisha 23',
      'subtitle': '40 Km'
    },
    {
      'image': 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=800&q=80',
      'title': 'Faria 32',
      'subtitle': '40 Km'
    },
    {
      'image': 'https://images.unsplash.com/photo-1520813792240-56fc4a3765a7?auto=format&fit=crop&w=800&q=80',  // new 3rd image
      'title': 'Angel 44',
      'subtitle': '40 Km'
    },
    {
      'image': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=800&q=80',
      'title': 'Forida 76',
      'subtitle': '40 Km'
    },
    {
      'image': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=800&q=80',
      'title': 'Malkova 21',
      'subtitle': '40 Km'
    },
  ];



}

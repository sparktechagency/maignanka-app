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



}

// YouTube channel - https://www.youtube.com/@dimitarklaturov
// paid video - https://www.youtube.com/watch?v=ZmWEXE2DziQ
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

CustomAppState appState = CustomAppState();

Future customAppState() async {
  // CustomAppState appState = CustomAppState();
}

class CustomAppState extends ChangeNotifier {
  List<UsersRecord> _usersList = [];

  List<UsersRecord> get usersList => _usersList;

  set usersList(List<UsersRecord> value) {
    if (_usersList != value) {
      _usersList = value;
      notifyListeners(); // Notify listeners when the value changes
    }
  }

  // Method to add a UsersRecord to the list
  void addUser(UsersRecord user) {
    _usersList.add(user);
    notifyListeners();
  }

  // Method to remove a UsersRecord from the list
  void removeUser(UsersRecord user) {
    _usersList.remove(user);
    notifyListeners();
  }

  // Method to add a list of UsersRecord to the list
  void addUsers(List<UsersRecord> users) {
    _usersList.addAll(users);
    notifyListeners();
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!

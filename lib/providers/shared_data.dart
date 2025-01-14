import 'dart:collection';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:toastification/toastification.dart';
import 'package:trivi_app/pages/pages.dart';
import 'package:trivi_app/widgets/widgets.dart';

class SharedData extends ChangeNotifier {
  String _user = Hive.box<String>('userBox').get('user') ?? '-';
  String _profileBase64 = '';
  String _token = Hive.box<String>('tokenBox').get('token') ?? '';
  Widget _currentPage = const HomePage();
  int _nPreg = 1;
  int _model = 0;
  DateTime _lostDate = DateTime.now();
  int _lives = Hive.box<int>('livesBox').get('lives', defaultValue: 5) ?? 5;
  int _date = Hive.box<int>('dateBox').get('date', defaultValue: 0) ?? 0;
  int _diffSelected = 0;
  String _appLang =
      Hive.box<String>("appLangBox").get("appLang", defaultValue: "en")!;
  int _subIndex = 0;
  List<Widget> _topicsBoxes =
      Hive.box<List<Widget>>('topicsBox').get('topics') ??
          [
            const AddBoxWidget(),
          ];
  int _selectedAnswer = 0;
  final TextToSpeech _flutterTts = TextToSpeech();
  int _stars = Hive.box<int>('starsBox').get('stars', defaultValue: 0) ?? 0;
  int _streak = 0;
  String _selectedTopic = '';
  String _jwt = Hive.box<String>('jwtBox').get('jwt', defaultValue: '') ?? '';
  String _instrucciones = '';
  String _annualPrice = '';
  String _monthlyPrice = '';
  bool _isFreeTrial = false;
  bool _isGetting = false;
  bool _loaded = false;
  double _discMonthlyPrice = 0;
  double _discAnnualPrice = 0;
  String _selectedLang = 'Español';
  bool _isFirst =
      Hive.box<bool>("isFirstBox").get("isFirst", defaultValue: true)!;
  String _selectedFilename = 'Español';
  List<PlatformFile> _uploadedFiles = [];
  int _actualQuestion = 0;
  int _correctAnswers = 0;
  bool _loading = true;
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  double _progressValue = 0;
  Map<String, dynamic> _questionAndAnswers = {};
  List<Widget> __leaderboardItems = [];
  List _models = [];
  bool _nightMode = false;
  bool _snackShown = false;
  bool _checked = false;
  bool _leaderLoaded = true;
  bool _leaderLoading = false;
  bool _toggleHint = false;
  bool _isPremium = false;
  bool _vibration =
      Hive.box<bool>("vibrationBox").get("vibration", defaultValue: true)!;
  bool _sound = Hive.box<bool>("soundBox").get("sound", defaultValue: true)!;
  bool _uploaded = false;
  int __attempts = 0;
  bool _remember = true;
  bool _toConfirm = false;
  bool _deleting = false;
  String _appUserId =
      Hive.box<String>("appIdBox").get("id", defaultValue: "") ?? "";
  dynamic _texts;

  UnmodifiableListView<Widget> get realTopicsBoxes =>
      UnmodifiableListView(_topicsBoxes);
  UnmodifiableListView get realQuestionsAndAnswers =>
      UnmodifiableListView([_questionAndAnswers]);
  Widget get currentPage => _currentPage;
  int get nPreg => _nPreg;
  int get lives => _lives;
  int get model => _model;
  int get subIndex => _subIndex;
  List<Widget> get leaderboardItems => __leaderboardItems;
  List<Widget> get topicsBoxes => _topicsBoxes;
  List<PlatformFile> get uploadedFiles => _uploadedFiles;
  String get user => _user;
  String get instrucciones => _instrucciones;
  bool get isFirst => _isFirst;
  String get profileBase64 => _profileBase64;
  String get selectedLang => _selectedLang;
  String get selectedFilename => _selectedFilename;
  String get annualPrice => _annualPrice;
  String get monthlyPrice => _monthlyPrice;
  String get appLang => _appLang;
  String get token => _token;
  TextToSpeech get flutterTts => _flutterTts;
  bool get nightMode => _nightMode;
  bool get snackShown => _snackShown;
  bool get sound => _sound;
  bool get isGetting => _isGetting;
  bool get isFreeTrial => _isFreeTrial;
  bool get checked => _checked;
  int get actualQuestion => _actualQuestion;
  StopWatchTimer get stopWatchTimer => _stopWatchTimer;
  int get correctAnswers => _correctAnswers;
  int get stars => _stars;
  int get attempts => __attempts;
  int get streak => _streak;
  double get discAnnualPrice => _discAnnualPrice;
  double get discMonthlyPrice => _discMonthlyPrice;
  bool get leaderLoaded => _leaderLoaded;
  bool get leaderLoading => _leaderLoading;
  bool get toConfirm => _toConfirm;
  int get date => _date;
  List get questionsAndAnswers => [_questionAndAnswers];
  List get models => _models;
  int get selectedAnswer => _selectedAnswer;
  double get progressValue => _progressValue;
  int get diffSelected => _diffSelected;
  String get topicSelected => _selectedTopic;
  String get jwt => _jwt;
  String get appUserId => _appUserId;
  bool get toggleHint => _toggleHint;
  bool get vibration => _vibration;
  bool get uploaded => _uploaded;
  bool get remember => _remember;
  bool get deleting => _deleting;
  bool get loaded => _loaded;
  bool get loading => _loading;
  DateTime get lostDate => _lostDate;
  bool get isPremium => _isPremium;
  dynamic get texts => _texts;

  void setCurrentPage(Widget value) {
    _currentPage = value;
    notifyListeners();
  }

  void setTexts(dynamic value) {
    _texts = value;
    notifyListeners();
  }

  void setPremium(bool value) {
    _isPremium = value;
    notifyListeners();
  }

  void setVibration(bool value) {
    _vibration = value;
    notifyListeners();
  }

  void setSound(bool value) {
    _sound = value;
    notifyListeners();
  }

  void setFirst(bool value) {
    _isFirst = value;
    notifyListeners();
  }

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setGetting(bool value) {
    _isGetting = value;
    notifyListeners();
  }

  void setModels(List value) {
    _models = value;
    notifyListeners();
  }

  void setFreeTrial(bool value) {
    _isFreeTrial = value;
    notifyListeners();
  }

  void setLoaded(bool value) {
    _loaded = value;
    notifyListeners();
  }

  void setAnnualPrice(String value) {
    _annualPrice = value;
    notifyListeners();
  }

  void setAppLang(String value) {
    _appLang = value;
    notifyListeners();
  }

  void setModel(int value) {
    _model = value;
    notifyListeners();
  }

  void setMonthlyPrice(String value) {
    _monthlyPrice = value;
    notifyListeners();
  }

  void setDiscAnnualPrice(double value) {
    _discAnnualPrice = value;
    notifyListeners();
  }

  void setDiscMonthlyPrice(double value) {
    _discMonthlyPrice = value;
    notifyListeners();
  }

  void setRemember(bool value) {
    _remember = value;
    notifyListeners();
  }

  void setSubIndex(int value) {
    _subIndex = value;
    notifyListeners();
  }

  void setAppUserId(String value) {
    _appUserId = value;
    notifyListeners();
  }

  void setHint(bool value) {
    _toggleHint = value;
    notifyListeners();
  }

  void setConfirm(bool value) {
    _toConfirm = value;
    notifyListeners();
  }

  void setDeleting(bool value) {
    _deleting = value;
    notifyListeners();
  }

  void setHintTopic(bool value) {
    _toggleHint = value;
    notifyListeners();
  }

  void setUploaded(bool value) {
    _uploaded = value;
    notifyListeners();
  }

  void setJwt(String value) {
    _jwt = value;
    notifyListeners();
  }

  void setInstrucciones(String value) {
    _instrucciones = value;
    notifyListeners();
  }

  void setUploadedFiles(List<PlatformFile> value) {
    _uploadedFiles = value;
    notifyListeners();
  }

  void setDifficulty(int value) {
    _diffSelected = value;
    notifyListeners();
  }

  void setCorrectAnswers(int value) {
    _correctAnswers = value;
    notifyListeners();
  }

  void setlives(int value) {
    _lives = value;
    notifyListeners();
  }

  void setLeaderboardItems(List<Widget> value) {
    __leaderboardItems = value;
    notifyListeners();
  }

  void setprofileBase64(String value) {
    _profileBase64 = value;
    notifyListeners();
  }

  void setSelectedLang(String value) {
    _selectedLang = value;
    notifyListeners();
  }

  void setSelectedFilename(String value) {
    _selectedFilename = value;
    notifyListeners();
  }

  void changeSnackShown(bool value) {
    _snackShown = value;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void toggleLeaderLoaded() {
    _leaderLoaded = !_leaderLoaded;
    notifyListeners();
  }

  void toggleLeaderLoading() {
    _leaderLoading = !_leaderLoading;
    notifyListeners();
  }

  void toggleChecked() {
    _checked = !_checked;
    notifyListeners();
  }

  void setTopic(String value) {
    _selectedTopic = value;
    notifyListeners();
  }

  void addTopic(
    String name,
    String emoji,
    String instrucciones,
    String filename,
    String language,
    BuildContext context,
  ) {
    _topicsBoxes.insert(
      1,
      SubjectBoxWidget(
        topicName: name,
        emoji: emoji,
        instrucciones: instrucciones,
        filename: filename,
        language: language,
        buildContext: context,
      ),
    );
    notifyListeners();
  }

  void popTopics() {
    _topicsBoxes = _topicsBoxes.sublist(0, _topicsBoxes.length - 2);
    notifyListeners();
  }

  void resetTopics() {
    _topicsBoxes = [
      const AddBoxWidget(),
      // const SubjectBoxWidget(
      //   topicName: 'Ciclos Programación',
      //   emoji: '🧑‍💻',
      //   instrucciones: '',
      // ),
      // const SubjectBoxWidget(
      //   topicName: 'Verb To Be English',
      //   emoji: '✈️',
      //   instrucciones: '',
      // ),
      // const SubjectBoxWidget(
      //   topicName: 'Derivadas',
      //   emoji: '🔢',
      //   instrucciones: '',
      // ),
    ];
    notifyListeners();
  }

  void setTopics(List<Widget> topics) {
    _topicsBoxes = topics;
    notifyListeners();
  }

  void toggleNightMode() {
    Hive.box<bool>('nightBox').put('night', !nightMode);
    _nightMode = !_nightMode;
    notifyListeners();
  }

  void setDate(int value) {
    _date = value;
    notifyListeners();
  }

  void setUser(String value) {
    _user = value;
    notifyListeners();
  }

  void setStreak(int value) {
    _streak = value;
    notifyListeners();
  }

  void setStars(int value) {
    _stars = value;
    notifyListeners();
  }

  void setAttempts(int value) {
    __attempts = value;
    notifyListeners();
  }

  void setToken(String value) {
    _token = value;
    notifyListeners();
  }

  void setActualQuestion(int value) {
    _actualQuestion = value;
    notifyListeners();
  }

  void setQuestionsAndAnswers(Map<String, dynamic> value) {
    _questionAndAnswers = value;
    notifyListeners();
  }

  void setProgress(double value) {
    _progressValue = value;
    notifyListeners();
  }

  void setAnswer(int value) {
    _selectedAnswer = value;
    notifyListeners();
  }

  void addTopicBox(Widget value) {
    _topicsBoxes.insert(1, value);
    notifyListeners();
  }

  void setLostDate(DateTime value) {
    _lostDate = value;
    notifyListeners();
  }

  void setNPreg(int value, BuildContext context) {
    final providerWith = Provider.of<SharedData>(context, listen: false);
    if (value > 0) {
      _nPreg = value;
    } else {
      toastification.show(
        icon: const Icon(
          Icons.error_outline_outlined,
          size: 35,
        ),
        type: ToastificationType.error,
        style: ToastificationStyle.minimal,
        title: Text(
          providerWith.texts[providerWith.appLang]["numQuestionsMoreThanZero"],
          style: const TextStyle(fontSize: 15),
        ),
        alignment: Alignment.topCenter,
        autoCloseDuration: const Duration(seconds: 4),
      );
    }
    notifyListeners();
  }
}

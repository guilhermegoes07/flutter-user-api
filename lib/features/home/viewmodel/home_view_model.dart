import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:pessoas/features/user/model/user_model.dart';
import 'package:pessoas/features/user/repository/user_repository.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel(this._repository);

  final UserRepository _repository;
  final List<User> _sessionUsers = [];
  bool _isLoading = false;
  bool _isFetching = false;
  String? _errorMessage;
  Ticker? _ticker;
  Duration _lastTick = Duration.zero;

  static const Duration _interval = Duration(seconds: 5);

  List<User> get sessionUserList => List.unmodifiable(_sessionUsers);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> startTicker(TickerProvider tickerProvider) async {
    if (_ticker != null) {
      return;
    }

    await _fetchAndAppend(showLoader: true);
    _ticker = tickerProvider.createTicker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    if (elapsed - _lastTick >= _interval && !_isFetching) {
      _lastTick = elapsed;
      _fetchAndAppend();
    }
  }

  Future<void> manualRefresh() async {
    await _fetchAndAppend(showLoader: true);
  }

  Future<void> _fetchAndAppend({bool showLoader = false}) async {
    if (_isFetching) {
      return;
    }

    _isFetching = true;
    _errorMessage = null;
    if (showLoader) {
      _isLoading = true;
      notifyListeners();
    }

    try {
      final user = await _repository.getNewUserFromApi();
      _sessionUsers.insert(0, user);
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isFetching = false;
      _isLoading = false;
      notifyListeners();
    }
  }

  void disposeTicker() {
    _ticker?.dispose();
    _ticker = null;
  }

  @override
  void dispose() {
    disposeTicker();
    super.dispose();
  }
}

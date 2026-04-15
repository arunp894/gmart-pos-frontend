import 'package:gmart/Core/application_base.dart';

enum ViewState { active, inActive, innerActive, innerInActive }

class BaseModel extends ChangeNotifier {
  ViewState _state = ViewState.active;

  ViewState get state => _state;

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }
}

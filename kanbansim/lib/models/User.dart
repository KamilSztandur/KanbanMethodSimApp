import 'dart:ui';

class User {
  static int _registeredUsersAmount = 0;
  String _name;
  int _maxProductivity;
  Color _color;

  int _id;
  int _productivity;

  User(String name, int maxProductivity, Color color) {
    this._name = name;
    this._maxProductivity = maxProductivity;
    this._color = color;

    this._id = _registeredUsersAmount++;
    this._productivity = maxProductivity;
  }

  bool decreaseProductivity(int amount) {
    if (amount > this._productivity) {
      return false;
    } else {
      this._productivity -= amount;
      return true;
    }
  }

  void restoreProductivity() {
    this._productivity = this._maxProductivity;
  }

  bool increaseProductivity(int amount) {
    int newProductivity = this._productivity + amount;

    if (newProductivity > this._maxProductivity) {
      return false;
    } else {
      this._productivity = newProductivity;
      return true;
    }
  }

  String getName() {
    return this._name;
  }

  Color getColor() {
    return this._color;
  }

  int getProductivity() {
    return this._productivity;
  }

  int getMaxProductivity() {
    return this._maxProductivity;
  }

  int getID() {
    return this._id;
  }
}

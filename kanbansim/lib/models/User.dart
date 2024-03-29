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
    this._productivity = 0;
  }

  void loadAdditionalDataFromSavefile(int id, int productivity) {
    this._id = id;
    this._productivity = productivity;
  }

  bool decreaseProductivity(int amount) {
    if (amount > this._productivity) {
      return false;
    } else {
      this._productivity -= amount;
      return true;
    }
  }

  void addProductivity(int productivity) {
    int prodSum = this.getProductivity() + productivity;

    if (prodSum > this.getMaxProductivity()) {
      this._productivity = this.getMaxProductivity();
    } else {
      this._productivity += productivity;
    }
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

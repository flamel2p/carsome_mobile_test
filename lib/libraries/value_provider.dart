class ValueProvider {
  final Map value;

  ValueProvider(this.value);

  int getInt(String keyName, {int defaultValue = 0}) {
    if (value.containsKey(keyName)) {
      return int.tryParse(value[keyName].toString()) ?? defaultValue;
    }

    return defaultValue;
  }

  String getString(String keyName) {
    if (value.containsKey(keyName)) {
      return value[keyName].toString();
    }
    return '';
  }
}

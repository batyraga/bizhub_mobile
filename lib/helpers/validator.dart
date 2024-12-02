import 'dart:developer';

class OjoValidatorRule<T> {
  final bool Function(T) callback;
  final String err;
  const OjoValidatorRule(this.callback, this.err);
}

class OjoValidator<T> {
  Map<String, OjoValidatorRule<T>> _rules = {};

  OjoValidator<T> required([String? err]) {
    bool _required(T? v) {
      log("$v ${v.runtimeType}");
      if (v.runtimeType == String) {
        log("$v true");
        return (v as String).isNotEmpty;
      }
      return v != null;
    }

    _rules["required"] = OjoValidatorRule(_required, err ?? "Required");
    return this;
  }

  OjoValidator<T> minLength(int n, [String? err]) {
    bool _call(T v) {
      if (v.runtimeType == String) {
        return (v as String).length >= n;
      }
      return true;
    }

    _rules["minLength"] = OjoValidatorRule(_call, err ?? "Minimum length: $n");
    return this;
  }

  OjoValidator<T> min(num n, [String? err]) {
    bool _call(T v) {
      if (v.runtimeType == int) {
        return (v as int) >= n;
      } else if (v.runtimeType == double) {
        return (v as double) >= n;
      }
      return true;
    }

    _rules["min"] = OjoValidatorRule(_call, err ?? "Minimum: $n");
    return this;
  }

  OjoValidator<T> max(num n, [String? err]) {
    bool _call(T v) {
      if (v.runtimeType == int) {
        return (v as int) <= n;
      } else if (v.runtimeType == double) {
        return (v as double) <= n;
      }
      return true;
    }

    _rules["max"] = OjoValidatorRule(_call, err ?? "Maximum: $n");
    return this;
  }

  OjoValidator<T> maxLength(int n, [String? err]) {
    bool _call(T v) {
      log("${v.runtimeType == String}");
      if (v.runtimeType == String) {
        return (v as String).length <= n;
      }
      return true;
    }

    _rules["maxLength"] = OjoValidatorRule(_call, err ?? "Maximum length: $n");
    return this;
  }

  OjoValidator<T> regex(RegExp r, [String? err]) {
    bool _call(T v) {
      if (v.runtimeType == String) {
        return r.hasMatch(v as String);
      }
      return true;
    }

    _rules["regex"] = OjoValidatorRule(_call, err ?? "Regexp error");
    return this;
  }

  OjoValidator<T> notEqual(T o, [String? err]) {
    bool _call(T v) {
      return v != o;
    }

    _rules["notEqual"] = OjoValidatorRule(_call, err ?? "Mustn't be equal");
    return this;
  }

  OjoValidator<T> equal(T o, [String? err]) {
    bool _call(T v) {
      return v == o;
    }

    _rules["equal"] = OjoValidatorRule(_call, err ?? "Mustn't be not equal");
    return this;
  }

  Map<String, String> _build(T? v) {
    if (v == null) {
      return {
        'value': "Required",
      };
    }
    Map<String, String> errors = {};

    _rules.forEach((key, value) {
      final bool s = value.callback(v);
      log("$key: $s");
      if (s == false) {
        errors[key] = value.err;
      }
    });

    log("$errors");

    return errors;
  }
}

class OjoValidatorBuilder {
  Map<String, OjoValidator<dynamic>> _schema = {};
  OjoValidatorBuilder(this._schema);

  static OjoValidator<String> string() => OjoValidator<String>();
  static OjoValidator<List> list() => OjoValidator<List>();
  static OjoValidator<int> number() => OjoValidator<int>();
  static OjoValidator<double> float() => OjoValidator<double>();
  static OjoValidator<T> generic<T>() => OjoValidator<T>();

  Map<String, Map<String, String>> build(Map<String, dynamic> values) {
    Map<String, Map<String, String>> allErrors_ = {};
    _schema.forEach((key, value) {
      final v = values[key];
      final errors = value._build(v);
      allErrors_[key] = errors;
    });

    return allErrors_;
  }
}

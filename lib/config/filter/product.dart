import 'package:bizhub/config/langs/locale_keys.g.dart';

class SortType {
  final int index;
  final String localeKey;
  const SortType({required this.index, required this.localeKey});
}

const filterProductSortTypes = {
  0: SortType(index: 0, localeKey: LocaleKeys.lowToHigh),
  1: SortType(index: 1, localeKey: "highToLow"),
  2: SortType(index: 2, localeKey: "newProducts"),
  3: SortType(index: 3, localeKey: "trending"),
  4: SortType(index: 4, localeKey: "discount"),
};

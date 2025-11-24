import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/countries.dart';

class CurrencyCubit extends Cubit<Country> {
  CurrencyCubit() : super(countries.first) {
    _loadCurrency();
  }

  static const _key = 'selected_country';

  Future<void> _loadCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    final countryCode = prefs.getString(_key);
    
    if (countryCode != null) {
      final country = getCountryByCode(countryCode);
      emit(country);
    } else {
      emit(countries.first); // default to Rwanda
    }
  }

  Future<void> setCurrency(Country country) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, country.code);
    emit(country);
  }
}
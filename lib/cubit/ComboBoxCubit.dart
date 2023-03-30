import 'package:flutter_bloc/flutter_bloc.dart';

class ComboBoxCubit extends Cubit<List<String>> {
  ComboBoxCubit() : super([]);

  void addItem(String item) {
    if (!state.contains(item)) {
      emit([...state, item]);
    }
  }

  void editItem(String oldItem, String newItem) {
    final index = state.indexOf(oldItem);
    if (index >= 0) {
      final newList = List<String>.from(state);
      newList[index] = newItem;
      emit(newList);
    }
  }

  void removeItem(String item) {
    emit(state.where((element) => element != item).toList());
  }
}

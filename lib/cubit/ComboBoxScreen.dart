// ignore: file_names
// ignore: file_names
// ignore: file_names
// ignore_for_file: library_private_types_in_public_api, file_names, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ComboBoxCubit extends Cubit<List<String>> {
  ComboBoxCubit() : super([]);

  void addItem(String item) {
    emit([...state, item]);
  }

  void editItem(String oldItem, String newItem) {
    final index = state.indexOf(oldItem);
    if (index != -1) {
      state[index] = newItem;
      emit([...state]);
    }
  }

  void removeItem(String item) {
    final updatedList = state.where((element) => element != item).toList();
    emit(updatedList);
  }
}

class ComboBoxScreen extends StatefulWidget {
  const ComboBoxScreen({super.key});

  @override
  _ComboBoxScreenState createState() => _ComboBoxScreenState();
}

class _ComboBoxScreenState extends State<ComboBoxScreen> {
  final TextEditingController _controller = TextEditingController();
  late ComboBoxCubit _comboBoxCubit;
  late String _selectedItem;

  @override
  void initState() {
    super.initState();
    _comboBoxCubit = ComboBoxCubit();
    _selectedItem =
        _comboBoxCubit.state.isNotEmpty ? _comboBoxCubit.state[0] : '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ComboBox Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Add Item'),
                        content: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            hintText: 'Enter a new item',
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Add'),
                            onPressed: () {
                              final newItem = _controller.text;
                              _comboBoxCubit.addItem(newItem);
                              setState(() {
                                _selectedItem = newItem;
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('Add'),
                ),
                const SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Edit Item'),
                        content: TextField(
                          controller: _controller..text = _selectedItem,
                          decoration: const InputDecoration(
                            hintText: 'Edit the item',
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              _controller.clear();
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Save'),
                            onPressed: () {
                              final newItem = _controller.text;
                              _comboBoxCubit.editItem(_selectedItem, newItem);
                              setState(() {
                                _selectedItem = newItem;
                                _controller.clear();
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('Edit'),
                ),
                const SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    _controller.clear();
                    _comboBoxCubit.removeItem(_selectedItem);
                    setState(() {
                      _selectedItem = _comboBoxCubit.state.isNotEmpty
                          ? _comboBoxCubit.state[0]
                          : '';
                    });
                  },
                  child: const Text('Remove'),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            BlocBuilder<ComboBoxCubit, List<String>>(
              bloc: _comboBoxCubit,
              builder: (context, state) {
                if (state.isNotEmpty) {
                  return DropdownButton<String>(
                    value: _selectedItem,
                    items: state.map((item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedItem = value!;
                      });
                    },
                  );
                } else {
                  return const Text('No items added');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _comboBoxCubit.close();
    super.dispose();
  }
}

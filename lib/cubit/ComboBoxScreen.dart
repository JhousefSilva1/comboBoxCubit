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
        title: Text('ComboBox Example'),
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
                        title: Text('Add Item'),
                        content: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'Enter a new item',
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('Add'),
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
                  child: Text('Add'),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Edit Item'),
                        content: TextField(
                          controller: _controller..text = _selectedItem,
                          decoration: InputDecoration(
                            hintText: 'Edit the item',
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('Save'),
                            onPressed: () {
                              final newItem = _controller.text;
                              _comboBoxCubit.editItem(_selectedItem, newItem);
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
                  child: Text('Edit'),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    _comboBoxCubit.removeItem(_selectedItem);
                    setState(() {
                      _selectedItem = _comboBoxCubit.state.isNotEmpty
                          ? _comboBoxCubit.state[0]
                          : '';
                    });
                  },
                  child: Text('Remove'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
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
                  return Text('No items added');
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

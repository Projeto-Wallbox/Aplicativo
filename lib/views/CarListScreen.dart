import 'package:flutter/material.dart';
import 'package:wallbox_app/database.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CarListScreen(),
    );
  }
}

class CarListScreen extends StatefulWidget {
  @override
  _CarListScreenState createState() => _CarListScreenState();
}

class _CarListScreenState extends State<CarListScreen> {
  List<Car> _carsList = List.empty();

  void loadCars() async {
    final database = AppDatabase.instance();
    final carsList = await database.select(database.cars).get();
    setState(() {
      _carsList = carsList;
    });
  }

  @override
  void initState() {
    loadCars();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _carsList.length,
        itemBuilder: (context, index) {
          Car car = _carsList[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(
                '${car.name} ${car.model}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Ano: ${car.year}',
                style: const TextStyle(fontSize: 16),
              ),
              onTap: () {
                _editCar(context, car);
              },
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  _showDeleteConfirmationDialog(car);
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addCar(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addCar(BuildContext context) async {
    Car newCar = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CarFormScreen(),
      ),
    );

    final database = AppDatabase.instance();
    database.into(database.cars).insert(newCar);
    loadCars();
  }

  void _editCar(BuildContext context, Car car) async {
    Car updatedCar = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CarFormScreen(editingCar: car),
      ),
    );
    final database = AppDatabase.instance();
    database.update(database.cars).replace(updatedCar);
    loadCars();
  }

  void _showDeleteConfirmationDialog(Car car) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Excluir Carro'),
          content: const Text('Tem certeza de que deseja excluir este carro?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final database = AppDatabase.instance();
                database.delete(database.cars).delete(car);
                loadCars();
                Navigator.pop(context);
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }
}

class CarFormScreen extends StatefulWidget {
  final Car? editingCar;

  const CarFormScreen({this.editingCar});

  @override
  _CarFormScreenState createState() => _CarFormScreenState();
}

class _CarFormScreenState extends State<CarFormScreen> {
  late TextEditingController _nameController;
  late TextEditingController _modelController;
  late TextEditingController _yearController;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.editingCar?.name ?? '');
    _modelController =
        TextEditingController(text: widget.editingCar?.model ?? '');
    _yearController =
        TextEditingController(text: widget.editingCar?.year?.toString() ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.editingCar == null ? 'Adicionar Carro' : 'Editar Carro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _modelController,
              decoration: InputDecoration(labelText: 'Modelo'),
            ),
            TextField(
              controller: _yearController,
              decoration: InputDecoration(labelText: 'Ano'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _saveCar();
              },
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveCar() {
    String name = _nameController.text.trim();
    String model = _modelController.text.trim();
    int? year = int.tryParse(_yearController.text.trim());

    if (name.isNotEmpty && model.isNotEmpty && year != null) {
      Car newCar;
      if (widget.editingCar != null) {
        newCar = Car(
          id: widget.editingCar!.id,
          name: name,
          model: model,
          year: year,
        );
      } else {
        newCar = Car(
          id: DateTime.now().millisecondsSinceEpoch,
          name: name,
          model: model,
          year: year,
        );
      }

      Navigator.pop(context, newCar);
    } else {
      // Exibir mensagem de erro, caso algum campo esteja vazio ou ano seja inválido.
      // Você pode usar um SnackBar ou AlertDialog para isso.
    }
  }
}

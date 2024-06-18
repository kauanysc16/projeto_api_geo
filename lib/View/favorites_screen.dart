import 'package:exemplo_api/Controller/favorites_controller.dart';
import 'package:flutter/material.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoritesController _controller = FavoritesController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favoritos"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Lista de Favoritos",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _buildFavoritesList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesList() {
    List<String> favorites = _controller.getFavorites();

    if (favorites.isEmpty) {
      return Center(
        child: Text(
          "Nenhum item favorito encontrado.",
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final item = favorites[index];
        return Card(
          elevation: 4,
          margin: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text(
              item,
              style: TextStyle(fontSize: 18),
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _removeFromFavorites(item),
            ),
          ),
        );
      },
    );
  }

  void _removeFromFavorites(String itemToRemove) {
    _controller.removeFromFavorites(itemToRemove);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$itemToRemove removido dos favoritos.'),
        duration: Duration(seconds: 2),
      ),
    );
    setState(() {}); // Força a atualização da UI após a remoção
  }
}

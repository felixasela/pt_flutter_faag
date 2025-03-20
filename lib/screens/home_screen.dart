import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_provider.dart';
import '../providers/delete_user_provider.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Usuarios'),
        backgroundColor: const Color(0xFF003366),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              Future.microtask(() => ref.invalidate(userProvider));
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          Future.microtask(() => ref.invalidate(userProvider));
        },
        child: userAsync.when(
          data: (users) => users is List
              ? ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      color: const Color(0xFF00509E),
                      child: ListTile(
                        title: Text(
                          user['primerNombre'] ?? 'Sin nombre',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Documento: ${user['numeroDocumento'] ?? 'N/A'}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.white),
                              onPressed: () => _editUser(context, user),
                            ),
                            IconButton(
                              icon:
                                  const Icon(Icons.delete, color: Colors.white),
                              onPressed: () =>
                                  _confirmDelete(context, ref, user),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : const Center(child: Text('No hay usuarios disponibles')),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) =>
              const Center(child: Text('Error al cargar usuarios')),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await context.push('/add-user');
          if (result != null && result == true) {
            Future.microtask(() => ref.invalidate(userProvider));
          }
        },
        label: const Text('Registrar',
            style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add),
        backgroundColor: const Color(0xFF007FFF),
      ),
    );
  }

  void _editUser(BuildContext context, Map<String, dynamic> user) {
    context.push('/edit-user', extra: user);
  }

  void _confirmDelete(
      BuildContext context, WidgetRef ref, Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF003366),
        title: const Text(
          'Eliminar Usuario',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          '¿Estás seguro de eliminar a ${user['primerNombre'] ?? 'este usuario'}?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text('Cancelar', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final deleteUser = ref.read(deleteUserProvider);
              final success = await deleteUser.deleteUser(
                  user['tipoDocumento'], user['numeroDocumento']);

              if (success) {
                Future.microtask(() => ref.invalidate(userProvider));
              } else if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error al eliminar usuario')),
                );
              }
            },
            child: const Text('Eliminar',
                style: TextStyle(
                    color: Color(0xFF007FFF), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

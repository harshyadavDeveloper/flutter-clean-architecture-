import 'package:create_user_app/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:create_user_app/src/authentication/presentation/widgets/add_user_dialog.dart';
import 'package:create_user_app/src/authentication/presentation/widgets/loading_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController nameController = TextEditingController();
  void getUsers() {
    context.read<AuthenticationBloc>().add(const GetUsersEvent());
  }

  @override
  void initState() {
    super.initState();
    // Fetch users when the screen first loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is UserCreated) {
          getUsers();
        }
      },
      builder: (context, state) {
        return Scaffold(
          body:
              state is GettingUser
                  ? const LoadingColumn(message: 'Fetching Users')
                  : state is CreatingUser
                  ? const LoadingColumn(message: 'Creating User')
                  : state is UsersLoaded
                  ? Center(
                    child: ListView.builder(
                      itemCount: state.users.length,
                      itemBuilder: (context, index) {
                        final user = state.users[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(user.avatar),
                          ),
                          title: Text(user.name),
                          subtitle: Text('Created at: ${user.createdAt}'),
                        );
                      },
                    ),
                  )
                  : const Center(child: Text('No users found')),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              await showDialog(
                context: context,
                builder:
                    (context) => AddUserDialog(nameController: nameController),
              );
              getUsers(); // Refresh the user list after adding a user
            },
            icon: const Icon(Icons.add),
            label: const Text('Add User'),
          ),
        );
      },
    );
  }
}

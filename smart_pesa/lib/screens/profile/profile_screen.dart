import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/profile/profile_bloc.dart';
import '../bloc/profile/profile_event.dart';
import '../bloc/profile/profile_state.dart';
import '../core/constants/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoadInProgress) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ProfileLoadFailure) {
          // No user exists → show create profile form
          return _buildProfileForm(context, createNew: true);
        }

        if (state is ProfileLoadSuccess) {
          _nameController.text = state.user.name;
          _emailController.text = state.user.email;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(state.user.avatarUrl.isNotEmpty
                      ? state.user.avatarUrl
                      : 'https://i.pravatar.cc/150?img=3'),
                ),
                const SizedBox(height: 24),
                _isEditing
                    ? _buildProfileForm(context)
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name', style: _labelStyle()),
                          const SizedBox(height: 4),
                          Text(state.user.name, style: _valueStyle()),
                          const SizedBox(height: 16),
                          Text('Email', style: _labelStyle()),
                          const SizedBox(height: 4),
                          Text(state.user.email, style: _valueStyle()),
                          const SizedBox(height: 32),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _isEditing = true;
                                });
                              },
                              child: const Text('Edit Profile'),
                            ),
                          )
                        ],
                      )
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildProfileForm(BuildContext context, {bool createNew = false}) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3'),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              filled: true,
              fillColor: Colors.white,
            ),
            validator: (value) =>
                value == null || value.isEmpty ? 'Enter your name' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              filled: true,
              fillColor: Colors.white,
            ),
            validator: (value) =>
                value == null || value.isEmpty ? 'Enter your email' : null,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if (createNew) {
                  context.read<ProfileBloc>().add(CreateProfile(
                        name: _nameController.text,
                        email: _emailController.text,
                        avatarUrl: '',
                      ));
                } else {
                  context.read<ProfileBloc>().add(UpdateProfile(
                        name: _nameController.text,
                        email: _emailController.text,
                      ));
                }
                setState(() {
                  _isEditing = false;
                });
              }
            },
            child: Text(createNew ? 'Create Profile' : 'Save Changes'),
          ),
        ],
      ),
    );
  }

  TextStyle _labelStyle() =>
      const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500);

  TextStyle _valueStyle() =>
      const TextStyle(fontSize: 18, color: AppColors.textPrimary, fontWeight: FontWeight.bold);
}
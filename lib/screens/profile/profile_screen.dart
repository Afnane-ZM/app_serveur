// lib/screens/profile/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/profile/profile_bloc.dart';
import '../../blocs/profile/profile_event.dart';
import '../../blocs/profile/profile_state.dart';
import '../../utils/theme.dart';
import '../../widgets/bottom_navigation.dart';
import '../../widgets/custom_input_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final int _currentIndex = 3;
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _passwordsMatch = true;
  bool _passwordMinLength = true;
  bool _showPasswordForm = false;

  @override
  void initState() {
    super.initState();
    
    context.read<ProfileBloc>().add(LoadProfileStats());
  }
  
  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateNewPassword() {
    setState(() {
      final newPassword = _newPasswordController.text;
      final confirmPassword = _confirmPasswordController.text;
      
      _passwordsMatch = newPassword == confirmPassword;
      _passwordMinLength = newPassword.length >= 8;
    });
  }

  void _submitPasswordChange(BuildContext context) {
   
    setState(() {
      _passwordsMatch = _newPasswordController.text == _confirmPasswordController.text;
      _passwordMinLength = _newPasswordController.text.length >= 8;
    });

    // Vérifications côté client
    if (_currentPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez saisir votre mot de passe actuel'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_newPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez saisir un nouveau mot de passe'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_passwordsMatch) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Les mots de passe ne correspondent pas'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_passwordMinLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Le mot de passe doit contenir au moins 8 caractères'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
  
    final user = context.read<AuthBloc>().state.user;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Utilisateur non connecté'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
   
    context.read<AuthBloc>().add(
      ChangePasswordRequested(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: SafeArea(
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state.status == ProfileStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Une erreur est survenue'),
                ),
              );
            }
          },
          builder: (context, ProfileState state) {
            return BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
               
                final user = authState.user;
                
                if (authState.status == AuthStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (user == null) {
                
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      Navigator.of(context).pushReplacementNamed('/login');
                    }
                  });
                  
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('Utilisateur non connecté'),
                        SizedBox(height: 20),
                        CircularProgressIndicator(),
                      ]
                    ),
                  );
                }
                
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5EDD9),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                               
                                color: Colors.black.withAlpha(26),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              
                              Row(
                                children: [
                                  
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 30,
                                    child: Icon(
                                      Icons.restaurant,
                                      color: AppTheme.accentColor,
                                      size: 35,
                                    ),
                                  ),
                                  
                                  const SizedBox(width: 15),
                                  Text(
                                    '${user.firstName} ${user.lastName}',
                                    style: TextStyle(
                                      color: AppTheme.accentColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              
                           
                              _buildInfoRow('Nom', user.lastName ?? 'N/A'),
                              _buildInfoRow('Prénom', user.firstName ?? 'N/A'),
                              _buildInfoRow('Email', user.email),
                              _buildInfoRow('Role', user.role),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                       
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5EDD9),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                
                                color: Colors.black.withAlpha(26), 
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Commandes gérées',
                                    style: TextStyle(
                                      color: AppTheme.accentColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                    
                                      color: AppTheme.accentColor.withAlpha(51),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.receipt_long,
                                      color: AppTheme.accentColor,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              
                              
                              state.status == ProfileStatus.loading
                                  ? const Center(child: CircularProgressIndicator())
                                  : Text(
                                      state.stats?.handledOrders.toString() ?? '0',
                                      style: TextStyle(
                                        color: AppTheme.secondaryColor,
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                              
                             
                              Text(
                                '• Commandes traitées depuis ton inscription',
                                style: TextStyle(
                                 
                                  color: AppTheme.accentColor.withAlpha(179), 
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                     
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _showPasswordForm = !_showPasswordForm;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF5EDD9),
                            foregroundColor: AppTheme.accentColor,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text(
                            _showPasswordForm ? 'Annuler' : 'Changer le mot de passe',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        
                      
                        if (_showPasswordForm) ...[
                          const SizedBox(height: 20),
                          
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5EDD9),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  
                                  color: Colors.black.withAlpha(26), 
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: BlocListener<AuthBloc, AuthState>(
                              listener: (context, state) {
                                if (state.status == AuthStatus.error) {
                                 
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(state.errorMessage ?? 'Une erreur est survenue'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                } else if (state.status == AuthStatus.authenticatedWithError) {
                                 
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(state.errorMessage ?? 'Échec du changement de mot de passe'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                } else if (state.status == AuthStatus.authenticated && _showPasswordForm) {
                                  
                                  _currentPasswordController.clear();
                                  _newPasswordController.clear();
                                  _confirmPasswordController.clear();
                                  
                                  // Cachez le formulaire
                                  setState(() {
                                    _showPasswordForm = false;
                                  });
                                  
                                
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Mot de passe changé avec succès'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Changer le mot de passe',
                                    style: TextStyle(
                                      color: AppTheme.accentColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  
                                
                                  CustomInputField(
                                    hintText: 'Mot de passe actuel',
                                    obscureText: true,
                                    controller: _currentPasswordController,
                                  ),
                                  
                                  const SizedBox(height: 15),
                                  
                                  
                                  CustomInputField(
                                    hintText: 'Nouveau mot de passe',
                                    obscureText: true,
                                    controller: _newPasswordController,
                                    onChanged: (_) => _validateNewPassword(),
                                    errorText: !_passwordMinLength && _newPasswordController.text.isNotEmpty
                                        ? 'Minimum 8 caractères'
                                        : null,
                                  ),
                                  
                                  const SizedBox(height: 15),
                                  
                                 
                                  CustomInputField(
                                    hintText: 'Confirmer le nouveau mot de passe',
                                    obscureText: true,
                                    controller: _confirmPasswordController,
                                    onChanged: (_) => _validateNewPassword(),
                                    errorText: !_passwordsMatch && _confirmPasswordController.text.isNotEmpty
                                        ? 'Les mots de passe ne correspondent pas'
                                        : null,
                                  ),
                                  
                                  const SizedBox(height: 20),
                                  
                                  
                                  ElevatedButton(
                                    onPressed: () => _submitPasswordChange(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFF5EDD9),
                                      foregroundColor:AppTheme.secondaryColor,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: const Text(
                                      'Confirmer',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        
                        const SizedBox(height: 20),
                        
                        
                        ElevatedButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(LogoutRequested());
                            Navigator.of(context).pushReplacementNamed('/login');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF5EDD9),
                            foregroundColor: AppTheme.accentColor,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            'Déconnexion',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index != _currentIndex) {
          
            _navigateToScreen(context, index);
          }
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            '$label : ',
            style: TextStyle(
              color: AppTheme.accentColor,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              
              color: AppTheme.accentColor.withAlpha(204),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToScreen(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed('/home');
        break;
      case 1:
        Navigator.of(context).pushReplacementNamed('/orders');
        break;
      case 2:
        Navigator.of(context).pushReplacementNamed('/tables');
        break;
      case 3:
        
        break;
    }
  }
}
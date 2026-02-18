import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/user_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_nameController.text.isEmpty || 
        _usernameController.text.isEmpty || 
        _passwordController.text.isEmpty) {
      setState(() => _errorMessage = '请填写所有字段');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _errorMessage = '两次输入的密码不一致');
      return;
    }

    if (_passwordController.text.length < 6) {
      setState(() => _errorMessage = '密码长度至少6位');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final success = await ref.read(userProvider.notifier).register(
      _usernameController.text,
      _passwordController.text,
      _nameController.text,
    );

    if (mounted) {
      setState(() => _isLoading = false);
      
      if (success) {
        context.go('/onboarding');
      } else {
        setState(() => _errorMessage = '用户名已存在');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: AppSpacing.xl),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.record_voice_over,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                '开口易',
                style: AppTextStyles.headline1.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: '昵称',
                  prefixIcon: const Icon(Icons.badge_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: '用户名',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '密码',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '确认密码',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                ),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: AppColors.error),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('注册', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: () => context.go('/login'),
                child: Text(
                  '已有账号？去登录',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

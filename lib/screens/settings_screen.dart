import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/wallet_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/theme.dart';
import '../services/api_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _biometricsEnabled = false;
  
  Future<void> _updatePreference(String key, bool value) async {
    try {
      // Call API to update user preferences
      final response = await ApiService.updateUserPreferences({key: value});
      
      if (response['success'] == true) {
        // Update local state
        setState(() {
          if (key == 'notifications') {
            _notificationsEnabled = value;
          } else if (key == 'biometrics') {
            _biometricsEnabled = value;
          }
        });
      }
    } catch (e) {
      debugPrint('Error updating preference: $e');
    }
  }
  
  Future<void> _handleLogout() async {
    final walletProvider = context.read<WalletProvider>();
    
    try {
      // Show confirmation dialog
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to disconnect your wallet and log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.errorColor,
              ),
              child: const Text('Logout'),
            ),
          ],
        ),
      );
      
      if (confirmed == true) {
        // Call API to logout
        final response = await ApiService.logout();
        
        if (response['success'] == true) {
          // Disconnect wallet
          await walletProvider.disconnectWallet();
        }
      }
    } catch (e) {
      debugPrint('Error logging out: $e');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final walletProvider = context.watch<WalletProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final connectedWallet = walletProvider.connectedWallet;
    final theme = Theme.of(context);
    
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Settings',
                  style: theme.textTheme.displayLarge,
                ),
              ),
            ),
            
            SliverList(
              delegate: SliverChildListDelegate([
                // Account Section
                if (connectedWallet != null) ...[
                  _buildSectionHeader('Account', theme),
                  _buildSettingItem(
                    icon: Icons.person,
                    iconColor: AppTheme.primaryColor,
                    title: 'Profile',
                    subtitle: 'Manage your profile information',
                    onTap: () {},
                    theme: theme,
                  ),
                  _buildSettingItem(
                    icon: Icons.account_balance_wallet,
                    iconColor: AppTheme.primaryColor,
                    title: 'Connected Wallet',
                    subtitle: connectedWallet.shortAddress,
                    onTap: () {},
                    theme: theme,
                  ),
                  _buildSettingItem(
                    icon: Icons.key,
                    iconColor: AppTheme.primaryColor,
                    title: 'Security',
                    subtitle: 'Manage your security settings',
                    onTap: () {},
                    theme: theme,
                  ),
                  const SizedBox(height: 16),
                ],
                
                // Preferences Section
                _buildSectionHeader('Preferences', theme),
                _buildSettingItem(
                  icon: themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  iconColor: AppTheme.primaryColor,
                  title: 'Dark Mode',
                  subtitle: 'Toggle dark/light theme',
                  trailing: Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (value) {
                      themeProvider.toggleTheme();
                    },
                    activeColor: AppTheme.primaryColor,
                  ),
                  theme: theme,
                ),
                _buildSettingItem(
                  icon: Icons.notifications,
                  iconColor: AppTheme.primaryColor,
                  title: 'Notifications',
                  subtitle: 'Manage notification settings',
                  trailing: Switch(
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      _updatePreference('notifications', value);
                    },
                    activeColor: AppTheme.primaryColor,
                  ),
                  theme: theme,
                ),
                _buildSettingItem(
                  icon: Icons.language,
                  iconColor: AppTheme.primaryColor,
                  title: 'Language',
                  subtitle: 'English',
                  onTap: () {},
                  theme: theme,
                ),
                const SizedBox(height: 16),
                
                // Security Section
                _buildSectionHeader('Security', theme),
                _buildSettingItem(
                  icon: Icons.shield,
                  iconColor: AppTheme.primaryColor,
                  title: 'Privacy',
                  subtitle: 'Manage privacy settings',
                  onTap: () {},
                  theme: theme,
                ),
                _buildSettingItem(
                  icon: Icons.phone_android,
                  iconColor: AppTheme.primaryColor,
                  title: 'Biometric Authentication',
                  subtitle: 'Use Face ID or Touch ID',
                  trailing: Switch(
                    value: _biometricsEnabled,
                    onChanged: (value) {
                      _updatePreference('biometrics', value);
                    },
                    activeColor: AppTheme.primaryColor,
                  ),
                  theme: theme,
                ),
                const SizedBox(height: 16),
                
                // Support Section
                _buildSectionHeader('Support', theme),
                _buildSettingItem(
                  icon: Icons.help_center,
                  iconColor: AppTheme.primaryColor,
                  title: 'Help Center',
                  subtitle: 'Get help with the app',
                  onTap: () {},
                  theme: theme,
                ),
                _buildSettingItem(
                  icon: Icons.public,
                  iconColor: AppTheme.primaryColor,
                  title: 'About',
                  subtitle: 'Learn more about the app',
                  onTap: () {},
                  theme: theme,
                ),
                const SizedBox(height: 24),
                
                // Logout Button
                if (connectedWallet != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton.icon(
                      onPressed: _handleLogout,
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.errorColor.withOpacity(0.1),
                        foregroundColor: AppTheme.errorColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                
                // Version
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.brightness == Brightness.dark 
                            ? AppTheme.subtextColor 
                            : AppTheme.lightSubtextColor,
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }
  
  Widget _buildSettingItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    required ThemeData theme,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: theme.brightness == Brightness.dark 
                          ? AppTheme.textColor 
                          : AppTheme.lightTextColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.brightness == Brightness.dark 
                          ? AppTheme.subtextColor 
                          : AppTheme.lightSubtextColor,
                    ),
                  ),
                ],
              ),
            ),
            trailing ?? Icon(
              Icons.chevron_right,
              size: 20,
              color: theme.brightness == Brightness.dark 
                  ? AppTheme.subtextColor 
                  : AppTheme.lightSubtextColor,
            ),
          ],
        ),
      ),
    );
  }
}
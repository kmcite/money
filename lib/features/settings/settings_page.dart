import 'package:money/domain/repositories/dark_repository.dart';
import 'package:money/main.dart';

class SettingsBloc extends Bloc {
  late final darkRepository = depend<DarkRepository>();
  bool get dark => darkRepository.dark;
  void toggleDark() {
    darkRepository.setDark(!dark);
  }
}

class SettingsPage extends Feature<SettingsBloc> {
  @override
  SettingsBloc create() => SettingsBloc();

  const SettingsPage({super.key});

  @override
  Widget build(context, controller) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Appearance Section
          _SettingsSection(
            title: 'Appearance',
            children: [
              _SettingsTile(
                icon: Icon(Icons.palette),
                title: 'Theme',
                subtitle: controller.dark ? 'Dark mode' : 'Light mode',
                trailing: Switch(
                  value: controller.dark,
                  onChanged: (_) => controller.toggleDark(),
                ),
              ),
            ],
          ),

          SizedBox(height: 24),

          // App Information Section
          _SettingsSection(
            title: 'App Information',
            children: [
              _SettingsTile(
                icon: Icon(Icons.info),
                title: 'Version',
                subtitle: '1.0.0',
                trailing: null,
              ),
              _SettingsTile(
                icon: Icon(Icons.help),
                title: 'Help & Support',
                subtitle: 'Get help with the app',
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Implement help screen
                },
              ),
            ],
          ),

          SizedBox(height: 24),

          // Data Section
          _SettingsSection(
            title: 'Data',
            children: [
              _SettingsTile(
                icon: Icon(Icons.download),
                title: 'Export Data',
                subtitle: 'Export your transactions',
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Implement data export
                },
              ),
              _SettingsTile(
                icon: Icon(Icons.upload),
                title: 'Import Data',
                subtitle: 'Import transactions from file',
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Implement data import
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// UI Components for Settings Page
class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
          ),
        ),
        Card(
          elevation: 2,
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: icon,
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey[600]),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}

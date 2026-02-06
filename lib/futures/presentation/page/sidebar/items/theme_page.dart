import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:list_selection_widget/list_selection_widget.dart';

import '../../../cubit/theme_cubit.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({super.key});

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  final List<String> items = ['SYSTEM', 'LIGHT', 'DARK'];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final currentTheme = state.themeMode;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'THEMES',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            leading: BackButton(onPressed: () => context.pop()),
          ),
          body: Center(
            child: ListView.separated(
              itemCount: ThemeMode.values.length,
              separatorBuilder: (context, index) => const SizedBox(height: 20,),
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: CheckboxListTile(
                  title: Text(
                    items[index],
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  value: currentTheme == ThemeMode.values[index],
                  onChanged: (value) => context.read<ThemeCubit>().pickTheme(
                    ThemeMode.values[index],
                  ),
                  tileColor: Theme.of(context).colorScheme.secondary,
                  activeColor: Theme.of(context).colorScheme.onSurface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

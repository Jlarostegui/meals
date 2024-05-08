import 'package:demo/presentation/widgets/main_drawer.dart';
import 'package:demo/providers/providers.dart';
import 'package:demo/shared/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  // void _toggleMealFavoriteStatus(Meal meal) {
  //   setState(() {
  //     if (favoriteMeals.contains(meal)) {
  //       favoriteMeals.remove(meal);
  //       _showInfoMessage('Meal is no longer a favorite');
  //     } else {
  //       favoriteMeals.add(meal);
  //       _showInfoMessage('Marked as a favorite');
  //
  //   });
  // }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (context) => const FiltersScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = ref.watch(filteredMealsProvider);

    Widget activePage = CategoriesScreen(
      avaliableMeals: availableMeals,
    );

    String activePageTitle = 'Categories';
    if (_selectedPageIndex == 1) {
      final favoriteMeal = ref.watch(favoriteMealsProvider);

      activePage = MealScreen(meals: favoriteMeal);
      activePageTitle = 'Favorites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        onSlectedScreen: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.set_meal), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites')
        ],
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
      ),
    );
  }
}

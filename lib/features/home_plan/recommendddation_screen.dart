import 'dart:async';
import 'package:dream_home_user/common_widgets.dart/custom_button.dart';
import 'package:dream_home_user/common_widgets.dart/custom_search.dart';
import 'package:dream_home_user/features/home_plan/filter_screen.dart';
import 'package:dream_home_user/features/home_plan/home_plan_details.dart';
import 'package:dream_home_user/features/category/category_view_all_screen.dart';
import 'package:dream_home_user/common_widgets.dart/home_plan_card.dart';
import 'package:dream_home_user/features/home_plan/homeplans.dart';
import 'package:dream_home_user/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/web.dart';

import '../../common_widgets.dart/custom_alert_dialog.dart';
import 'homeplans_bloc/homeplans_bloc.dart';

class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({super.key});

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  final List<String> imageList = const [
    'assets/images/home1.jpg',
    'assets/images/home4.jpg',
    'assets/images/home2.jpg',
    'assets/images/home3.jpg',
  ];
  final HomeplansBloc _homeplansBloc = HomeplansBloc();

  Map<String, dynamic> params = {
    'query': null,
  };

  List<Map<String, dynamic>> _homeplans = [], _categories = [];

  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;
  bool _isScrollingManually = false;

  @override
  void initState() {
    getHomeplans();
    getCategoris();
    super.initState();
    _startTimer();
  }

  void getHomeplans() {
    _homeplansBloc.add(GetAllHomeplansEvent(params: params));
  }

  void getCategoris() {
    if (params['query'] == null) {
      _homeplansBloc.add(GetAllCategoriesEvent());
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted || _isScrollingManually) return;

      if (_pageController.hasClients) {
        if (_currentPage < imageList.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _homeplansBloc,
      child: BlocConsumer<HomeplansBloc, HomeplansState>(
        listener: (context, state) {
          if (state is HomeplansFailureState) {
            showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(
                title: 'Failure',
                description: state.message,
                primaryButton: 'Try Again',
                onPrimaryPressed: () {
                  getHomeplans();
                  getCategoris();
                  Navigator.pop(context);
                },
              ),
            );
          } else if (state is HomeplansGetSuccessState) {
            _homeplans = state.homeplans;
            Logger().w(_homeplans);
            setState(() {});
          } else if (state is CategoriesGetSuccessState) {
            _categories = state.categories;
            Logger().w(_categories);
            setState(() {});
          } else if (state is HomeplansSuccessState) {
            getHomeplans();
            getCategoris();
          }
        },
        builder: (context, state) {
          return ListView(
            padding: EdgeInsets.all(0),
            children: [
              NotificationListener<UserScrollNotification>(
                onNotification: (notification) {
                  if (notification.direction == ScrollDirection.idle) {
                    _isScrollingManually = false;
                  } else {
                    _isScrollingManually = true;
                  }
                  return false;
                },
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    SizedBox(
                      height: 370,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: imageList.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(imageList[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomSearch(
                              onSearch: (search) {
                                params['query'] = search;
                                getHomeplans();
                              },
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          CustomButton(
                              iconData: Icons.tune_outlined,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FilterScreen(
                                      categories: _categories,
                                    ),
                                  ),
                                );
                              })
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (params['query'] == null)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Categories',
                        style: TextStyle(
                            fontSize: 18,
                            color: onSecondaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Material(
                          borderRadius: BorderRadius.circular(16),
                          shadowColor: primaryColor,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            child: Text('View all'),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              if (state is HomeplansLoadingState)
                Center(
                  child: CircularProgressIndicator(),
                ),
              if (state is HomeplansGetSuccessState && _homeplans.isEmpty)
                Center(
                  child: Text("No Homeplan found!"),
                ),
              if (params['query'] == null)
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 0),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => CategoryCard(
                            title: _categories[index]['name'],
                            image: _categories[index]['image_url'],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Homeplans(
                                    categoryId: _categories[index]['id'],
                                  ),
                                ),
                              );
                            },
                          ),
                      separatorBuilder: (context, index) => const SizedBox(
                            width: 5,
                          ),
                      itemCount: _categories.length),
                ),
              const SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Text(
                  params['query'] == null ? 'Recommended' : 'Search',
                  style: TextStyle(
                    fontSize: 18,
                    color: onSecondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (state is HomeplansLoadingState)
                Center(
                  child: CircularProgressIndicator(),
                ),
              if (state is HomeplansGetSuccessState && _homeplans.isEmpty)
                Center(
                  child: Text("No Homeplan found!"),
                ),
              ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) => HomePlanCard(
                  cardData: _homeplans[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePlanDetail(
                          owend: _homeplans[index]['owned'],
                          homeplanId: _homeplans[index]['id'],
                        ),
                      ),
                    );
                  },
                ),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 15),
                itemCount: _homeplans.length,
              ),
            ],
          );
        },
      ),
    );
  }
}

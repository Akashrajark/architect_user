import 'package:dream_home_user/common_widgets.dart/custom_button.dart';
import 'package:dream_home_user/util/format_function.dart';
import 'package:flutter/material.dart';
import 'package:dream_home_user/common_widgets.dart/feature_card.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/web.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common_widgets.dart/custom_alert_dialog.dart';
import 'homeplans_bloc/homeplans_bloc.dart';

class HomePlanDetail extends StatefulWidget {
  final bool owend;
  final int homeplanId;
  const HomePlanDetail({
    super.key,
    required this.homeplanId,
    required this.owend,
  }); // Constructor with required parameter

  @override
  State<HomePlanDetail> createState() => _HomePlanDetailState();
}

class _HomePlanDetailState extends State<HomePlanDetail> {
  final HomeplansBloc _homeplansBloc = HomeplansBloc();
  late Razorpay _razorpay;
  Map<String, dynamic> _homeplan = {};
  List _floors = [];
  bool _isOwned = false;

  @override
  void initState() {
    _isOwned = widget.owend;
    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    getHomeplans();
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Successful: ${response.paymentId}")),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Failed: ${response.message}")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text("External Wallet Selected: ${response.walletName}")),
    );
  }

  void _startPayment({
    required int amount,
    required String name,
  }) {
    var options = {
      'key': 'rzp_test_7DHXFKNuMLiTBe', // Replace with your API Key
      'amount': amount * 100, // 100 INR (in paise)
      'name': name,
      'description': 'Test Payment',
      'prefill': {'contact': '9999999999', 'email': 'test@example.com'},
      'theme': {'color': '#3399cc'},
      'method': {
        'card': true, // Enable card payments
        'netbanking': false, // Disable net banking
        'upi': true, // Disable UPI (Google Pay, PhonePe, etc.)
        'wallet': false, // Disable wallets
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void getHomeplans() {
    _homeplansBloc.add(GetAllHomeplanByIdEvent(homeplanID: widget.homeplanId));
  }

  int getTotalBedrooms(List? properties) {
    if (properties == null || properties.isEmpty) {
      return 0; // Return 0 if the list is null or empty
    }

    return properties.fold(0, (sum, property) {
      int bedrooms =
          property['bedrooms'] ?? 0; // Default to 0 if 'bedrooms' is missing
      return sum + bedrooms;
    });
  }

  int getTotalBathroom(List? properties) {
    if (properties == null || properties.isEmpty) {
      return 0; // Return 0 if the list is null or empty
    }

    return properties.fold(0, (sum, property) {
      int bedrooms =
          property['bathrooms'] ?? 0; // Default to 0 if 'bedrooms' is missing
      return sum + bedrooms;
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

                  Navigator.pop(context);
                },
              ),
            );
          } else if (state is HomeplansGetByIdSuccessState) {
            _homeplan = state.homeplan;
            _floors = _homeplan['floors'];
            Logger().w(_homeplan);
            setState(() {});
          } else if (state is HomeplansSuccessState) {
            _isOwned = true;
            getHomeplans();
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  if (state is HomeplansLoadingState)
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  if (state is HomeplansGetSuccessState && _homeplan.isEmpty)
                    Center(
                      child: Text("No Homeplan found!"),
                    ),
                  Stack(
                    children: [
                      if (_homeplan['image_url'] != null)
                        Image.network(
                          _homeplan['image_url'],
                          fit: BoxFit.cover,
                          height: 400,
                          width: double.infinity,
                        ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 40),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: CircleAvatar(
                            radius: 15,
                            child: Icon(Icons.chevron_left),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formatValue(_homeplan['name']),
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Wrap(
                          runSpacing: 10,
                          spacing: 10,
                          children: [
                            FeatureCard(
                              text: "${getTotalBedrooms(_floors)} Bed",
                              icon: Icons.bed,
                            ),
                            FeatureCard(
                              icon: Icons.bathtub,
                              text: "${getTotalBathroom(_floors)} Bath",
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundImage: _homeplan['architect']?['photo'] !=
                                    null
                                ? NetworkImage(_homeplan['architect']?['photo'])
                                : null,
                          ),
                          title: Text(
                              formatValue(_homeplan['architect']?['name'])),
                          subtitle: Text(
                              formatValue(_homeplan['architect']?['email'])),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Description',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          formatValue(_homeplan['description']),
                          style: TextStyle(fontSize: 14.0),
                        ),
                        const SizedBox(height: 20),
                        ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.only(bottom: 100),
                          shrinkWrap: true,
                          itemBuilder: (context, index) => FloorCard(
                            floorDetails: _floors[index],
                          ),
                          separatorBuilder: (context, index) => SizedBox(
                            height: 30,
                          ),
                          itemCount: _floors.length,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomSheet: _isOwned
                ? Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CustomButton(
                      inverse: true,
                      onPressed: () {
                        launchWhatsApp(
                            phone: _homeplan['architect']['phone'],
                            message: _homeplan['name']);
                      },
                      label: 'Message',
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                    ),
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₹${formatInteger(_homeplan['price'])}',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _startPayment(
                              amount: _homeplan['price'],
                              name: _homeplan['name'],
                            );
                            _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
                                (response) {
                              BlocProvider.of<HomeplansBloc>(context).add(
                                AddHomeplanEvent(
                                  homeplanDetails: {
                                    'home_plan_id': _homeplan['id'],
                                    'user_id': Supabase
                                        .instance.client.auth.currentUser!.id,
                                    'amount': _homeplan['price'],
                                  },
                                ),
                              );
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: Text('Buy Now'),
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}

void launchWhatsApp({required String phone, required String message}) async {
  final Uri url =
      Uri.parse("https://wa.me/$phone?text=${Uri.encodeComponent(message)}");

  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch WhatsApp';
  }
}

class FloorCard extends StatelessWidget {
  final Map<String, dynamic> floorDetails;
  const FloorCard({
    super.key,
    required this.floorDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          formatValue(floorDetails['name']).toUpperCase(),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          runSpacing: 10,
          spacing: 10,
          children: [
            FeatureCard(
              text: "${formatValue(floorDetails['bedrooms'])} Bed",
              icon: Icons.bed,
            ),
            FeatureCard(
              icon: Icons.bathtub,
              text: "${formatValue(floorDetails['bathrooms'])} Bath",
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          formatValue(floorDetails['description']),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 10),
        Text(
          'Image',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        if (floorDetails['image_url'] != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              floorDetails['image_url'],
              fit: BoxFit.cover,
            ),
          ),
      ],
    );
  }
}

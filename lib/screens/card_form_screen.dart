import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '/blocs/blocs.dart';

class CardFormScreen extends StatelessWidget {
  const CardFormScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pay with a Credit Card'),
      ),
      body: BlocBuilder<PaymentBloc, PaymentState>(
        builder: (context, state) {
          CardFormEditController controller = CardFormEditController(
            initialDetails: state.cardFieldInputDetails,
          );

          if (state.status == PaymentStatus.initial) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Card Form',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  const SizedBox(height: 20),
                  CardFormField(controller: controller),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      (controller.details.complete)
                          ? context.read<PaymentBloc>().add(
                                const PaymentCreateIntent(
                                  billingDetails: BillingDetails(
                                    email: 'massimo@maxonflutter.com',
                                  ),
                                  items: [
                                    {'id': '0'},
                                    {'id': '1'},
                                    {'id': '1'},
                                    {'id': '1'},
                                    {'id': '1'},
                                    {'id': '2'},
                                  ],
                                ),
                              )
                          : ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('The form is not complete.'),
                              ),
                            );
                    },
                    child: const Text('Pay'),
                  ),
                ],
              ),
            );
          }
          if (state.status == PaymentStatus.success) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('The payment is successful.'),
                const SizedBox(
                  height: 10,
                  width: double.infinity,
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<PaymentBloc>().add(PaymentStart());
                  },
                  child: const Text('Back to Home'),
                ),
              ],
            );
          }
          if (state.status == PaymentStatus.failure) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('The payment failed.'),
                const SizedBox(
                  height: 10,
                  width: double.infinity,
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<PaymentBloc>().add(PaymentStart());
                  },
                  child: const Text('Try again'),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

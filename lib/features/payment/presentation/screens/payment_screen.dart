import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/payment_bloc.dart';
import '../bloc/payment_event.dart';
import '../bloc/payment_state.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    context.read<PaymentBloc>().add(InitializePaymentEvent(args));
  }

  String _formatPrice(double price) {
    return price.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state is PaymentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is PaymentSuccess) {
            Navigator.pushReplacementNamed(context, '/payment-success');
          }
        },
        builder: (context, state) {
          if (state is PaymentLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PaymentInitialized) {
            return _buildPaymentDetails(context, state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildPaymentDetails(BuildContext context, PaymentInitialized state) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.horizontalPadding,
        vertical: Responsive.verticalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildPaymentCard(context, state),
          const Spacer(),
          PrimaryButton(
            onTap: () => context.read<PaymentBloc>().add(
                  ProcessPaymentEvent(state.sessionDetails.paymentIntentId),
                ),
            text: 'Pay Now',
            width: double.infinity,
            height: Responsive.buttonHeight,
          ),
          SizedBox(height: Responsive.spacingHeight),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(BuildContext context, PaymentInitialized state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              state.event.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              'Price per ticket:',
              'IDR ${_formatPrice(state.event.ticketPrice)}',
            ),
            _buildInfoRow(
              'Quantity:',
              '${state.ticketCount} tickets',
            ),
            const Divider(height: 24),
            _buildInfoRow(
              'Total Amount:',
              'IDR ${_formatPrice(state.event.ticketPrice * state.ticketCount)}',
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Theme.of(context).primaryColor : null,
            ),
          ),
        ],
      ),
    );
  }
}

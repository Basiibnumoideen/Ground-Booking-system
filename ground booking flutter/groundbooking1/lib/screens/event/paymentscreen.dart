import 'package:flutter/material.dart';
import 'package:demo123/provider/commonProvider.dart';
import 'package:demo123/utils.dart';
import 'package:demo123/widjents/textfield.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen(
      {super.key,
      required this.purpose,
      required this.amount,
      required this.date});
  final purpose;
  final amount;
  final date;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

String selectedPaymentMethod = 'UPI';

class _PaymentScreenState extends State<PaymentScreen> {
  TextEditingController accNoController = TextEditingController();
  TextEditingController ifscController = TextEditingController();

  TextEditingController pinController = TextEditingController();

  TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<CommonProvider>(context, listen: false);
    amountController.text = widget.amount;
    accNoController.text = accountdetails[0]['account_number'];
    ifscController.text = accountdetails[0]['IFSC'];

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF108554),
        title: const Text(
          'Proceed To Pay:',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
              prefixIcon: const Icon(Icons.account_balance_rounded),
              controller: accNoController,
              labelText: 'Acc No',
              readonly: true,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              prefixIcon: const Icon(Icons.account_balance_outlined),
              controller: ifscController,
              labelText: 'IFSC CODE',
              readonly: true,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              prefixIcon: const Icon(Icons.currency_rupee_sharp),
              controller: amountController,
              labelText: 'Amount',
              readonly: true,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              prefixIcon: const Icon(Icons.more_horiz_rounded),
              controller: pinController,
              labelText: 'Enter Your Pin',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (pinController.text == accountdetails[0]['key']) {
                  if (int.parse(accountdetails[0]['amount']) >
                      int.parse(widget.amount)) {
                    print('Payment method selected: $selectedPaymentMethod');
                    storeDataToApiWithIdAndToken({
                      'purpose': widget.purpose,
                      'membid': memuid,
                      'bookdate': widget.date,
                      'bookeddate': DateTime.now().toString().substring(0, 10),
                      'amount': widget.amount,
                    }, context, provider);
                    await updateBalanceAmount(widget.amount, context, provider);

                    pinController.clear();
                    accNoController.clear();
                    ifscController.clear();
                    amountController.text = 'amount';
                  } else {
                    provider.showSnackbar(
                        context, 'insuffisent balance', Colors.red);
                  }
                } else {
                  provider.showSnackbar(context, 'invalid pin', Colors.red);
                }

                // You can add logic for handling the payment process here
              },
              child: const Text('Pay'),
            ),
          ],
        ),
      ),
    );
  }
}

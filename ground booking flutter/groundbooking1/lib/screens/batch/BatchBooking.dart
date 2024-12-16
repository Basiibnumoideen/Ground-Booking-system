import 'package:demo123/provider/commonProvider.dart';
import 'package:demo123/utils.dart';
import 'package:demo123/widjents/textfield.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

DateTime? selectedDate;
DateTime? fromDate;
DateTime? toDate;
Duration? duration;

class BatchBooking extends StatefulWidget {
  const BatchBooking(
      {super.key,
      required this.batch,
      required this.batchTime,
      required this.item,
      required this.amount,
      required this.id});

  final batch;
  final batchTime;
  final item;
  final amount;
  final id;

  @override
  State<BatchBooking> createState() => _BatchBookingState();
}

class _BatchBookingState extends State<BatchBooking> {
  TextEditingController itemController = TextEditingController();

  TextEditingController batchController = TextEditingController();

  TextEditingController fromController = TextEditingController();

  TextEditingController toController = TextEditingController();

  TextEditingController timeController = TextEditingController();

  TextEditingController amounController = TextEditingController();
  TextEditingController pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<CommonProvider>(context, listen: false);
    batchController.text = widget.batch;
    timeController.text = widget.batchTime;
    itemController.text = widget.item;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF108554),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.batchTime,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                prefixIcon: const Icon(Icons.sports_esports_rounded),
                readonly: true,
                labelText: 'Sports Item',
                controller: itemController,
              ),
              const SizedBox(
                height: 5,
              ),
              CustomTextField(
                prefixIcon: const Icon(Icons.batch_prediction),
                readonly: true,
                labelText: 'Batch',
                controller: batchController,
              ),
              const SizedBox(
                height: 5,
              ),
              CustomTextField(
                prefixIcon: const Icon(Icons.timelapse),
                readonly: true,
                labelText: 'Time',
                controller: timeController,
              ),
              const SizedBox(
                height: 5,
              ),
              CustomTextField(
                hintText: 'YYYY-MM-DD',
                labelText: 'From Date',
                prefixIcon: IconButton(
                    onPressed: () {
                      _selectDate(context, () {
                        fromController.text =
                            selectedDate.toString().substring(0, 10);

                        fromDate = selectedDate;
                        toController.clear();
                        duration = selectedDate!.difference(fromDate!);
                        print('Duration in days: ${duration!.inDays}');
                        int days = duration!.inDays;
                        print('object');
                        int amount =
                            int.parse(widget.amount); // Convert String to int
                        print('object1');
                        int total = days * amount;
                        amounController.text = total.toString();
                        print(total);
                      });
                    },
                    icon: const Icon(Icons.calendar_month_sharp)),
                controller: fromController,
              ),
              const SizedBox(
                height: 5,
              ),
              CustomTextField(
                hintText: 'YYYY-MM-DD',
                labelText: 'To Date',
                prefixIcon: IconButton(
                    onPressed: () {
                      _selectDate(context, () {
                        toController.text =
                            selectedDate.toString().substring(0, 10);
                        toDate = selectedDate;
                        duration = selectedDate!.difference(fromDate!);
                        print('Duration in days: ${duration!.inDays}');
                        int days = duration!.inDays;
                        print('object');
                        int amount =
                            int.parse(widget.amount); // Convert String to int
                        print('object1');
                        int total = days * amount;
                        amounController.text = total.toString();
                        print(total);
                      });
                    },
                    icon: const Icon(Icons.calendar_month_sharp)),
                controller: toController,
              ),
              const SizedBox(
                height: 5,
              ),
              CustomTextField(
                prefixIcon: const Icon(Icons.currency_rupee_sharp),
                readonly: true,
                labelText: 'Amount',
                controller: amounController,
              ),
              const SizedBox(
                height: 5,
              ),
              CustomTextField(
                prefixIcon: const Icon(Icons.more_horiz_rounded),
                labelText: 'Enter pin',
                controller: pinController,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  height: 40,
                  width: 200,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (amounController.text != '0') {
                          if (pinController.text == accountdetails[0]['key']) {
                            if (int.parse(accountdetails[0]['amount']) >
                                int.parse(widget.amount)) {
                              if (int.parse(amounController.text) >= 0) {
                                await batchBooking({
                                  'membid': memuid,
                                  'batchid': widget.id,
                                  'fromdate': fromController.text,
                                  'todate': toController.text,
                                  'amount': amounController.text,
                                  'Sportsitem': itemController.text,
                                  'batch': batchController.text,
                                  'batchtime': timeController.text,
                                }, context, provider);
                                await updateBalanceAmount(
                                    amounController.text, context, provider);
                              } else {
                                provider.showSnackbar(context,
                                    'Please Select a Valid date', Colors.red);
                              }
                            } else {
                              provider.showSnackbar(
                                  context, 'insuffisent balance', Colors.red);
                            }
                          } else {
                            provider.showSnackbar(
                                context, 'invalid pin', Colors.red);
                          }
                        } else {
                          provider.showSnackbar(
                              context, 'fill all fields', Colors.red);
                        }
                      },
                      child: const Text('Register')))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, setdata) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (pickedDate != null) {
      selectedDate = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
      );

      setState(setdata);
    }
  }
}

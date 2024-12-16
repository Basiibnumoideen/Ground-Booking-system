import 'package:demo123/provider/commonProvider.dart';
import 'package:demo123/utils.dart';
import 'package:flutter/material.dart';
import 'package:demo123/screens/event/paymentscreen.dart';
import 'package:demo123/widjents/textfield.dart';
import 'package:provider/provider.dart';

// List<String> purposeList = [
//   'selectPurpose',
//   'marriage',
//   'party',
//   'sports',
//   'festival',
// ];

DateTime? selectedDateTime;

class GroundBookingScreen extends StatefulWidget {
  const GroundBookingScreen({super.key});

  @override
  State<GroundBookingScreen> createState() => _GroundBookingScreenState();
}

class _GroundBookingScreenState extends State<GroundBookingScreen> {
  String selectedPuspose = 'select';
  String selectedpurposeId = '0';
  bool isDateSelected = false;
  TextEditingController datecontroller = TextEditingController();
  TextEditingController amountContrpller = TextEditingController();
  Set<String> dropDownListValues = {};

  @override
  void initState() {
    getDatas();
    super.initState();
  }

  void getDatas() async {
    await getDropdownListFromApi();
    await getDatesFromApi();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<CommonProvider>(context, listen: false);
    dropDownListValues.add('select');
    for (Map purpose in dropDownList) {
      dropDownListValues.add(purpose['purpose_name']);
      if (purpose['purpose_name'] == selectedPuspose) {
        amountContrpller.text = purpose['payment_perday'].toString();
        selectedpurposeId = purpose['purposeid'].toString();
      }
    }

    print('dropdown list  $dropDownListValues');
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Book your Event',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF108554),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: Colors.black)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                  focusColor: Colors.transparent,
                  underline: const SizedBox(),
                  isExpanded: true,
                  elevation: 0,
                  value: selectedPuspose,
                  onChanged: (String? newValue) {
                    setState(() {
                      amountContrpller.text = 'Amount';
                      selectedPuspose = newValue!;
                    });
                  },
                  items: dropDownListValues
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              labelText: 'Date',
              prefixIcon: IconButton(
                  onPressed: () {
                    _selectDate(context);
                  },
                  icon: const Icon(Icons.calendar_month_sharp)),
              controller: datecontroller,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              readonly: true,
              labelText: 'Amount',
              controller: amountContrpller,
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () async {
                  if (dateList.contains(datecontroller.text)) {
                    provider.showSnackbar(
                        context, 'this date already booked', Colors.red);
                  } else if (selectedPuspose != 'select' &&
                      amountContrpller.text != 'Amount' &&
                      selectedDateTime != null) {
                    await getaccNoIfsc(memuid);
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PaymentScreen(
                        amount: amountContrpller.text,
                        date: datecontroller.text,
                        purpose: selectedpurposeId,
                      ),
                    ));
                  } else {
                    provider.showSnackbar(
                        context, 'fielsd can\'t be empty', Colors.red);
                  }
                },
                child: const Text("Pay Now"))
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (pickedDate != null) {
      final DateTime combinedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
      );

      setState(() {
        selectedDateTime = combinedDateTime;
        datecontroller.text = combinedDateTime.toString().substring(0, 10);
        isDateSelected = true;
      });
    }
  }
}

import 'package:demo123/utils.dart';
import 'package:flutter/material.dart';

class MyBookings extends StatelessWidget {
  const MyBookings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF108554),
        title: const Text('My Bookings', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/eventbg.png'),
                fit: BoxFit.cover)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: myBookingList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        title: Text(myBookingList[index]['purpose'].toString()),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Date: ${myBookingList[index]['bookdate']}'),
                            Text('₹ : ${myBookingList[index]['amount']}'),
                            Text(
                                'Payment Status: ${myBookingList[index]['paymentstatus']}'),
                          ],
                        ),
                        trailing: Column(
                          children: [
                            Text(
                              myBookingList[index]['bookeddate'].toString(),
                            ),
                            Text(
                              myBookingList[index]['bookstatus'].toString(),
                              style: TextStyle(
                                  color: myBookingList[index]['bookstatus'] ==
                                          'Pending'
                                      ? Colors.yellow
                                      : myBookingList[index]['bookstatus'] ==
                                              'Approved'
                                          ? Colors.green
                                          : Colors.red
                                  // Default color if none of the conditions are met
                                  ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

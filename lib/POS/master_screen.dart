import 'package:flutter/material.dart';

class MasterScreen extends StatefulWidget {
  const MasterScreen({super.key});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text("POS"),
      ),
      body: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 250.0,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        direction: Axis.horizontal,
                        runSpacing: 5.0,
                        spacing: 5.0,
                        children: List.generate(
                          50,
                          (index) {
                            return Container(
                              width: 100.0,
                              padding: const EdgeInsets.symmetric(vertical: 15.0),
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(15.0)),
                              child: Text(
                                "Item $index",
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        direction: Axis.horizontal,
                        runSpacing: 5.0,
                        spacing: 5.0,
                        children: List.generate(
                          50,
                              (index) {
                            return Container(
                              width: 100.0,
                              padding: const EdgeInsets.symmetric(vertical: 15.0),
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(15.0)),
                              child: Text(
                                "Item $index",
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              child: Column(
            children: [
              Expanded(
                child: Container(),
              ),
              Row(
                children: [
                  Expanded(child: inputWidget()),
                  Expanded(child: inputWidget()),
                ],
              )
            ],
          ))
        ],
      ),
    );
  }

  Widget inputWidget() {
    return Column(
      children: [
        Row(
          children: [
            buttonWidget(title: "Clear"),
            buttonWidget(title: "View Receipt"),
            buttonWidget(title: "void Receipt"),
          ],
        ),
        Row(
          children: [
            buttonWidget(title: "7"),
            buttonWidget(title: "8"),
            buttonWidget(title: "9"),
          ],
        ),
        Row(
          children: [
            buttonWidget(title: "4"),
            buttonWidget(title: "5"),
            buttonWidget(title: "6"),
          ],
        ),
        Row(
          children: [
            buttonWidget(title: "1"),
            buttonWidget(title: "2"),
            buttonWidget(title: "3"),
          ],
        ),
        Row(
          children: [
            buttonWidget(title: "0"),
            buttonWidget(title: "."),
            buttonWidget(title: ""),
          ],
        ),
      ],
    );
  }

  Widget buttonWidget({required String title}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(8.0)),
          child: Text(title),
        ),
      ),
    );
  }
}

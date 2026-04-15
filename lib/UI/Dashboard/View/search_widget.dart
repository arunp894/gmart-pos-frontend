import 'package:gmart/Constant/app_color.dart';
import 'package:gmart/Core/application_base.dart';
import 'package:gmart/UI/Dashboard/Model/scanned_product_response_model.dart';
import 'package:gmart/UI/Dashboard/ViewModel/dashboard_view_model.dart';
import 'package:gmart/Utils/text_decorator.dart';

class SearchWidget extends StatefulWidget {
  final Function(ScanProduct details) onSearchDone;
  final Function(bool close) onClose;

  const SearchWidget(
      {super.key, required this.onSearchDone, required this.onClose});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  DashboardViewModel? model;
  TextEditingController searchCtrl = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final keyLoader = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BaseView<DashboardViewModel>(
      prepareModel: (model) {
        this.model = model;
      },
      builder: (context, model, child) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    children: [
                      Text(
                        "Search\nProducts",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColor.blackColor,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                      Expanded(
                        child: TextFormField(
                          // textInputAction: TextInputAction.none,
                          // canRequestFocus: true,
                          // onEditingComplete: () => onSearch,
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          controller: searchCtrl,
                          // focusNode: _focusNode,
                          onChanged: onSearch,
                          decoration: textDecorator(
                              label: "Search",
                              suffixIcon: InkResponse(
                                radius: 5.0,
                                onTap: () {
                                  // Focus.of(context).unfocus();
                                  setState(() {
                                    searchCtrl.text = "";
                                  });
                                  widget.onClose(false);
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(10.0),
                                  decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle),
                                  child: Icon(
                                    Icons.clear,
                                    size: 20.0,
                                    color: AppColor.whiteColor,
                                  ),
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Expanded(
                    child: model.scannedProduct.isNotEmpty
                        ? GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 2.0,
                                    mainAxisSpacing: 2.0,
                                    crossAxisCount: 10,
                                    mainAxisExtent: 60.0),
                            itemCount: model.scannedProduct.length,
                            itemBuilder: (context, index) {
                              return InkResponse(
                                radius: 5.0,
                                onTap: () {
                                  Navigator.of(context).pop();
                                  widget.onSearchDone(
                                      model.scannedProduct[index]);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15.0, horizontal: 10.0),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      model.scannedProduct[index].name ?? "",
                                      style:
                                          TextStyle(color: AppColor.whiteColor),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: Text("No Records Found"),
                          ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void onSearch(String value) async {
    if (searchCtrl.text.isNotEmpty) {
      await model!
          .getProductBySearch(
        searchKey: searchCtrl.text,
        // keyLoader: keyLoader,
        // context: context)
      )
          .then(
        (value) {
          // _focusNode.requestFocus();
        },
      );
    }
  }
}

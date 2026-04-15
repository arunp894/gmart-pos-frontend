import 'package:gmart/Constant/app_color.dart';
import 'package:gmart/Core/application_base.dart';
import 'package:gmart/UI/Stock/ViewModel/stock_view_model.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  StockViewModel? model;

  @override
  Widget build(BuildContext context) {
    return BaseView<StockViewModel>(
      prepareModel: (model) {
        this.model = model;
      },
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 0.0,
            elevation: 0.0,
          ),
          body: Row(
            children: [
              Scrollbar(
                thickness: 5.0,
                interactive: true,
                thumbVisibility: true,
                radius: const Radius.circular(8.0),
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 0.0,
                      mainAxisSpacing: 2.0,
                      crossAxisCount: 5,
                      mainAxisExtent: 60.0),
                  itemCount: model.categoryProduct!.length,
                  itemBuilder: (context, index) {
                    return InkResponse(
                      onTap: () async {
                        // setState(() {
                        //   selectedCategoryId =
                        //       model.categoryProduct![index].id ?? 1;
                        // });
                        // await model
                        //     .getProductList(
                        //     categoryId: selectedCategoryId,
                        //     page: 1,
                        //     context: context,
                        //     keyLoader: keyLoader,
                        //     isInitial: false)
                        //     .then(
                        //       (value) {
                        //     setState(() {});
                        //   },
                        // );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 2.0),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 10.0),
                        decoration: BoxDecoration(
                          // color: selectedCategoryId ==
                          //     model.categoryProduct![index].id
                          //     ? Colors.orange
                          //     : Colors.red,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Center(
                          child: Text(
                            model.categoryProduct![index].name ?? "",
                            style: TextStyle(color: AppColor.whiteColor),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  InputDecoration boxDecoration() {
    return const InputDecoration(
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
    );
  }

  Widget categorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8),
          child: Text('Category',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w800)),
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            padding: const EdgeInsets.all(8.0),
            children: List.generate(6, (index) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.green[600],
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Center(
                  child: Text('Item ${index + 1}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(fontSize: 14.0, color: Colors.white)),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget stockSection() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 19.0, vertical: 19.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Stock',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8.0),

            Row(
              children: [
                SizedBox(
                  width: 300.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Name',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),
                      TextFormField(decoration: boxDecoration()),
                    ],
                  ),
                ),
                const SizedBox(width: 16.0),
                SizedBox(
                  width: 300.0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Brand : ',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 30.0,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 8.0),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black54),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),

            Row(
              children: [
                SizedBox(
                  width: 300.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Subcategory',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),
                      DropdownButtonFormField<String>(
                        decoration: boxDecoration(),
                        items: const [
                          DropdownMenuItem(
                              value: 'option1',
                              child: Text(
                                'Option 1',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )),
                          DropdownMenuItem(
                              value: 'option2',
                              child: Text(
                                'Option 2',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )),
                        ],
                        onChanged: (value) {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16.0),
                SizedBox(
                  width: 300.0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Category : ',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 30.0,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 8.0),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black54),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),

            // Business Location
            SizedBox(
              width: 300.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Business Location'),
                  const SizedBox(height: 4.0),
                  TextFormField(decoration: boxDecoration()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget priceLevelSection() {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 19.0, vertical: 19.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Price Level',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                SizedBox(
                  width: 300.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tax',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),
                      DropdownButtonFormField<String>(
                        decoration: boxDecoration(),
                        items: const [
                          DropdownMenuItem(
                              value: 'tax1',
                              child: Text(
                                'Tax 1',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )),
                          DropdownMenuItem(
                            value: 'tax2',
                            child: Text(
                              'Tax 2',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                        onChanged: (value) {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 300.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selling Price Tax',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),
                      DropdownButtonFormField<String>(
                        decoration: boxDecoration(),
                        items: const [
                          DropdownMenuItem(
                              value: 'spt1',
                              child: Text(
                                'SP Tax 1',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )),
                          DropdownMenuItem(
                              value: 'spt2',
                              child: Text(
                                'SP Tax 2',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )),
                        ],
                        onChanged: (value) {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                SizedBox(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Barcode',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),
                      TextFormField(decoration: boxDecoration()),
                    ],
                  ),
                ),
                const SizedBox(width: 16.0),
                SizedBox(
                  width: 300.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Product Code',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),
                      TextFormField(decoration: boxDecoration()),
                    ],
                  ),
                ),
                const SizedBox(width: 16.0),
                SizedBox(
                  width: 300.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Unit',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),
                      DropdownButtonFormField<String>(
                        decoration: boxDecoration(),
                        items: const [
                          DropdownMenuItem(
                            value: 'unit1',
                            child: Text(
                              'Unit 1',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          DropdownMenuItem(
                              value: 'unit2',
                              child: Text(
                                'Unit 2',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )),
                        ],
                        onChanged: (value) {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomButtons() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 8, bottom: 8),
      child: Row(
        children: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
            child: const Text('Add',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 8.0),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text('Modify',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 8.0),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text('Delete',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Row(
          children: [
            Container(
              width: 340.0,
              color: Colors.grey.shade200,
              child: categorySection(),
            ),
            Expanded(
              child: Container(
                color: Colors.grey.shade200,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Products',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            child: ListView(
                              padding: const EdgeInsets.all(8),
                              children: [
                                stockSection(),
                                const SizedBox(height: 30),
                                priceLevelSection(),
                                const SizedBox(height: 80),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Fixed bottom buttons
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Colors.grey.shade200,
                        padding:
                            const EdgeInsets.only(left: 8, bottom: 8, top: 8),
                        child: bottomButtons(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

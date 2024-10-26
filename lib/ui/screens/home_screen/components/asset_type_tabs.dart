import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/route_manager.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:trader_app/constants/color_palate.dart';
import 'package:trader_app/constants/enums.dart';
import 'package:trader_app/core/view_models/home_viewmodel.dart';
import 'package:trader_app/ui/screens/home_screen/components/symbol_search_dialog.dart';

class AssetTypeTabs extends StatelessWidget {
  const AssetTypeTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorPalate.background,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      margin: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: GetBuilder<HomeViewModel>(
          id: 'asset_type_tabs',
          builder: (controller) => Row(
            children: [
              for (AssetType assetType in AssetType.values)
                TextButton(
                    style:
                        TextButton.styleFrom(overlayColor: Colors.transparent),
                    onPressed: () {
                      if (!controller.liveTradesLoading) {
                        controller.handleChangeAssetType(assetType);
                      }
                    },
                    child: Text(
                      assetType.title,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(
                              controller.assetType == assetType ? 1 : 0.45)),
                    )),
              const Spacer(),
              if (controller.assetType == AssetType.stock)
                IconButton(
                    onPressed: () {
                      handleShowSearchBottomSheet(context);
                    },
                    icon: const Icon(Icons.search_rounded))
            ],
          ),
        ),
      ),
    );
  }

  void handleShowSearchBottomSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
        context: context, builder: (context) => SymbolSearchDialog());
  }
}

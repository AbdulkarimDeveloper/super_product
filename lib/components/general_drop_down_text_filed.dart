import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

const double BORDER_RADUIS = 8;

class GeneralDropDownTextFiled<T> extends StatefulWidget {
  final String? Function(T?)? validate;
  final Widget? prefixIcon;
  final Widget? subfixIcon;
  final List<T> list;
  final Function(T) getLabel;
  final T? value;
  final double rad;
  final double height;
  final Color? labelColor;
  final Color? textColor;
  final Color? borderColor;
  final String? hintText;
  final EdgeInsetsGeometry? contentPadding;
  final AutovalidateMode autovalidateMode;
  final bool? isDense;
  final bool? readOnly;
  final bool showLabel;
  final bool isExpanded;
  final Function(T?)? onChange;

  final bool enableSearchBox;
  final bool Function(T? item, String searchText)? onSearchMatch;

  final bool enableMultiSelection;
  final List<T>? multiSectionList;
  final dynamic Function(T item)? compareMultiSelection;
  final void Function(List<T> list)? onMultiSectionListChanged;
  final Widget Function(T item)? customDropDownItem;
  final bool disable;

  const GeneralDropDownTextFiled({
    super.key,
    required this.list,
    this.showLabel = true,
    this.height = 1,
    required this.getLabel,
    this.readOnly = false,
    this.contentPadding,
    this.isDense,
    this.rad = BORDER_RADUIS,
    this.borderColor,
    required this.onChange,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.labelColor,
    this.textColor,
    this.value,
    this.validate,
    this.subfixIcon,
    this.prefixIcon,
    this.disable = false,
    this.isExpanded = false,
    this.enableSearchBox = false,
    this.onSearchMatch,
    this.enableMultiSelection = false,
    this.onMultiSectionListChanged,
    this.customDropDownItem,
    this.multiSectionList,
    this.compareMultiSelection,
    this.hintText,
  }) : assert(
         !(enableMultiSelection == true && compareMultiSelection == null),
         'You must add compareMultiSelection logic if you want to enable multiSection',
       );
  @override
  State<GeneralDropDownTextFiled<T>> createState() =>
      _GeneralDropDownTextFiledState<T>();
}

class _GeneralDropDownTextFiledState<T>
    extends State<GeneralDropDownTextFiled<T>> {
  late TextEditingController searchController;
  List<T> _multiSelectionList = [];

  @override
  void initState() {
    searchController = TextEditingController();
    if (widget.enableMultiSelection) {
      if (widget.multiSectionList != null) {
        _multiSelectionList = widget.multiSectionList!;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(platform: TargetPlatform.android),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField2<T>(
              iconStyleData: IconStyleData(iconSize: 0),
              customButton: !widget.enableMultiSelection ? null : SizedBox(),
              items: widget.list.map((T category) {
                return DropdownMenuItem<T>(
                  value: category,
                  enabled: widget.enableMultiSelection ? false : true,
                  child: widget.enableMultiSelection
                      ? SizedBox()
                      : widget.customDropDownItem != null
                      ? widget.customDropDownItem!(category)
                      : Text("${widget.getLabel(category)}"),
                );
              }).toList(),
              isExpanded: widget.isExpanded,
              onChanged: widget.disable ? null : widget.onChange,
              //<Search section
              dropdownSearchData: !widget.enableSearchBox
                  ? null
                  : DropdownSearchData(
                      searchController: searchController,
                      searchInnerWidgetHeight: 60,
                      // searchInnerWidget: _searchBox(),
                      searchMatchFn: widget.onSearchMatch != null
                          ? (item, searchValue) {
                              return widget.onSearchMatch!(
                                item.value,
                                searchValue,
                              );
                            }
                          : null,
                    ),
              onMenuStateChange: (isOpen) {
                if (!isOpen) {
                  searchController.clear();
                }
              },
              //Search section/>
              style: TextStyle(
                height: widget.height,
                color: Colors.blue,
                fontSize: 17,
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: widget.validate,
              // selectedItemBuilder: widget.enableMultiSelection
              //     ? (context) => _multiSelectedItems()
              //     : null,
              value: widget.enableMultiSelection
                  ? _multiSelectionList.isEmpty
                        ? null
                        : _multiSelectionList.last
                  : widget.value,
              decoration: InputDecoration(
                suffixIcon: widget.subfixIcon,
                filled: true,

                prefixIcon: widget.prefixIcon,
                enabled: widget.readOnly ?? true,
                isDense: widget.isDense,
                contentPadding:
                    widget.contentPadding ??
                    const EdgeInsets.fromLTRB(15, 15, 15, 15),
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.rad),
                  borderSide: BorderSide(
                    color: widget.borderColor ?? Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.rad),
                  borderSide: BorderSide(
                    color: widget.borderColor ?? Colors.grey,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.rad),
                  borderSide: BorderSide(
                    color: widget.borderColor ?? const Color(0XFFFB6340),
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.rad),
                  borderSide: BorderSide(
                    color: widget.borderColor ?? const Color(0XFFFB6340),
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.rad),
                  borderSide: BorderSide(
                    color: widget.borderColor ?? Colors.grey,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: widget.borderColor ?? Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(widget.rad),
                ),
                labelText: widget.showLabel == true ? widget.hintText : null,
                labelStyle: TextStyle(
                  fontFamily: "",
                  fontSize: 17,
                  color: Colors.blue,
                ),
                errorStyle: const TextStyle(
                  fontFamily: "",
                  color: Color(0XFFFB6340),
                ),
                hintText: widget.showLabel == false
                    ? '${widget.hintText}'
                    : null,
                hintStyle: TextStyle(color: Colors.blue[300], fontSize: 17),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

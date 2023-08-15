import 'package:flutter/material.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:punch_ios_android/category_list/bloc.dart';
import 'package:punch_ios_android/category_list/event.dart';
import 'package:punch_ios_android/category_list/model.dart';
import 'package:punch_ios_android/category_list/state.dart';
import 'package:punch_ios_android/utility/colors.dart';
import 'package:punch_ios_android/widgets/build_error_ui.dart';
import 'package:punch_ios_android/widgets/build_loading_widget.dart';

class InterestWidget extends StatefulWidget {
  late CategoryListModel categoryListModel;

   InterestWidget({Key? key,  required this.categoryListModel}) : super(key: key);

  @override
  InterestWidgetState createState() => InterestWidgetState();
}

class InterestWidgetState extends State<InterestWidget> with TickerProviderStateMixin {

  // multiple choice value
  List<String> tags = ['Education'];

  // list of string options

  // list of string options
  // List<String> options = [
  //   'Entertainment',
  //   'Politics',
  //   'Business',
  //   'Sports',
  //   'Education',
  //   'Special Feature',
  //   'Health',
  //   'In case you missed it',
  //   'Interview',
  //   'Metro Plus',
  //   'Editorial',
  //   'Panorama',
  //   'Opinion',
  //   'Technology',
  //   'Sex & Relationship',
  //   'Interactive',
  //   'Columns',
  //   'Featured',
  // ];

  List<CategoryListModel> categoryListModel =  <CategoryListModel>[
     CategoryListModel(categoryName: 'Home', categoryId: "12"),
     CategoryListModel(categoryName: 'Home', categoryId: "12"),
     CategoryListModel(categoryName: 'Home', categoryId: "12"),
     CategoryListModel(categoryName: 'Home', categoryId: "12"),
     CategoryListModel(categoryName: 'Home', categoryId: "12"),
     CategoryListModel(categoryName: 'Home', categoryId: "12"),
     CategoryListModel(categoryName: 'Home', categoryId: "12"),
     CategoryListModel(categoryName: 'Home', categoryId: "12"),
     CategoryListModel(categoryName: 'Home', categoryId: "12"),
  ].toList();

  String? user;
  final usersMemoizer = C2ChoiceMemoizer<String>();

  // Create a global key that uniquely identifies the Form widget and allows validation of the form.

  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>.
  final formKey = GlobalKey<FormState>();
  final key = UniqueKey();

  List<String> formValue = [];

  late CategoryListBloc categoryListBloc;

  @override
  void initState() {
    categoryListBloc = BlocProvider.of<CategoryListBloc>(this.context);
    categoryListBloc.add(FetchCategoryListEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar (
        centerTitle: true ,
        title: Image.asset ( 'assets/punchLogo.png' , width: 100 , height: 40 ) ,
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).textTheme.bodyText1!.color,)
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: BlocListener<CategoryListBloc, CategoryListState>(
           listener: (context, state) {
             if (state is CategoryListRefreshingState) {}
             else if (state is CategoryListLoadedState) {}
             else if (state is CategoryListLoadFailureState) {
             }
           },
           child: BlocBuilder<CategoryListBloc, CategoryListState>(
             builder: (context, state) {
               if (state is CategoryListInitialState) {
                 return BuildLoadingWidget();
               } else if (state is CategoryListLoadingState) {
                 return BuildLoadingWidget();
               } else if (state is CategoryListLoadedState) {

                 return

                   // Form(
                   //   key: formKey,
                   //   child: Column(
                   //     children: [
                   //       FormField<List<String>>(
                   //         autovalidateMode: AutovalidateMode.always,
                   //         initialValue: formValue,
                   //         onSaved: (val) => setState(() => formValue = val ?? []),
                   //         validator: (value) {
                   //           if (value?.isEmpty ?? value == null) {
                   //             return 'Please select some categories';
                   //           }
                   //           // if (value!.length > 5) {
                   //           //   return "Can't select more than 5 categories";
                   //           // }
                   //           return null;
                   //         },
                   //         builder: (state) {
                   //           return Column(
                   //             children: <Widget>[
                   //               Container(
                   //                 alignment: Alignment.centerLeft,
                   //                 child: ChipsChoice<String>.multiple(
                   //                   value: state.value ?? [],
                   //                   onChanged: (val) => state.didChange(val),
                   //                   choiceStyle: C2ChipStyle(
                   //                     backgroundColor: Colors.grey,
                   //                     checkmarkColor: Theme.of(context).primaryColor,
                   //                     foregroundColor: Theme.of(context).primaryColor,
                   //                     borderColor: mainColor,
                   //                     borderWidth: 1,
                   //                   ),
                   //
                   //                   choiceItems: C2Choice.listFrom<String, String>(
                   //                     source:options,
                   //                     // source: [widget.categoryListModel.categoryName!],
                   //                     value: (i, v) => v.toLowerCase(),
                   //                     label: (i, v) => v,
                   //                     tooltip: (i, v) => v,
                   //                   ),
                   //                   choiceCheckmark: true,
                   //                   wrapped: true,
                   //                 ),
                   //               ),
                   //               Container(
                   //                 padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                   //                 alignment: Alignment.centerLeft,
                   //                 child: Text(
                   //                   state.errorText ??
                   //                       '${state.value!.length} selected',
                   //                   style: TextStyle(
                   //                       color: state.hasError
                   //                           ? Theme.of(context).textTheme.bodyText1!.color
                   //                           : Theme.of(context).textTheme.bodyText1!.color),
                   //                 ),
                   //               )
                   //             ],
                   //           );
                   //         },
                   //       ),
                   //       const Divider(),
                   //       Padding(
                   //         padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                   //         child: Row(
                   //           crossAxisAlignment: CrossAxisAlignment.start,
                   //           children: [
                   //             ElevatedButton(
                   //               style: ElevatedButton.styleFrom(
                   //                   backgroundColor: mainColor
                   //               ),
                   //               onPressed: () {
                   //                 // Validate returns true if the form is valid, or false otherwise.
                   //                 if (formKey.currentState!.validate()) {
                   //                   // If the form is valid, save the value.
                   //                   formKey.currentState!.save();
                   //                 }
                   //               },
                   //
                   //               child: const Text('Submit',),
                   //             ),
                   //             const SizedBox(
                   //               width: 15,
                   //             ),
                   //             Expanded(
                   //               child: Column(
                   //                 crossAxisAlignment:
                   //                 CrossAxisAlignment.start,
                   //                 children: <Widget>[
                   //                   Text('Submitted Value:', style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),),
                   //                   const SizedBox(height: 5),
                   //                   Text(formValue.toString())
                   //                 ],
                   //               ),
                   //             ),
                   //           ],
                   //         ),
                   //       ),
                   //     ],
                   //   ),
                   // );
                   // buildInterestList(state.categoryList);

              Column(
                   children: [
                     Container(
                       width: double.infinity,
                       padding: const EdgeInsets.all(15),
                       // color: Colors.blueGrey[50],
                       child: Text("Choose Category",
                         style: TextStyle(
                           color: Theme.of(context).textTheme.bodyText1!.color,
                           fontWeight: FontWeight.w500,
                           fontSize: 23,
                         ),
                       ),
                     ),
                     buildInterestList(state.categoryList),
                     ElevatedButton(
                       style: ElevatedButton.styleFrom(
                           backgroundColor: mainColor
                       ),
                       onPressed: () {
                         // Validate returns true if the form is valid, or false otherwise.
                         if (formKey.currentState!.validate()) {
                           // If the form is valid, save the value.
                           formKey.currentState!.save();
                         }
                       },

                       child: const Text('Done',),
                     ),
                   ],
                 );

               } else if (state is CategoryListLoadFailureState) {
                 return BuildErrorUi(message:state.error);
               }
               else {
                 return BuildErrorUi(message:"Something went wrong!");
               }
             },
           ),
         ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget buildInterestList(List<CategoryListModel> categoryListModel) {
    return Wrap(
      spacing: -20,
      children: List.generate(
        categoryListModel.length,
            (index) {
          return FormField<List<String>>(
            autovalidateMode: AutovalidateMode.always,
            initialValue: formValue,
            onSaved: (val) => setState(() => formValue = val ?? []),
            validator: (value) {
              if (value?.isEmpty ?? value == null) {
                return 'Please select some categories';
              }
              if (value!.length > 5) {
                return "Can't select more than 5 categories";
              }
              return null;
            },
            builder: (state) {
              return ChipsChoice<String>.multiple(
                value: state.value ?? [],
                onChanged: (val) => state.didChange(val),
                choiceLeadingBuilder: (data, i) {
                  if (data.meta == null) return null;
                  return CircleAvatar(
                    maxRadius: 12,
                    backgroundImage: data.avatarImage,);
                    // backgroundImage: data.avatarImage.categoryListModel[index].imageUrl!,);
                },
                choiceStyle: C2ChipStyle(
                  backgroundColor: Colors.grey,
                  checkmarkColor: Theme.of(this.context).primaryColor,
                  foregroundColor: Theme.of(this.context).primaryColor,
                  borderColor: mainColor,
                  borderWidth: 1,
                ),
                choiceItems: C2Choice.listFrom<String, String>(
                  source: [categoryListModel[index].categoryName!],
                  // source: options,
                  value: (i, v) => v.toLowerCase(),
                  label: (i, v) => v,
                  tooltip: (i, v) => v,
                ),
                choiceCheckmark: true,
                wrapped: true,
              );
            },
          );
        },
      ),
    );
  }
}


// class CustomChip extends StatelessWidget {
//   final String label;
//   final Color? color;
//   final double? width;
//   final double? height;
//   final EdgeInsetsGeometry? margin;
//   final bool selected;
//   final Function(bool selected) onSelect;
//
//   const CustomChip({
//     Key? key,
//     required this.label,
//     this.color,
//     this.width,
//     this.height,
//     this.margin,
//     this.selected = false,
//     required this.onSelect,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return AnimatedContainer(
//       width: width,
//       height: height,
//       margin: margin ?? const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
//       duration: const Duration(milliseconds: 300),
//       clipBehavior: Clip.antiAlias,
//       decoration: BoxDecoration(
//         color: selected
//             ? (color ?? Colors.green)
//             : theme.unselectedWidgetColor.withOpacity(.12),
//         borderRadius: BorderRadius.all(Radius.circular(selected ? 25 : 10)),
//         border: Border.all(
//           color: selected
//               ? (color ?? Colors.green)
//               : theme.colorScheme.onSurface.withOpacity(.38),
//           width: 1,
//         ),
//       ),
//       child: InkWell(
//         borderRadius: BorderRadius.all(Radius.circular(selected ? 25 : 10)),
//         onTap: () => onSelect(!selected),
//         child: Stack(
//           alignment: Alignment.center,
//           children: <Widget>[
//             AnimatedCheckmark(
//               active: selected,
//               color: Colors.white,
//               size: const Size.square(32),
//               weight: 5,
//               duration: const Duration(milliseconds: 400),
//             ),
//             Positioned(
//               left: 9,
//               right: 9,
//               bottom: 7,
//               child: Text(
//                 label,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(
//                   color: selected ? Colors.white : theme.colorScheme.onSurface,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class Content extends StatefulWidget {
   final  String title;
  final Widget child;

   Content({
    Key? key,
     required this.title,
    required this.child,
  }) : super(key: key);

  @override
  ContentState createState() => ContentState();
}

class ContentState extends State<Content> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(5),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            // color: Colors.blueGrey[50],
            child: Text(
              widget.title,
              style: const TextStyle(
                // color: Colors.blueGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Flexible(fit: FlexFit.loose, child: widget.child),
        ],
      ),
    );
  }
}




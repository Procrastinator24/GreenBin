import 'package:flutter/material.dart';
import 'package:flutter_application_3/features/user/presentation/bloc/user_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_3/features/user/presentation/bloc/auth_bloc.dart';
import 'package:flutter_application_3/features/user/presentation/bloc/user_event.dart';
import 'package:flutter_application_3/features/user/presentation/bloc/user_state.dart';
import 'package:flutter_application_3/core/utils/processing_widget_views.dart';

class UserDataScreen extends StatefulWidget {
  const UserDataScreen({super.key});

  @override
  State<UserDataScreen> createState() => _UserDataScreenState();
}

class _UserDataScreenState extends State<UserDataScreen> {
  late final TextEditingController _nameControl;
  late final TextEditingController _phoneControl;
  late final TextEditingController _adressControl;
  

  final formKey = GlobalKey<FormState>();
  bool _hasLoadedUser = false;
  ProcessingWidgetViews processingWidgets = ProcessingWidgetViews();
  @override
  void dispose() {
    _nameControl.dispose();
    _phoneControl.dispose();
    _adressControl.dispose();
    super.dispose();
  }
  
  @override
  void initState(){
    super.initState();

    final userState = context.read<UserBloc>().state;
    if (userState is UserLoaded){
      _nameControl = TextEditingController(text: userState.user.name);
      _phoneControl = TextEditingController(text: userState.user.phone);
      _adressControl = TextEditingController(text: userState.user.adress);

    }else{
      _nameControl = TextEditingController();
      _phoneControl = TextEditingController();
      _adressControl = TextEditingController();

    }
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Загружаем пользователя только один раз при первом встраивании экрана
    if (!_hasLoadedUser) {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated) {
        context.read<UserBloc>().add(LoadUserEvent(authState.userId));
        _hasLoadedUser = true;
      }
    }
  }
  // @override
  // Widget build(BuildContext context){
  //   return Scaffold(
  //     body: SafeArea(child: 
  //     Text("${context.read<UserBloc>().state}")),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserUpdateSuccess){
          showDialog(
            context: context,
           
            builder: (context) => AlertDialog(
              icon: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,

                ),
                child: Icon(Icons.done, color: Color(0xff00858C),),
              ),
              backgroundColor: Color(0xffDEEFF3),
              title: Align(
                alignment: Alignment.center,
                child: Text('Пользователь обновен', style: TextStyle(
                  fontSize: 16
                ),)),
              actions: [
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xff00858C),
                    ),
                    onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    } , child: Text('Закрыть'),),
                )
              ],
          ));
        }
      },
      builder: (context, state) {
        if (state is UserLoading || state is UserInitial){
          return processingWidgets.buildLoadingView();
        }else if (state is UserError){
          return processingWidgets.buildErrorView(state.message);
        }
        else if (state is UserLoaded){
        return Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.arrow_back),
              ),
            ),
            title: Text('Мои данные', style: TextStyle(fontSize: 18)),
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 1,
                    child: TextFormField(
                      // initialValue: state.user.name,
                      controller: _nameControl,
                      keyboardType: TextInputType.name,

                      decoration: InputDecoration(
                        labelText: 'Имя пользователя',
                        // hintText: 'Введите ваш email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 13),
                  Flexible(
                    flex: 1,
                    child: TextFormField(
                      controller: _phoneControl,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Телефон',
                        // hintText: 'Введите ваш email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 13),

                  Flexible(
                    flex: 1,
                    child: TextFormField(
                      controller: _adressControl,
                      keyboardType: TextInputType.streetAddress,
                      decoration: InputDecoration(
                        labelText: 'Адресс',
                        // hintText: 'Введите ваш email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 13),

                  _buidActionButton(
                    width: 105,
                    label: "Сохранить изменения",
                    onPressed:
                        () {
                          context.read<UserBloc>().add(UpdateUserProfileEvent(userId: state.user.uid,
                            newName: _nameControl.text,
                            newPhone: _phoneControl.text,
                            newAdress: _adressControl.text,
                          ));
                        },
                  ),
                  Spacer(flex: 2),

                  _buidActionButton(
                    width: 125,
                    label: 'Удалить аккаунт',
                    onPressed:
                        () => SnackBar(content: Text('Еще разрабатывается')),
                  ),
                ],
              ),
            ),
          ),
        );
        }else{
          return processingWidgets.buildErrorView("Неизвестное состояние");
        }
      },
    );
  }

  Widget _buidActionButton({
    required String label,
    required VoidCallback onPressed,
    required double width,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: width, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Color(0xff00858c),
        foregroundColor: Colors.white,
      ),
      child: Text(label, style: TextStyle(fontSize: 16)),
    );
  }
}

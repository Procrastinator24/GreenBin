
import 'package:flutter/material.dart';
import 'package:flutter_application_3/screens/mainPageScreens/main_page_screen.dart';

class UserDataScreen  extends StatefulWidget{
  const UserDataScreen({super.key});

  @override
  State<UserDataScreen> createState() => _UserDataScreenState();
  
}

class _UserDataScreenState extends State<UserDataScreen>{
  
  TextEditingController nameControl = TextEditingController();
  TextEditingController phoneControl = TextEditingController();
  TextEditingController adressControl = TextEditingController();
  final formKey = GlobalKey<FormState>(); 


  @override
  void dispose() {
    nameControl.dispose();
    phoneControl.dispose();
    adressControl.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
          child: IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.arrow_back)),),
        title: Text('Мои данные', style: TextStyle(fontSize: 18),),
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
                  controller: nameControl,
                  keyboardType: TextInputType.name,
        
                  decoration: InputDecoration(
                    labelText: 'Имя пользователя',
                    // hintText: 'Введите ваш email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),  
                  ),
                ),),
              SizedBox(height: 13,),
              Flexible(
                flex: 1,
                child: TextFormField(
                  controller: phoneControl,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Телефон',
                    // hintText: 'Введите ваш email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),  
                  ),
                ),),
              SizedBox(height: 13,),

              Flexible(
                flex: 1,
                child: TextFormField(
                  controller: adressControl,
                  keyboardType: TextInputType.streetAddress,
                  decoration: InputDecoration(
                    labelText: 'Адресс',
                    // hintText: 'Введите ваш email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),  
                  ),
                ),),
              SizedBox(height: 13,),

              Flexible(
                flex: 1,
                child: ElevatedButton(
                  onPressed: (){}, 
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 105, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16), 
                    ),
                    backgroundColor:  Color(0xff00858c),
                    foregroundColor:  Colors.white,
                  ),
                  child: Text('Сохранить изменения', style: TextStyle(fontSize: 16),),
                ),
              ),
              Spacer(flex: 1,),

              ElevatedButton(
                onPressed: (){}, 
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 125, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16), 
                  ),
                  backgroundColor:  Color(0xff00858c),
                  foregroundColor:  Colors.white,
                ),
                child: Text('Удалить аккаунт', style: TextStyle(fontSize: 16),),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
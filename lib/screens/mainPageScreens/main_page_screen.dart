import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_3/screens/userScreens/account_screen.dart';
import 'package:flutter_application_3/services/get_user_data.dart';

class MainScreen extends StatefulWidget{
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>{
  final user = FirebaseAuth.instance.currentUser;
  final userService = UserService();
  UserModel? userData;
  UserModel? userData1;

  @override
  void initState(){
    super.initState();
    loadUser();
  }
  Future<void> loadUser() async {
    
    userData =  await userService.getUser(user?.uid ?? '123');
    setState(() {
      userData1 = userData;
    });

  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        
        leading: IconButton(
          color: Color(0xff005E63),
          style: IconButton.styleFrom(
            backgroundColor: Color(0xffDEEFF3)
          ),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountScreen()));
          }, icon: const Icon(
                        Icons.person_2_outlined, 
                        size: 25, )),
        title: Text(userData1?.name ?? 'Загрузка...'), //заглушка  
      ),
      body:Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
       child:  SingleChildScrollView(
        child: 
       
       Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          carousel.CarouselSlider(
            items: [
              _buildCarouselItem('Какой пластик поддается переработке?'),
              _buildCarouselItem('Какой пластик поддается переработке?'),
              _buildCarouselItem('Какой пластик поддается переработке?'),
            ], 
            options: carousel.CarouselOptions(

            height: 280,
            // aspectRatio: 16/9,
            viewportFraction: 0.52,
            // initialPage: 0,
            enableInfiniteScroll: true,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
          )),
  
          SizedBox(height: 10,),
          Align(
            alignment: Alignment.centerLeft, 
            child:
              Padding(padding: EdgeInsets.all(20), child:
                Text('Посмотреть пункты приема', 
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    ),
                  )
                ,)
            ,),
          
          SizedBox(
            height: 100,  
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildMiniButton('Пластик'),
                  SizedBox(width: 10,),
                  
                  _buildMiniButton('Стекло'),
                  SizedBox(width: 10,),
                  
                  _buildMiniButton('Батарейки'),
                  SizedBox(width: 10,),
                  
                  _buildMiniButton('Макулатура'),
                  SizedBox(width: 10,),

                  _buildMiniButton('Другое'),
                  SizedBox(width: 10,),
                ],    
              )
              ,
            )
            //Мидл скроллер  
              
          ),
          
          SizedBox(height: 10,),
          Align(
            alignment: Alignment.centerLeft, 
            child:
              Padding(padding: EdgeInsets.all(20), child:
                Text('Полезная информация', 
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    ),
                  )
                ,)
            ,),
          SizedBox(height: 2,),
          SizedBox( height: 300,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  // childAspectRatio: 1.2, // соотношение ширины к высоте
                ),
                itemCount: 6, 
                itemBuilder: (context, index){
                  return Container(
                    padding: EdgeInsets.all(10),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color(0xffBCE6e5),
                      borderRadius: BorderRadius.circular(12.0),
                      shape: BoxShape.rectangle,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(alignment: Alignment.centerLeft, child: Icon(Icons.folder_outlined)),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Text("Справочник кодов", style: TextStyle(fontSize: 12),),
                        ),
                      ],
                    ),

                  );
                }),
            ),
          )

          ],
        ),
      ) 
      )   
    );
  }

  // Метод вывода карточек в верхнем скроллере
  Widget _buildCarouselItem(String text) {
  return Container(
    width: 200,
    height: 280,
    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
    decoration: BoxDecoration(
      color: Color(0xffDEEFF3),
      borderRadius: BorderRadius.circular(12.0)
    ),
    child: Padding(
      padding: EdgeInsets.fromLTRB(10,0,10,30), 
      child: Align(
        alignment:  Alignment.bottomCenter, 
        child: Text(text, 
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold),
            ),
          )
        )
      );
    }

  //Метод вывода карточек пунктов приема
  Widget _buildMiniButton(String label){
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(12.0),
            color: Color(0xff00858C),
            
          ),
          child: Icon(Icons.folder_outlined, color: Colors.white,),
        ),
        SizedBox(height: 5,),
        SizedBox(width: 64, child: 
          Text(label, 
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),)
        ,),
      ],
    );
  
  } 
}



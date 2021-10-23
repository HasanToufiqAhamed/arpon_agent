import 'package:arpon_agent/data/my_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'UserInfoPublicActivity.dart';

class UserInfoPrivetActivity extends StatefulWidget {
  UserInfoPrivetActivity({Key? key}) : super(key: key);

  _UserInfoPrivetState createState() => _UserInfoPrivetState();
}

AppBar appBar = AppBar();

class _UserInfoPrivetState extends State<UserInfoPrivetActivity> {
  FirebaseFirestore _firestore=FirebaseFirestore.instance;
  FirebaseAuth _auth=FirebaseAuth.instance;
  bool emptyEmail = false;
  bool emptyName = false;
  bool emptyMobileNumber = false;
  bool emptyNidNumber = false;
  bool emptyZipCode = false;
  bool emptyTradeLicence = false;
  bool emptyDivision = false;
  bool emptyDistrict = false;
  bool emptyUpozila = false;
  TextEditingController fulName = new TextEditingController();
  TextEditingController mobileNumber = new TextEditingController();
  TextEditingController emailAddress = new TextEditingController();
  TextEditingController nidNumber = new TextEditingController();
  TextEditingController zipCode = new TextEditingController();
  TextEditingController tradeLicence = new TextEditingController();
  TextEditingController divisionCon = new TextEditingController();
  bool? loading = false;
  String? mobileNumberErrorText = 'Enter correct number';
  String? emailErrorText = 'Enter email address';
  Color? color;
  Color? color2;
  Color? color3;
  Color? color4;
  Color? color5;
  Color? color6;
  FocusNode oneFocus = new FocusNode();
  FocusNode twoFocus = new FocusNode();
  FocusNode threeFocus = new FocusNode();
  FocusNode fourFocus = new FocusNode();
  FocusNode fiveFocus = new FocusNode();
  FocusNode sixFocus = new FocusNode();
  String? divisionValue = 'Division';
  List<String> dividionItem = [
    'Division',
    'Barishal',
    'Chattogram',
    'Dhaka',
    'Khulna',
    'Mymensingh',
    'Rajshahi',
    'Rangpur',
    'Sylhet'
  ];
  String? districtValue = 'District';
  List<String> defaultDistrictItem = ['District'];
  List<String> districtItem1 = [
    'District',
    'Barguna',
    'Barishal',
    'Bhola',
    'Jhalokathi',
    'Patuakhali',
    'Pirojpur'
  ];
  List<String> districtItem2 = [
    'District',
    'B.baria',
    'Bandarban',
    'Chandpur',
    'Chattogram',
    'Coxs bazar',
    'Cumilla',
    'Feni',
    'Khagrachari',
    'Laxmipur',
    'Noakhali',
    'Rangamati'
  ];
  List<String> districtItem3 = [
    'District',
    'Dhaka',
    'Faridpur',
    'Gazipur',
    'Gopalganj' 'Kishoreganj',
    'Madaripur',
    'Manikganj',
    'Munshiganj',
    'Narayanganj',
    'Narshingdi',
    'Rajbari',
    'Shariatpur',
    'Tangail'
  ];
  List<String> districtItem4 = [
    'District',
    'Bagerhat',
    'Chuadanga',
    'Jashore',
    'Jhenaidah',
    'Khulna',
    'Kushtia',
    'Magura',
    'Meherpur',
    'Narail',
    'Satkhira'
  ];
  List<String> districtItem5 = [
    'District',
    'Jamalpur',
    'Mymensingh',
    'Netrokona',
    'Sherpur'
  ];
  List<String> districtItem6 = [
    'District',
    'Bogura',
    'Chapai Nawabganj',
    'Joypurhat',
    'Naogaon',
    'Natore',
    'Pabna',
    'Rajshahi',
    'Sirajganj'
  ];
  List<String> districtItem7 = [
    'District',
    'Dinajpur',
    'Gaibandha',
    'Kurigram',
    'Lalmonirhat',
    'Nilphamari',
    'Panchagarh',
    'Rangpur',
    'Thakurgaon'
  ];
  List<String> districtItem8 = [
    'District',
    'Habiganj',
    'Moulvibazar',
    'Sunamganj',
    'Sylhet'
  ];

  String? upazilaValue = 'Upozila';
  List<String> defaultUpazilaItem = ['Upozila'];
  List<String> Barguna = [
    'Upozila',
    'Amtali',
    'Bamna',
    'Barguna Sadar',
    'Betagi',
    'Patharghata',
    'Taltali'
  ];
  List<String> Barishal = [
    'Upozila',
    'Agailjhara',
    'Babuganj',
    'Bakerganj',
    'Banaripara',
    'Barishal Sadar',
    'Gouranadi',
    'Hizla',
    'Mehendiganj',
    'Muladi',
    'Uzirpur'
  ];
  List<String> Bhola = [
    'Upozila',
    'Bhola Sadar',
    'Borhanuddin',
    'Charfassion',
    'Daulatkhan',
    'Lalmohan',
    'Monpura',
    'Tazumuddin'
  ];
  List<String> Jhalokathi = [
    'Upozila',
    'Jhalokathi Sadar',
    'Kathalia',
    'Nalchity',
    'Rajapur'
  ];
  List<String> Patuakhali = [
    'Upozila',
    'Bauphal',
    'Dashmina',
    'Dumki',
    'Galachipa',
    'Kalapara',
    'Mirjaganj',
    'Patuakhali Sadar',
    'Rangabali'
  ];
  List<String> Pirojpur = [
    'Upozila',
    'Bhandaria',
    'Kawkhali',
    'Mothbaria',
    'Nazirpur',
    'Nesarabad',
    'Pirojpur Sadar',
    'Zianagar',
  ];

  List<String> bbaria = [
    'Upozila',
    'Akhaura',
    'Ashuganj',
    'B.Baria',
    'Bancharampur',
    'Bijoynagar',
    'Kasba',
    'Nabinagar',
    'Nasirnagar',
    'Sarail'
  ];
  List<String> Bandarban = [
    'Upozila',
    'Alikadam',
    'Bandarban',
    'Lama',
    'Naikhyongchari',
    'Rowangchari',
    'Ruma',
    'Thanchi'
  ];
  List<String> Chandpur = [
    'Upozila',
    'Chandpur',
    'Faridganj',
    'Haimchar',
    'Haziganj',
    'Kachua',
    'Matlab (Dakshin)',
    'Matlab (Uttar)',
    'Shahrasti'
  ];
  List<String> Chattogram = [
    'Upozila',
    'Anwara',
    'Banskhali',
    'Boalkhali',
    'Chandanish',
    'Fatikchari',
    'Hathazari',
    'Karnaphuli',
    'Lohagara',
    'Mirsharai',
    'Patiya',
    'Rangunia',
    'Raojan',
    'Sandwip',
    'Satkania',
    'Sitakunda'
  ];
  List<String> Coxs_bazar = [
    'Upozila',
    'Chakoria',
    'Coxs Bazar',
    'Kutubdia',
    'Moheskhali',
    'Pekua',
    'Ramu',
    'Teknaf',
    'Ukhiya'
  ];
  List<String> Cumilla = [
    'Upozila',
    'Barura',
    'Brahmanpara',
    'Burichong',
    'Chandina',
    'Chouddagram',
    'Cumilla Sadar',
    'Cumilla Sadar Daksin',
    'Daudkandi',
    'Debidwar',
    'Homna',
    'Laksham',
    'Lalmai',
    'Meghna',
    'Monohorganj',
    'Muradnagar',
    'Nangalkot',
    'Titas'
  ];
  List<String> Feni = [
    'Upozila',
    'Chhagalniya',
    'Daganbhuiyan',
    'Feni Sadar',
    'Fulgazi',
    'Porshuram',
    'Sonagazi'
  ];
  List<String> Khagrachari = [
    'Upozila',
    'Dighinala',
    'Guimara',
    'Khagrachari Sadar',
    'Laxmichari',
    'Mahalchari',
    'Manikchari',
    'Matiranga',
    'Panchari',
    'Ramgarh'
  ];
  List<String> Laxmipur = [
    'Upozila',
    'Komol, Nagar',
    'Laxmipur Sadar',
    'Raipur',
    'Ramganj',
    'Ramgati'
  ];
  List<String> Noakhali = [
    'Upozila',
    'Begumganj',
    'Chatkhil',
    'Companiganj',
    'Hatiya',
    'Kabir Hat',
    'Noakhali Sadar',
    'Senbag',
    'Sonaimuri',
    'Subarna Char'
  ];
  List<String> Rangamati = [
    'Upozila',
    'Baghaichari',
    'Barkal',
    'Belaichari',
    'Juraichari',
    'Kaptai',
    'Kaukhali',
    'Langadu',
    'Nanniarchar',
    'Rajosthali',
    'Rangamati Sadar'
  ];

  List<String> Dhaka = [
    'Upozila',
    'Dhamrai',
    'Dohar',
    'Keraniganj',
    'Nawabganj',
    'Savar'
  ];
  List<String> Faridpur = [
    'Upozila',
    'Alfadanga',
    'Bhanga',
    'Boalmari',
    'Charbhadrasan',
    'Faridpur Sadar',
    'Madhukhali',
    'Nagarkanda',
    'Sadarpur',
    'Saltha'
  ];
  List<String> Gazipur = [
    'Upozila',
    'Gazipur Sadar',
    'Kaliakoir',
    'Kaliganj',
    'Kapasia',
    'Sreepur'
  ];
  List<String> Gopalganj = [
    'Upozila',
    'Gopalganj Sadar',
    'Kasiani',
    'Kotwalipara',
    'Muksudpur',
    'Tungipara'
  ];
  List<String> Kishoreganj = [
    'Upozila',
    'Austagram',
    'Bajitpur',
    'Bhairab',
    'Hossainpur',
    'Itna',
    'Karimganj',
    'Katiadi',
    'Kishoreganj Sadar',
    'Kuliarchar',
    'Mithamoin',
    'Nikli',
    'Pakundia',
    'Tarail'
  ];
  List<String> Madaripur = [
    'Upozila',
    'Kalkini',
    'Madaripur Sadar',
    'Rajoir',
    'Shibchar'
  ];
  List<String> Manikganj = [
    'Upozila',
    'Daulatpur',
    'Ghior',
    'Harirampur',
    'Manikganj Sadar',
    'Saturia',
    'Shivalaya',
    'Singair'
  ];
  List<String> Munshiganj = [
    'Upozila',
    'Gazaria',
    'Lauhajong',
    'Munshiganj Sadar',
    'Sirajdikhan',
    'Sreenagar',
    'Tongibari'
  ];
  List<String> Narayanganj = [
    'Upozila',
    'Araihazar',
    'Bandar',
    'Narayanganj Sadar',
    'Rupganj',
    'Sonargaon'
  ];
  List<String> Narshingdi = [
    'Upozila',
    'Belabo',
    'Monohardi',
    'Narshingdi Sadar',
    'Palash',
    'Raipura',
    'Shibpur'
  ];
  List<String> Rajbari = [
    'Upozila',
    'Baliakandi',
    'Goalanda',
    'Kalukhali',
    'Pangsha',
    'Rajbari Sadar'
  ];
  List<String> Shariatpur = [
    'Upozila',
    'Bhedarganj',
    'Damuddya',
    'Goshairhat',
    'Janjira',
    'Naria',
    'Shariatpur Sadar'
  ];
  List<String> Tangail = [
    'Upozila',
    'Basail',
    'Bhuapur',
    'Delduar',
    'Dhanbari',
    'Ghatail',
    'Gopalpur',
    'Kalihati',
    'Madhupur',
    'Mirzapur',
    'Nagarpur',
    'Shakhipur',
    'Tangail Sadar'
  ];

  List<String> Bagerhat = [
    'Upozila',
    'Bagerhat Sadar',
    'Chitalmari',
    'Fakirhat',
    'Kachua',
    'Mollahat',
    'Mongla',
    'Morrelganj',
    'Rampal',
    'Sharankhola'
  ];
  List<String> Chuadanga = [
    'Upozila',
    'Alamdanga',
    'Chuadanga Sadar',
    'Damurhuda',
    'Jibannagar'
  ];
  List<String> Jashore = [
    'Upozila',
    'Abhoynagar',
    'Bagherpara',
    'Chowgacha',
    'Jashore Sadar',
    'Jhikargacha',
    'Keshabpur',
    'Monirampur',
    'Sarsha'
  ];
  List<String> Jhenaidah = [
    'Upozila',
    'Harinakunda',
    'Jhenaidah Sadar',
    'Kaliganj',
    'Kotchandpur',
    'Moheshpur',
    'Shailkupa',
  ];
  List<String> Khulna = [
    'Upozila',
    'Batiaghata',
    'Dacope',
    'Dighalia',
    'Dumuria',
    'Koira',
    'Paikgacha',
    'Phultala',
    'Rupsa',
    'Terokhada'
  ];
  List<String> Kushtia = [
    'Upozila',
    'Bheramara',
    'Daulatpur',
    'Khoksha',
    'Kumarkhali',
    'Kushtia Sadar',
    'Mirpur'
  ];
  List<String> Magura = [
    'Upozila',
    'Magura Sadar',
    'Mohammadpur',
    'Salikha',
    'Sreepur'
  ];
  List<String> Meherpur = [
    'Upozila',
    'Gangni',
    'Meherpur Sadar',
    'Mujib Nagar'
  ];
  List<String> Narail = ['Upozila', 'Kalia', 'Lohagara', 'Narail Sadar'];
  List<String> Satkhira = [
    'Upozila',
    'Assasuni',
    'Debhata',
    'Kalaroa',
    'Kaliganj',
    'Satkhira Sadar',
    'Shyamnagar',
    'Tala'
  ];

  List<String> Jamalpur = [
    'Upozila',
    'Bakshiganj',
    'Dewanganj',
    'Islampur',
    'Jamalpur Sadar',
    'Madarganj',
    'Melendah',
    'Sarishabari'
  ];
  List<String> Mymensingh = [
    'Upozila',
    'Bhaluka',
    'Dhobaura',
    'Fulbaria',
    'Gaffargaon',
    'Gouripur',
    'Haluaghat',
    'Ishwarganj',
    'Muktagacha',
    'Mymensingh Sasar',
    'Nandail',
    'Phulpur',
    'Tarakanda',
    'Trishal'
  ];
  List<String> Netrokona = [
    'Upozila',
    'Atpara',
    'Barhatta',
    'Durgapur',
    'Kalmakanda',
    'Kendua',
    'Khaliajuri',
    'Madan',
    'Mohanganj',
    'Netrakona Sadar',
    'Purbadhala'
  ];
  List<String> Sherpur = [
    'Upozila',
    'Jhenaigati',
    'Nakla',
    'Nalitabari',
    'Sherpur Sadar',
    'Sreebordi'
  ];

  List<String> Bogura = [
    'Upozila',
    'Adamdighi',
    'Bogura Sadar',
    'Dhunot',
    'Dhupchancia',
    'Gabtali',
    'Kahaloo',
    'Nandigram',
    'Sariakandi',
    'Shajahanpur',
    'Sherpur',
    'Shibganj',
    'Sonatala'
  ];
  List<String> Chapai_Nawabganj = [
    'Upozila',
    'Bholahat',
    'Gomostapur',
    'Nachol',
    'Nawabganj Sadar',
    'Shibganj'
  ];
  List<String> Joypurhat = [
    'Upozila',
    'Akkelpur',
    'Joypurhat Sadar',
    'Kalai',
    'Khetlal',
    'Panchbibi'
  ];
  List<String> Naogaon = [
    'Upozila',
    'Atrai',
    'Badalgachi',
    'Dhamoirhat',
    'Manda',
    'Mohadevpur',
    'Naogaon Sadar',
    'Niamatpur',
    'Patnitala',
    'Porsha',
    'Raninagar',
    'Shapahar'
  ];
  List<String> Natore = [
    'Upozila',
    'Bagatipara',
    'Baraigram',
    'Gurudaspur',
    'Lalpur',
    'Naldanga',
    'Natore Sadar',
    'Singra'
  ];
  List<String> Pabna = [
    'Upozila',
    'Atghoria',
    'Bera',
    'Bhangura',
    'Chatmohar',
    'Faridpur',
    'Ishwardi',
    'Pabna Sadar',
    'Santhia',
    'Sujanagar'
  ];
  List<String> Rajshahi = [
    'Upozila',
    'Bagha',
    'Bagmara',
    'Charghat',
    'Durgapur',
    'Godagari',
    'Mohanpur',
    'Paba',
    'Puthia',
    'Tanore'
  ];
  List<String> Sirajganj = [
    'Upozila',
    'Belkuchi',
    'Chowhali',
    'Kamarkhand',
    'Kazipur',
    'Raiganj',
    'Shahzadpur',
    'Sirajganj Sadar',
    'Tarash',
    'Ullapara'
  ];

  List<String> Dinajpur = [
    'Upozila',
    'Birampur',
    'Birganj',
    'Birol',
    'Bochaganj',
    'Chirirbandar',
    'Dinajpur Sadar',
    'Fulbari',
    'Ghoraghat',
    'Hakimpur',
    'Kaharol',
    'Khanshama',
    'Nawabganj',
    'Parbatipur'
  ];
  List<String> Gaibandha = [
    'Upozila',
    'Fulchari',
    'Gaibandha Sadar',
    'Gobindaganj',
    'Palashbari',
    'Sadullapur',
    'Saghata',
    'Sundarganj'
  ];
  List<String> Kurigram = [
    'Upozila',
    'Bhurungamari',
    'Chilmari',
    'Fulbari',
    'Kurigram Sadar',
    'Nageswari',
    'Rajarhat',
    'Rowmari',
    'Ulipur'
  ];
  List<String> Lalmonirhat = [
    'Upozila',
    'Aditmari',
    'Hatibandha',
    'Kaliganj',
    'Lalmonirhat Sadar',
    'Patgram'
  ];
  List<String> Nilphamari = [
    'Upozila',
    'Dimla',
    'Domar',
    'Jaldhaka',
    'Kishoreganj',
    'Nilphamari Sadar',
    'Sayedpur'
  ];
  List<String> Panchagarh = [
    'Upozila',
    'Atwari',
    'Boda',
    'Debiganj',
    'Panchagarh Sadar',
    'Tetulia'
  ];
  List<String> Rangpur = [
    'Upozila',
    'Badarganj',
    'Gangachara',
    'Kaunia',
    'Mithapukur',
    'Pirgacha',
    'Pirganj',
    'Rangpur Sadar',
    'Taraganj'
  ];
  List<String> Thakurgaon = [
    'Upozila',
    'Baliadangi',
    'Haripur',
    'Pirganj',
    'Ranisankail',
    'Thakurgaon Sadar'
  ];

  List<String> Habiganj = [
    'Upozila',
    'Azmiriganj',
    'Bahubal',
    'Baniachong',
    'Chunarughat',
    'Habiganj Sadar',
    'Lakhai',
    'Madhabpur',
    'Nabiganj',
    'Sayestaganj'
  ];
  List<String> Moulvibazar = [
    'Upozila',
    'Barlekha',
    'Juri',
    'Kamalganj',
    'Kulaura',
    'Moulvibazar Sadar',
    'Rajnagar',
    'Sreemangal',
  ];
  List<String> Sunamganj = [
    'Upozila',
    'Biswamvarpur',
    'Chatak',
    'Dakhin Sunamganj',
    'Derai',
    'Dharmapasha',
    'Doarabazar',
    'Jagannathpur',
    'Jamalganj',
    'Sulla',
    'Sunamganj Sadar',
    'Tahirpur',
  ];
  List<String> Sylhet = [
    'Upozila',
    'Balaganj',
    'Beanibazar',
    'Biswanath',
    'Companiganj',
    'Dakshin Surma',
    'Fenchuganj',
    'Golapganj',
    'Gowainghat',
    'Jointiapur',
    'Kanaighat',
    'Osmaninagar',
    'Sylhet Sadar',
    'Zakiganj',
  ];

  @override
  Widget build(BuildContext context) {
    oneFocus.addListener(() {
      setState(() {
        color = oneFocus.hasFocus ? Colors.black : MyColors.text_third_color;
      });
    });
    twoFocus.addListener(() {
      setState(() {
        color2 = twoFocus.hasFocus ? Colors.black : MyColors.text_third_color;
      });
    });
    threeFocus.addListener(() {
      setState(() {
        color3 = threeFocus.hasFocus ? Colors.black : MyColors.text_third_color;
      });
    });
    fourFocus.addListener(() {
      setState(() {
        color4 = fourFocus.hasFocus ? Colors.black : MyColors.text_third_color;
      });
    });
    fiveFocus.addListener(() {
      setState(() {
        color5 = fiveFocus.hasFocus ? Colors.black : MyColors.text_third_color;
      });
    });
    sixFocus.addListener(() {
      setState(() {
        color6 = sixFocus.hasFocus ? Colors.black : MyColors.text_third_color;
      });
    });
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            SizedBox(height: statusBarHeight),
            Container(
              height: appBar.preferredSize.height,
              child: Center(
                child: Text(
                  'Personal info',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          'All information must should match with your legal documents',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: MyColors.text_color, fontSize: 16),
                        ),
                      ),
                      SizedBox(height: 25),
                      TextFormField(
                        focusNode: oneFocus,
                        controller: fulName,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(twoFocus);
                        },
                        decoration: InputDecoration(
                          errorText: emptyName ? 'Enter name' : null,
                          border: OutlineInputBorder(),
                          labelText: 'Full name *',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: MyColors.layout_divider_color,
                                width: 2.0),
                          ),
                          labelStyle: TextStyle(color: color),
                        ),
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        focusNode: twoFocus,
                        controller: mobileNumber,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        maxLength: 11,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9]'),
                          ),
                        ],
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(threeFocus);
                        },
                        decoration: InputDecoration(
                          errorText:
                              emptyMobileNumber ? mobileNumberErrorText : null,
                          border: OutlineInputBorder(),
                          counterText: '',
                          labelText: 'Contact number *',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: MyColors.layout_divider_color,
                                width: 2.0),
                          ),
                          labelStyle: TextStyle(color: color2),
                        ),
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        focusNode: threeFocus,
                        controller: emailAddress,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.emailAddress,
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(fourFocus);
                        },
                        decoration: InputDecoration(
                          errorText: emptyEmail ? emailErrorText : null,
                          border: OutlineInputBorder(),
                          labelText: 'Email *',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: MyColors.layout_divider_color,
                                width: 2.0),
                          ),
                          labelStyle: TextStyle(color: color3),
                        ),
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        focusNode: fourFocus,
                        controller: nidNumber,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        maxLength: 11,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9]'),
                          ),
                        ],
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(fiveFocus);
                        },
                        decoration: InputDecoration(
                          errorText:
                              emptyNidNumber ? 'Enter NID number' : null,
                          border: OutlineInputBorder(),
                          counterText: '',
                          labelText: 'NID number *',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: MyColors.layout_divider_color,
                                width: 2.0),
                          ),
                          labelStyle: TextStyle(color: color4),
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                errorText:
                                    emptyDivision ? 'Enter division' : null,
                                border: OutlineInputBorder(),
                                labelText: 'Division *',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyColors.layout_divider_color,
                                      width: 2.0),
                                ),
                              ),
                              isExpanded: true,
                              value: divisionValue,
                              icon: Icon(FeatherIcons.chevronDown),
                              elevation: 1,
                              onChanged: (String? newValue) {
                                setState(() {
                                  divisionValue = newValue;
                                  if (newValue == 'Barishal')
                                    defaultDistrictItem = districtItem1;
                                  else if (newValue == 'Chattogram')
                                    defaultDistrictItem = districtItem2;
                                  else if (newValue == 'Dhaka')
                                    defaultDistrictItem = districtItem3;
                                  else if (newValue == 'Khulna')
                                    defaultDistrictItem = districtItem4;
                                  else if (newValue == 'Mymensingh')
                                    defaultDistrictItem = districtItem5;
                                  else if (newValue == 'Rajshahi')
                                    defaultDistrictItem = districtItem6;
                                  else if (newValue == 'Rangpur')
                                    defaultDistrictItem = districtItem7;
                                  else if (newValue == 'Sylhet')
                                    defaultDistrictItem = districtItem8;

                                  districtValue = defaultDistrictItem[0];
                                });
                              },
                              items: dividionItem.map((e) {
                                return DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                errorText:
                                    emptyDistrict ? 'Enter district' : null,
                                border: OutlineInputBorder(),
                                labelText: 'District *',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyColors.layout_divider_color,
                                      width: 2.0),
                                ),
                              ),
                              isExpanded: true,
                              value: districtValue,
                              icon: Icon(FeatherIcons.chevronDown),
                              elevation: 1,
                              onChanged: divisionValue == 'Division'
                                  ? null
                                  : (String? newValue) {
                                      setState(() {
                                        districtValue = newValue;

                                        switch (newValue) {
                                          case 'Barguna':
                                            defaultUpazilaItem = Barguna;
                                            break;
                                          case 'Barishal':
                                            defaultUpazilaItem = Barishal;
                                            break;
                                          case 'Bhola':
                                            defaultUpazilaItem = Bhola;
                                            break;
                                          case 'Jhalokathi':
                                            defaultUpazilaItem = Jhalokathi;
                                            break;
                                          case 'Patuakhali':
                                            defaultUpazilaItem = Patuakhali;
                                            break;
                                          case 'Pirojpur':
                                            defaultUpazilaItem = Pirojpur;
                                            break;

                                          case 'B.baria':
                                            defaultUpazilaItem = bbaria;
                                            break;
                                          case 'Bandarban':
                                            defaultUpazilaItem = Bandarban;
                                            break;
                                          case 'Chandpur':
                                            defaultUpazilaItem = Chandpur;
                                            break;
                                          case 'Chattogram':
                                            defaultUpazilaItem = Chattogram;
                                            break;
                                          case 'Coxs bazar':
                                            defaultUpazilaItem = Coxs_bazar;
                                            break;
                                          case 'Cumilla':
                                            defaultUpazilaItem = Cumilla;
                                            break;
                                          case 'Feni':
                                            defaultUpazilaItem = Feni;
                                            break;
                                          case 'Khagrachari':
                                            defaultUpazilaItem = Khagrachari;
                                            break;
                                          case 'Laxmipur':
                                            defaultUpazilaItem = Laxmipur;
                                            break;
                                          case 'Noakhali':
                                            defaultUpazilaItem = Noakhali;
                                            break;
                                          case 'Rangamati':
                                            defaultUpazilaItem = Rangamati;
                                            break;

                                          case 'Dhaka':
                                            defaultUpazilaItem = Dhaka;
                                            break;
                                          case 'Faridpur':
                                            defaultUpazilaItem = Faridpur;
                                            break;
                                          case 'Gazipur':
                                            defaultUpazilaItem = Gazipur;
                                            break;
                                          case 'Gopalganj':
                                            defaultUpazilaItem = Gopalganj;
                                            break;
                                          case 'Kishoreganj':
                                            defaultUpazilaItem = Kishoreganj;
                                            break;
                                          case 'Madaripur':
                                            defaultUpazilaItem = Madaripur;
                                            break;
                                          case 'Manikganj':
                                            defaultUpazilaItem = Manikganj;
                                            break;
                                          case 'Munshiganj':
                                            defaultUpazilaItem = Munshiganj;
                                            break;
                                          case 'Narayanganj':
                                            defaultUpazilaItem = Narayanganj;
                                            break;
                                          case 'Narshingdi':
                                            defaultUpazilaItem = Narshingdi;
                                            break;
                                          case 'Rajbari':
                                            defaultUpazilaItem = Rajbari;
                                            break;
                                          case 'Shariatpur':
                                            defaultUpazilaItem = Shariatpur;
                                            break;
                                          case 'Tangail':
                                            defaultUpazilaItem = Tangail;
                                            break;

                                          case 'Bagerhat':
                                            defaultUpazilaItem = Bagerhat;
                                            break;
                                          case 'Chuadanga':
                                            defaultUpazilaItem = Chuadanga;
                                            break;
                                          case 'Jashore':
                                            defaultUpazilaItem = Jashore;
                                            break;
                                          case 'Jhenaidah':
                                            defaultUpazilaItem = Jhenaidah;
                                            break;
                                          case 'Khulna':
                                            defaultUpazilaItem = Khulna;
                                            break;
                                          case 'Kushtia':
                                            defaultUpazilaItem = Kushtia;
                                            break;
                                          case 'Magura':
                                            defaultUpazilaItem = Magura;
                                            break;
                                          case 'Meherpur':
                                            defaultUpazilaItem = Meherpur;
                                            break;
                                          case 'Narail':
                                            defaultUpazilaItem = Narail;
                                            break;
                                          case 'Satkhira':
                                            defaultUpazilaItem = Satkhira;
                                            break;

                                          case 'Jamalpur':
                                            defaultUpazilaItem = Jamalpur;
                                            break;
                                          case 'Mymensingh':
                                            defaultUpazilaItem = Mymensingh;
                                            break;
                                          case 'Netrokona':
                                            defaultUpazilaItem = Netrokona;
                                            break;
                                          case 'Sherpur':
                                            defaultUpazilaItem = Sherpur;
                                            break;

                                          case 'Bogura':
                                            defaultUpazilaItem = Bogura;
                                            break;
                                          case 'Chapai Nawabganj':
                                            defaultUpazilaItem =
                                                Chapai_Nawabganj;
                                            break;
                                          case 'Joypurhat':
                                            defaultUpazilaItem = Joypurhat;
                                            break;
                                          case 'Naogaon':
                                            defaultUpazilaItem = Naogaon;
                                            break;
                                          case 'Natore':
                                            defaultUpazilaItem = Natore;
                                            break;
                                          case 'Pabna':
                                            defaultUpazilaItem = Pabna;
                                            break;
                                          case 'Rajshahi':
                                            defaultUpazilaItem = Rajshahi;
                                            break;
                                          case 'Sirajganj':
                                            defaultUpazilaItem = Sirajganj;
                                            break;

                                          case 'Dinajpur':
                                            defaultUpazilaItem = Dinajpur;
                                            break;
                                          case 'Gaibandha':
                                            defaultUpazilaItem = Gaibandha;
                                            break;
                                          case 'Kurigram':
                                            defaultUpazilaItem = Kurigram;
                                            break;
                                          case 'Lalmonirhat':
                                            defaultUpazilaItem = Lalmonirhat;
                                            break;
                                          case 'Nilphamari':
                                            defaultUpazilaItem = Nilphamari;
                                            break;
                                          case 'Panchagarh':
                                            defaultUpazilaItem = Panchagarh;
                                            break;
                                          case 'Rangpur':
                                            defaultUpazilaItem = Rangpur;
                                            break;
                                          case 'Thakurgaon':
                                            defaultUpazilaItem = Thakurgaon;
                                            break;

                                          case 'Habiganj':
                                            defaultUpazilaItem = Habiganj;
                                            break;
                                          case 'Moulvibazar':
                                            defaultUpazilaItem = Moulvibazar;
                                            break;
                                          case 'Sunamganj':
                                            defaultUpazilaItem = Sunamganj;
                                            break;
                                          case 'Sylhet':
                                            defaultUpazilaItem = Sylhet;
                                            break;

                                          default:
                                            upazilaValue =
                                                defaultUpazilaItem[0];
                                        }
                                        upazilaValue = defaultUpazilaItem[0];
                                      });
                                    },
                              items: defaultDistrictItem.map((e) {
                                return DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                errorText:
                                    emptyUpozila ? 'Enter upozila' : null,
                                border: OutlineInputBorder(),
                                labelText: 'Upazila *',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyColors.layout_divider_color,
                                      width: 2.0),
                                ),
                              ),
                              isExpanded: true,
                              value: upazilaValue,
                              icon: Icon(FeatherIcons.chevronDown),
                              elevation: 1,
                              onChanged: districtValue == 'District'
                                  ? null
                                  : (String? newValue) {
                                      setState(() {
                                        upazilaValue = newValue;
                                      });
                                    },
                              items: defaultUpazilaItem.map((e) {
                                return DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: TextFormField(
                              focusNode: fiveFocus,
                              controller: zipCode,
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]'),
                                ),
                              ],
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(sixFocus);
                              },
                              decoration: InputDecoration(
                                errorText:
                                    emptyZipCode ? 'Enter zip code' : null,
                                border: OutlineInputBorder(),
                                counterText: '',
                                labelText: 'Zip Code *',
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyColors.layout_divider_color,
                                      width: 2.0),
                                ),
                                labelStyle: TextStyle(color: color5),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        focusNode: sixFocus,
                        controller: tradeLicence,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          errorText:
                              emptyTradeLicence ? 'Enter Trade Licence' : null,
                          border: OutlineInputBorder(),
                          labelText: 'Trade Licence *',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: MyColors.layout_divider_color,
                                width: 2.0),
                          ),
                          labelStyle: TextStyle(color: color6),
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: loading! ? null : () {
                String name = fulName.text.toString();
                String number = mobileNumber.text.toString();
                String email = emailAddress.text.toString();
                String nid = nidNumber.text.toString();
                String div = divisionValue!;
                String dis = districtValue!;
                String upo = upazilaValue!;
                String postC = zipCode.text.toString();
                String trdLic = tradeLicence.text.toString();

                setState(() {
                  name.isEmpty
                      ? emptyName = true
                      : emptyName = false;
                  number.isEmpty
                      ? () {
                    mobileNumberErrorText = 'Enter mobile number';
                    emptyMobileNumber = true;
                  }
                      : emptyMobileNumber = false;
                  email.isEmpty
                      ? () {
                    emailErrorText='Enter email address';
                    emptyEmail = true;
                  }
                      : emptyEmail = false;
                  nid.isEmpty
                      ? emptyNidNumber = true
                      : emptyNidNumber = false;
                  postC.isEmpty
                      ? emptyZipCode = true
                      : emptyZipCode = false;
                  trdLic.isEmpty
                      ? emptyTradeLicence = true
                      : emptyTradeLicence = false;
                  div == 'Division'
                      ? emptyDivision = true
                      : emptyDivision = false;
                  dis == 'District'
                      ? emptyDistrict = true
                      : emptyDistrict = false;
                  upo == 'Upozila'
                      ? emptyUpozila = true
                      : emptyUpozila = false;
                });

                if (name.isEmpty ||
                    number.isEmpty ||
                    email.isEmpty ||
                    nid.isEmpty ||
                    postC.isEmpty ||
                    trdLic.isEmpty ||
                    div == 'Division' ||
                    dis == 'District' ||
                    upo == 'Upozila')
                  return;
                else {
                  if(!checkValidEmail(email)){
                    setState(() {
                      emailErrorText='Enter valid email address';
                      emptyEmail = true;
                    });
                  }
                  else if(number.length!=11){
                    setState(() {
                      mobileNumberErrorText = 'Enter valid mobile number';
                      emptyMobileNumber = true;
                    });
                  }
                  else if (!number.startsWith('016') &&
                      !number.startsWith('019') &&
                      !number.startsWith('014') &&
                      !number.startsWith('017') &&
                      !number.startsWith('013') &&
                      !number.startsWith('018') &&
                      !number.startsWith('015')) {
                    setState(() {
                      mobileNumberErrorText = 'Enter valid mobile number';
                      emptyMobileNumber = true;
                    });
                  }
                  else {
                    setState(() {
                      loading=true;
                    });
                    _firestore.collection('UserAgentSecretInformation').doc(_auth.currentUser!.uid).set({
                      'name': name,
                      'contactNumber':number,
                      'email':email,
                      'nidNumber':nid,
                      'division':div,
                      'district':dis,
                      'upozila':upo,
                      'postCode':int.parse(postC),
                      'tradeLicence':trdLic,
                      'verified':0,
                      'uid':_auth.currentUser!.uid,
                      'time': FieldValue.serverTimestamp(),
                    }).then((value) {
                      setState(() {
                        loading=false;
                      });
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => UserInfoPublicActivity()), (route) => false);
                    }).onError((error, stackTrace) {
                      setState(() {
                        loading=false;
                      });
                      Fluttertoast.showToast(msg: 'as774a '+error.toString());
                    });
                  }
                }
              },
              child: Container(
                color: MyColors.main_color,
                height: appBar.preferredSize.height,
                child: Center(
                  child: loading!
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 1,
                            ),
                          ),
                        )
                      : Text(
                          'CONTINUE',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool checkValidEmail(String text) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(text);
  }
}

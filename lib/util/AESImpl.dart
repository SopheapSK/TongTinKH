
class AESUtil{


  static String _encryptAES(String src, String keyAES){

    return "";

  }
  static String  encryptAES(String src, String keyAES){
    String enText = "";
      try{
       enText =  _encryptAES(src, keyAES);
      }catch(e){
        enText = "";
        print(e.toString());
      }
      return enText;
  }




}
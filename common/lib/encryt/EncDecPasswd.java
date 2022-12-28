import java.io.*;
import java.util.*;     
import java.util.Base64;
import java.util.Base64.Encoder;
import java.util.Base64.Decoder; 
                                                                      
public class EncDecPasswd {  
    public static void main(String[] args) throws Exception {
        String strEncDecGb  = "";
        String strPasswd    = "";
        if(args.length < 2) {
            System.out.println("패스워드 암복호화 실행조건이 잘못되었습니다.");
            System.out.println("패스워드 패스워드 암호화시 : ENC 패스워드 입력");
            System.out.println("패스워드 패스워드 복호화시 : DEC 암호화된 패스워드 입력");
            System.out.println("ex) 1.암호화시 : java EncDecPasswd2 ENC XXXXXXXXXXXXXXXXXX ");
            System.out.println("ex) 1.암호화시 : java EncDecPasswd2 DEC XXXXXXXXXXXXXXXXXX ");
            System.exit(1);
        } else {
            strEncDecGb = args[0];
            strPasswd   = args[1];
        }
        //System.out.println("strEncDecGb :" + strEncDecGb);
        //System.out.println("strPasswd   :" + strPasswd);
        
        try {
            /*----------- 암호화 -----------*/
            if(strEncDecGb.equals("ENC")) {
                byte[]  encBytes    = strPasswd.getBytes("UTF-8");
                Encoder encoder     = Base64.getEncoder();
                String  encString   = encoder.encodeToString(encBytes);
                System.out.println(" 패스워드 암호화 : [" + encString + "]");
                
            /*----------- 복호화 -----------*/
            } else if(strEncDecGb.equals("DEC")) { 
                Decoder decoder     = Base64.getDecoder();
                byte[]  decBytes    = decoder.decode(strPasswd);
                String  decString   = new String(decBytes, "UTF-8");
                System.out.println(decString);
            }
              
        } catch(Exception e) {
            System.out.println(e.getMessage());
        }
    }  
}
 

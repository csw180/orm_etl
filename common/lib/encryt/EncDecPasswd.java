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
            System.out.println("�н����� �Ϻ�ȣȭ ���������� �߸��Ǿ����ϴ�.");
            System.out.println("�н����� �н����� ��ȣȭ�� : ENC �н����� �Է�");
            System.out.println("�н����� �н����� ��ȣȭ�� : DEC ��ȣȭ�� �н����� �Է�");
            System.out.println("ex) 1.��ȣȭ�� : java EncDecPasswd2 ENC XXXXXXXXXXXXXXXXXX ");
            System.out.println("ex) 1.��ȣȭ�� : java EncDecPasswd2 DEC XXXXXXXXXXXXXXXXXX ");
            System.exit(1);
        } else {
            strEncDecGb = args[0];
            strPasswd   = args[1];
        }
        //System.out.println("strEncDecGb :" + strEncDecGb);
        //System.out.println("strPasswd   :" + strPasswd);
        
        try {
            /*----------- ��ȣȭ -----------*/
            if(strEncDecGb.equals("ENC")) {
                byte[]  encBytes    = strPasswd.getBytes("UTF-8");
                Encoder encoder     = Base64.getEncoder();
                String  encString   = encoder.encodeToString(encBytes);
                System.out.println(" �н����� ��ȣȭ : [" + encString + "]");
                
            /*----------- ��ȣȭ -----------*/
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
 

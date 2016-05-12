import java.io.*;
import java.security.MessageDigest;

public class md5 {    
  // Constants
  final String Algorithm = "MD5"; // or MD5 etc.
  final protected static char[] hexArray = "0123456789ABCDEF".toCharArray();
  
  public static void main(String[] args) throws Exception {
    String file = args[0];
    String hash = bytesToHex(md5Hash(file));
    System.out.println(hash);
  }

  
  public static String bytesToHex(byte[] bytes) {
  char[] hexChars = new char[bytes.length * 2];
  for (int i = 0; i < bytes.length; i++ ) {
    int v = bytes[i] & 0xFF;
    hexChars[i * 2] = hexArray[v >>> 4];
    hexChars[i * 2 + 1] = hexArray[v & 0x0F];
  }
  return new String(hexChars);
  }

  public static byte[] md5Hash(String filename) throws Exception {
  InputStream fis =  new FileInputStream(filename);
  try {
    byte[] buffer = new byte[1024];
    MessageDigest complete = MessageDigest.getInstance("MD5"); 
    int numRead;
    do {
    numRead = fis.read(buffer);
    if (numRead > 0) {
      complete.update(buffer, 0, numRead);
    }
    } while (numRead != -1);
    return complete.digest();
  }
  finally {
    fis.close();
  }
  }
}

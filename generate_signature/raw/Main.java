package testi;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.security.KeyFactory;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.Signature;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.PKCS8EncodedKeySpec;
import java.util.Base64;
/**
	Generate RAW signature from private key loaded from file
**/
public class Main {

	public static void main(String[] args) {
		try {
			PrivateKey privKey = loadPrivateKey("C:\\Users\\n.mojir\\Desktop\\VA\\Valid One Level\\Test_End_Entity_private_key.pem");
			
			String tbs = "helloo"; //to be signed
			
			Signature sig = Signature.getInstance("SHA256withRSA");
			sig.initSign(privKey);
			sig.update(tbs.getBytes());
			byte[] signature = sig.sign();
			System.out.println(Base64.getEncoder().encodeToString(signature));
		} catch (Exception e) {
			e.printStackTrace();
		}

	}
	
	private static PrivateKey loadPrivateKey(String filePath) throws InvalidKeySpecException, NoSuchAlgorithmException, IOException
	{
		File privKeyFile = new File(filePath);
		String privKeyStr = new String(Files.readAllBytes(privKeyFile.toPath()));
		
		String privKeyPEM = privKeyStr
			      .replace("-----BEGIN PRIVATE KEY-----", "")
			      .replaceAll("\n", "")
			      .replace("-----END PRIVATE KEY-----", "");
		
		byte[] encodedKey = Base64.getDecoder().decode(privKeyPEM);
		KeyFactory keyFactory = KeyFactory.getInstance("RSA");
		PKCS8EncodedKeySpec keySpec = new PKCS8EncodedKeySpec(encodedKey);
		return keyFactory.generatePrivate(keySpec);
	}

}

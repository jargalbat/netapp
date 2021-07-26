# Keytool path
C:\Program Files\Java\jdk1.8.0_221\bin

# Generate key
keytool -genkey -v -keystore D:/GitHub/netware/digital_signature/key.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias netwarealias

# Alias, password path
<app dir>/android/key.properties

# Alias, passwords
storePassword=netwarepassword
keyPassword=netwarepassword
keyAlias=netwarealias
storeFile=D:/GitHub/netware/digital_signature/key.jks

# Questions
What is your first and last name?
  [Unknown]:  Netware Netcapital
What is the name of your organizational unit?
  [Unknown]:  Netware
What is the name of your organization?
  [Unknown]:  Netware
What is the name of your City or Locality?
  [Unknown]:  Ulaanbaatar
What is the name of your State or Province?
  [Unknown]:  Ulaanbaatar
What is the two-letter country code for this unit?
  [Unknown]:  MN
Is CN=Netware Netcapital, OU=Netware, O=Netware, L=Ulaanbaatar, ST=Ulaanbaatar, C=MN correct?
  [no]:  yes
  
# Debug hash key
keytool -exportcert -alias androiddebugkey -keystore "C:\Users\pc\.android\debug.keystore" | "D:\Packages\openssl-0.9.8k_X64\bin\openssl.exe" sha1 -binary | "D:\Packages\openssl-0.9.8k_X64\bin\openssl.exe" base64

# Release hash key
keytool -exportcert -alias netwarealias -keystore "D:\GitHub\netware\digital_signature\key.jks" | "D:\Packages\openssl-0.9.8k_X64\bin\openssl.exe" sha1 -binary | "D:\Packages\openssl-0.9.8k_X64\bin\openssl.exe" base64
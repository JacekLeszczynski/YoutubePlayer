#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdbool.h>
#include <math.h>
#include <sys/time.h>
#include <mcrypt.h>
#include <sys/stat.h>
#include "aes.h"

#define TRUE  1;
#define FALSE 0;

long int filesize(char *filename)
{
    struct stat st;
    stat(filename, &st);
    return st.st_size;
}

long int fsize(char *filename)
{
    FILE *f;
    long int size;
    f=fopen(filename,"rb");
    if(!f) return -1;
    fseek(f,0,SEEK_END);
    size = ftell(f);
    fclose(f);
    return size;
}

bool FileExists(char *fname)
{
    if(access(fname,F_OK) == 0) {
        return 1;
    } else {
        return 0;
    }
}

bool FileNotExists(char *fname)
{
    return !FileExists(fname);
}

int length(char* s)
{
    return strlen(s);
}

char *UpCase(char *str)
{
   int i = 0;
   char pom[length(str)+1];
   while(str[i])
   {
      pom[i] = toupper(str[i]);
      i++;
   }
   pom[i]='\0';
   return strdup(pom);
}

char* trim(char *s)
{
    char *cp1;
    char *cp2;
    // usuwam spacje z przodu
    for (cp1=s; isspace(*cp1); cp1++ );
    for (cp2=s; *cp1; cp1++, cp2++) *cp2 = *cp1;
    *cp2-- = 0;
    // usuwam spacje z końca
    while ( cp2 > s && isspace(*cp2) ) *cp2-- = 0;
    return s;
}

int UnixTime()
{
    return (int)time(NULL);
}

char* LocalTime()
{
    time_t rawtime;
    struct tm * timeinfo;
    char buf[20];

    time (&rawtime);
    timeinfo = localtime (&rawtime);
    strftime(buf,sizeof buf,"%Y-%m-%d %H:%M:%S",timeinfo);

    return strdup(buf);
}

char* concat_str_char(char *tekst, char znak) {
  int a = strlen(tekst);
  char wynik[a+2];
  strncpy(wynik,tekst,a);
  wynik[a] = znak;
  wynik[a+1] = '\0';
  return strdup(wynik);
}

char* concat_char_str(char znak, char *tekst) {
  int a = strlen(tekst);
  char wynik[a+2];
  char *pom;
  *wynik = znak;
  pom = wynik;
  pom++;
  strncpy(pom,tekst,a);
  wynik[a+1] = '\0';
  return strdup(wynik);
}

char* concat(char *tekst1, char *tekst2) {
  int a = strlen(tekst1);
  int b = strlen(tekst2);
  char wynik[a+b+1];
  char *pom;
  strncpy(wynik,tekst1,a);
  pom = wynik;
  pom+=a;
  strncpy(pom,tekst2,b);
  wynik[a+b] = '\0';
  return strdup(wynik);
}

char *Concat(char *tekst1, char *tekst2)
{
    char *s;
    s = concat_str_char(tekst1,'$');
    s = concat(s,tekst2);
    return s;
}

char *concat2(char *tekst1, char *tekst2)
{
    char *s;
    s = concat_str_char(tekst1,'$');
    s = concat(s,tekst2);
    return s;
}

char *concat3(char *tekst1, char *tekst2, char *tekst3)
{
    char *s;
    s = concat_str_char(tekst1,'$');
    s = concat(s,tekst2);
    s = concat_str_char(s,'$');
    s = concat(s,tekst3);
    return s;
}

char *concat4(char *tekst1, char *tekst2, char *tekst3, char *tekst4)
{
    char *s;
    s = concat_str_char(tekst1,'$');
    s = concat(s,tekst2);
    s = concat_str_char(s,'$');
    s = concat(s,tekst3);
    s = concat_str_char(s,'$');
    s = concat(s,tekst4);
    return s;
}

char *dolar(char *tekst)
{
    return concat_str_char(tekst,'$');
}

char* String(char *tekst){
  int l = strlen(tekst);
  char s[l+1];
  strncpy(s,tekst,l);
  s[l] = '\0';
  return strdup(s);
}

char* StringReplace(char* string, const char* substr, const char* replacement) {
	char* tok = NULL;
	char* newstr = NULL;
	char* oldstr = NULL;
	int   oldstr_len = 0;
	int   substr_len = 0;
	int   replacement_len = 0;

	newstr = strdup(string);
	substr_len = strlen(substr);
	replacement_len = strlen(replacement);

	if (substr == NULL || replacement == NULL) {
		return newstr;
	}

	while ((tok = strstr(newstr, substr))) {
		oldstr = newstr;
		oldstr_len = strlen(oldstr);
		newstr = (char*)malloc(sizeof(char) * (oldstr_len - substr_len + replacement_len + 1));

		if (newstr == NULL) {
			free(oldstr);
			return NULL;
		}

		memcpy(newstr, oldstr, tok - oldstr);
		memcpy(newstr + (tok - oldstr), replacement, replacement_len);
		memcpy(newstr + (tok - oldstr) + replacement_len, tok + substr_len, oldstr_len - substr_len - (tok - oldstr));
		memset(newstr + oldstr_len - substr_len + replacement_len, 0, 1);

		free(oldstr);
	}

	free(string);

	return newstr;
}

char *StrBase(char *aValue, int aLength)
{
  int a;
  int i;
  char *wsk;
  a = length(aValue);
  if (a>aLength) {
    char *s = aValue;
    return s;
  } else {
    char s[aLength+1];
    wsk=s;
    for (i=0; i<aLength-a; i++)
    {
      *wsk='0';
      wsk++;
    }
    *wsk='\0';
    return concat(s,aValue);
  }
}

int IntToB256(int liczba, unsigned char **buffer, int size)
{
    char *p = *buffer;
    int l,i,j,n,pom;
    l = 0;
    n = liczba;
    do {
        if (l+1>size) return -1;
        for (i=l;i>0;i--) p[i] = p[i-1];
        pom = n % 256;
        *p = (unsigned char)pom;
        n = div(n,256).quot;
        l++;
    } while (n!=0);
    for (i=1;i<=size-l;i++)
    {
        for (j=l;j>0;j--) p[j] = p[j-1];
        *p = (unsigned char)0;
    }
    return l;
}

int B256ToInt(unsigned char *buffer, int size)
{
    int i,m=1,r=0;
    int b;
    for (i=size-1;i>=0;i--)
    {
        b=buffer[i];
        r=r+b*m;
        m=m << 8;
    }
    return r;
}

/*
function B256ToInt(const buffer; size: integer): integer;
var
  p: PPBuffer256;
  i, M: Integer;
  b: byte;
begin
  p:=@buffer;
  Result:=0;
  M:=1;
  for i:=size-1 downto 0 do
  begin
    b:=ord(p^[i]);
    Result:=Result+b*M;
    M:=M shl 8;
  end;
end;
*/

char *IntToSys(int aLiczba, int aBaza)
{
     char znaki[62] = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
     char *wynik = "";
     int n = aLiczba, pom;
     do {
        pom = n % aBaza;
        wynik = concat_char_str(znaki[pom],wynik);
        n = div(n,aBaza).quot;
     } while (n!=0);
     return wynik;
}

char *LongIntToSys(long int aLiczba, int aBaza)
{
     char znaki[62] = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
     char *wynik = "";
     long int n = aLiczba, pom;
     do {
        pom = n % aBaza;
        wynik = concat_char_str(znaki[pom],wynik);
        n = div(n,aBaza).quot;
     } while (n!=0);
     return wynik;
}

char *UnsignedIntToSys(unsigned int aLiczba, int aBaza)
{
     char znaki[62] = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
     char *wynik = "";
     unsigned int n = aLiczba, pom;
     do {
        pom = n % aBaza;
        wynik = concat_char_str(znaki[pom],wynik);
        n = div(n,aBaza).quot;
     } while (n!=0);
     return wynik;
}

char *uIntToHex(uint aLiczba)
{
    char wynik[50];
    sprintf(wynik,"%x",aLiczba);
    return strdup(wynik);
}

char *ltoa(long int aLiczba)
{
    char wynik[50];
    sprintf(wynik,"%ld",aLiczba);
    return strdup(wynik);
}

unsigned int crc32block(unsigned char *message, int size)
{
   int i, j;
   unsigned int byte, crc, mask;

   i = 0;
   crc = 0xFFFFFFFF;
   while (i < size) {
      byte = message[i];            // Get next byte.
      crc = crc ^ byte;
      for (j = 7; j >= 0; j--) {    // Do eight times.
         mask = -(crc & 1);
         crc = (crc >> 1) ^ (0xEDB88320 & mask);
      }
      i = i + 1;
   }
   return ~crc;
}

char *crc32blockhex(unsigned char *message, int size)
{
    return UpCase(uIntToHex(crc32block(message,size)));
}

unsigned int crc32(unsigned char *message)
{
   int i, j;
   unsigned int byte, crc, mask;

   i = 0;
   crc = 0xFFFFFFFF;
   while (message[i] != 0) {
      byte = message[i];            // Get next byte.
      crc = crc ^ byte;
      for (j = 7; j >= 0; j--) {    // Do eight times.
         mask = -(crc & 1);
         crc = (crc >> 1) ^ (0xEDB88320 & mask);
      }
      i = i + 1;
   }
   return ~crc;
}

char *crc32hex(unsigned char *message)
{
    return UpCase(uIntToHex(crc32(message)));
}

char* itoa(int val, int base)
{
     return IntToSys(val,base);
}

long CurrentTimeMillisecond() {
  struct timeval time;
  gettimeofday(&time, NULL);
  return time.tv_sec * 1000 + time.tv_usec;
}

void Randomize()
{
     srand(CurrentTimeMillisecond());
}

void randomize()
{
     srand(time(NULL));
}

int Rand(int min_num, int max_num)
{
    int result = 0, low_num = 0, hi_num = 0;

    if (min_num < max_num)
    {
        low_num = min_num;
        hi_num = max_num + 1; // include max_num in output
    } else {
        low_num = max_num + 1; // include max_num in output
        hi_num = min_num;
    }
    result = (rand() % (hi_num - low_num)) + low_num;
    return result;
}

char *GetUuid()
{
    char *uuid;
    int unix_time = UnixTime();
    int l1 = Rand(0,65535);
    int l2 = Rand(0,65535);
    int l3 = Rand(0,65535);
    int l4 = Rand(0,16777215);
    int l5 = Rand(0,16777215);
    char *s = IntToSys(unix_time,16);
    char *s1 = StrBase(IntToSys(l1,16),4);
    char *s2 = StrBase(IntToSys(l2,16),4);
    char *s3 = StrBase(IntToSys(l3,16),4);
    char *s4 = StrBase(IntToSys(l4,16),6);
    char *s5 = StrBase(IntToSys(l5,16),6);
    uuid = concat_str_char(s,'-');
    uuid = concat(uuid,s1);
    uuid = concat_str_char(uuid,'-');
    uuid = concat(uuid,s2);
    uuid = concat_str_char(uuid,'-');
    uuid = concat(uuid,s3);
    uuid = concat_str_char(uuid,'-');
    uuid = concat(uuid,s4);
    uuid = concat(uuid,s5);
    return uuid;
}

int pos(char *substring, char *string)
{
  int start_index = 0;
  int string_index = 0, substring_index = 0;
  int substring_len = length(substring);
  int s_len = length(string);
  while(substring_index<substring_len && string_index<s_len){
    if(*(string+string_index)==*(substring+substring_index)){
      substring_index++;
    }
    string_index++;
    if(substring_index==substring_len){
      return string_index-substring_len+1;
    }
  }
  return 0;
}

int HexToDec(char *hex)
{
    int i, m = 1, r = 0;
    char *str = UpCase(hex);

    for (i=length(str)-1; i>=0; i--)
    {
      if (str[i]>='0' && str[i]<='9') {r=r+(str[i]-'0')*m;} else
      if (str[i]>='A' && str[i]<='F') {r=r+(str[i]-'A'+10)*m;}
      m = m << 4;
    }

    return r;
}

char *copy(char *str, int start, int ile)
{
     char s[ile+1];
     char *pom;
     int i;
     pom = str;
     for (i=1; i<start; i++) pom++;
     strncpy(s,pom,ile);
     pom = s;
     pom+=ile;
     *pom = '\0';
     return strdup(s);
}

/* ciag 24 znaków (znacząca jest wielkość liter!) */
char *GetUuidCompress()
{
     char *uuid = GetUuid();
     char *s = StringReplace(uuid,"-","");
     int i;
     char *s1 = "";
     char *pom;
     for (i=0; i<8; i++)
     {
         s1 = concat(s1,StrBase(IntToSys(HexToDec(copy(s,i*4+1,4)),62),3));
     }
     return s1;
}

char *GetLineToStr(char *aStr, int l, char separator, char *wynik)
{
  int i, ll = 1, dl = strlen(aStr);
  bool b = 0;
  char *s = concat(aStr," "), *pom;
  pom = s;
  pom+=dl;
  *pom = separator;
  // wyszukuję początek żądanego elementu
  pom = s;
  for (i=0; i<dl; i++)
  {
    if (*pom=='"') {b=!b;}
    if (!b && *pom==separator) ll++;
    if (ll==l) break;
    pom++;
  }
  if (*pom==separator) pom++;
  s=pom;
  // wyszukuję koniec żądanego elementu
  b = 0;
  for (i=0; i<strlen(s); i++)
  {
    if (*pom=='"') {b=!b;}
    if ((!b && *pom=='"') || (!b && *pom==separator)) break;
    pom++;
  }
  *pom='\0';
  if (*s=='"') s++;
  if (*s==separator) s++;
  if (s[strlen(s)-1]==separator) s[strlen(s)-1]='\0';
  // jeśli puste zwracam wynik, w innym razie zwracam co wyszło
  if (*s=='\0') return wynik; else return s;
}

int TimeToInteger()
{
  time_t czas = time(NULL);
  struct timespec ts;
  timespec_get(&ts, TIME_UTC);
  int h, m, s, a;
  h = localtime(&czas)->tm_hour;
  m = localtime(&czas)->tm_min;
  s = localtime(&czas)->tm_sec;
  a = (h * 60 * 60 * 1000) + (m * 60 * 1000) + (s * 1000) + round(ts.tv_nsec/1000000);
  return a;
}

char *AliasNull(char *aStr, char *aAlias)
{
    return StringReplace(aStr,aAlias,"NULL");
}

char *AliasStr(char *aStr, char *aAlias, char *aValue)
{
    char bufor[strlen(aValue)+2];
    sprintf(bufor,"'%s'",aValue);
    return StringReplace(aStr,aAlias,bufor);
}

char *AliasStrInt(char *aStr, char *aAlias, char *aValue)
{
    return StringReplace(aStr,aAlias,aValue);
}

char *AliasIntStr(char *aStr, char *aAlias, char *aValue)
{
    return StringReplace(aStr,aAlias,aValue);
}

char *AliasInt(char *aStr, char *aAlias, int aValue)
{
    char bufor[50];
    sprintf(bufor,"%ld",aValue);
    return StringReplace(aStr,aAlias,bufor);
}

/* SZYFROWANIE I DESZYFROWANIE CIĄGU ZNAKÓW */

int _encrypt(
    void* buffer,
    int buffer_len, /* Because the plaintext could include null bytes*/
    char* IV,
    char* key,
    int key_len
){
  MCRYPT td = mcrypt_module_open("rijndael-128", NULL, "cbc", NULL);
  int blocksize = mcrypt_enc_get_block_size(td);
  if( buffer_len % blocksize != 0 ){return 1;}

  mcrypt_generic_init(td, key, key_len, IV);
  mcrypt_generic(td, buffer, buffer_len);
  mcrypt_generic_deinit (td);
  mcrypt_module_close(td);

  return 0;
}

int _encrypt2(void *buf, int size, char *iv, char *key, int key_len)
{
    struct AES_ctx ctx;
    AES_init_ctx_iv(&ctx,key,iv);
    AES_CBC_encrypt_buffer(&ctx,buf,size);
    return 0;
}

int _decrypt2(void *buf, int size, char *iv, char *key, int key_len)
{
    struct AES_ctx ctx;
    AES_init_ctx_iv(&ctx,key,iv);
    AES_CBC_decrypt_buffer(&ctx,buf,size);
    return 0;
}

           /*
ilość odebranych danych v = 18
0 10 10 26 59 54 88 5b b4 2a 77 2c bf 3 11 5f 16 9f
  BLOK = 16
Przed: 10 26 59 54 88 5b b4 2a 77 2c bf 3 11 5f 16 9f
   Po: 7f 88 cc 13 2e 98 c2 87 71 cb da 7d 4d 1e ab 2b
  l=16 ll=32648 (7f 88) l1=52243 l2=-19595
           */

int _decrypt(
    void* buffer,
    int buffer_len,
    char* IV,
    char* key,
    int key_len
){
  MCRYPT td = mcrypt_module_open("rijndael-128", NULL, "cbc", NULL);
  int blocksize = mcrypt_enc_get_block_size(td);
  if( buffer_len % blocksize != 0 ){return 1;}

  mcrypt_generic_init(td, key, key_len, IV);
  mdecrypt_generic(td, buffer, buffer_len);
  mcrypt_generic_deinit (td);
  mcrypt_module_close(td);

  return 0;
}

void _display(char *tekst, char *s, int len)
{
  int i,a;
  fprintf(stderr,"%s",tekst);
  for (i=0; i<len; i++)
  {
    a = s[i];
    fprintf(stderr,"%hhx ",s[i]);
  }
  fprintf(stderr,"\n");
}

//szukasz liczby ktora zmiesci sie tobie
//w buforze, który musi być wielokrotnością
//liczby "aStala" - glugosc takiego buforu
//zostanie obliczona.
int CalcBuffer(int aLen)
{
  div_t o = div(aLen,16);
  int r = o.quot;
  if (o.rem>0) r++;
  return r*16;
}

char *GenNewVector(int size)
{
  char *tmp;
  int l1 = Rand(0,65535);
  int l2 = Rand(0,65535);
  int l3 = Rand(0,65535);
  int l4 = Rand(0,65535);
  char *s1 = StrBase(IntToSys(l1,16),4);
  char *s2 = StrBase(IntToSys(l2,16),4);
  char *s3 = StrBase(IntToSys(l3,16),4);
  char *s4 = StrBase(IntToSys(l4,16),4);
  if (size == 8){
    tmp = concat(s1,s2);
  } else
  if (size == 16){
    tmp = concat(s1,s2);
    tmp = concat(tmp,s3);
    tmp = concat(tmp,s4);
  }
  return tmp;
}

int StringEncrypt(char **buf, int len, char *IV, char *key)
{
  char *tmp = *buf;
  int l = CalcBuffer(len);

  if (len == 0) len = strlen(tmp);
  _encrypt2(tmp,l,IV,key,strlen(key));
  return l;
}

int UStringEncrypt(unsigned char **buf, int len, char *IV, char *key)
{
  unsigned char *tmp = *buf;
  int l = CalcBuffer(len);

  if (len == 0) len = strlen(tmp);
  _encrypt(tmp,l,IV,key,strlen(key));
  return l;
}

int StringDecrypt(char **buf, int len, char *IV, char *key)
{
  char *tmp = *buf;
  int l = len;

  _decrypt(tmp,len,IV,key,strlen(key));
  l = strlen(tmp);
  return l;
}


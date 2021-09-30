#include <sys/types.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <netinet/in.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <pthread.h>
#include <mysql/mysql.h>
#include "lazc.h"
#include <locale.h>
#include <fcntl.h>
#include <signal.h>
#include "keystd.h"

#define RUNNING_DIR	"/disk/dbases"
#define LOCK_FILE	"/var/run/studio.jahu.pid"
#define LOG_FILE	"/disk/log/studio.jahu.log"

#define DB_HOST         "127.0.0.1"
#define DB_DATABASE     "komunikator"
#define DB_USER         "komunikatoruser"
#define DB_PASS         "YFGzdcRwKUO7e8cTgYT7"

#define CONST_MAX_CLIENTS 5000
#define CONST_MAX_BUFOR 65535
#define CONST_MAX_FILE_BUFOR 1024
#define SLEEP_DOWN_UP_LOADS 0

const int ACTIVES = 6;

struct client_info {
    int sockno;
    char ip[INET_ADDRSTRLEN];
    int port;
    char ip2[INET_ADDRSTRLEN];
    int port2;
    char key[25];
};

int my_sock, is_port;
int sockfd; //soket serwera UDP
//int their_sock;
char znaczek = 1;
int server;
int clients[CONST_MAX_CLIENTS];
char key[CONST_MAX_CLIENTS][25];
char vector[CONST_MAX_CLIENTS][17];
char ips[CONST_MAX_CLIENTS][INET_ADDRSTRLEN];
int ports[CONST_MAX_CLIENTS];


/*
  ACTIVES:
    0 - LOGIN;         - zawsze aktywny, umożliwia zalogowanie się itd.
    1 - POZ_1;         - podstawowa komunikacja, aktywna dla wszystkich zalogowanych
    2 - POZ_2;         - (nieużywane)
    3 - POZ_3;         - (nieuzywane)
    4 - STUDIO JAHU;   - platforma studia jahu (monitor)
    5 - CHAT           - chat (chat grupowy)
*/
bool actives[CONST_MAX_CLIENTS][6];
char niki[CONST_MAX_CLIENTS][51];
int n = 0, mn = 0, ischat = 0;
int error = 0;
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
MYSQL *db;

#include "komunikacja.c"

// int id = mysql_insert_id(db);

/* FUNKCJA TESTUJĄCA */
int test()
{
    return 0;

    char *sql;
    MYSQL_ROW row;
    MYSQL_RES *res;
    int a = -1;
    char *s;

    db = mysql_init(NULL);
    if (!mysql_real_connect(db,DB_HOST,"tao","nahalia","filmy",0,NULL,0)) {
      fprintf(stderr, "%s\n", mysql_error(db));
      return(1);
    }

    sql = String("select id,nazwa,rok_produkcji,aktualizacja from filmy where nazwa like :nazwa and rok_produkcji=:rok");
    sql = AliasStr(sql,":nazwa","%horror%");
    sql = AliasInt(sql,":rok",2021);
    if (mysql_query(db,sql)) fprintf(stderr, "ERROR: %s\n", mysql_error(db));

    res = mysql_store_result(db);
    while ((row = mysql_fetch_row(res)) != NULL) {
        const int id = atoi(row[0]);
        const char *nazwa = row[1];
        const char *rok = row[2];
        const char *data = row[3];
        printf("id=%d nazwa=%s rok=%s data=%s\n",id,nazwa,rok,data);
    }
    mysql_free_result(res);

    //if (mysql_num_rows(res))
    //{
    //    row = mysql_fetch_row(res);
    //    a = atoi(row[0]);
    //}
    //mysql_free_result(res);

    mysql_close(db);


    //fprintf(stderr,"Wynik: ILOŚĆ = %d\n",a);

    return(1);
}

void log_message(char *filename, char *message)
{
    FILE *logfile;
    logfile=fopen(filename,"a");
    if(!logfile) return;
    fprintf(logfile,"%s %s\n",LocalTime(),message);
    fclose(logfile);
}

void LOG(char *rodzaj, char *title, char *message)
{
    char *q;

    q = String("insert into log (rodzaj,title,message) values (:rodzaj,:title,:message)");
    q = AliasStr(q,":rodzaj",rodzaj);
    q = AliasStr(q,":title",title);
    q = AliasStr(q,":message",message);
    if (mysql_query(db,q)) fprintf(stderr,"%s\n",mysql_error(db));
}

bool ExecSQL(char *sql)
{
    char *err = 0;
    if (mysql_query(db,sql)) {fprintf(stderr,"SQL Error: %s\n",mysql_error(db)); return 1;}
    return 0;
}

bool KluczToDb(char *klucz)
{
    char *q;
    //LOG("I","ExecSQL","Klucz to DB");
    q = String("insert into klucze (klucz) values (:klucz)");
    q = AliasStr(q,":klucz",klucz);
    if (mysql_query(db,q)) {
        fprintf(stderr,"%s\n",mysql_error(db));
        return 1;
    }
    return 0;
}

void RemoveKluczFromDb(char *klucz)
{
    char *q;
    //LOG("I","ExecSQL","Remove Klucz z DB");
    q = String("delete from klucze where klucz=:klucz");
    q = AliasStr(q,":klucz",klucz);
    mysql_query(db,q);
}

bool DbKluczIsExists(char *klucz)
{
    char *q;
    MYSQL_ROW row;
    MYSQL_RES *res;
    int a = 0;

    //LOG("I","ExecSQL","DbKluczIsExists");
    q = String("select count(*) as ile from klucze where klucz=:klucz");
    q = AliasStr(q,":klucz",klucz);
    mysql_query(db,q);
    res = mysql_use_result(db);
    row = mysql_fetch_row(res);
    if (mysql_num_rows(res)) a = atoi(row[0]);
    mysql_free_result(res);
    return a>0;
}

bool DbKluczIsNotExists(char *klucz)
{
    return !DbKluczIsExists(klucz);
}

bool RequestRegisterNewKey(char *stary, char *nowy, bool UsunStaryKlucz, bool aMutex)
{
    bool b1,b2;
    if (strcmp(stary,nowy)!=0)
    {
        if (aMutex) pthread_mutex_lock(&mutex);
        /* czy stary klucz istnieje */
        b1 = DbKluczIsExists(stary);
        /* czy nowy klucz istnieje */
        b2 = DbKluczIsExists(nowy);
        /* usuwam stary klucz */
        if (b1 && UsunStaryKlucz) RemoveKluczFromDb(stary);
        /* dodaję nowy klucz */
        if (!b2) KluczToDb(nowy);
        if (aMutex) pthread_mutex_unlock(&mutex);
    }
    return 1;
}

bool PytanieToDb(char *klucz, char *nick, char *pytanie)
{
    char *q;
    q = String("insert into pytania (klucz,nick,pytanie) values (:klucz,:nick,:pytanie)");
    q = AliasStr(q,":klucz",klucz);
    q = AliasStr(q,":nick",nick);
    q = AliasStr(q,":pytanie",pytanie);
    if (mysql_query(db,q)) return 1;
    return 0;
}

//TABLE prive (id integer primary key,dt_insert text,nadawca text,adresat text,tresc text)
bool PriveMessageToDB(char *nadawca, char *nick, char* adresat, char *formatowanie, char *tresc, char *czas, char *indeks_pliku)
{
    char *q;
    if (strcmp(indeks_pliku,"")==0) {
        q = String("insert into prive (nadawca,nick,adresat,formatowanie,tresc) values (:nadawca,:nick,:adresat,:formatowanie,:tresc)");
    } else {
        q = String("insert into prive (nadawca,nick,adresat,formatowanie,tresc,indeks_pliku) values (:nadawca,:nick,:adresat,:formatowanie,:tresc,:plik)");
        q = AliasStr(q,":plik",indeks_pliku);
    }
    q = AliasStr(q,":nadawca",nadawca);
    q = AliasStr(q,":nick",nick);
    q = AliasStr(q,":adresat",adresat);
    q = AliasStr(q,":formatowanie",formatowanie);
    q = AliasStr(q,":tresc",tresc);
    if (mysql_query(db,q)) return 1;
    return 0;
}

/*CREATE TABLE wersja (id integer primary key,major integer,minor integer,rel integer,build integer)*/
int SetVersionProg(int a1,int a2,int a3,int a4)
{
    char *q;
    int a = 0;

    pthread_mutex_lock(&mutex);
    q = String("call SetVer(:major,:minor,:rel,:build)");
    q = AliasInt(q,":major",a1);
    q = AliasInt(q,":minor",a2);
    q = AliasInt(q,":rel",a3);
    q = AliasInt(q,":build",a4);
    if (mysql_query(db,q)) {pthread_mutex_unlock(&mutex); return 1;}
    pthread_mutex_unlock(&mutex);

    return 0;
}

/*CREATE TABLE wersja (id integer primary key,major integer,minor integer,rel integer,build integer)*/
void InfoVersionProg(int sock_adresat)
{
    MYSQL_RES *res;
    MYSQL_ROW row;
    char *s,*ss;
    int a1=0,a2=0,a3=0,a4=0;

    /* poinformowanie wszystkich o nowej wersji programu */
    pthread_mutex_lock(&mutex);
    if (mysql_query(db,"select GetVersion()")) {pthread_mutex_unlock(&mutex); return;}
    res = mysql_store_result(db);
    if ((row = mysql_fetch_row(res)) != NULL) {
        s = row[0];
        a1 = atoi(GetLineToStr(s,1,',',"0"));
        a2 = atoi(GetLineToStr(s,2,',',"0"));
        a3 = atoi(GetLineToStr(s,3,',',"0"));
        a4 = atoi(GetLineToStr(s,4,',',"0"));
    }
    mysql_free_result(res);
    /* przygotowuję i wysyłam ramkę odpowiedzi */
    ss = concat4("{NEW_VERSION}",IntToSys(a1,10),IntToSys(a2,10),IntToSys(a3,10));
    ss = concat2(ss,IntToSys(a4,10));
    sendtouser(ss,0,sock_adresat,1,0);
    pthread_mutex_unlock(&mutex);
}

int ReadPytania(int nadawca, int adresat) //zwraca ilość przeczytanych pytań
{
    //CREATE TABLE pytania (id integer primary key,czas text,klucz text,nick text,pytanie text)
    MYSQL_RES *res;
    MYSQL_ROW row;
    int l = 0;
    char *s, *w;
    pthread_mutex_lock(&mutex);
    if (mysql_query(db,"select id,czas,klucz,nick,pytanie from pytania order by id")) {pthread_mutex_unlock(&mutex);; return 0;}
    res = mysql_store_result(db);
    while ((row = mysql_fetch_row(res)) != NULL) {
        const int id = atoi(row[0]);
        const char *czas = row[1];
        const char *klucz = row[2];
        const char *nick = row[3];
        const char *pytanie = row[4];
        s = concat4("{PYTANIE}",strdup(klucz),strdup(nick),strdup(pytanie));
        s = concat2(s,strdup(czas));
        sendtouser(s,nadawca,adresat,0,0);
        l++;
    }
    mysql_free_result(res);
    ExecSQL("delete from pytania");
    pthread_mutex_unlock(&mutex);
    return l;
}

int PrivMessageFromDbToUser(int sock_adresat, char *key) //zwracam ilość zczytanych rekordów
{
    MYSQL_RES *res;
    MYSQL_ROW row;
    char *q;
    int n = 0, a = 0;
    char *s;
    pthread_mutex_lock(&mutex);
    /* sprawdzam czy są jakieś rekordy */
    q = String("select count(*) from prive where adresat=:adresat");
    q = AliasStr(q,":adresat",key);
    if (mysql_query(db,q)) {pthread_mutex_unlock(&mutex); return -1;}

    res = mysql_store_result(db);
    if ((row = mysql_fetch_row(res)) != NULL) a = atoi(row[0]);
    mysql_free_result(res);
    if (a==0) {pthread_mutex_unlock(&mutex); return 0;}
    /* wysyłam zawartość */
    q = String("select dt_insert,nadawca,nick,adresat,formatowanie,tresc,indeks_pliku from prive where adresat=:adresat order by id");
    q = AliasStr(q,":adresat",key);
    if (mysql_query(db,q)) {pthread_mutex_unlock(&mutex); return -2;}
    res = mysql_store_result(db);
    while ((row = mysql_fetch_row(res)) != NULL) {
        const char *czas = row[0];
        const char *nadawca = row[1];
        const char *nick = row[2]; //na razie brak, więc wrzucam nadawcę
        const char *adresat = row[3];
        const char *formatowanie = row[4];
        const char *tresc = row[5];
        const char *indeks = row[6];
        s = concat4("{CHAT}",strdup(nadawca),strdup(nick),strdup(adresat));
        s = concat4(s,strdup(formatowanie),strdup(tresc),strdup(czas));
        s = dolar(s);
        if (indeks!=NULL) s = concat(s,strdup(indeks));
        sendtouser(s,0,sock_adresat,1,0);
        n++;
    }
    mysql_free_result(res);
    /* usuwam to co pobralem */
    q = String("delete from prive where adresat=:adresat");
    q = AliasStr(q,":adresat",key);
    if (mysql_query(db,q)) {pthread_mutex_unlock(&mutex); return -3;}
    pthread_mutex_unlock(&mutex);
    return n;
}

char *IniReadStr(char *zmienna, bool now_mutex)
{
    char *q;
    MYSQL_RES *res;
    MYSQL_ROW row;
    char *s;
    if (now_mutex) pthread_mutex_lock(&mutex);
    q = String("select value_text from config where zmienna=:zmienna");
    q = AliasStr(q,":zmienna",zmienna);
    if (mysql_query(db,q)) {if (now_mutex) pthread_mutex_unlock(&mutex); return "";}
    res = mysql_store_result(db);
    if ((row = mysql_fetch_row(res)) != NULL) s = row[0]; else s = "";
    mysql_free_result(res);
    if (now_mutex) pthread_mutex_unlock(&mutex);
    return s;
}

int IniReadInt(char *zmienna, bool now_mutex)
{
    char *q;
    MYSQL_RES *res;
    MYSQL_ROW row;
    int a;
    if (now_mutex) pthread_mutex_lock(&mutex);
    q = String("select value_int from config where zmienna=:zmienna");
    q = AliasStr(q,":zmienna",zmienna);
    if (mysql_query(db,q)) {if (now_mutex) pthread_mutex_unlock(&mutex); return 0;}
    res = mysql_store_result(db);
    if ((row = mysql_fetch_row(res)) != NULL) a = atoi(row[0]); else a = 0;
    mysql_free_result(res);
    if (now_mutex) pthread_mutex_unlock(&mutex);
    return a;
}

bool IniWriteStr(char *zmienna, char *wartosc, bool now_mutex)
{
    char *q;
    MYSQL_RES *res;
    MYSQL_ROW row;
    int id;
    if (now_mutex) pthread_mutex_lock(&mutex);
    /* sprawdzam czy rekord istnieje */
    q = String("select id from config where zmienna=:s");
    q = AliasStr(q,":s",zmienna);
    if (mysql_query(db,q)) {if (now_mutex) pthread_mutex_unlock(&mutex); return 0;}
    res = mysql_store_result(db);
    if ((row = mysql_fetch_row(res)) != NULL) id = atoi(row[0]); else id = 0;
    mysql_free_result(res);
    /* dodaję lub aktualizuję rekord */
    if (id==0)
    {
        /* dodaję rekord */
        q = String("insert into config (zmienna,value_text) values (:s1,:s2)");
        q = AliasStr(q,":s1",zmienna);
        q = AliasStr(q,":s2",wartosc);
        if (mysql_query(db,q)) {if (now_mutex) pthread_mutex_unlock(&mutex); return 0;}
    } else {
        /* aktualizuję rekord */
        q = String("update config set value_text=:s1 where zmienna=:s2");
        q = AliasStr(q,":s1",wartosc);
        q = AliasStr(q,":s2",zmienna);
        if (mysql_query(db,q)) {if (now_mutex) pthread_mutex_unlock(&mutex); return 0;}
    }
    if (now_mutex) pthread_mutex_unlock(&mutex);
    return 1;
}

bool IniWriteInt(char *zmienna, int wartosc, bool now_mutex)
{
    char *q;
    MYSQL_RES *res;
    MYSQL_ROW row;
    int id;
    if (now_mutex) pthread_mutex_lock(&mutex);
    /* sprawdzam czy rekord istnieje */
    q = String("select id from config where zmienna=:s");
    q = AliasStr(q,":s",zmienna);
    if (mysql_query(db,q)) {if (now_mutex) pthread_mutex_unlock(&mutex); return 0;}
    res = mysql_store_result(db);
    if ((row = mysql_fetch_row(res)) != NULL) id = atoi(row[0]); else id = 0;
    mysql_free_result(res);
    /* dodaję lub aktualizuję rekord */
    if (id==0)
    {
        /* dodaję rekord */
        q = String("insert into config (zmienna,value_int) values (:zmienna,:wartosc)");
    } else {
        /* aktualizuję rekord */
        q = String("update config set value_int=:wartosc where zmienna=:zmienna");
    }
    q = AliasStr(q,":zmienna",zmienna);
    q = AliasInt(q,":wartosc",wartosc);
    if (mysql_query(db,q)) {if (now_mutex) pthread_mutex_unlock(&mutex); return 0;}
    if (now_mutex) pthread_mutex_unlock(&mutex);
    return 1;
}

char *FileNew(char *key,char *nick,char *nazwa,char *dlugosc)
{
    char *q;
    MYSQL_RES *res;
    MYSQL_ROW row;
    char *s, *indeks, *czas = LocalTime();
    int a;
    char *sciezka;
    pthread_mutex_lock(&mutex);
    /* pobieram indeks */
    if (mysql_query(db,"select value_int from config where zmienna='file_index'")) {pthread_mutex_unlock(&mutex); return "";}
    res = mysql_store_result(db);
    if ((row = mysql_fetch_row(res)) != NULL) a = atoi(row[0]); else a = 0;
    mysql_free_result(res);
    /* zwiększam o jeden ten odczytany w tabeli config */
    if (a==0)
    {
        /* nie istnieje - dodaję o indeksie kolejnym */
        if (mysql_query(db,"insert into config (zmienna,value_int) values ('file_index',2)")) {pthread_mutex_unlock(&mutex); return "";}
        a = 1;
    } else {
        /* istnieje - aktualizuję indeks wartością zwiększoną o jeden */
        q = String("update config set value_int=:wartosc where zmienna='file_index'");
        q = AliasInt(q,":wartosc",a+1);
        if (mysql_query(db,q)) {pthread_mutex_unlock(&mutex); return "";}
    }
    /* obliczenia */
    indeks = StrBase(IntToSys(a,16),8);
    sciezka = concat("/disk/komunikator_files/",indeks);
    sciezka = concat(sciezka,".dat");
    /* dodaję rekord */
    q = String("insert into pliki (indeks,nick,klucz,nazwa,sciezka,dlugosc) values (:indeks,:nick,:klucz,:nazwa,:sciezka,:dlugosc)");
    q = AliasStr(q,":indeks",indeks);
    q = AliasStr(q,":nick",nick);
    q = AliasStr(q,":klucz",key);
    q = AliasStr(q,":nazwa",nazwa);
    q = AliasStr(q,":sciezka",sciezka);
    q = AliasIntStr(q,":dlugosc",dlugosc);
    if (mysql_query(db,q)) {pthread_mutex_unlock(&mutex); return "";}
    s = concat2(indeks,sciezka);
    pthread_mutex_unlock(&mutex);
    return s;
}

bool FileOpis(char *key,char *indeks,char *opis,char *bufor,int size)
{
    /* dodanie opisu */
    MYSQL_RES *res;
    MYSQL_ROW row;
    char *q, *pom;
    bool b;
    pthread_mutex_lock(&mutex);
    /* sprawdzam czy rekord o podanym kluczu i indeksie istnieje */
    q = String("select count(*) as ile from pliki where indeks like :indeks and klucz like :klucz");
    q = AliasStr(q,":indeks",indeks);
    q = AliasStr(q,":klucz",key);
    if (mysql_query(db,q)) {pthread_mutex_unlock(&mutex); return 0;}
    res = mysql_store_result(db);
    if ((row = mysql_fetch_row(res)) != NULL) b = atoi(row[0]); else b = 0;
    mysql_free_result(res);
    /* aktualizacja */
    if (b)
    {
        q = String("update pliki set opis=:opis, awatar=:awatar where indeks like :indeks and klucz like :klucz");
        if (strcmp(opis,"")==0) q = AliasNull(q,":opis"); else q = AliasStr(q,":opis",opis);
        q = AliasStr(q,":indeks",indeks);
        q = AliasStr(q,":klucz",key);
        if (size==0) {
            q = AliasNull(q,":awatar");
            if (mysql_query(db,q)) {pthread_mutex_unlock(&mutex); return 0;}
        } else {
            q = AliasStr(q,":awatar","%s");
            char chunk[2*size+1];
            mysql_real_escape_string(db,chunk,bufor,size);
            size_t st_len = strlen(q);
            char query[st_len + 2*size+1];
            int len = snprintf(query,st_len+2*size+1,q,chunk);
            if (mysql_real_query(db,query,len)) {pthread_mutex_unlock(&mutex); return 0;}
        }
    }
    pthread_mutex_unlock(&mutex);
    return b;
}

bool FileToPublic(char *key,char *indeks,bool reverse)
{
    char *q;
    MYSQL_RES *res;
    MYSQL_ROW row;
    bool b;
    pthread_mutex_lock(&mutex);
    /* sprawdzam czy rekord o podanym kluczu i indeksie istnieje */
    q = String("select count(*) as ile from pliki where indeks like :indeks and klucz like :klucz");
    q = AliasStr(q,":indeks",indeks);
    q = AliasStr(q,":klucz",key);
    if (mysql_query(db,q)) {pthread_mutex_unlock(&mutex); return 0;}
    res = mysql_store_result(db);
    if ((row = mysql_fetch_row(res)) != NULL) b = atoi(row[0]); else b = 0;
    mysql_free_result(res);
    /* ustawiam dany rekord jako publiczny */
    if (b)
    {
        if (reverse)
        {
            q = String("update pliki set public=0 where indeks like :indeks and klucz like :klucz");
        } else {
            q = String("update pliki set public=1 where indeks like :indeks and klucz like :klucz");
        }
        q = AliasStr(q,":indeks",indeks);
        q = AliasStr(q,":klucz",key);
        if (mysql_query(db,q)) {pthread_mutex_unlock(&mutex); return 0;}
        IniWriteStr("PublicDateTime",LocalTime(),0);
    }
    pthread_mutex_unlock(&mutex);
    return b;
}

bool FileToOwner(char *indeks, char *key, char *newkey)
{
    return 0;
}

bool FileDelete(char *key,char *indeks)
{
    char *q;
    MYSQL_RES *res;
    MYSQL_ROW row;
    bool b;
    char *s;
    pthread_mutex_lock(&mutex);
    /* pobranie nazwy pliku */
    q = String("select sciezka from pliki where indeks=:indeks and klucz=:klucz");
    q = AliasStr(q,":indeks",indeks);
    q = AliasStr(q,":klucz",key);
    if (mysql_query(db,q)) {pthread_mutex_unlock(&mutex); return 0;}
    res = mysql_store_result(db);
    if ((row = mysql_fetch_row(res)) != NULL)
    {
        b = 1;
        s = row[0];
    } else {
        b = 0;
        s = "";
    }
    mysql_free_result(res);
    if (b)
    {
        /* usunięcie pliku */
        if (FileExists(s)) remove(s);
        /* usunięcie wpisu */
        q = String("delete from pliki where indeks=:indeks and klucz=:klucz");
        q = AliasStr(q,":indeks",indeks);
        q = AliasStr(q,":klucz",key);
        if (mysql_query(db,q)) {pthread_mutex_unlock(&mutex); return 0;}
    }
    pthread_mutex_unlock(&mutex);
    return 1;
}

int idsock(int soket)
{
    int i, a = -1;
    for(i=0; i<n; i++)
    {
        if (clients[i]==soket)
        {
            a=i;
            break;
        }
    }
    return a;
}

int key_to_soket(char *klucz, bool aMutex)
{
    int i,a = -1;
    if (aMutex) pthread_mutex_lock(&mutex);
    for(i=0; i<n; i++)
    {
        if (strcmp(key[i],klucz)==0)
        {
            a=clients[i];
            break;
        }
    }
    if (aMutex) pthread_mutex_unlock(&mutex);
    return a;
}

char *SendTxtChat()
{
    char s[1024];
    char *ss = "";
    FILE *f;
    f = fopen("/home/tao/serwer/chat.txt","r");
    while (fgets(s,1024,f)!=NULL)
    {
        ss = concat(ss,strdup(s));
    }
    fclose(f);
    return strdup(ss);
}

void KillUser(int sock)
{
    shutdown(sock,2);
    close(sock);
}

char *StatFile(char *indeks)
{
    char *q;
    MYSQL_RES *res;
    MYSQL_ROW row;
    bool b;
    char *s,*s1,*s2;
    int size;
    pthread_mutex_lock(&mutex);
    /* pobranie nazwy pliku */
    q = String("select sciezka,dlugosc from pliki where indeks like :indeks");
    q = AliasStr(q,":indeks",indeks);
    if (mysql_query(db,q)) {pthread_mutex_unlock(&mutex); return "$-1";}
    res = mysql_store_result(db);
    if ((row = mysql_fetch_row(res)) != NULL)
    {
        b = 1;
        s1 = row[0];
        s2 = row[1];
        s = concat2(s1,s2);
    } else {
        b = 0;
        s = "$-1";
    }
    mysql_free_result(res);
    pthread_mutex_unlock(&mutex);
    return s;
}

char *FileRequestNow(char *key, char *indeks, char **bufor, int *size)
{
    char *q;
    MYSQL_RES *res;
    MYSQL_ROW row;
    bool b;
    char *s, *nick, *klucz, *nazwa, *dlugosc, *czas1, *czas2, *opis;
    bool pub;

    q = String("select nick,klucz,nazwa,dlugosc,czas_wstawienia,czas_modyfikacji,opis,awatar,public from pliki where indeks=:indeks");
    q = AliasStr(q,":indeks",indeks);
    if (mysql_query(db,q)) return "";
    res = mysql_store_result(db);
    if ((row = mysql_fetch_row(res)) != NULL)
    {
        b = 1;
        nick = row[0];
        klucz = row[1];
        nazwa = row[2];
        dlugosc = row[3];
        czas1 = row[4];
        czas2 = row[5];
        opis = row[6];
	//const void *blob = row[7];
	//size_t blob_size = sqlite3_column_bytes(stmt,7);
        const void *blob;
        size_t blob_size = 0;
        if (blob_size>0)
        {
            /* dołączam plik graficzny */
            *size = blob_size;
            *bufor = malloc(blob_size);
            memcpy(*bufor,blob,blob_size);
        }
        pub = atoi(row[8]);
    } else {
        b = 0;
        s = "";
    }
    mysql_free_result(res);
    if (b)
    {
        s = concat4("{FILE_REQUESTING}",klucz,key,nick);
        s = concat4(s,indeks,nazwa,dlugosc);
        s = concat4(s,czas1,czas2,opis);
        s = concat2(s,IntToSys(pub,10));
        return s;
    } else return "";
}

char *GetPublic(char *czas, int lp)
{
    //select * from pliki order by id limit 1 offset 0
    char *q;
    MYSQL_RES *res;
    MYSQL_ROW row;
    char *indeks;
    pthread_mutex_lock(&mutex);
    if (czas)
    {
        q = String("select indeks from pliki where public=1 and czas_modyfikacji>:czas order by id limit 1 offset :off");
        q = AliasStr(q,":czas",czas);
        q = AliasInt(q,":off",lp);
    } else {
        q = String("select indeks from pliki where public=1 order by id limit 1 offset :off");
        q = AliasInt(q,":off",lp);
    }
    if (mysql_query(db,q)) { pthread_mutex_unlock(&mutex); return ""; }
    res = mysql_store_result(db);
    if ((row = mysql_fetch_row(res)) != NULL) indeks = row[0]; else indeks = "";
    mysql_free_result(res);
    pthread_mutex_unlock(&mutex);
    return indeks;
}

int FileStatExist(char *indeks)
{
    char *q;
    MYSQL_RES *res;
    MYSQL_ROW row;
    int r;
    pthread_mutex_lock(&mutex);
    q = String("select id,public from pliki where indeks like :indeks");
    q = AliasStr(q,":indeks",indeks);
    if (mysql_query(db,q)) { pthread_mutex_unlock(&mutex); return -1; }
    res = mysql_store_result(db);
    if ((row = mysql_fetch_row(res)) != NULL)
    {
        const int cid = atoi(row[0]);
        const int cpb = atoi(row[1]);
        r = cpb + 1;
    } else {
        r = 0;
    }
    mysql_free_result(res);
    pthread_mutex_unlock(&mutex);
    /* -1=błąd, 0=deleted, 1=exist_not_public, 2=exist_public */
    return r;
}

/* WĄTEK POŁĄCZENIA */
void *recvmg(void *sock)
{
    struct client_info cl = *((struct client_info *)sock);
    bool TerminateNow = 0, czysc = 0;
    int e,a1,a2,a3,a4,l,l1,l2,ll,lx,lx2,bin_len=0,len=0,len2=0,len3=0,v=0;
    char msg[CONST_MAX_BUFOR], *vv, *msg2;
    char *ss, *ss2, *s, *x, *s1, *s2, *s3, *s4, *s5, *s6, *s7, *s8, *tmp, *bin, *wbin;
    unsigned char *x1, *x2, *x3, *x4, *x5;
    int id,id2=-1,sock_user,i,j,k,blok,wsize; //UWAGA: używam id jako identa tablicy, zaś id2 jako wartość soketa!
    char *IV,*IV_NEW;
    char *KEY  = globalny_key;
    IV = malloc(17);
    strcpy(IV,globalny_vec);
    bool wysylka = 0, b1, b2;
    bool isserver = 0;
    char *sql;
    char *filename, *filename2;
    int max_file_buffer = CONST_MAX_FILE_BUFOR;
    FILE *f;
    bool factive = 0, nie_zmieniaj = 0, bin_active = 0, zapis = 0, zm_tmp = 0;
    int fidx = 0, fidx2 = 0;

    ss = concat("{USERS_COUNT}$",IntToSys(n,10));
    sendtoall(ss,0,0,1,0);
    if (server!=-1) sendtouser(ss,cl.sockno,server,1,0);

    vv = &msg[0];
    len = 0;

    while((v = recv(cl.sockno,&msg[len],CONST_MAX_BUFOR-len,0)) > 0)
    {
        if (v<=0) continue;
        len += v;

        vv = msg;
        while (len-(vv-msg)>2) {
            nie_zmieniaj = 0;
            blok = B256ToInt(vv,2);
            if (blok==0) { czysc = 1; break; }
            if (blok>(len-(vv-msg))+2){ czysc = 0; break; }

            czysc = 1;
            /* ODEBRANIE WIADOMOŚCI */
            /* rozszyfrowanie wiadomości */
            tmp = &vv[2];
            vv += blok+2;
            l = StringDecrypt(&tmp,blok,IV,KEY);
            ll = B256ToInt(tmp,2);
            l1 = B256ToInt(&tmp[2],2); //długość stringu
            l2 = ll - l1-2;            //długość ciągu binarnego
            wbin = &tmp[l1+4];
            wsize = l2;

            s = malloc(l1+1);
            strncpy(s,&tmp[4],l1);
            s[l1] = '\0';

            s1 = GetLineToStr(s,1,'$',"");
            //fprintf(stderr,"KOMENDA: %s (l1=%d)\n",s1,l1);
            /* test wiadomości */
            if (s1[0]!='{') continue;

            //LOG("I","RAMKA","");

            #include "zdarzenia.c"

            /* KOMUNIKACJA Ze STUDIEM */
            if (strcmp(s1,"{READ_MON}")==0 || strcmp(s1,"{READ_ALL}")==0 ||
                strcmp(s1,"{INFO}")==0 || strcmp(s1,"{INF1}")==0 ||
                strcmp(s1,"{INF2}")==0 || strcmp(s1,"{CAMERAS}")==0 ||
                strcmp(s1,"{RAMKA_PP}")==0 || strcmp(s1,"{INDEX_CZASU}")==0 ||
                strcmp(s1,"{PYTANIE}")==0 || strcmp(s1,"{INTERAKCJA}")==0 ||
                strcmp(s1,"{STUDIO_ALARM}")==0 || strcmp(s1,"{STUDIO_PLAY_STOP}")==0 ||
                strcmp(s1,"{STUDIO}")==0)
            {
                if (cl.sockno == server)
                {
                    id2 = atoi(GetLineToStr(s,2,'$',"-1")); //ID RURKI
                    //LOG("[STUDIO-OD-SERWERA]",IntToSys(id2,10),"s = ",s);
                    /* wiadomość na sokecie serwera - wszystko leci do użytkownika/użytkowników */
                    if (id2==-1)
                    {
                        /* wiadomość jest przekazywana do wszystkich użytkowników */
                        ss = s;
                        sendtoall(ss,cl.sockno,0,4,0);
                        //LOG("[  ODPOWIEDŹ]","[ALL]","ss = ",ss);
                    } else {
                        /* wiadomość jest przekazywana do wybranego użytkownika */
                        ss = s;
                        sendtouser(ss,cl.sockno,id2,4,1);
                        //LOG("[  ODPOWIEDŹ]",IntToSys(id2,10),"ss = ",ss);
                    }
                } else {
                    /* wiadomość na sokecie użytkownika - wszystko leci do serwera */
                    if (server==-1)
                    {
                        /* serwer nie jest zalogowany - odpowiedź brak serwera */
                        ss = String("{SERVER-NON-EXIST}");
                        wysylka = 1;
                        //LOG("[  SERWER-NIE-ZALOGOWANY]","","","");
                    } else {
                        /* serwer istnieje więc przekazuję wszystkie ramki do serwera */
                        ss = concat2(s,IntToSys(cl.sockno,10)); //DODAJĘ INFORMACJĘ O ID RURKI SIECIOWEJ
                        sendtouser(ss,cl.sockno,server,4,1);
                        //LOG("[  ŻĄDANIE-DO-SERWERA]",IntToSys(cl.sockno,10),"ss = ",ss);
                    }
                }
            }

            /* wysyłka - wiadomość odsyłana do nadawcy */
            if (wysylka)
            {
                wysylka = 0;
                l1 = strlen(ss);
                l2 = bin_len;
                ll = l1 + l2;
                /* zaszyfrowanie odpowiedzi */
                lx = CalcBuffer(ll+4);
                x = malloc(lx+2);
                x1 = x;        //suma cryptu
                x2 = &x[2];    //suma ramki + te 2
                x3 = &x[4];    //suma stringu
                x4 = &x[6];    //string
                x5 = &x[l1+6]; //binary
                IntToB256(ll+2,&x2,2);
                IntToB256(l1,&x3,2);
                strncpy(x4,ss,l1);
                if (l2>0) memcpy(x5,bin,l2);
                lx2 = UStringEncrypt(&x2,lx,IV,KEY);
                IntToB256(lx,&x1,2);
                /* wysłanie wiadomości do nadawcy */
                pthread_mutex_lock(&mutex);
                send(cl.sockno,x,lx+2,MSG_NOSIGNAL);
                pthread_mutex_unlock(&mutex);
                /* zwolnienie buforów */
                free(x);
            }

            if (bin_active)
            {
                free(bin);
                bin_len = 0;
                bin_active = 0;
            }

            if (TerminateNow) break;

            /* zmiana wektora jeśli wymagane */
            if (IV_NEW) {
                strcpy(IV,IV_NEW);
                IV_NEW=0;
                pthread_mutex_lock(&mutex);
                strcpy(vector[idsock(cl.sockno)],IV);
                pthread_mutex_unlock(&mutex);
            }
            free(s);
        }
        if (czysc) len = 0;
        if (TerminateNow) break;
    }  /* pętla główna recv i pętla wykonywania gotowych zapytań */

    pthread_mutex_lock(&mutex);
    for(i = 0; i < n; i++) {
	if(clients[i] == cl.sockno)
        {
	    j = i;
	    while(j < n-1)
            {
		clients[j] = clients[j+1];
                strcpy(key[j],key[j+1]);
                strcpy(vector[j],vector[j+1]);
                strcpy(niki[j],niki[j+1]);
                for (k=0; k<ACTIVES; k++) actives[j][k]= actives[j+1][k];
                strcpy(ips[j],ips[j+1]);
                ports[j] = ports[j+1];
		j++;
	    }
	}
    }
    n--;
    if (isserver)
    {
        server = -1;
        ss = concat("{SERVER-NON-EXIST}$",IntToSys(n,10));
        sendtoall(ss,cl.sockno,0,1,0);
    } else {
        ss = concat("{USERS_COUNT}$",IntToSys(n,10));
        sendtoall(ss,cl.sockno,0,1,0);
        if (server!=-1) sendtouser(ss,cl.sockno,server,1,0);
    }
    if (ischat)
    {
        ss = concat("{CHAT_LOGOUT}$",cl.key);
        sendtoall(ss,cl.sockno,0,5,0);
    }
    pthread_mutex_unlock(&mutex);
    shutdown(cl.sockno,SHUT_RDWR);
    if (len2>0) free(msg2);
    free(IV);
}

void signal_handler(int sig)
{
    char *ss;
    switch(sig)
    {
        case SIGHUP:
	    log_message(LOG_FILE,"hangup signal catched");
	    break;
        case SIGINT:
        case SIGTERM:
            ss = String("{EXIT}");
            sendtoall(ss,0,1,0,1);
            sleep(2);
            shutdown(sockfd,2);
            close(sockfd);
            //shutdown(my_sock,2);
            //close(my_sock);
            log_message(LOG_FILE,"terminate signal catched");
            mysql_close(db);
            exit(0);
            break;
    }
}

void daemonize()
{
    int i,lfp;
    char str[10];

    if(getppid()==1) return; /* already a daemon */
    i=fork();
    if (i<0) exit(1); /* fork error */
    if (i>0) exit(0); /* parent exits */
    /* child (daemon) continues */
    setsid(); /* obtain a new process group */
    for (i=getdtablesize();i>=0;--i) close(i); /* close all descriptors */
    i=open("/dev/null",O_RDWR); dup(i); dup(i); /* handle standart I/O */
    umask(027); /* set newly created file permissions */
    chdir(RUNNING_DIR); /* change running directory */
    lfp=open(LOCK_FILE,O_RDWR|O_CREAT,0640);
    if (lfp<0) exit(1); /* can not open */
    if (lockf(lfp,F_TLOCK,0)<0) exit(0); /* can not lock */
    /* first instance continues */
    sprintf(str,"%d\n",getpid());
    write(lfp,str,strlen(str)); /* record pid to lockfile */
    signal(SIGCHLD,SIG_IGN); /* ignore child */
    signal(SIGTSTP,SIG_IGN); /* ignore tty signals */
    signal(SIGTTOU,SIG_IGN);
    signal(SIGTTIN,SIG_IGN);
    signal(SIGHUP,signal_handler); /* catch hangup signal */
    signal(SIGTERM,signal_handler); /* catch kill signal */
}

/* GŁÓWNA FUNKCJA STARTOWA */
int main(int argc,char *argv[])
{
    const int TRYB = 1; //0-FUNCTION_TEST, 1-PRODUKCJA, 2-LOCAL

    struct sockaddr_in my_addr,their_addr;
    //int my_sock;
    int their_sock;
    int option = 1;
    socklen_t their_addr_size;
    int portno;
    pthread_t sendt,recvt,udpvt;
    char msg[CONST_MAX_BUFOR];
    int len,i;
    struct client_info cl;
    char ip[INET_ADDRSTRLEN],IP[INET_ADDRSTRLEN];
    int PORT;

    if(argc > 2)
    {
	printf("too many arguments");
	exit(1);
    }

    if (test()==1) return 0;
    if (TRYB==1) daemonize();
    Randomize();
    server = -1;

    db = mysql_init(NULL);
    if (!mysql_real_connect(db,DB_HOST,DB_USER,DB_PASS,DB_DATABASE,0,NULL,0)) {
      fprintf(stderr, "%s\n", mysql_error(db));
      log_message(LOG_FILE,"Problem z bazą danych.");
      return(0);
    }

    // inicjalizacja kluczy do kryptografii
    UstawKlucze();

    portno = 4681;
    my_sock = socket(AF_INET,SOCK_STREAM,0);
    setsockopt(my_sock, SOL_SOCKET, SO_REUSEADDR, &option, sizeof(option));
    memset(my_addr.sin_zero,'\0',sizeof(my_addr.sin_zero));
    my_addr.sin_family = AF_INET;
    my_addr.sin_port = htons(portno);
    my_addr.sin_addr.s_addr = 0; //inet_addr("0.0.0.0");
    their_addr_size = sizeof(their_addr);

    if(bind(my_sock,(struct sockaddr *)&my_addr,sizeof(my_addr)) != 0)
    {
        perror("binding unsuccessful");
        log_message(LOG_FILE,"Zajęty port!");
        mysql_close(db);
        exit(1);
    };

    is_port = portno;

    if(listen(my_sock,5) != 0)
    {
	perror("listening unsuccessful");
        log_message(LOG_FILE,"Problem z listiningiem.");
        mysql_close(db);
	exit(1);
    }

    while(1)
    {
        if((their_sock = accept(my_sock,(struct sockaddr *)&their_addr,&their_addr_size)) < 0)
        {
            perror("accept unsuccessful");
            mysql_close(db);
            exit(1);
        }
        pthread_mutex_lock(&mutex);
        inet_ntop(AF_INET, (struct sockaddr *)&their_addr, ip, INET_ADDRSTRLEN);
        cl.sockno = their_sock;

        strcpy(IP,inet_ntoa(their_addr.sin_addr));
        PORT = (int) ntohs(their_addr.sin_port);

        strcpy(cl.ip,ip); strcpy(cl.ip2,IP); cl.port2 = PORT;
        strcpy(cl.key,GetUuidCompress());
        strcpy(cl.key,GetUuidCompress());
	clients[n] = their_sock;
        for (i=0; i<ACTIVES; i++) actives[n][i] = 0;
        actives[n][0] = 1; //LOGIN - TO ZAWSZE JEST WŁĄCZONE!
        strcpy(key[n],cl.key);
        strcpy(vector[n],globalny_vec);
        strcpy(ips[n],IP);
        ports[n] = PORT;
	n++;
	pthread_create(&recvt,NULL,recvmg,&cl);
	pthread_mutex_unlock(&mutex);
    }
    mysql_close(db);
    return 0;
}

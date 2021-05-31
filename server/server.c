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
#include <sqlite3.h>
#include "lazc.h"
#include <locale.h>
#include <fcntl.h>
#include <signal.h>
#include "keystd.h"

#define RUNNING_DIR	"/disk/dbases"
#define DB_FILE         "/disk/dbases/studio.jahu.db"
#define LOCK_FILE	"/var/run/studio.jahu.pid"
#define LOG_FILE	"/disk/log/studio.jahu.log"

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
sqlite3 *db;

#include "komunikacja.c"



/* FUNKCJA TESTUJĄCA */
int test()
{
    return 0;

    char *key = "1234567890123456";
    char *vec = "abcdefghijklmnou";
    char *s = String("x1234567890123456x");
    char *s1 = &s[1];
    _display("1: ",s1,16);
    int l = StringEncrypt(&s,16,vec,key);
    _display("2: ",s1,l);
    int k = StringDecrypt(&s,l,vec,key);
    _display("3: ",s1,l);

    fprintf(stderr,"%s\n",s);

    return 1;
}

void log_message(char *filename, char *message)
{
    FILE *logfile;
    logfile=fopen(filename,"a");
    if(!logfile) return;
    fprintf(logfile,"%s %s\n",LocalTime(),message);
    fclose(logfile);
}

void LOG(char *s1, char *s2, char *s3, char *s4)
{
    char *s;
    s = concat_str_char(s1,' ');
    s = concat(s,s2);
    s = concat_str_char(s,' ');
    s = concat(s,s3);
    s = concat_str_char(s,' ');
    s = concat(s,s4);
    log_message(LOG_FILE,s);
}

bool ExecSQL(char *sql)
{
    char *err = 0;
    int rc;
    rc = sqlite3_exec(db,sql,NULL,0,&err);
    if (rc != SQLITE_OK){fprintf(stderr,"SQL Error: %s\n",err); sqlite3_free(err); return 1;}
    return 0;
}

bool create_db_struct()
{
    if (ExecSQL("CREATE TABLE config (id INTEGER NOT NULL,zmienna TEXT NOT NULL,value_int INTEGER,value_text TEXT,PRIMARY KEY(id))")) return 1;
    if (ExecSQL("CREATE INDEX idx_config_zmienna ON config (zmienna)")) return 1;
    if (ExecSQL("CREATE TABLE wersja (id integer primary key,major integer,minor integer,rel integer,build integer)")) return 1;
    if (ExecSQL("CREATE TABLE klucze (id integer primary key,dt_insert text,klucz text)")) return 1;
    if (ExecSQL("CREATE INDEX idx_klucze_klucz on klucze(klucz)")) return 1;
    if (ExecSQL("CREATE TABLE pytania (id integer primary key,czas text,klucz text,nick text,pytanie text)")) return 1;
    if (ExecSQL("CREATE INDEX idx_pytania_klucz on pytania(klucz)")) return 1;
    if (ExecSQL("CREATE TABLE prive (id integer primary key,dt_insert text,nadawca text,nick text,adresat text,formatowanie text,tresc text)")) return 1;
    if (ExecSQL("CREATE INDEX idx_prive_adresat on prive(adresat)")) return 1;
    if (ExecSQL("CREATE TABLE pliki (id INTEGER primary key,indeks TEXT NOT NULL,nick TEXT NOT NULL,klucz TEXT NOT NULL,nazwa TEXT NOT NULL,sciezka TEXT NOT NULL,dlugosc INTEGER NOT NULL,czas_wstawienia TEXT NOT NULL,czas_modyfikacji TEXT NOT NULL,status INTEGER NOT NULL DEFAULT 0, public INTEGER NOT NULL DEFAULT 0, opis TEXT, awatar BLOB)")) return 1;
    if (ExecSQL("CREATE INDEX idx_pliki_czas_wstawienia ON pliki (czas_wstawienia)")) return 1;
    if (ExecSQL("CREATE INDEX idx_pliki_czas_modyfikacji ON pliki (czas_modyfikacji)")) return 1;
    if (ExecSQL("CREATE INDEX idx_pliki_indeks ON pliki (indeks)")) return 1;
    if (ExecSQL("CREATE INDEX idx_pliki_klucz ON pliki (klucz)")) return 1;
    if (ExecSQL("CREATE INDEX idx_pliki_nazwa ON pliki (nazwa)")) return 1;
    if (ExecSQL("CREATE INDEX idx_pliki_public ON pliki (public)")) return 1;
    if (ExecSQL("CREATE INDEX idx_pliki_sciezka ON pliki (sciezka)")) return 1;
    if (ExecSQL("CREATE INDEX idx_pliki_status ON pliki (status)")) return 1;
    return 0;
}

bool KluczToDb(char *klucz)
{
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(db,"insert into klucze (dt_insert,klucz) values (datetime('now'),?)",-1,&stmt,NULL)) return 1;
    sqlite3_bind_text(stmt,1,klucz,-1,NULL);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    return 0;
}

void RemoveKluczFromDb(char *klucz)
{
    sqlite3_stmt *stmt;
    sqlite3_prepare_v2(db,"delete from klucze where klucz=?",-1,&stmt,NULL);
    sqlite3_bind_text(stmt,1,klucz,-1,NULL);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
}

bool DbKluczIsExists(char *klucz)
{
    int a = 0, err;
    sqlite3_stmt *stmt;
    err = sqlite3_prepare_v2(db,"select count(*) as ile from klucze where klucz=?",-1,&stmt,NULL);
    sqlite3_bind_text(stmt,1,klucz,-1,NULL);
    while (sqlite3_step(stmt) != SQLITE_DONE)
    {
        a = sqlite3_column_int(stmt,0);
        break;
    }
    sqlite3_finalize(stmt);
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
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(db,"insert into pytania (czas,klucz,nick,pytanie) values (?,?,?,?)",-1,&stmt,NULL)) return 1;
    sqlite3_bind_text(stmt,1,LocalTime(),-1,NULL);
    sqlite3_bind_text(stmt,2,klucz,-1,NULL);
    sqlite3_bind_text(stmt,3,nick,-1,NULL);
    sqlite3_bind_text(stmt,4,pytanie,-1,NULL);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    return 0;
}

//TABLE prive (id integer primary key,dt_insert text,nadawca text,adresat text,tresc text)
bool PriveMessageToDB(char *nadawca, char *nick, char* adresat, char *formatowanie, char *tresc, char *czas, char *indeks_pliku)
{
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(db,"insert into prive (dt_insert,nadawca,nick,adresat,formatowanie,tresc,indeks_pliku) values (?,?,?,?,?,?,?)",-1,&stmt,NULL)) return 1;
    sqlite3_bind_text(stmt,1,czas,-1,NULL);
    sqlite3_bind_text(stmt,2,nadawca,-1,NULL);
    sqlite3_bind_text(stmt,3,nick,-1,NULL);
    sqlite3_bind_text(stmt,4,adresat,-1,NULL);
    sqlite3_bind_text(stmt,5,formatowanie,-1,NULL);
    sqlite3_bind_text(stmt,6,tresc,-1,NULL);
    if (strcmp(indeks_pliku,"")==0) sqlite3_bind_text(stmt,7,NULL,-1,NULL); else sqlite3_bind_text(stmt,7,indeks_pliku,-1,NULL);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    return 0;
}

/*CREATE TABLE wersja (id integer primary key,major integer,minor integer,rel integer,build integer)*/
int SetVersionProg(int a1,int a2,int a3,int a4)
{
    int a = 0;
    sqlite3_stmt *stmt;

    pthread_mutex_lock(&mutex);
    /* sprawdzam czy zapis istnieje */
    if (sqlite3_prepare_v2(db,"select count(*) as ile from wersja where id=?",-1,&stmt,NULL)) {pthread_mutex_unlock(&mutex); return 1;}
    sqlite3_bind_int(stmt,1,1);
    if (sqlite3_step(stmt)==SQLITE_ROW) a = sqlite3_column_int(stmt,0);
    sqlite3_finalize(stmt);
    /* aktualizacja */
    if (a==0)
    {
        /* jeśli nie istnieje - dodaję  */
        if (sqlite3_prepare_v2(db,"insert into wersja (id,major,minor,rel,build) values (1,?,?,?,?)",-1,&stmt,NULL)) {pthread_mutex_unlock(&mutex); return 2;}
        sqlite3_bind_int(stmt,1,a1);
        sqlite3_bind_int(stmt,2,a2);
        sqlite3_bind_int(stmt,3,a3);
        sqlite3_bind_int(stmt,4,a4);
        sqlite3_step(stmt);
        sqlite3_finalize(stmt);
    } else {
        /* jeśli istnieje - aktualizuję */
        if (sqlite3_prepare_v2(db,"update wersja set major=?, minor=?, rel=?, build=? where id=1",-1,&stmt,NULL)) {pthread_mutex_unlock(&mutex); return 3;}
        sqlite3_bind_int(stmt,1,a1);
        sqlite3_bind_int(stmt,2,a2);
        sqlite3_bind_int(stmt,3,a3);
        sqlite3_bind_int(stmt,4,a4);
        sqlite3_step(stmt);
        sqlite3_finalize(stmt);
    }
    pthread_mutex_unlock(&mutex);
    return 0;
}

/*CREATE TABLE wersja (id integer primary key,major integer,minor integer,rel integer,build integer)*/
void InfoVersionProg(int sock_adresat)
{
    char *ss;
    int a1=0,a2=0,a3=0,a4=0;
    sqlite3_stmt *stmt;
    /* poinformowanie wszystkich o nowej wersji programu */
    pthread_mutex_lock(&mutex);
    if (sqlite3_prepare_v2(db,"select major,minor,rel,build from wersja where id=1",-1,&stmt,NULL)) {pthread_mutex_unlock(&mutex); return;}
    if (sqlite3_step(stmt)==SQLITE_ROW)
    {
        a1 = sqlite3_column_int(stmt,0);
        a2 = sqlite3_column_int(stmt,1);
        a3 = sqlite3_column_int(stmt,2);
        a4 = sqlite3_column_int(stmt,3);
    }
    sqlite3_finalize(stmt);
    /* przygotowuję i wysyłam ramkę odpowiedzi */
    ss = concat4("{NEW_VERSION}",IntToSys(a1,10),IntToSys(a2,10),IntToSys(a3,10));
    ss = concat2(ss,IntToSys(a4,10));
    sendtouser(ss,0,sock_adresat,1,0);
    pthread_mutex_unlock(&mutex);
}

int ReadPytania(int nadawca, int adresat) //zwraca ilość przeczytanych pytań
{
    //CREATE TABLE pytania (id integer primary key,czas text,klucz text,nick text,pytanie text)
    int l = 0;
    char *s, *w;
    sqlite3_stmt *stmt;
    pthread_mutex_lock(&mutex);
    if (sqlite3_prepare_v2(db,"select id,czas,klucz,nick,pytanie from pytania order by id",-1,&stmt,NULL)) {pthread_mutex_unlock(&mutex);; return 0;}
    while (sqlite3_step(stmt) != SQLITE_DONE)
    //while (sqlite3_step(stmt) == SQLITE_ROW)
    {
        const int id = sqlite3_column_int(stmt,0);
        const char *czas = sqlite3_column_text(stmt,1);
        const char *klucz = sqlite3_column_text(stmt,2);
        const char *nick = sqlite3_column_text(stmt,3);
        const char *pytanie = sqlite3_column_text(stmt,4);
        s = concat4("{PYTANIE}",strdup(klucz),strdup(nick),strdup(pytanie));
        s = concat2(s,strdup(czas));
        sendtouser(s,nadawca,adresat,0,0);
        l++;
    }
    sqlite3_finalize(stmt);
    ExecSQL("delete from pytania");
    pthread_mutex_unlock(&mutex);
    return l;
}

int PrivMessageFromDbToUser(int sock_adresat, char *key) //zwracam ilość zczytanych rekordów
{
    int n = 0, a;
    char *s;
    sqlite3_stmt *stmt;
    pthread_mutex_lock(&mutex);
    /* sprawdzam czy są jakieś rekordy */
    if (sqlite3_prepare_v2(db,"select count(*) as ile from prive where adresat=?",-1,&stmt,NULL)) {pthread_mutex_unlock(&mutex); return -1;}
    sqlite3_bind_text(stmt,1,key,-1,NULL);
    if (sqlite3_step(stmt)==SQLITE_ROW) a = sqlite3_column_int(stmt,0);
    sqlite3_finalize(stmt);
    if (a==0) {pthread_mutex_unlock(&mutex); return 0;}
    /* wysyłam zawartość */
    if (sqlite3_prepare_v2(db,"select dt_insert,nadawca,nick,adresat,formatowanie,tresc,indeks_pliku from prive where adresat=? order by id",-1,&stmt,NULL)) {pthread_mutex_unlock(&mutex); return -2;}
    sqlite3_bind_text(stmt,1,key,-1,NULL);
    while (sqlite3_step(stmt) != SQLITE_DONE)
    {
        const char *czas = sqlite3_column_text(stmt,0);
        const char *nadawca = sqlite3_column_text(stmt,1);
        const char *nick = sqlite3_column_text(stmt,2); //na razie brak, więc wrzucam nadawcę
        const char *adresat = sqlite3_column_text(stmt,3);
        const char *formatowanie = sqlite3_column_text(stmt,4);
        const char *tresc = sqlite3_column_text(stmt,5);
        const char *indeks = sqlite3_column_text(stmt,6);
        s = concat4("{CHAT}",strdup(nadawca),strdup(nick),strdup(adresat));
        s = concat4(s,strdup(formatowanie),strdup(tresc),strdup(czas));
        s = dolar(s);
        if (indeks!=NULL) s = concat(s,strdup(indeks));
        sendtouser(s,0,sock_adresat,1,0);
        n++;
    }
    sqlite3_finalize(stmt);
    /* usuwam to co pobralem */
    if (sqlite3_prepare_v2(db,"delete from prive where adresat=?",-1,&stmt,NULL)) {pthread_mutex_unlock(&mutex); return -3;}
    sqlite3_bind_text(stmt,1,key,-1,NULL);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    pthread_mutex_unlock(&mutex);
    return n;
}

char *IniReadStr(char *zmienna, bool now_mutex)
{
    char *s;
    sqlite3_stmt *stmt;
    if (now_mutex) pthread_mutex_lock(&mutex);
    if (sqlite3_prepare_v2(db,"select value_text from config where zmienna=?",-1,&stmt,NULL)) {if (now_mutex) pthread_mutex_unlock(&mutex); return "";}
    sqlite3_bind_text(stmt,1,zmienna,-1,NULL);
    if (sqlite3_step(stmt)==SQLITE_ROW)
    {
        const char *cs = sqlite3_column_text(stmt,0);
        s = strdup(cs);
    } else s = "";
    sqlite3_finalize(stmt);
    if (now_mutex) pthread_mutex_unlock(&mutex);
    return s;
}

int IniReadInt(char *zmienna, bool now_mutex)
{
    int a;
    sqlite3_stmt *stmt;
    if (now_mutex) pthread_mutex_lock(&mutex);
    if (sqlite3_prepare_v2(db,"select value_int from config where zmienna=?",-1,&stmt,NULL)) {if (now_mutex) pthread_mutex_unlock(&mutex); return 0;}
    sqlite3_bind_text(stmt,1,zmienna,-1,NULL);
    if (sqlite3_step(stmt)==SQLITE_ROW)
    {
        a = sqlite3_column_int(stmt,0);
    } else a = 0;
    sqlite3_finalize(stmt);
    if (now_mutex) pthread_mutex_unlock(&mutex);
    return a;
}

bool IniWriteStr(char *zmienna, char *wartosc, bool now_mutex)
{
    int id;
    sqlite3_stmt *stmt;
    if (now_mutex) pthread_mutex_lock(&mutex);
    /* sprawdzam czy rekord istnieje */
    if (sqlite3_prepare_v2(db,"select id from config where zmienna=?",-1,&stmt,NULL)) {if (now_mutex) pthread_mutex_unlock(&mutex); return 0;}
    sqlite3_bind_text(stmt,1,zmienna,-1,NULL);
    if (sqlite3_step(stmt)==SQLITE_ROW) id = sqlite3_column_int(stmt,0); else id = 0;
    sqlite3_finalize(stmt);
    /* dodaję lub aktualizuję rekord */
    if (id==0)
    {
        /* dodaję rekord */
        if (sqlite3_prepare_v2(db,"insert into config (zmienna,value_text) values (?,?)",-1,&stmt,NULL)) {pthread_mutex_unlock(&mutex); return 0;}
        sqlite3_bind_text(stmt,1,zmienna,-1,NULL);
        sqlite3_bind_text(stmt,2,wartosc,-1,NULL);
        sqlite3_step(stmt);
        sqlite3_finalize(stmt);
    } else {
        /* aktualizuję rekord */
        if (sqlite3_prepare_v2(db,"update config set value_text=? where zmienna=?",-1,&stmt,NULL)) {pthread_mutex_unlock(&mutex); return 0;}
        sqlite3_bind_text(stmt,1,wartosc,-1,NULL);
        sqlite3_bind_text(stmt,2,zmienna,-1,NULL);
        sqlite3_step(stmt);
        sqlite3_finalize(stmt);
    }
    if (now_mutex) pthread_mutex_unlock(&mutex);
    return 1;
}

bool IniWriteInt(char *zmienna, int wartosc, bool now_mutex)
{
    int id;
    sqlite3_stmt *stmt;
    if (now_mutex) pthread_mutex_lock(&mutex);
    /* sprawdzam czy rekord istnieje */
    if (sqlite3_prepare_v2(db,"select id from config where zmienna=?",-1,&stmt,NULL)) {if (now_mutex) pthread_mutex_unlock(&mutex); return 0;}
    sqlite3_bind_text(stmt,1,zmienna,-1,NULL);
    if (sqlite3_step(stmt)==SQLITE_ROW) id = sqlite3_column_int(stmt,0); else id = 0;
    sqlite3_finalize(stmt);
    /* dodaję lub aktualizuję rekord */
    if (id==0)
    {
        /* dodaję rekord */
        if (sqlite3_prepare_v2(db,"insert into config (zmienna,value_int) values (?,?)",-1,&stmt,NULL)) {pthread_mutex_unlock(&mutex); return 0;}
        sqlite3_bind_text(stmt,1,zmienna,-1,NULL);
        sqlite3_bind_int(stmt,2,wartosc);
        sqlite3_step(stmt);
        sqlite3_finalize(stmt);
    } else {
        /* aktualizuję rekord */
        if (sqlite3_prepare_v2(db,"update config set value_int=? where zmienna=?",-1,&stmt,NULL)) {pthread_mutex_unlock(&mutex); return 0;}
        sqlite3_bind_int(stmt,1,wartosc);
        sqlite3_bind_text(stmt,2,zmienna,-1,NULL);
        sqlite3_step(stmt);
        sqlite3_finalize(stmt);
    }
    if (now_mutex) pthread_mutex_unlock(&mutex);
    return 1;
}

char *FileNew(char *key,char *nick,char *nazwa,char *dlugosc)
{
    char *s, *indeks, *czas = LocalTime();
    sqlite3_stmt *stmt;
    int a;
    char *sciezka;
    pthread_mutex_lock(&mutex);
    /* pobieram indeks */
    if (sqlite3_prepare_v2(db,"select value_int from config where zmienna=?",-1,&stmt,NULL)) {pthread_mutex_unlock(&mutex); return "";}
    sqlite3_bind_text(stmt,1,"file_index",-1,NULL);
    if (sqlite3_step(stmt)==SQLITE_ROW) a = sqlite3_column_int(stmt,0); else a = 0;
    sqlite3_finalize(stmt);
    /* zwiększam o jeden ten odczytany w tabeli config */
    if (a==0)
    {
        /* nie istnieje - dodaję o indeksie kolejnym */
        if (sqlite3_prepare_v2(db,"insert into config (zmienna,value_int) values (?,?)",-1,&stmt,NULL)) {pthread_mutex_unlock(&mutex); return "";}
        sqlite3_bind_text(stmt,1,"file_index",-1,NULL);
        sqlite3_bind_int(stmt,2,2);
        sqlite3_step(stmt);
        sqlite3_finalize(stmt);
        a = 1;
    } else {
        /* istnieje - aktualizuję indeks wartością zwiększoną o jeden */
        if (sqlite3_prepare_v2(db,"update config set value_int=? where zmienna=?",-1,&stmt,NULL)) {pthread_mutex_unlock(&mutex); return "";}
        sqlite3_bind_int(stmt,1,a+1);
        sqlite3_bind_text(stmt,2,"file_index",-1,NULL);
        sqlite3_step(stmt);
        sqlite3_finalize(stmt);
    }
    /* obliczenia */
    indeks = StrBase(IntToSys(a,16),8);
    sciezka = concat("/disk/komunikator_files/",indeks);
    sciezka = concat(sciezka,".dat");
    /* dodaję rekord */
    if (sqlite3_prepare_v2(db,"insert into pliki (indeks,nick,klucz,nazwa,sciezka,dlugosc,czas_wstawienia,czas_modyfikacji,status) values (?,?,?,?,?,?,?,?,?)",-1,&stmt,NULL)) {pthread_mutex_unlock(&mutex); return "";}
    sqlite3_bind_text(stmt,1,indeks,-1,NULL);
    sqlite3_bind_text(stmt,2,nick,-1,NULL);
    sqlite3_bind_text(stmt,3,key,-1,NULL);
    sqlite3_bind_text(stmt,4,nazwa,-1,NULL);
    sqlite3_bind_text(stmt,5,sciezka,-1,NULL);
    sqlite3_bind_text(stmt,6,dlugosc,-1,NULL);
    sqlite3_bind_text(stmt,7,czas,-1,NULL);
    sqlite3_bind_text(stmt,8,czas,-1,NULL);
    sqlite3_bind_int(stmt,9,0);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    s = concat2(indeks,sciezka);
    pthread_mutex_unlock(&mutex);
    return s;
}

bool FileOpis(char *key,char *indeks,char *opis,char *bufor,int size)
{
    /* dodanie opisu */
    bool b;
    sqlite3_stmt *stmt;
    pthread_mutex_lock(&mutex);
    /* sprawdzam czy rekord o podanym kluczu i indeksie istnieje */
    if (sqlite3_prepare_v2(db,"select count(*) as ile from pliki where indeks like ? and klucz like ?",-1,&stmt,NULL)) {pthread_mutex_unlock(&mutex); return 0;}
    sqlite3_bind_text(stmt,1,indeks,-1,NULL);
    sqlite3_bind_text(stmt,2,key,-1,NULL);
    if (sqlite3_step(stmt)==SQLITE_ROW)
    {
      const int ile = sqlite3_column_int(stmt,0);
      b = ile;
    } else b = 0;
    sqlite3_finalize(stmt);
    /* aktualizacja */
    if (b)
    {
        if (sqlite3_prepare_v2(db,"update pliki set opis=?, awatar=? where indeks like ? and klucz like ?",-1,&stmt,NULL)) {pthread_mutex_unlock(&mutex); return 0;}
        if (strcmp(opis,"")==0) sqlite3_bind_null(stmt,1); else sqlite3_bind_text(stmt,1,opis,-1,NULL);
        if (size==0) sqlite3_bind_null(stmt,2); else sqlite3_bind_blob(stmt,2,bufor,size,NULL);
        sqlite3_bind_text(stmt,3,indeks,-1,NULL);
        sqlite3_bind_text(stmt,4,key,-1,NULL);
        sqlite3_step(stmt);
        sqlite3_finalize(stmt);
    }
    pthread_mutex_unlock(&mutex);
    return b;
}

bool FileToPublic(char *key,char *indeks,bool reverse)
{
    bool b;
    sqlite3_stmt *stmt;
    pthread_mutex_lock(&mutex);
    /* sprawdzam czy rekord o podanym kluczu i indeksie istnieje */
    if (sqlite3_prepare_v2(db,"select count(*) as ile from pliki where indeks like ? and klucz like ?",-1,&stmt,NULL)) {pthread_mutex_unlock(&mutex); return 0;}
    sqlite3_bind_text(stmt,1,indeks,-1,NULL);
    sqlite3_bind_text(stmt,2,key,-1,NULL);
    if (sqlite3_step(stmt)==SQLITE_ROW)
    {
      const int ile = sqlite3_column_int(stmt,0);
      b = ile;
    } else b = 0;
    sqlite3_finalize(stmt);
    /* ustawiam dany rekord jako publiczny */
    if (b)
    {
        if (reverse)
        {
            if (sqlite3_prepare_v2(db,"update pliki set public=0 where indeks like ? and klucz like ?",-1,&stmt,NULL)) {pthread_mutex_unlock(&mutex); return 0;}
        } else {
            if (sqlite3_prepare_v2(db,"update pliki set public=1 where indeks like ? and klucz like ?",-1,&stmt,NULL)) {pthread_mutex_unlock(&mutex); return 0;}
        }
        sqlite3_bind_text(stmt,1,indeks,-1,NULL);
        sqlite3_bind_text(stmt,2,key,-1,NULL);
        sqlite3_step(stmt);
        sqlite3_finalize(stmt);
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
    bool b;
    char *s;
    sqlite3_stmt *stmt;
    pthread_mutex_lock(&mutex);
    /* pobranie nazwy pliku */
    if (sqlite3_prepare_v2(db,"select sciezka from pliki where indeks=? and klucz=?",-1,&stmt,NULL)) {pthread_mutex_unlock(&mutex); return 0;}
    sqlite3_bind_text(stmt,1,indeks,-1,NULL);
    sqlite3_bind_text(stmt,2,key,-1,NULL);
    if (sqlite3_step(stmt)==SQLITE_ROW)
    {
        b = 1;
        const char *sciezka = sqlite3_column_text(stmt,0);
        s = strdup(sciezka);
    } else {
        b = 0;
        const char *sciezka = "";
    }
    sqlite3_finalize(stmt);
    if (b)
    {
        /* usunięcie pliku */
        if (FileExists(s)) remove(s);
        /* usunięcie wpisu */
        if (sqlite3_prepare_v2(db,"delete from pliki where indeks=? and klucz=?",-1,&stmt,NULL)) {pthread_mutex_unlock(&mutex); return 0;}
        sqlite3_bind_text(stmt,1,indeks,-1,NULL);
        sqlite3_bind_text(stmt,2,key,-1,NULL);
        sqlite3_step(stmt);
        sqlite3_finalize(stmt);
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
    f = fopen("/root/serwer/chat.txt","r");
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
    bool b;
    char *s,*s1,*s2;
    int size;
    sqlite3_stmt *stmt;
    pthread_mutex_lock(&mutex);
    /* pobranie nazwy pliku */
    if (sqlite3_prepare_v2(db,"select sciezka,dlugosc from pliki where indeks like ?",-1,&stmt,NULL)) {pthread_mutex_unlock(&mutex); return "$-1";}
    sqlite3_bind_text(stmt,1,indeks,-1,NULL);
    if (sqlite3_step(stmt)==SQLITE_ROW)
    {
        b = 1;
        const char *sciezka = sqlite3_column_text(stmt,0);
        s1 = strdup(sciezka);
        const char *dlugosc = sqlite3_column_text(stmt,1);
        s2 = strdup(dlugosc);
        s = concat2(s1,s2);
    } else {
        b = 0;
        s = "$-1";
    }
    sqlite3_finalize(stmt);
    pthread_mutex_unlock(&mutex);
    return s;
}

char *FileRequestNow(char *key, char *indeks, char **bufor, int *size)
{
    bool b;
    char *s, *nick, *klucz, *nazwa, *dlugosc, *czas1, *czas2, *opis;
    bool pub;
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(db,"select nick,klucz,nazwa,dlugosc,czas_wstawienia,czas_modyfikacji,opis,awatar,public from pliki where indeks=?",-1,&stmt,NULL)) return "";
    sqlite3_bind_text(stmt,1,indeks,-1,NULL);
    if (sqlite3_step(stmt)==SQLITE_ROW)
    {
        b = 1;
        const char *s1 = sqlite3_column_text(stmt,0);
        const char *s2 = sqlite3_column_text(stmt,1);
        const char *s3 = sqlite3_column_text(stmt,2);
        const char *s4 = sqlite3_column_text(stmt,3);
        const char *s5 = sqlite3_column_text(stmt,4);
        const char *s6 = sqlite3_column_text(stmt,5);
        const char *s7 = sqlite3_column_text(stmt,6); //opis
	const void *blob = sqlite3_column_blob(stmt,7);
	size_t blob_size = sqlite3_column_bytes(stmt,7);
        const bool bb = sqlite3_column_int(stmt,8);
        nick = strdup(s1);
        klucz = strdup(s2);
        nazwa = strdup(s3);
        dlugosc = strdup(s4);
        czas1 = strdup(s5);
        czas2 = strdup(s6);
        opis = strdup(s7);
        if (blob_size>0)
        {
            /* dołączam plik graficzny */
            *size = blob_size;
            *bufor = malloc(blob_size);
            memcpy(*bufor,blob,blob_size);
        }
        pub = bb;
    } else {
        b = 0;
        s = "";
    }
    sqlite3_finalize(stmt);
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
    sqlite3_stmt *stmt;
    char *indeks;
    pthread_mutex_lock(&mutex);
    if (czas)
    {
        if (sqlite3_prepare_v2(db,"select indeks from pliki where public=1 and czas_modyfikacji>? order by id limit 1 offset ?",-1,&stmt,NULL)) { pthread_mutex_unlock(&mutex); return ""; }
        sqlite3_bind_text(stmt,1,czas,-1,NULL);
        sqlite3_bind_int(stmt,2,lp);
    } else {
        if (sqlite3_prepare_v2(db,"select indeks from pliki where public=1 order by id limit 1 offset ?",-1,&stmt,NULL)) { pthread_mutex_unlock(&mutex); return ""; }
        sqlite3_bind_int(stmt,1,lp);
    }
    if (sqlite3_step(stmt)==SQLITE_ROW)
    {
        const char *s1 = sqlite3_column_text(stmt,0);
        indeks = strdup(s1);
    } else {
        indeks = "";
    }
    sqlite3_finalize(stmt);
    pthread_mutex_unlock(&mutex);
    return indeks;
}

int FileStatExist(char *indeks)
{
    sqlite3_stmt *stmt;
    int r;
    pthread_mutex_lock(&mutex);
    if (sqlite3_prepare_v2(db,"select id,public from pliki where indeks like ?",-1,&stmt,NULL)) { pthread_mutex_unlock(&mutex); return -1; }
    sqlite3_bind_text(stmt,1,indeks,-1,NULL);
    if (sqlite3_step(stmt)==SQLITE_ROW)
    {
        const int cid = sqlite3_column_int(stmt,0);
        const int cpb = sqlite3_column_int(stmt,1);
        r = cpb + 1;
    } else {
        r = 0;
    }
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
    bool factive = 0, nie_zmieniaj = 0, bin_active = 0, zapis = 0;
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

            //LOG("RAMKA","","s1 = ",s1);

            #include "zdarzenia.c"

            /* KOMUNIKACJA Ze STUDIEM */
            if (strcmp(s1,"{READ_MON}")==0 || strcmp(s1,"{READ_ALL}")==0 ||
                strcmp(s1,"{INFO}")==0 || strcmp(s1,"{INF1}")==0 ||
                strcmp(s1,"{INF2}")==0 || strcmp(s1,"{CAMERAS}")==0 ||
                strcmp(s1,"{RAMKA_PP}")==0 || strcmp(s1,"{INDEX_CZASU}")==0 ||
                strcmp(s1,"{PYTANIE}")==0 || strcmp(s1,"{INTERAKCJA}")==0)
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

            /* wysyłka */
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
            sqlite3_close(db);
            log_message(LOG_FILE,"terminate signal catched");
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
    bool fdbe;

    if(argc > 2)
    {
	printf("too many arguments");
	exit(1);
    }

    if (test()==1) return 0;
    if (TRYB==1) daemonize();
    Randomize();
    server = -1;

    if (TRYB==2){
        fdbe = FileNotExists("studio.jahu.db");
        error = sqlite3_open("studio.jahu.db",&db);
    } else {
        fdbe = FileNotExists(DB_FILE);
        error = sqlite3_open(DB_FILE,&db);
    }
    if( error )
    {
        fprintf(stderr,"Can't open database: %s\n",sqlite3_errmsg(db));
        log_message(LOG_FILE,"Problem z bazą danych.");
        return(0);
    }

    if (fdbe)
    {
        /* zakładam strukturę bazy danych */
        if (create_db_struct()) exit(1);
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
        exit(1);
    };

    is_port = portno;

    if(listen(my_sock,5) != 0)
    {
	perror("listening unsuccessful");
        log_message(LOG_FILE,"Problem z listiningiem.");
	exit(1);
    }

    while(1)
    {
        if((their_sock = accept(my_sock,(struct sockaddr *)&their_addr,&their_addr_size)) < 0)
        {
            perror("accept unsuccessful");
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
    sqlite3_close(db);
    return 0;
}

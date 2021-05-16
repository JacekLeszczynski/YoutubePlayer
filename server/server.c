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

long int StatFile2(char *indeks, long int *size)
{
    *size = 10;
    return 20;
}

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
    if (ExecSQL("CREATE TABLE wersja (id integer primary key,major integer,minor integer,rel integer,build integer)")) return 1;
    if (ExecSQL("CREATE TABLE klucze (id integer primary key,dt_insert text,klucz text)")) return 1;
    if (ExecSQL("CREATE INDEX idx_klucze_klucz on klucze(klucz)")) return 1;
    if (ExecSQL("CREATE TABLE pytania (id integer primary key,czas text,klucz text,nick text,pytanie text)")) return 1;
    if (ExecSQL("CREATE INDEX idx_pytania_klucz on pytania(klucz)")) return 1;
    if (ExecSQL("CREATE TABLE prive (id integer primary key,dt_insert text,nadawca text,nick text,adresat text,formatowanie text,tresc text)")) return 1;
    if (ExecSQL("CREATE INDEX idx_prive_adresat on prive(adresat)")) return 1;
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

/* PROCEDURY WYSYŁAJĄCE */
void sendtouser(char *msg, int sock_nadawca, int sock_adresat, int active, bool aMutex) //nadawca i adresat to sokety!
{
    char *KEY  = globalny_key;
    char *IV = malloc(17);
    int i,a,lx,lx2,l1,ll;
    char *tmp,*ss,*x,*hex;
    unsigned char *x1,*x2,*x3,*x4,*x5;

    a = -1;
    if (aMutex) pthread_mutex_lock(&mutex);
    for(i = 0; i < n; i++)
    {
        if(clients[i] == sock_adresat)
        {
            if (actives[i][active]) a = i;
            break;
	}
    }
    if (a>-1)
    {
        strcpy(IV,vector[a]);
        ss = String(msg);
        ss = dolar(ss);
        /* zaszyfrowanie odpowiedzi */
        l1 = strlen(ss);
        ll = l1;
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
        lx2 = UStringEncrypt(&x2,lx,IV,KEY);
        IntToB256(lx,&x1,2);
        /* wysłanie wiadomości */
        send(sock_adresat,x,lx2+2,MSG_NOSIGNAL);
        /* zwolnienie buforów */
        free(x);
    }
    if (aMutex) pthread_mutex_unlock(&mutex);
    free(IV);
}

/* PROCEDURY WYSYŁAJĄCE */
void sendtoall(char *msg, int sock_nadawca, bool force_all, int active, bool aMutex) //nadawca to soket
{
    char *KEY  = globalny_key;
    char *IV = malloc(17);
    int i,lx,lx2,l1,ll;
    char *komenda = GetLineToStr(msg,1,'$',"");
    char *tmp,*ss,*x,*hex,*xx;
    unsigned char *x1,*x2,*x3,*x4,*x5;
    bool b = 0, b2 = 0;

    if (aMutex) pthread_mutex_lock(&mutex);
    for(i = 0; i < n; i++)
    {
        if(!actives[i][active]) continue;
        if(force_all && clients[i] != server || (clients[i] != sock_nadawca && clients[i] != server))
        {
            if (strcmp(IV,vector[i])!=0)
            {
                if (b2) {free(x); b2=0;}
                b = 1;
                strcpy(IV,vector[i]);
                ss = concat_str_char(msg,'$');
                /* zaszyfrowanie odpowiedzi */
                l1 = strlen(ss);
                ll = l1;
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
                lx2 = UStringEncrypt(&x2,lx,IV,KEY);
                IntToB256(lx,&x1,2);
            }
            /* wysłanie wiadomości */
            send(clients[i],x,lx2+2,MSG_NOSIGNAL);
	}
    }
    if (b2) {free(x); b2=0;}
    if (aMutex) pthread_mutex_unlock(&mutex);
    free(IV);
}

/* PROCEDURA WYSYŁANIA LISTY UŻYTKOWNIKÓW - WEWNĘTRZNA */
void wewn_ChatListUser(int sock_adresat, int id)
{
    char *KEY  = globalny_key;
    char *IV = malloc(17);
    char *ss,*x,*hex;
    unsigned char *x1,*x2,*x3,*x4,*x5;
    int i,l1,ll,lx,lx2;

    for (i=0; i<n; i++){
        if (actives[i][5]) {
            ss = concat3("{CHAT_USER}",niki[i],key[i]);
            ss = dolar(ss);
            strcpy(IV,vector[id]);
            /* zaszyfrowanie odpowiedzi */
            l1 = strlen(ss);
            ll = l1;
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
            lx2 = UStringEncrypt(&x2,lx,IV,KEY);
            IntToB256(lx,&x1,2);
            /* wysłanie wiadomości */
            send(sock_adresat,x,lx2+2,MSG_NOSIGNAL);
            /* zwolnienie buforów */
            free(x);
        }
    }
    free(IV);
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

char *FileNew(char *key,char *nick,char *nazwa,char *dlugosc)
{
    char *s, *indeks;
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
    if (sqlite3_prepare_v2(db,"insert into pliki (indeks,nick,klucz,nazwa,sciezka,dlugosc,czas_wstawienia,status) values (?,?,?,?,?,?,?,?)",-1,&stmt,NULL)) {pthread_mutex_unlock(&mutex); return "";}
    sqlite3_bind_text(stmt,1,indeks,-1,NULL);
    sqlite3_bind_text(stmt,2,nick,-1,NULL);
    sqlite3_bind_text(stmt,3,key,-1,NULL);
    sqlite3_bind_text(stmt,4,nazwa,-1,NULL);
    sqlite3_bind_text(stmt,5,sciezka,-1,NULL);
    sqlite3_bind_text(stmt,6,dlugosc,-1,NULL);
    sqlite3_bind_text(stmt,7,LocalTime(),-1,NULL);
    sqlite3_bind_int(stmt,8,0);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    s = concat2(indeks,sciezka);
    pthread_mutex_unlock(&mutex);
    return s;
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

char *FileRequestNow(char *key, char *indeks)
{
    bool b;
    char *s, *nick, *klucz, *nazwa, *dlugosc, *czas1, *czas2;
    sqlite3_stmt *stmt;
    pthread_mutex_lock(&mutex);
    if (sqlite3_prepare_v2(db,"select nick,klucz,nazwa,dlugosc,czas_wstawienia,czas_zycia from pliki where indeks=?",-1,&stmt,NULL)) {pthread_mutex_unlock(&mutex); return "";}
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
        nick = strdup(s1);
        klucz = strdup(s2);
        nazwa = strdup(s3);
        dlugosc = strdup(s4);
        czas1 = strdup(s5);
        if (s6==NULL) czas2 = ""; else czas2 = strdup(s6);
    } else {
        b = 0;
        s = "";
    }
    sqlite3_finalize(stmt);
    pthread_mutex_unlock(&mutex);
    if (b)
    {
        s = concat4("{FILE_REQUESTING}",klucz,key,nick);
        s = concat4(s,indeks,nazwa,dlugosc);
        s = concat3(s,czas1,czas2);
        return s;
    } else return "";
}

char *SendFile(char *sciezka, int idx, unsigned int *count, int max_file_buffer)
{
    FILE *f;
    char *s = malloc(max_file_buffer+1);

    f=fopen(sciezka,"rb+");
    if(!f)
    {
        free(s);
        *count = 0;
        return "";
    }
    fseek(f,idx*max_file_buffer,SEEK_SET);
    *count = fread(s,1,max_file_buffer,f);
    fclose(f);
    return s;
}

/* WĄTEK POŁĄCZENIA */
void *recvmg(void *sock)
{
    struct client_info cl = *((struct client_info *)sock);
    bool TerminateNow = 0, czysc = 0;
    int e,a1,a2,a3,a4,nn,l,l1,l2,ll,lx,lx2,bin_len=0,len=0,len2=0,len3=0,v=0;
    char msg[CONST_MAX_BUFOR], *vv, *msg2;
    char *ss, *ss2, *s, *x, *s1, *s2, *s3, *s4, *s5, *s6, *s7, *s8, pom[5], *hex, *tmp, *bin, *wbin;
    unsigned char *x1, *x2, *x3, *x4, *x5;
    int id,id2,sock_user,i,j,k,blok,wsize; //UWAGA: używam id jako identa tablicy, zaś id2 jako wartość soketa!
    char *IV,*IV_NEW;
    char *KEY  = globalny_key;
    IV = malloc(17);
    strcpy(IV,globalny_vec);
    bool wysylka = 0, nook, b1, b2;
    bool isserver = 0;
    char *sql;
    char *filename, *filename2;
    long int la1;
    int max_file_buffer = CONST_MAX_FILE_BUFOR;
    FILE *f;
    bool factive = 0, nie_zmieniaj = 0, bin_active = 0;
    int fidx = 0;

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

        //if (len2<5) continue;
        blok = B256ToInt(vv,2);

        if (blok==0)
        {
            czysc = 1;
            break;
        }
        if (blok>(len-(vv-msg))+2){
            czysc = 0;                                   //7f 88 cc 13 2e 98 c2 87 71 cb da 7d 4d 1e ab 2b
            break;                                       //  l=16 ll=32648 (7f 88) l1=52243 l2=-19595
        }

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


        /* tworzenie odpowiedzi */
        if (strcmp(s1,"{EXIT}")==0)
        {
            TerminateNow = 1;
            break;
        } else
        if (strcmp(s1,"{NTP}")==0)
        {
            ss = concat2("{NTP}",IntToSys(TimeToInteger(),10));
            wysylka = 1;
        } else
        if (strcmp(s1,"{GET_VECTOR}")==0)
        {
            pthread_mutex_lock(&mutex);
            actives[idsock(cl.sockno)][1] = 1;
            pthread_mutex_unlock(&mutex);
            IV_NEW = GenNewVector(16);
            ss = concat2("{VECTOR_IS_NEW}",IV_NEW);
            wysylka = 1;
        } else
        if (strcmp(s1,"{I-AM-SERVER}")==0)
        {
            isserver = 1;
            pthread_mutex_lock(&mutex);
            server = cl.sockno;
            actives[idsock(cl.sockno)][4] = 1;
            pthread_mutex_unlock(&mutex);
            ss = String("{SERVER-EXIST}");
            sendtoall(ss,cl.sockno,0,1,0);
            ss = concat2("{USERS_COUNT}",IntToSys(n,10));
            ReadPytania(0,cl.sockno);
            wysylka = 1;
        } else
        if (strcmp(s1,"{SET_VERSION}")==0)
        {
            a1 = atoi(GetLineToStr(s,2,'$',"0"));
            a2 = atoi(GetLineToStr(s,3,'$',"0"));
            a3 = atoi(GetLineToStr(s,4,'$',"0"));
            a4 = atoi(GetLineToStr(s,5,'$',"0"));
            e = SetVersionProg(a1,a2,a3,a4);
            ss = concat("{SET_VERSION_ERR}$",IntToSys(e,10));
            if (e==0)
            {
                /* poinformowanie wszystkich o nowej wersji programu */
                ss = concat4("{NEW_VERSION}",IntToSys(a1,10),IntToSys(a2,10),IntToSys(a3,10));
                ss = concat2(ss,IntToSys(a4,10));
                sendtoall(ss,cl.sockno,0,1,0);
            }
            wysylka = 1;
        } else
        if (strcmp(s1,"{FILE_NEW}")==0)
        {
            s2 = GetLineToStr(s,2,'$',""); //key
            s3 = GetLineToStr(s,3,'$',""); //nick
            s4 = GetLineToStr(s,4,'$',""); //nazwa
            s7 = GetLineToStr(s,5,'$',"0"); //dlugosc
            a2 = atoi(GetLineToStr(s,6,'$',"0")); //id
            max_file_buffer = atoi(GetLineToStr(s,7,'$',"1024")); //wielkosc segmentu danych (domyślnie 1024)
            s5 = FileNew(s2,s3,s4,s7);
            s6 = GetLineToStr(s5,1,'$',"");
            filename = GetLineToStr(s5,2,'$',"");
            if (factive) fclose(f);
            f=fopen(filename,"wb");
            factive = 1;
            fidx = 0;
            ss = concat4("{FILE_NEW_ACCEPTED}",s2,IntToSys(a2,10),s6);
            wysylka = 1;
        } else
        if (strcmp(s1,"{FILE_DELETE}")==0)
        {
            s2 = GetLineToStr(s,2,'$',""); //key
            a1 = atoi(GetLineToStr(s,3,'$',"0")); //id
            s3 = GetLineToStr(s,4,'$',""); //indeks
            if (FileDelete(s2,s3))
            {
                /* plik został usunięty */
                ss = concat3("{FILE_DELETE_TRUE}",s2,IntToSys(a1,10));
            } else {
                /* plik nie został usunięty */
                ss = concat3("{FILE_DELETE_FALSE}",s2,IntToSys(a1,10));
            }
            wysylka = 1;
        } else
        if (strcmp(s1,"{FILE_UPLOAD}")==0)
        {
            usleep(SLEEP_DOWN_UP_LOADS);
            s2 = GetLineToStr(s,2,'$',""); //key
            s3 = GetLineToStr(s,3,'$',""); //id
            s4 = GetLineToStr(s,4,'$',""); //indeks
            s5 = GetLineToStr(s,5,'$',""); //crc-hex
            a1 = atoi(GetLineToStr(s,6,'$',"-1")); //idx
            a2 = atoi(GetLineToStr(s,7,'$',"0")); //długość ciągu
            if (strcmp(crc32blockhex(wbin,wsize),s5)==0)
            {
                /* crc zgodne */
                ss = concat4("{FILE_UPLOADING}",s2,s3,"OK");
                ss = concat2(ss,IntToSys(a1+1,10));
                if (fidx!=a1)
                {
                    fseek(f,(a1-fidx)*max_file_buffer,SEEK_CUR);
                    fidx = a1;
                }
                fwrite(wbin,wsize,1,f);
                fidx++;
            } else {
                /* crc niezgodne */
                ss = concat4("{FILE_UPLOADING}",s2,s3,"ERROR");
                ss = concat2(ss,IntToSys(a1,10));
            }
            wysylka = 1;
        } else
        if (strcmp(s1,"{FILE_END}")==0)
        {
            s2 = GetLineToStr(s,2,'$',""); //key
            s3 = GetLineToStr(s,3,'$',""); //id
            s4 = GetLineToStr(s,4,'$',""); //indeks
            if (factive) fclose(f); //dla bezpieczeństwa
            factive = 0;
        } else
        if (strcmp(s1,"{FILE_STAT}")==0)
        {
            s2 = GetLineToStr(s,2,'$',""); //key
            s3 = GetLineToStr(s,3,'$',""); //id
            s4 = GetLineToStr(s,4,'$',""); //indeks
            max_file_buffer = atoi(GetLineToStr(s,5,'$',"1024")); //wielkosc segmentu danych (domyślnie 1024)
            s5 = StatFile(s4);
            filename2 = GetLineToStr(s5,1,'$',""); //scieżka
            s6 = GetLineToStr(s5,2,'$',"");        //wielkość pliku
            if (factive) fclose(f);
            f=fopen(filename2,"rb+");
            factive = 1;
            fidx = 0;
            ss = concat4("{FILE_STATING}",s2,s3,s4);
            ss = concat2(ss,s6); //wielkość pliku
            wysylka = 1;
        } else
        if (strcmp(s1,"{FILE_DOWNLOAD}")==0)
        {
            usleep(SLEEP_DOWN_UP_LOADS);
            s2 = GetLineToStr(s,2,'$',"");         //key
            s3 = GetLineToStr(s,3,'$',"");         //id
            s4 = GetLineToStr(s,4,'$',"");         //indeks
            a1 = atoi(GetLineToStr(s,5,'$',"-1")); //idx
            //bin = SendFile(filename2,a1,&bin_len,max_file_buffer);

            if (bin_active) free(bin);
            bin = malloc(max_file_buffer+1);
            bin_active = 1;
            if (fidx!=a1)
            {
                fseek(f,(a1-fidx)*max_file_buffer,SEEK_CUR);
                fidx = a1;
            }
            bin_len = fread(bin,1,max_file_buffer,f);
            fidx++;

            if (bin_len==0)
            {
                /* nie ma nic do wysłania */
                ss = concat4("{FILE_DOWNLOADING_ZERO}",s2,s3,s4);
                ss = concat2(ss,IntToSys(a1,10));
            } else {
                /* gotowe do wysłania */
                s5 = crc32blockhex(bin,bin_len);
                ss = concat4("{FILE_DOWNLOADING}",s2,s3,s4);
                ss = concat4(ss,IntToSys(a1,10),s5,IntToSys(bin_len,10));
                ss = concat(ss,"$#");
                nie_zmieniaj = 1;
            }
            wysylka = 1;
        } else
        if (strcmp(s1,"{FILE_REQUEST}")==0)
        {
            s2 = GetLineToStr(s,2,'$',"");         //key
            s3 = GetLineToStr(s,3,'$',"");         //indeks
            ss = FileRequestNow(s2,s3);
            if (strcmp(ss,"")!=0) wysylka = 1;
        } else
        if (strcmp(s1,"{PYTANIE}")==0 && server==-1)
        {
            /* jeśli przyszło pytanie, ale nie ma zalogowanego serwera to pytanie leci do bazy */
            /* Format wywołania: PytanieToDb(klucz,nick,pytanie);                              */
            pthread_mutex_lock(&mutex);
            if (PytanieToDb(GetLineToStr(s,2,'$',""),GetLineToStr(s,3,'$',""),GetLineToStr(s,4,'$',"")))
            {
                /* jeśli błąd powiadamian nadawcę pytania o błędzie */
                ss = String("{PYTANIE_ERROR}");
                wysylka = 1;
            }
            pthread_mutex_unlock(&mutex);
        } else
        if (strcmp(s1,"{LOGIN}")==0)
        {
            if (server==-1)
            {
                ss = String("{SERVER-NON-EXIST}");
                sendtouser(ss,-1,cl.sockno,0,1);
            } else {
                ss = String("{SERVER-EXIST}");
                sendtouser(ss,-1,cl.sockno,0,1);
            }
            s2 = GetLineToStr(s,2,'$',"");
            if (strcmp(s2,"")==0)
            {
                /* użytkownik bez określonego klucza - nadaję nowy klucz */
                ss = concat2("{KEY-NEW}",cl.key);
                pthread_mutex_lock(&mutex);
                KluczToDb(cl.key);
                pthread_mutex_unlock(&mutex);
                wysylka = 1;
            } else {
                /* użytkownik z kluczem - sprawdzam czy taki klucz istnieje */
                pthread_mutex_lock(&mutex);
                id = idsock(cl.sockno);
                if (DbKluczIsNotExists(s2))
                {
                    /* użytkownik z nieważnym kluczem - nadaję nowy klucz */
                    ss=concat2("{KEY-NEW}",cl.key);
                    KluczToDb(cl.key);
                } else {
                    a1 = key_to_soket(s2,0);
                    if (a1 == -1)
                    {
                        strcpy(key[id],s2);
                        strcpy(cl.key,s2);
                        ss=String("{KEY-OK}");
                    } else {
                        KillUser(a1);
                        id = idsock(cl.sockno);
                        strcpy(key[id],s2);
                        strcpy(cl.key,s2);
                        ss=String("{KEY-OK}");
                        //ss=concat("{KEY-IS-LOGIN}$",IntToSys(a1,10));
                    }
                }
                pthread_mutex_unlock(&mutex);
                wysylka = 1;
            }
            ss2 = concat("{USERS_COUNT}$",IntToSys(n,10));
            sendtouser(ss2,0,cl.sockno,1,1);
            InfoVersionProg(cl.sockno);
        } else
        if (strcmp(s1,"{REQUEST_NEW_KEY}")==0)
        {
            /* przyjęto żądanie zmiany klucza */
            s2 = GetLineToStr(s,2,'$',""); //key aktualny
            s3 = GetLineToStr(s,3,'$',""); //key nowy
            a1 = atoi(GetLineToStr(s,4,'$',"1")); //żądanie nie usuwania starego klucza jesli jest 0
            /* sprawdzenie czy w bazie klucz istnieje,
               jeśli nie istnieje - dodanie nowego klucza do bazy
               i usunięcie aktualnie używanego klucza z bazy,
               chyba że zażądano nie usuwania starego klucza */
            pthread_mutex_lock(&mutex);
            a1 = key_to_soket(s2,0);
            b1 = RequestRegisterNewKey(s2,s3,a1,0);
            if (b1)
            {
                if (a1 != -1)
                {
                    strcpy(key[id],s3);
                    strcpy(cl.key,s3);
                    /* nadanie nowego klucza - tego który przyszedł wraz z żądaniem */
                    ss = concat3("{KEY-NEW}$",cl.key,"1"); //dodanie informacji o żądaniu poinformowania o wykonanej akcji
                } else ss = String("{KEY-DROP}");
            } else {
                /* coś poszło źle - wysłanie informacji o odrzuceniu żądania */
                ss = String("{KEY-DROP}");
            }
            pthread_mutex_unlock(&mutex);
            wysylka = 1;
        } else
        if (strcmp(s1,"{CHAT_INIT}")==0)
        {
            /* Tekst powitania przy wejściu na chat */
            ss = concat2("{CHAT_INIT}",SendTxtChat());
            wysylka = 1;
        } else
        if (strcmp(s1,"{GET_CHAT}")==0)
        {
            /* żądanie pobrania wszystkich wiadomości do mnie */
            a1 = PrivMessageFromDbToUser(cl.sockno,cl.key);
            ss = concat2("{GET_CHAT_END}",IntToSys(a1,10));
            wysylka = 1;
        } else
        if (strcmp(s1,"{CHAT}")==0)
        {
            /* CHAT GRUPOWY UŻYTKOWNIKÓW */
            s2 = GetLineToStr(s,2,'$',""); //key nadawcy
            s3 = GetLineToStr(s,3,'$',""); //nick nadawcy
            s4 = GetLineToStr(s,4,'$',""); //key adresata
            s5 = GetLineToStr(s,5,'$',""); //formatowanie
            s6 = GetLineToStr(s,6,'$',""); //treść
            s7 = LocalTime();              //lokalny czas
            s8 = GetLineToStr(s,7,'$',""); //indeks pliku
            ss = concat4("{CHAT}",s2,s3,s4);
            ss = concat4(ss,s5,s6,s7);
            ss = concat2(ss,s8);
            if (strcmp(s4,"")==0) sendtoall(ss,cl.sockno,1,5,1); else
            {
                /* wiadomość prywatna - leci tylko do adresata */
                pthread_mutex_lock(&mutex);
                a1 = key_to_soket(s4,0);
                if (a1==-1) PriveMessageToDB(s2,s3,s4,s5,s6,s7,s8); else sendtouser(ss,cl.sockno,a1,1,0);
                pthread_mutex_unlock(&mutex);
                if (strcmp(s8,"")==0)
                {
                    if (strcmp(s6,"")!=0) wysylka = 1;
                } else {
                    /* wysyłam sygnał o przyjęciu udostępnienia pliku */
                    ss = concat4("{SIGNAL}",s4,s2,"MESSAGE");
                    ss = concat3(ss,"2","Żądanie udostępnienia pliku zostało zarejestrowane i przekazane do adresata.");
                    ss = concat(ss,"$$");
                    wysylka = 1;
                }
            }
        } else
        if (strcmp(s1,"{SIGNAL}")==0)
        {
            /* Wiadomość Sygnałowa */
            s2 = GetLineToStr(s,2,'$',"");        //key nadawcy
            s3 = GetLineToStr(s,3,'$',"");        //key adresata
            s4 = GetLineToStr(s,4,'$',"");        //kod operacji: STUN, P2P, FTP, SPEAK, MESSAGE
            a1 = atoi(GetLineToStr(s,5,'$',"0")); //kod statusu: 1 (wysłanie żądania), 2 (przesłanie żądania dalej / odpowiedź serwera), 3-4 (komunikacja między peerami)
            if (a1==2) continue;
            if (a1==1) a1++;
            s5 = GetLineToStr(s,6,'$',"");        //parametr 1: P2P (dane połączenia), FTP (nazwa pliku do przesłania)
            s6 = GetLineToStr(s,7,'$',"");        //parametr 2: P2P (losowy klucz do weryfikacji)
            /* budowanie odpowiedzi */
            ss = concat4("{SIGNAL}",s2,s3,s4);
            ss = concat4(ss,IntToSys(a1,10),s5,s6);
            if (strcmp(s4,"P2P")==0)
            {
                //wysłanie wiadomości bezpośredniej
                pthread_mutex_lock(&mutex);
                a1 = key_to_soket(s3,0);
                if (a1!=-1) sendtouser(ss,cl.sockno,a1,1,0);
                pthread_mutex_unlock(&mutex);
            }
            //if (strcmp(s6,"")!=0) wysylka = 1;
        } else
        if (strcmp(s1,"{ADM}")==0)
        {
            /* OPERACJE ADMINISTRACYJNE - ŻĄDANIA */
            s2 = GetLineToStr(s,2,'$',""); //key nadawcy
            s3 = GetLineToStr(s,3,'$',""); //key adresata
            s4 = GetLineToStr(s,4,'$',""); //operacja
            ss = String(s);
            pthread_mutex_lock(&mutex);
            a1 = key_to_soket(s3,0);
            if (a1!=-1) sendtouser(ss,cl.sockno,a1,1,0);
            pthread_mutex_unlock(&mutex);
        } else
        if (strcmp(s1,"{ADMO}")==0)
        {
            /* OPERACJE ADMINISTRACYJNE - ODPOWIEDZI */
            s2 = GetLineToStr(s,2,'$',""); //key nadawcy
            s3 = GetLineToStr(s,3,'$',""); //key adresata
            s4 = GetLineToStr(s,4,'$',""); //operacja
            ss = String(s);
            pthread_mutex_lock(&mutex);
            a1 = key_to_soket(s3,0);
            if (a1!=-1) sendtouser(ss,cl.sockno,a1,1,0);
            pthread_mutex_unlock(&mutex);
        } else
        if (strcmp(s1,"{SET_ACTIVE}")==0)
        {
            b1 = 0; b2 = 0;
            a1 = atoi(GetLineToStr(s,2,'$',"0"));
            if (a1!=0)
            {
                a2 = atoi(GetLineToStr(s,3,'$',"0"));
                pthread_mutex_lock(&mutex);
                id = idsock(cl.sockno);
                actives[id][a1] = a2;
                if (a1==5)
                {
                    if (a2==1)
                    {
                        ischat = 1;
                        s2 = GetLineToStr(s,4,'$',"");
                        memset(niki[id],0,51);
                        strncpy(niki[id],s2,strlen(s2));
                        niki[id][strlen(niki[id])] = '\0';
                        wewn_ChatListUser(cl.sockno,id);
                        ss = concat3("{CHAT_USER}",s2,cl.key);
                        b1 = 1;
                    } else {
                        ischat = 0;
                        memset(niki[id],0,51);// niki[id][0]='\0';
                        b2 = 1; //wyslij do wszystkich że już mnie nie ma na chacie
                    }
                }
                pthread_mutex_unlock(&mutex);
                if (b1) sendtoall(ss,cl.sockno,0,5,0);
                else if (b2)
                {
                    ss = concat2("{CHAT_LOGOUT}",cl.key);
                    sendtoall(ss,cl.sockno,0,5,0);
                }
            }
        } else
        if (strcmp(s1,"{INF1}")==0)
        {
            /* jeśli przyszło z kluczem - przerabiam na starszą wersję */
            s2 = GetLineToStr(s,2,'$',""); //KEY
            s3 = GetLineToStr(s,3,'$',""); //VALUE
            sock_user = key_to_soket(s2,1);
            ss = concat2("{INF1}",s3);
            sendtouser(ss,cl.sockno,sock_user,4,1);
        } else
        if (strcmp(s1,"{READ_PYTANIA}")==0)
        {
            a1 = ReadPytania(0,cl.sockno);
            ss = concat2("{READ_PYTANIA_COUNT}",IntToSys(a1,10));
            wysylka = 1;
        } else
        if (cl.sockno == server)
        {
            /* wiadomość na sokecie serwera - wszystko leci do użytkownika/użytkowników */
            if (id2==-1)
            {
                /* wiadomość jest przekazywana do wszystkich użytkowników */
                ss = s;
                sendtoall(ss,cl.sockno,0,4,0);
            } else {
                /* wiadomość jest przekazywana do wybranego użytkownika */
                ss = s;
                sendtouser(ss,cl.sockno,id2,4,1);
            }
        } else {
            /* wiadomość na sokecie użytkownika - wszystko leci do serwera */
            if (server==-1)
            {
                /* serwer nie jest zalogowany - odpowiedź brak serwera */
                ss = String("{SERVER-NON-EXIST}");
                wysylka = 1;
            } else {
                /* serwer istnieje więc przekazuję wszystkie ramki do serwera */
                ss = s;
                sendtouser(ss,cl.sockno,server,4,1);
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
    } if (czysc) len = 0; if (TerminateNow) break; }  /* pętla główna recv i pętla wykonywania gotowych zapytań */

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

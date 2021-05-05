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
int clients[10000];
char key[10000][25];
char vector[10000][17];
char ips[10000][INET_ADDRSTRLEN];
int ports[10000];


/*
  ACTIVES:
    0 - LOGIN;         - zawsze aktywny, umożliwia zalogowanie się itd.
    1 - POZ_1;         - podstawowa komunikacja, aktywna dla wszystkich zalogowanych
    2 - POZ_2;         - (nieużywane)
    3 - POZ_3;         - (nieuzywane)
    4 - STUDIO JAHU;   - platforma studia jahu (monitor)
    5 - CHAT           - chat (chat grupowy)
*/
bool actives[10000][6];
char niki[10000][51];
int n = 0, mn = 0, ischat = 0;
int error = 0;
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
sqlite3 *db;

/* FUNKCJA TESTUJĄCA */
int test()
{
    return 0;
    //printf("%s\n",crc32hex("Hello!"));

    FILE *f;
    char *s = "ABXDEFGH";
    char *s1 = "C";
    /* zapis ramki do pliku */
    f=fopen("tet.txt","w");
    if(!f) return 1;
    fwrite(s,strlen(s),1,f);
    fclose(f);
    //return 1;

    f=fopen("tet.txt","r+b");
    if(!f) return 1;
    fseek(f,2,SEEK_SET);
    fwrite(s1,strlen(s1),1,f);
    fclose(f);
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

void LOG(char *s1, char *s2, char *s3)
{
    char *s;
    s = concat_str_char(s1,' ');
    s = concat(s,s2);
    s = concat_str_char(s,' ');
    s = concat(s,s3);
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
bool PriveMessageToDB(char *nadawca, char *nick, char* adresat, char *formatowanie, char *tresc, char *czas)
{
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(db,"insert into prive (dt_insert,nadawca,nick,adresat,formatowanie,tresc) values (?,?,?,?,?,?)",-1,&stmt,NULL)) return 1;
    sqlite3_bind_text(stmt,1,czas,-1,NULL);
    sqlite3_bind_text(stmt,2,nadawca,-1,NULL);
    sqlite3_bind_text(stmt,3,nick,-1,NULL);
    sqlite3_bind_text(stmt,4,adresat,-1,NULL);
    sqlite3_bind_text(stmt,5,formatowanie,-1,NULL);
    sqlite3_bind_text(stmt,6,tresc,-1,NULL);
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
    int i,a,lx,lx2;
    char *tmp,*ss,*x,*x1,*hex;

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
        tmp = concat_char_str(znaczek,itoa(sock_nadawca,10));
        tmp = concat_str_char(tmp,znaczek);
        ss = concat(tmp,msg);
        /* zaszyfrowanie odpowiedzi */
        lx = CalcBuffer(strlen(ss)+1);
        x = malloc(lx+4);
        memset(x,0,lx+4);
        x1 = &x[4];
        strncpy(x1,ss,strlen(ss));
        x1[strlen(ss)]='\0';
        lx2 = StringEncrypt(&x1,strlen(x1),IV,KEY);
        hex = StrBase(IntToSys(lx2,16),4);
        x[0] = hex[0];
        x[1] = hex[1];
        x[2] = hex[2];
        x[3] = hex[3];
        /* wysłanie wiadomości */
        send(sock_adresat,x,lx2+4,MSG_NOSIGNAL);
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
    int i,lx,lx2;
    char *komenda = GetLineToStr(msg,1,'$',"");
    char *tmp,*ss,*x,*x1,*hex,*xx;
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
                if (sock_nadawca>-1)
                {
                    tmp = concat_char_str(znaczek,IntToSys(sock_nadawca,10));
                    tmp = concat_str_char(tmp,znaczek);
                    ss = concat(tmp,msg);
                } else ss = String(msg);
                /* zaszyfrowanie odpowiedzi */
                lx = CalcBuffer(strlen(ss)+1);
                b2 = 1;
                x = malloc(lx+4);
                memset(x,0,lx+4);
                x1 = &x[4];
                strncpy(x1,ss,strlen(ss));
                x1[strlen(ss)]='\0';
                lx2 = StringEncrypt(&x1,strlen(x1),IV,KEY);
                hex = StrBase(IntToSys(lx2,16),4);
                x[0] = hex[0];
                x[1] = hex[1];
                x[2] = hex[2];
                x[3] = hex[3];
            }
            /* wysłanie wiadomości */
            send(clients[i],x,lx2+4,MSG_NOSIGNAL);
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
    char *msg,*tmp,*ss,*x,*x1,*hex;
    int i,lx,lx2;

    for (i=0; i<n; i++){
        if (actives[i][5]) {
            msg = concat("{CHAT_USER}$",niki[i]);
            msg = concat_str_char(msg,'$');
            msg = concat(msg,key[i]);
            strcpy(IV,vector[id]);
            tmp = concat_char_str(znaczek,itoa(0,10));
            tmp = concat_str_char(tmp,znaczek);
            ss = concat(tmp,msg);
            /* zaszyfrowanie odpowiedzi */
            lx = CalcBuffer(strlen(ss)+1);
            x = malloc(lx+4);
            memset(x,0,lx+4);
            x1 = &x[4];
            strncpy(x1,ss,strlen(ss));
            x1[strlen(ss)]='\0';
            lx2 = StringEncrypt(&x1,strlen(x1),IV,KEY);
            hex = StrBase(IntToSys(lx2,16),4);
            x[0] = hex[0];
            x[1] = hex[1];
            x[2] = hex[2];
            x[3] = hex[3];
            /* wysłanie wiadomości */
            send(sock_adresat,x,lx2+4,MSG_NOSIGNAL);
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
    ss = concat("{NEW_VERSION}$",IntToSys(a1,10));
    ss = concat_str_char(ss,'$');
    ss = concat(ss,IntToSys(a2,10));
    ss = concat_str_char(ss,'$');
    ss = concat(ss,IntToSys(a3,10));
    ss = concat_str_char(ss,'$');
    ss = concat(ss,IntToSys(a4,10));
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
        s = concat_str_char("{PYTANIE}",'$');
        s = concat(s,strdup(klucz));
        s = concat_str_char(s,'$');
        s = concat(s,strdup(nick));
        s = concat_str_char(s,'$');
        s = concat(s,strdup(pytanie));
        s = concat_str_char(s,'$');
        s = concat(s,strdup(czas));
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
    if (sqlite3_prepare_v2(db,"select dt_insert,nadawca,nick,adresat,formatowanie,tresc from prive where adresat=? order by id",-1,&stmt,NULL)) {pthread_mutex_unlock(&mutex); return -2;}
    sqlite3_bind_text(stmt,1,key,-1,NULL);
    while (sqlite3_step(stmt) != SQLITE_DONE)
    {
        const char *czas = sqlite3_column_text(stmt,0);
        const char *nadawca = sqlite3_column_text(stmt,1);
        const char *nick = sqlite3_column_text(stmt,2); //na razie brak, więc wrzucam nadawcę
        const char *adresat = sqlite3_column_text(stmt,3);
        const char *formatowanie = sqlite3_column_text(stmt,4);
        const char *tresc = sqlite3_column_text(stmt,5);
        s = concat("{CHAT}$",strdup(nadawca));
        s = concat_str_char(s,'$');
        s = concat(s,strdup(nick));
        s = concat_str_char(s,'$');
        s = concat(s,strdup(adresat));
        s = concat_str_char(s,'$');
        s = concat(s,strdup(formatowanie));
        s = concat_str_char(s,'$');
        s = concat(s,strdup(tresc));
        s = concat_str_char(s,'$');
        s = concat(s,strdup(czas));
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

char *FileNew(char *key,char *nick,char *nazwa,int dlugosc)
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
    sqlite3_bind_int(stmt,6,dlugosc);
    sqlite3_bind_text(stmt,7,LocalTime(),-1,NULL);
    sqlite3_bind_int(stmt,8,0);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    pthread_mutex_unlock(&mutex);
    s = concat_str_char(indeks,'$');
    s = concat(s,sciezka);
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
        remove(s);
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

void SaveFile(char *filename, char *ciag, int dlugosc, int segment)
{
    FILE *f;
    bool b;
    char *s;

    if (segment==0)
    {
        /* zapis ramki do pliku */
        f=fopen(filename,"w");
        if(!f) return;
        fwrite(ciag,dlugosc,1,f);
        fclose(f);
    } else {
        /* zapis ramki do pliku */
        f=fopen(filename,"a");
        if(!f) return;
        //fseek(f,segment*1024,SEEK_SET);
        fwrite(ciag,dlugosc,1,f);
        fclose(f);
    }
}

/* WĄTEK POŁĄCZENIA */
void *recvmg(void *sock)
{
    struct client_info cl = *((struct client_info *)sock);
    bool TerminateNow = 0;
    int e,a1,a2,a3,a4,nn;
    char msg[2048];
    char *ss, *ss2, *s, *x, *x1, *s1, *s2, *s3, *s4, *s5, *s6, *s7, *pom = malloc(5), *hex, *tmp;
    int len,l,lx,lx2;
    int id,id2,sock_user,i,j,k,wsk,blok; //UWAGA: używam id jako identa tablicy, zaś id2 jako wartość soketa!
    char *IV,*IV_NEW;
    char *KEY  = globalny_key;
    IV = malloc(17);
    strcpy(IV,globalny_vec);
    bool wysylka = 0, nook, b1, b2;
    bool isserver = 0;
    char* sql;
    char* filename;

    ss = concat("{USERS_COUNT}$",IntToSys(n,10));
    sendtoall(ss,0,0,1,0);
    if (server!=-1) sendtouser(ss,cl.sockno,server,1,0);

    while((len = recv(cl.sockno,msg,2048,0)) > 0)
    {
        /* ODEBRANIE WIADOMOŚCI */
        wsk = 0;
        blok = 0;
        id2 = -1;
        while (wsk+4<len)
        {
            pom[0] = msg[wsk];
            pom[1] = msg[wsk+1];
            pom[2] = msg[wsk+2];
            pom[3] = msg[wsk+3];
            pom[4] = '\0';
            blok = HexToDec(pom);
            /* rozszyfrowanie wiadomości */
            s = &msg[wsk+4];
            l = StringDecrypt(&s,blok,IV,KEY);
            if (s[0]==znaczek)
            {
                /* wybieram ID rurki */
                id2 = atoi(GetLineToStr(s,2,znaczek,"-1"));
                s = GetLineToStr(s,3,znaczek,"");
            }
            s1 = GetLineToStr(s,1,'$',"");

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
                ss = concat("NTP$",IntToSys(TimeToInteger(),10));
                wysylka = 1;
            } else
            if (strcmp(s1,"{GET_VECTOR}")==0)
            {
                pthread_mutex_lock(&mutex);
                actives[idsock(cl.sockno)][1] = 1;
                pthread_mutex_unlock(&mutex);
                IV_NEW = GenNewVector(16);
                ss = concat("{VECTOR_IS_NEW}$",IV_NEW);
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
                ss = concat("{USERS_COUNT}$",IntToSys(n,10));
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
                    ss = concat("{NEW_VERSION}$",IntToSys(a1,10));
                    ss = concat_str_char(ss,'$');
                    ss = concat(ss,IntToSys(a2,10));
                    ss = concat_str_char(ss,'$');
                    ss = concat(ss,IntToSys(a3,10));
                    ss = concat_str_char(ss,'$');
                    ss = concat(ss,IntToSys(a4,10));
                    sendtoall(ss,cl.sockno,0,1,0);
                }
                wysylka = 1;
            } else
            if (strcmp(s1,"{FILE_NEW}")==0)
            {
                s2 = GetLineToStr(s,2,'$',""); //key
                s3 = GetLineToStr(s,3,'$',""); //nick
                s4 = GetLineToStr(s,4,'$',""); //nazwa
                a1 = atoi(GetLineToStr(s,5,'$',"0")); //dlugosc
                a2 = atoi(GetLineToStr(s,6,'$',"0")); //id
                s5 = FileNew(s2,s3,s4,a1);
                s6 = GetLineToStr(s5,1,'$',"");
                filename = GetLineToStr(s5,2,'$',"");
                ss = concat("{FILE_NEW_ACCEPTED}$",s2);
                ss = concat_str_char(ss,'$');
                ss = concat(ss,IntToSys(a2,10));
                ss = concat_str_char(ss,'$');
                ss = concat(ss,s6);
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
                    ss = concat("{FILE_DELETE_TRUE}$",s2);
                    ss = concat_str_char(ss,'$');
                    ss = concat(ss,IntToSys(a1,10));
                } else {
                    /* plik nie został usunięty */
                    ss = concat("{FILE_DELETE_FALSE}$",s2);
                    ss = concat_str_char(ss,'$');
                    ss = concat(ss,IntToSys(a1,10));
                }
                wysylka = 1;
            } else
            if (strcmp(s1,"{FILE_UPLOAD}")==0)
            {
                s2 = GetLineToStr(s,2,'$',""); //key
                s3 = GetLineToStr(s,3,'$',""); //id
                s4 = GetLineToStr(s,4,'$',""); //indeks
                s5 = GetLineToStr(s,5,'$',""); //crc-hex
                a1 = atoi(GetLineToStr(s,6,'$',"-1")); //idx
                a2 = atoi(GetLineToStr(s,7,'$',"0")); //długość ciągu
                s6 = strchr(s,'X');
                s6++;
                s6[a2] = '\0';
                if (strcmp(crc32blockhex(s6,a2),s5)==0)
                {
                    /* crc zgodne */
                    ss = concat("{FILE_UPLOADING}$",s2); //key
                    ss = concat_str_char(ss,'$');
                    ss = concat(ss,s3);                  //id
                    ss = concat_str_char(ss,'$');
                    ss = concat(ss,"OK");                //"OK"
                    ss = concat_str_char(ss,'$');
                    ss = concat(ss,IntToSys(a1+1,10));   //idx
                    SaveFile(filename,s6,a2,a1);
                } else {
                    /* crc niezgodne */
                    ss = concat("{FILE_UPLOADING}$",s2); //key
                    ss = concat_str_char(ss,'$');
                    ss = concat(ss,s3);                  //id
                    ss = concat_str_char(ss,'$');
                    ss = concat(ss,"ERROR");             //"ERROR"
                    ss = concat_str_char(ss,'$');
                    ss = concat(ss,IntToSys(a1,10));     //idx
                }
                wysylka = 1;
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
                    ss = concat("{KEY-NEW}$",cl.key);
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
                        ss=concat("{KEY-NEW}$",cl.key);
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
                        ss = concat("{KEY-NEW}$",cl.key);
                        ss = concat(ss,"$1"); //dodanie informacji o żądaniu poinformowania o wykonanej akcji
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
                ss = concat("{CHAT_INIT}$",SendTxtChat());
                //ss = concat("{CHAT_INIT}$","HELLO!");
                wysylka = 1;
            } else
            if (strcmp(s1,"{GET_CHAT}")==0)
            {
                /* żądanie pobrania wszystkich wiadomości do mnie */
                a1 = PrivMessageFromDbToUser(cl.sockno,cl.key);
                ss = concat("{GET_CHAT_END}$",IntToSys(a1,10));
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
                ss = concat("{CHAT}$",s2);
                ss = concat_str_char(ss,'$');
                ss = concat(ss,s3);
                ss = concat_str_char(ss,'$');
                ss = concat(ss,s4);
                ss = concat_str_char(ss,'$');
                ss = concat(ss,s5);
                ss = concat_str_char(ss,'$');
                ss = concat(ss,s6);
                ss = concat_str_char(ss,'$');
                ss = concat(ss,s7);
                ss = concat_str_char(ss,'$');
                if (strcmp(s4,"")==0) sendtoall(ss,cl.sockno,1,5,1); else
                {
                    /* wiadomość prywatna - leci tylko do adresata */
                    pthread_mutex_lock(&mutex);
                    a1 = key_to_soket(s4,0);
                    if (a1==-1) PriveMessageToDB(s2,s3,s4,s5,s6,s7); else sendtouser(ss,cl.sockno,a1,1,0);
                    pthread_mutex_unlock(&mutex);
                    if (strcmp(s6,"")!=0) wysylka = 1;
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
                ss = concat("{SIGNAL}$",s2);
                ss = concat_str_char(ss,'$');
                ss = concat(ss,s3);
                ss = concat_str_char(ss,'$');
                ss = concat(ss,s4); //KOD OPERACJI
                ss = concat_str_char(ss,'$');
                ss = concat(ss,IntToSys(a1,10)); //KOD PRZEKAZANIA DALEJ
                ss = concat_str_char(ss,'$');
                ss = concat(ss,s5);
                ss = concat_str_char(ss,'$');
                ss = concat(ss,s6);
                ss = concat_str_char(ss,'$');
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
                            ss = concat("{CHAT_USER}$",s2);
                            ss = concat_str_char(ss,'$');
                            ss = concat(ss,cl.key);
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
                        ss = concat("{CHAT_LOGOUT}$",cl.key);
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
                ss = concat("{INF1}$",s3);
                sendtouser(ss,cl.sockno,sock_user,4,1);
            } else
            if (strcmp(s1,"{READ_PYTANIA}")==0)
            {
                a1 = ReadPytania(0,cl.sockno);
                ss = concat_str_char("{READ_PYTANIA_COUNT}",'$');
                ss = concat(ss,IntToSys(a1,10));
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
                ss[strlen(ss)] = '\0';
                tmp = concat_char_str(znaczek,IntToSys(cl.sockno,10));
                tmp = concat_str_char(tmp,znaczek);
                ss = concat(tmp,ss);
                /* zaszyfrowanie odpowiedzi */
                lx = CalcBuffer(strlen(ss)+1);
                x = malloc(lx+4);
                memset(x,0,lx+4);
                x1 = &x[4];
                strncpy(x1,ss,strlen(ss));
                x1[strlen(ss)]='\0';
                lx2 = StringEncrypt(&x1,strlen(x1),IV,KEY);
                hex = StrBase(IntToSys(lx2,16),4);
                x[0] = hex[0];
                x[1] = hex[1];
                x[2] = hex[2];
                x[3] = hex[3];
                /* wysłanie wiadomości do nadawcy */
                pthread_mutex_lock(&mutex);
                send(cl.sockno,x,lx2+4,MSG_NOSIGNAL);
                pthread_mutex_unlock(&mutex);
                /* zwolnienie buforów */
                free(x);
            }

            wsk+=blok+4;
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
    }

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
    free(IV);
    free(pom);
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
    struct sockaddr_in my_addr,their_addr;
    //int my_sock;
    int their_sock;
    socklen_t their_addr_size;
    int portno;
    pthread_t sendt,recvt,udpvt;
    char msg[2048];
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
    daemonize();
    Randomize();
    server = -1;

    fdbe = FileNotExists(DB_FILE);
    error = sqlite3_open(DB_FILE,&db);
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

    for (i=0; i<2; i++)
    {
        portno = 4681+i;
        my_sock = socket(AF_INET,SOCK_STREAM,0);
        memset(my_addr.sin_zero,'\0',sizeof(my_addr.sin_zero));
        my_addr.sin_family = AF_INET;
        my_addr.sin_port = htons(portno);
        my_addr.sin_addr.s_addr = 0; //inet_addr("0.0.0.0");
        their_addr_size = sizeof(their_addr);

        if(bind(my_sock,(struct sockaddr *)&my_addr,sizeof(my_addr)) == 0) break; else
        {
            if (i==0) continue; else
            {
                perror("binding unsuccessful");
                log_message(LOG_FILE,"Zajęty port!");
                exit(1);
            }
        };
    }

    /*
    // WYMUSZENIE PONOWNEGO BINDOWANIA
    int opt = 1;
    setsockopt(my_sock,SOL_SOCKET,SO_REUSEADDR,&opt,sizeof(opt));
    */

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

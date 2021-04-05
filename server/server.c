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
#define LOCK_FILE	"/var/run/studio.jahu.lock"
#define LOG_FILE	"/disk/log/studio.jahu.log"

const int ACTIVES = 6;

struct client_info {
    int sockno;
    char ip[INET_ADDRSTRLEN];
    char key[25];
};

int my_sock;
//int their_sock;
char znaczek = 1;
int server;
int clients[10000];
char key[10000][25];
char vector[10000][17];
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
    char *s;
    s = String("Ala ma kota.");
    printf("Tekst: %s\n",s);
    return 1;
}

void log_message(char *filename, char *message)
{
    FILE *logfile;
    logfile=fopen(filename,"a");
    if(!logfile) return;
    fprintf(logfile,"%s\n",message);
    fclose(logfile);
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

bool DbKluczIsExists(char *klucz)
{
    int a = 0;
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(db,"select count(*) as ile from klucze where klucz=?",-1,&stmt,NULL)) return 1;
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

bool PytanieToDb(char *klucz, char *nick, char *pytanie)
{
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(db,"insert into pytania (czas,klucz,nick,pytanie) values (datetime('now'),?,?,?)",-1,&stmt,NULL)) return 1;
    sqlite3_bind_text(stmt,1,klucz,-1,NULL);
    sqlite3_bind_text(stmt,2,nick,-1,NULL);
    sqlite3_bind_text(stmt,3,pytanie,-1,NULL);
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
        send(sock_adresat,x,lx2+4,0);
        /* zwolnienie buforów */
        free(x);
    }
    if (aMutex) pthread_mutex_unlock(&mutex);
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
            send(clients[i],x,lx2+4,0);
	}
    }
    if (b2) {free(x); b2=0;}
    if (aMutex) pthread_mutex_unlock(&mutex);
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
            send(sock_adresat,x,lx2+4,0);
            /* zwolnienie buforów */
            free(x);
        }
    }
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
        sendtouser(s,nadawca,adresat,0,0);
        l++;
    }
    sqlite3_finalize(stmt);
    ExecSQL("delete from pytania");
    pthread_mutex_unlock(&mutex);
    return l;
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

int key_to_soket(char *klucz)
{
    int i,a = -1;
    pthread_mutex_lock(&mutex);
    for(i=0; i<n; i++)
    {
        if (strcmp(key[i],klucz)==0)
        {
            a=clients[i];
            break;
        }
    }
    pthread_mutex_unlock(&mutex);
    return a;
}

/* WĄTEK POŁĄCZENIA */
void *recvmg(void *sock)
{
    struct client_info cl = *((struct client_info *)sock);
    int e,a1,a2,a3,a4;
    char msg[2048];
    char *ss, *s, *x, *x1, *s1, *s2, *s3, *s4, *s5, *s6, *pom = malloc(5), *hex, *tmp;
    int len,l,lx,lx2;
    int id,id2,sock_user,i,j,k,wsk,blok; //UWAGA: używam id jako identa tablicy, zaś id2 jako wartość soketa!
    char *IV,*IV_NEW;
    char *KEY  = globalny_key;
    IV = malloc(17);
    strcpy(IV,globalny_vec);
    bool wysylka = 0, nook, b1, b2;
    bool isserver = 0;
    char* sql;

    if (server>-1)
    {
        ss = concat("{USERS_COUNT}$",IntToSys(n-1,10));
        sendtouser(ss,cl.sockno,server,0,1);
    }

    while((len = recv(cl.sockno,msg,65535,0)) > 0)
    {
        /* ODEBRANIE WIADOMOŚCI */
        //msg[len] = '\0';

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

            /* tworzenie odpowiedzi */
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
                ss = concat("{USERS_COUNT}$",IntToSys(n-1,10));
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
                        strcpy(key[id],s2);
                        strcpy(cl.key,s2);
                        ss=String("{KEY-OK}");
                    }
                    pthread_mutex_unlock(&mutex);
                    wysylka = 1;
                }
                InfoVersionProg(cl.sockno);
            } else
            if (strcmp(s1,"{CHAT}")==0)
            {
                /* CHAT GRUPOWY UŻYTKOWNIKÓW */
                s2 = GetLineToStr(s,2,'$',"");
                s3 = GetLineToStr(s,3,'$',"");
                s4 = GetLineToStr(s,4,'$',"");
                s5 = GetLineToStr(s,5,'$',"");
                s6 = GetLineToStr(s,6,'$',"");
                ss = concat("{CHAT}$",s2);
                ss = concat_str_char(ss,'$');
                ss = concat(ss,s3);
                ss = concat_str_char(ss,'$');
                ss = concat(ss,s4);
                ss = concat_str_char(ss,'$');
                ss = concat(ss,s5);
                ss = concat_str_char(ss,'$');
                ss = concat(ss,s6);
                sendtoall(ss,cl.sockno,1,5,0);
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
                            strncpy(niki[id],s2,strlen(s2));
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
                sock_user = key_to_soket(s2);
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
                send(cl.sockno,x,lx2+4,0);
                pthread_mutex_unlock(&mutex);
                /* zwolnienie buforów */
                free(x);
            }

            wsk+=blok+4;
        }

        /* zmiana wektora jeśli wymagane */
        if (IV_NEW) {
            strcpy(IV,IV_NEW);
            IV_NEW=0;
            pthread_mutex_lock(&mutex);
            strcpy(vector[idsock(cl.sockno)],IV);
            pthread_mutex_unlock(&mutex);
        }
    }
    if (isserver)
    {
        pthread_mutex_lock(&mutex);
        server = -1;
        pthread_mutex_unlock(&mutex);
        ss = String("{SERVER-NON-EXIST}");
        sendtoall(ss,cl.sockno,0,1,0);
    }
    if (server>-1)
    {
        ss = concat("{USERS_COUNT}$",IntToSys(n-2,10));
        sendtouser(ss,cl.sockno,server,4,1);
    }
    if (ischat)
    {
        ss = concat("{CHAT_LOGOUT}$",cl.key);
        sendtoall(ss,cl.sockno,0,5,0);
    }
    sleep(2);

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
		j++;
	    }
	}
    }
    n--;
    pthread_mutex_unlock(&mutex);
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
            sendtoall(ss,-1,1,0,0);
            sleep(1);
            close(my_sock);
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
    pthread_t sendt,recvt;
    char msg[2048];
    int len,i;
    struct client_info cl;
    char ip[INET_ADDRSTRLEN];
    bool fdbe;

    if(argc > 2)
    {
	printf("too many arguments");
	exit(1);
    }

    daemonize();
    // Rejestracja signalu i funkcji która ma się wywołac
    //signal(SIGINT,signal_handler);

    //setlocale(LC_ALL,"pl_PL.UTF-8");
    Randomize();
    server = -1;
    //if (test()==1) return 0;

    fdbe = FileNotExists(DB_FILE);
    error = sqlite3_open(DB_FILE,&db);
    if( error )
    {
        fprintf(stderr,"Can't open database: %s\n",sqlite3_errmsg(db));
        return(0);
    }

    if (fdbe)
    {
        /* zakładam strukturę bazy danych */
        if (create_db_struct()) exit(1);
    }

    portno = 4681;
    my_sock = socket(AF_INET,SOCK_STREAM,0);
    memset(my_addr.sin_zero,'\0',sizeof(my_addr.sin_zero));
    my_addr.sin_family = AF_INET;
    my_addr.sin_port = htons(portno);
    my_addr.sin_addr.s_addr = 0; //inet_addr("0.0.0.0");
    their_addr_size = sizeof(their_addr);

    if(bind(my_sock,(struct sockaddr *)&my_addr,sizeof(my_addr)) != 0)
    {
	perror("binding unsuccessful");
	exit(1);
    }

    if(listen(my_sock,5) != 0)
    {
	perror("listening unsuccessful");
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
        strcpy(cl.ip,ip);
        strcpy(cl.key,GetUuidCompress());
        strcpy(cl.key,GetUuidCompress());
	clients[n] = their_sock;
        for (i=0; i<ACTIVES; i++) actives[n][i] = 0;
        actives[n][0] = 1; //LOGIN - TO ZAWSZE JEST WŁĄCZONE!
        strcpy(key[n],cl.key);
        strcpy(vector[n],globalny_vec);
	n++;
	pthread_create(&recvt,NULL,recvmg,&cl);
	pthread_mutex_unlock(&mutex);
    }
    sqlite3_close(db);
    return 0;
}

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


/* ZDARZENIA OBSŁUGI PLIKÓW */
if (strcmp(s1,"{FILE_NEW}")==0)
{
    s2 = GetLineToStr(s,2,'$',""); //key
    s3 = GetLineToStr(s,3,'$',""); //nick
    s4 = GetLineToStr(s,4,'$',""); //nazwa
    s7 = GetLineToStr(s,5,'$',"0"); //dlugosc
    a2 = atoi(GetLineToStr(s,6,'$',"0")); //id
    max_file_buffer = atoi(GetLineToStr(s,7,'$',"1024")); //wielkosc segmentu danych (domyślnie 1024)
    s8 = GetLineToStr(s,8,'$',"0"); //opis
    s5 = FileNew(s2,s3,s4,s7);
    s6 = GetLineToStr(s5,1,'$',"");
    filename = GetLineToStr(s5,2,'$',"");
    if (strcmp(s8,"")!=0 || wsize>0) FileOpis(s2,s6,s8,wbin,wsize);
    if (factive) fclose(f);
    f=fopen(filename,"wb");
    factive = 1;
    fidx = 0;
    fidx2 = 0;
    zapis = 1;
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
        if (a1<fidx)
        {
            /* żądanie o przesłanie wcześniejszej ramki */
            fseek(f,(a1-fidx)*max_file_buffer,SEEK_CUR);
            fidx = a1;
        }
        /* zapis aktualnej ramki */
        fwrite(wbin,1,wsize,f);
        fidx++;
        if (fidx2<fidx) fidx2 = fidx;
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
    a1 = atoi(GetLineToStr(s,5,'$',"1")); //status
    if (factive) fclose(f); //dla bezpieczeństwa
    if (zapis && a1==0)
    {
        if (FileDelete(s2,s4)) ss = concat3("{FILE_DELETE_TRUE}",s2,s3);
        wysylka = 1;
    }
    factive = 0;
    zapis = 0;
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
    zapis = 0;
    ss = concat4("{FILE_STATING}",s2,s3,s4);
    ss = concat2(ss,s6); //wielkość pliku
    wysylka = 1;
} else
if (strcmp(s1,"{FILE_DOWNLOAD}")==0)
{
    s2 = GetLineToStr(s,2,'$',"");         //key
    s3 = GetLineToStr(s,3,'$',"");         //id
    s4 = GetLineToStr(s,4,'$',"");         //indeks
    a1 = atoi(GetLineToStr(s,5,'$',"-1")); //idx
    //bin = SendFile(filename2,a1,&bin_len,max_file_buffer);

    if (bin_active) free(bin);
    bin = malloc(max_file_buffer+1);
    bin_active = 1;
    if (a1!=fidx)
    {
        /* dostaję wcześniejszą lub późniejszą ramkę */
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
    pthread_mutex_lock(&mutex);
    ss = FileRequestNow(s2,s3,&bin,&bin_len);
    pthread_mutex_unlock(&mutex);
    if (bin_len>0) bin_active = 1;
    if (strcmp(ss,"")!=0) wysylka = 1;
} else
if (strcmp(s1,"{FILE_TO_PUBLIC}")==0)
{
    s2 = GetLineToStr(s,2,'$',"");        //key właściciela
    s3 = GetLineToStr(s,3,'$',"");        //id pliku w systemie właściciela
    s4 = GetLineToStr(s,4,'$',"");        //indeks pliku
    a1 = atoi(GetLineToStr(s,5,'$',"0")); //reverse operacji
    b1 = FileToPublic(s2,s4,a1);
    if (b1)
    {
        ss = concat4("{FILE_TO_PUBLIC_OK}",s2,s3,s4);
        ss = concat2(ss,IntToSys(a1,10));
        wysylka = 1;
    } else {
        ss = concat4("{FILE_TO_PUBLIC_FALSE}",s2,s3,s4);
        ss = concat2(ss,IntToSys(a1,10));
        wysylka = 1;
    }
} else
if (strcmp(s1,"{FILE_CHOWN}")==0)
{
    s2 = GetLineToStr(s,2,'$',""); //key właściciela
    s3 = GetLineToStr(s,3,'$',""); //id pliku w systemie właściciela
    s4 = GetLineToStr(s,4,'$',""); //indeks pliku
    s5 = GetLineToStr(s,5,'$',""); //key nowego właściciela pliku
    b1 = FileToOwner(s4,s2,s5);
    if (b1)
    {
        ss = concat3("{FILE_CHOWN_NOW}",s4,s5);
        pthread_mutex_lock(&mutex);
        a1 = key_to_soket(s5,0);
        sendtouser(ss,cl.sockno,a1,1,0);
        pthread_mutex_unlock(&mutex);
        wysylka = 1;
    }
} else
if (strcmp(s1,"{GET_PUBLIC}")==0)
{
    s2 = GetLineToStr(s,2,'$',""); //key właściciela
    s3 = GetLineToStr(s,3,'$',""); //czas
    a1 = atoi(GetLineToStr(s,4,'$',"")); //lp
    s4 = GetPublic(s3,a1);
    if (strcmp(s4,"")==0)
    {
        /* nie ma już nic do zwrócenia */
        s5 = IniReadStr("PublicDateTime",1);
        ss = concat3("{GET_PUBLIC_END}",s2,s5);
    } else {
        /* zwracam rekord */
        pthread_mutex_lock(&mutex);
        ss = FileRequestNow(s2,s4,&bin,&bin_len);
        pthread_mutex_unlock(&mutex);
        ss = concat2(ss,IntToSys(a1+1,10));
        if (bin_len>0) bin_active = 1;
    }
    wysylka = 1;
} else
if (strcmp(s1,"{FILE_STAT_EXIST}")==0)
{
    s2 = GetLineToStr(s,2,'$',""); //id
    s3 = GetLineToStr(s,3,'$',""); //indeks
    s4 = GetLineToStr(s,4,'$',""); //opis
    a1 = FileStatExist(s3);
    ss = concat4("{FILE_STATING_EXIST}",s2,s3,IntToSys(a1,10));
    ss = concat2(ss,s4);
    wysylka = 1;
} else

/* PODSTAWOWE ZDARZENIA */
if (strcmp(s1,"{EXIT}")==0) { TerminateNow = 1; break; } else
if (strcmp(s1,"{NTP}")==0)  { ss = concat2("{NTP}",IntToSys(TimeToInteger(),10)); wysylka = 1; } else
if (strcmp(s1,"{GET_VECTOR}")==0)
{
    pthread_mutex_lock(&mutex);
    actives[idsock(cl.sockno)][1] = 1;
    pthread_mutex_unlock(&mutex);
    IV_NEW = GenNewVector(16);
    ss = concat2("{VECTOR_IS_NEW}",IV_NEW);
    wysylka = 1;
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

/* LOGOWANIE */
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
    s3 = GetLineToStr(s,3,'$',"");
    if (strcmp(s3,"TMP")==0)
    {
        zm_tmp = 1;
    } else {
        zm_tmp = 0;
    }
    if (strcmp(s2,"")==0)
    {
        /* użytkownik bez określonego klucza - nadaję nowy klucz */
        ss = concat2("{KEY-NEW}",cl.key);
        pthread_mutex_lock(&mutex);
        if (!zm_tmp) KluczToDb(cl.key);
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

/* CZY W SIECI ZALOGOWANY JEST SERWER STUDIA? */
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

/* USTAWIENIE NOWEJ WERSJI PROGRAMU */
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

/* STUDIO */
if (strcmp(s1,"{INF1}")==0)
{
    /* jeśli przyszło z kluczem - przerabiam na starszą wersję */
    s2 = GetLineToStr(s,2,'$',""); //KEY
    s3 = GetLineToStr(s,3,'$',""); //VALUE
    sock_user = key_to_soket(s2,1);
    ss = concat2("{INF1}",s3);
    sendtouser(ss,cl.sockno,sock_user,4,1);
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
if (strcmp(s1,"{READ_PYTANIA}")==0)
{
    a1 = ReadPytania(0,cl.sockno);
    ss = concat2("{READ_PYTANIA_COUNT}",IntToSys(a1,10));
    wysylka = 1;
} else

/* ADMINISTRACYJNE - WYKONYWANE NA KOŃCU */
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
if (strcmp(s1,"{BAN}")==0)
{
    /* OPERACJE ADMINISTRACYJNE - ODPOWIEDZI */
    s2 = GetLineToStr(s,2,'$',""); //key
    ss = String("{BAN}");
    pthread_mutex_lock(&mutex);
    a1 = key_to_soket(s2,0);
    if (a1!=-1) sendtouser(ss,cl.sockno,a1,1,0);
    pthread_mutex_unlock(&mutex);
} else
if (strcmp(s1,"{PING}")==0)
{
    /* OPERACJE ADMINISTRACYJNE - ODPOWIEDZI */
    ss = String("{PONG}");
    wysylka = 1;
} else


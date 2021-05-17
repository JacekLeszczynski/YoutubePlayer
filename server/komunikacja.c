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


/* BIBLIOTEKA: libecode */

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char *Realloc(char **a, int l) {
    char *temp = malloc(l);
    memcpy(temp, *a, l);
    free(*a);
    *a = temp;
    return *a;
}

int fGetLineToStr2(const char* S, int N, char Delims, const char* wynik, char **wartosc) {
    bool cc = false;
    int w = 0;
    int i = 0;
    int l = 0;
    int len = strlen(S);
    if (*wartosc != NULL) free(*wartosc);
    *wartosc = malloc(len + 1);
    while ((i <= len) && (w != N)) {
        if (S[i] == '"') {
            cc = !cc;
        }
        if ((S[i] == Delims) && (!cc)) {
            w++;
        } else {
            if ((N - 1) == w) {
                l++;
                (*wartosc)[l - 1] = S[i];
            }
        }
        i++;
    }
    (*wartosc)[l] = '\0';
    *wartosc = Realloc(&*wartosc,l+1);
    if (strcmp(*wartosc, "") == 0) {
        *wartosc = Realloc(&*wartosc, strlen(wynik) + 1);
        strcpy(*wartosc, wynik);
    }
    return strlen(*wartosc);
}

int fGetLineToStr(char *aStr, int l, char separator, char *wynik, char **wartosc) {
  int ll = l - 1;
  char *start, *end;
  bool in_quotes = false;

  // Find start of specified element
  start = aStr;
  for (int i = 0; i < ll; i++) {
    if (*start == '"') {
      start++;
      //start = strchr(start, '"');
      while (*start != '"') {
        start++;
      }
    }
    start = strchr(start, separator);
    if (start == NULL) {
      if (*wartosc != NULL) free(*wartosc);
      *wartosc = malloc(strlen(wynik) + 1);
      strcpy(*wartosc, wynik);
      return strlen(*wartosc);
    }
    start++;
  }

  // Find end of element
  end = start;
  while (*end != '\0') {
    if (*end == '"') {
      in_quotes = !in_quotes;
    }
    if (!in_quotes && *end == separator) {
      break;
    }
    end++;
  }

  // Declare result for element string
  int r_len = end - start;
  if (*wartosc != NULL) free(*wartosc);
  *wartosc = malloc(r_len + 1);

  // Copy element string to result and add null terminator
  if (start[0] == '"') {
    memcpy(*wartosc, start + 1, r_len - 2);
    (*wartosc)[r_len - 2] = '\0';
  } else {
    memcpy(*wartosc, start, r_len);
    (*wartosc)[r_len] = '\0';
  }

  // Return element string or wynik if element is empty
  if ((*wartosc)[0] == '\0') {
      if (*wartosc != NULL) free(*wartosc);
      *wartosc = malloc(strlen(wynik) + 1);
      strcpy(*wartosc,wynik);
  }
  return strlen(*wartosc);
}


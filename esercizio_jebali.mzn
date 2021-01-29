% PARAMETRI IN INPUT

enum ESAMI;
int: S;
int: A;
int: G; 
set of int: STUDENTI = 1..S;
set of int: AULE = 1..A;
set of int: GIORNI = 1..G;
set of int: ORARI = 8..18;

array[ESAMI] of 1..4: durata; % duarata per ogni esame
array[STUDENTI,ESAMI] of int: prenotazioni; % tabella prenotazioni esami per ogni studente
array[AULE] of int: capienza; % capienza di ciascuna aula

% VARIABILI DECISIONALI

array[ESAMI] of var int: studenti_prenotati; % numero di studenti prenotati per ciascun esame
array[ESAMI] of var ORARI: start_time; % ora di inizio per ciascun esame
array[ESAMI] of var ORARI: end_time; % ora di fine per ciascun esame
array[ESAMI] of var AULE: aula_esame; % aula per ciascun esame
array[ESAMI] of var GIORNI: giorno_esame; % giorno per ciascun esame  
array[ESAMI] of var STUDENTI: studente_esame; % studente per ciascun esame 

% VINCOLI CORRETTEZZA VALORI IN INPUT
constraint assert(forall(i in STUDENTI, j in ESAMI)(prenotazioni[i,j] == 0 \/ prenotazioni[i,j] == 1),"ERROR: la prenotazione esame deve avere valore 1 oppure 0.");
constraint assert( A>0, "ERROR: nessuna aula disponibile! Controlla il numero di aule in input.");
constraint assert( G>0, "ERROR: nessun giorno disponibile! Controlla il numero di giorni in input.");
constraint assert( S>0, "ERROR: nessun studente iscritto! Controlla il numero di studenti in input.");
constraint assert(card(ESAMI)>0, "ERROR: nessun esame disponibile! Controlla l'insieme di esami in input.");

% -----VINCOLI SULLE VARIABILI DECISIONALI-----

% 1) VINCOLO SULLA CAPIENZA

constraint forall(e in ESAMI)
                  (sum(s in STUDENTI)(prenotazioni[s,e]) = studenti_prenotati[e]); % riempie il vettore studenti_prenotati
constraint forall(e in ESAMI)(studenti_prenotati[e] <= capienza[aula_esame[e]]); 

% 2) VINCOLO SUGLI STUDENTI

constraint forall(s in STUDENTI, i,j in 1..card(ESAMI) where i<j)(
                 ((prenotazioni[s,to_enum(ESAMI,i)] = 1  /\ prenotazioni[s,to_enum(ESAMI,j)]  = 1) ->
                   giorno_esame[to_enum(ESAMI,i)] != giorno_esame[to_enum(ESAMI,j)])); 
                      
% 3) VINCOLO SULL'ORARIO

constraint forall(e in ESAMI)(end_time[e] = start_time[e] + durata[e]); % riempio il vettore end_time
constraint forall(e in ESAMI)((start_time[e]>=8 /\ start_time[e] < 12 /\ end_time[e] <=12) \/ 
                              (start_time[e] >= 14 /\ start_time[e] < 18 /\ end_time[e] <= 18)
                              );
constraint forall(i,j in 1..card(ESAMI) where i < j /\ (studenti_prenotati[to_enum(ESAMI,i)]>0 /\ studenti_prenotati[to_enum(ESAMI,j)]>0))(
                                         ((end_time[to_enum(ESAMI,i)] >= start_time[to_enum(ESAMI,j)] \/ 
                                           end_time[to_enum(ESAMI,j)] >= start_time[to_enum(ESAMI,i)]) /\ 
                                           aula_esame[to_enum(ESAMI,i)] != aula_esame[to_enum(ESAMI,j)] /\
                                           giorno_esame[to_enum(ESAMI,i)] = giorno_esame[to_enum(ESAMI,j)]) \/
                                         
                                         ((end_time[to_enum(ESAMI,i)] >= start_time[to_enum(ESAMI,j)] \/ 
                                           end_time[to_enum(ESAMI,j)] >= start_time[to_enum(ESAMI,i)]) /\ 
                                           aula_esame[to_enum(ESAMI,i)] = aula_esame[to_enum(ESAMI,j)] /\
                                           giorno_esame[to_enum(ESAMI,i)] != giorno_esame[to_enum(ESAMI,j)]) \/
                                         
                                         ((end_time[to_enum(ESAMI,i)] <= start_time[to_enum(ESAMI,j)] \/ 
                                           end_time[to_enum(ESAMI,j)] <= start_time[to_enum(ESAMI,i)]) /\ 
                                           aula_esame[to_enum(ESAMI,i)] = aula_esame[to_enum(ESAMI,j)] /\
                                           giorno_esame[to_enum(ESAMI,i)] = giorno_esame[to_enum(ESAMI,j)])
                                         );
% SOLVER 

solve satisfy;

% OUTPUT FORM

output ["ESAME: \(e) | GIORNO: \(giorno_esame[e]) | AULA: \(aula_esame[e]) | ORA INIZIO: \(start_time[e]) | ORA FINE: \(end_time[e])\n" 
       | e in ESAMI where fix(studenti_prenotati[e]) > 0] ++ 
       ["ESAME: \(e): nessun studente iscritto per questo esame \n" | e in ESAMI where fix(studenti_prenotati[e]) = 0];
       
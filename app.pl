parametro(mauricio, temp, 38).

situacao(Paciente, gravissimo) :-
    parametro(Paciente, freqresp, Valor), Valor > 30;
    parametro(Paciente, pasist, Valor), Valor < 90;
    parametro(Paciente, sao2, Valor), Valor < 95;
    parametro(Paciente, dispneia, Valor), (Valor="s";Valor="S").

situacao(Paciente, grave) :-
    parametro(Paciente, temp, Valor), Valor>=39;
    parametro(Paciente, idade, Valor), Valor>=80;
    parametro(Paciente, pasist, Valor), Valor>=90,Valor=<100;
    parametro(Paciente, comorbidades, Valor), Valor>=2.

situacao(Paciente, medio) :-
    parametro(Paciente, temp, Valor), Valor=<35;
    parametro(Paciente, temp, Valor), Valor>=37, Valor=<39;
    parametro(Paciente, freqcard, Valor), Valor>=100;
    parametro(Paciente, freqresp, Valor), Valor>=19, Valor=<30;
    parametro(Paciente, idade, Valor), Valor>=60, Valor=<79;
    parametro(Paciente, comorbidades, Valor), Valor=:=1.

situacao(Paciente, leve) :-
    parametro(Paciente, temp, Valor), Valor>35, Valor<37;
    parametro(Paciente, freqcard, Valor), Valor<100;
    parametro(Paciente, freqresp, Valor), Valor=<18;
    parametro(Paciente, pasist, Valor), Valor>100;
    parametro(Paciente, sao2, Valor), Valor>=95;
    parametro(Paciente, dispneia, Valor), (Valor="n"; Valor="N");
    parametro(Paciente, idade, Valor), Valor<60;
    parametro(Paciente, comorbidades, Valor), Valor=:=0.




:- dynamic parametro/3.

covid :- carrega('covid.bd'),
    format('~n *** Estado de paciente ***~n~n'),
    repeat,
    pergunta(Nome),
    responde(Nome),
    continua(R),
    R=n,
    !,
    salva(parametro, 'covid.bd').

carrega(A) :-
    exists_file(A),
    consult(A)
    ;
    true.

pergunta(Nome) :-
    format('~nQual o nome do paciente?  '),
    gets(Nome),
    format('~nQual a temperatura?  '),
    gets(Temperatura),
    asserta(parametro(Nome, temp, Temperatura)),
    format('~nQual a frequência cardíaca?  '),
    gets(FreqCard),
    asserta(parametro(Nome, freqcard, FreqCard)),
    format('~nQual a frequência respiratória?  '),
    gets(FreqResp),
    asserta(parametro(Nome, freqresp, FreqResp)),
    format('~nQual a PA Sistólica?  '),
    gets(PaSist),
    asserta(parametro(Nome, pasist, PaSist)),
    format('~nQual a saturação?  '),
    gets(Saturacao),
    asserta(parametro(Nome, sao2, Saturacao)),
    format('~nTem dispnéia?(s/n)  '),
    gets(Dispneia),
    asserta(parametro(Nome, dispneia, Dispneia)),
    format('~nQual a idade?  '),
    gets(Idade),
    asserta(parametro(Nome, idade, Idade)),
    format('~nPossui quantas comorbidades?  '),
    gets(Comorbidades),
    asserta(parametro(Nome, comorbidades, Comorbidades)).

responde(Nome) :-
    situacao(Nome, X),
    !,
    format('~n A situação de ~w é ~w.~n', [Nome, X]).

continua(R) :-
    format('~nDeseja informar outro paciente?(s/n)'),
    get_char(R),
    get_char('\n').

gets(S) :-
    read_line_to_codes(user_input,C),
    name(S,C).

salva(P,A) :-
    tell(A),
    listing(P),
    told.
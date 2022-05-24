situacao(Paciente, gravissimo) :-
    parametro(Paciente, frequenciaRespiratoria, Valor), Valor > 30;
    parametro(Paciente, paSistolica, Valor), Valor < 90;
    parametro(Paciente, saturacao, Valor), Valor < 95;
    parametro(Paciente, dispneia, Valor), (Valor="s";Valor="S").

situacao(Paciente, grave) :-
    parametro(Paciente, temperatura, Valor), Valor>=39;
    parametro(Paciente, idade, Valor), Valor>=80;
    parametro(Paciente, paSistolica, Valor), Valor>=90,Valor=<100;
    parametro(Paciente, comorbidades, Valor), Valor>=2.

situacao(Paciente, medio) :-
    parametro(Paciente, temperatura, Valor), Valor=<35;
    parametro(Paciente, temperatura, Valor), Valor>=37, Valor=<39;
    parametro(Paciente, frequenciaCardiaca, Valor), Valor>=100;
    parametro(Paciente, frequenciaRespiratoria, Valor), Valor>=19, Valor=<30;
    parametro(Paciente, idade, Valor), Valor>=60, Valor=<79;
    parametro(Paciente, comorbidades, Valor), Valor=:=1.

situacao(Paciente, leve) :-
    parametro(Paciente, temperatura, Valor), Valor>35, Valor<37;
    parametro(Paciente, frequenciaCardiaca, Valor), Valor<100;
    parametro(Paciente, frequenciaRespiratoria, Valor), Valor=<18;
    parametro(Paciente, paSistolica, Valor), Valor>100;
    parametro(Paciente, saturacao, Valor), Valor>=95;
    parametro(Paciente, dispneia, Valor), (Valor="n"; Valor="N");
    parametro(Paciente, idade, Valor), Valor<60;
    parametro(Paciente, comorbidades, Valor), Valor=:=0.




:- dynamic parametro/3.

covid :- carrega('covid.bd'),
    format('~n ======= Laudo covid ======~n~n'),
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
    format('~nInforme o nome do paciente:  '),
    gets(Nome),
    format('~nTemperatura:  '),
    gets(Temperatura),
    asserta(parametro(Nome, temperatura, Temperatura)),
    format('~nFrequencia cardiaca:  '),
    gets(FreqCard),
    asserta(parametro(Nome, frequenciaCardiaca, FreqCard)),
    format('~nFrequencia respiratoria:  '),
    gets(FreqResp),
    asserta(parametro(Nome, frequenciaRespiratoria, FreqResp)),
    format('~nPA Sistolica:  '),
    gets(PaSist),
    asserta(parametro(Nome, paSistolica, PaSist)),
    format('~nQual a saturacao?  '),
    gets(Saturacao),
    asserta(parametro(Nome, saturacao, Saturacao)),
    format('~nTem dispneia?(s/n)  '),
    gets(Dispneia),
    asserta(parametro(Nome, dispneia, Dispneia)),
    format('~nIdade:  '),
    gets(Idade),
    asserta(parametro(Nome, idade, Idade)),
    format('~nQuantas comorbidades?  '),
    gets(Comorbidades),
    asserta(parametro(Nome, comorbidades, Comorbidades)).

responde(Nome) :-
    situacao(Nome, X),
    !,
    format('~n Situação do paciente: ~w  ~w.~n', [Nome, X]).

continua(R) :-
    format('~nFazer outro teste?(s/n)'),
    get_char(R),
    get_char('\n').

gets(S) :-
    read_line_to_codes(user_input,C),
    name(S,C).

salva(P,A) :-
    tell(A),
    listing(P),
    told.
%%%%%%%%%%%%%%%%%%%%%%%%%%
repositorio([["lab2", "Roa", "Wed Jul 30 03:53:17 2020"], [], [], [], []]).
repositorio([["lab1", "Cañoles", "Wed Jul 29 03:53:17 2020"], ["arch1","arch0"], ["arch2"], [["master","mensaje2","arch32","arch15","archXX"],["master","mensaje1","arch3","arch5"]], [["master","mensaje2","arch4"]]]).
%%%%%%%%%%%%%%%%%%%%%%%%%%


getFecha(Fecha):-get_time(X),convert_time(X,Fecha).

isListaStrings([]).
isListaStrings([Elemento|Cola]):-string(Elemento),isListaStrings(Cola).

isListaDeListasStrings([]).
isListaDeListasStrings([Elemento|Cola]):-is_list(Elemento),isListaStrings(Elemento),
    isListaDeListasStrings(Cola).

lista2InLista1(_,Lista2):-Lista2=[],!.
lista2InLista1(Lista1,Lista2):-Lista2=[Cabeza|Cola],member(Cabeza,Lista1),
    lista2InLista1(Lista1,Cola),!.

getUltimoElem([Cabeza|[]], Value):- !, Value = Cabeza.
getUltimoElem([_|Cola], Value):- getUltimoElem(Cola, Value).

invertirLista([],NewLista,NewLista).
invertirLista([Cabeza|Cola],Aux,NewLista):-
    invertirLista(Cola,[Cabeza|Aux],NewLista).

getCabeza([Cabeza|_],Cabeza).

getCola([_|Cola],Cola).

%-----TDA REPOSITORIO-----

%CONSTRUCTOR
repositorio(NombreRep,Autor,Fecha,Workspace,Index,Local,Remote,RepOutput):-
    string(NombreRep), string(Autor), string(Fecha),
    is_list(Workspace), isListaStrings(Workspace),
    is_list(Index), isListaStrings(Index),
    is_list(Local), isListaDeListasStrings(Local),
    is_list(Remote), isListaDeListasStrings(Remote),
    Info=[NombreRep,Autor,Fecha],
    RepOutput=[Info,Workspace,Index,Local,Remote].

%PERTENENCIA
isRep(RepInput):-is_list(RepInput),
    length(RepInput,5), RepInput=[InfoRep,Workspace,Index,Local,Remote],
    is_list(InfoRep), length(InfoRep,3), isListaStrings(InfoRep),
    is_list(Workspace), isListaStrings(Workspace),
    is_list(Index), isListaStrings(Index),
    is_list(Local), isListaDeListasStrings(Local),
    is_list(Remote), isListaDeListasStrings(Remote).

%SELECTORES
getInfoRep(RepInput,Info):-isRep(RepInput), RepInput=[Info|_].

getWorkspace(RepInput, Workspace):-isRep(RepInput), RepInput=[_,Workspace|_].

getIndex(RepInput, Index):-isRep(RepInput), RepInput=[_,_,Index|_].

getLocal(RepInput, Local):-isRep(RepInput), RepInput=[_,_,_,Local|_].

getRemote(RepInput, Remote):-isRep(RepInput), RepInput=[_,_,_,_,Remote|_].

getRama(RepInput, Rama):-getLocal(RepInput,Local), 
    getUltimoElem(Local,Commit),
    getCabeza(Commit,Rama).
    
%MODIFICADORES  
setWorkspace(Workspace,RepInput,RepOutput):-
    is_list(Workspace), isListaStrings(Workspace), isRep(RepInput),
    getInfoRep(RepInput, Info),
    getIndex(RepInput, Index),
    getLocal(RepInput, Local),
    getRemote(RepInput, Remote),
    RepOutput=[Info,Workspace,Index,Local,Remote].

setIndex(Index,RepInput,RepOutput):-
    is_list(Index), isListaStrings(Index), isRep(RepInput),
    getInfoRep(RepInput, Info),
    getWorkspace(RepInput, Workspace),
    getLocal(RepInput, Local),
    getRemote(RepInput, Remote),
    RepOutput=[Info,Workspace,Index,Local,Remote].

setLocal(Local,RepInput,RepOutput):-
    is_list(Local), isListaDeListasStrings(Local), isRep(RepInput),
    getInfoRep(RepInput, Info),
    getWorkspace(RepInput, Workspace),
    getIndex(RepInput, Index),
    getRemote(RepInput, Remote),
    RepOutput=[Info,Workspace,Index,Local,Remote].

setRemote(Remote,RepInput,RepOutput):-
    is_list(Remote), isListaDeListasStrings(Remote), isRep(RepInput),
    getInfoRep(RepInput, Info),
    getWorkspace(RepInput, Workspace),
    getIndex(RepInput, Index),
    getLocal(RepInput, Local),
    RepOutput=[Info,Workspace,Index,Local,Remote].

%OTRAS FUNCIONES

addCommit(Commits,Rama,Mensaje,Archivos,NewCommits):-
    append([Rama],[Mensaje],Aux),
    append(Aux,Archivos,Commit),
    append(Commits,[Commit],NewCommits).

addCommits(Commits,CommitsAux,NewCommits):-CommitsAux=[],NewCommits=Commits,!.
addCommits(Commits,CommitsAux,NewCommits):-
    getCabeza(CommitsAux,Cabeza),
    append(Commits,[Cabeza],Aux),
    getCola(CommitsAux,Cola),
    addCommits(Aux,Cola,NewCommits).


archivos2String(Archivos,Aux,String):-Archivos=[],string_concat(Aux,"\n",String),!.
archivos2String(Archivos,Aux,String):-getCabeza(Archivos,Cabeza),
    string_concat(Aux,Cabeza,Aux2),
    string_concat(Aux2,", ",Aux3),
    getCola(Archivos,Cola),
    archivos2String(Cola,Aux3,String).

commits2String(Commits,Aux,String):-Commits=[],String=Aux,!.
commits2String(Commits,Aux,String):-getCabeza(Commits,[_|Commit]),
    archivos2String(Commit,"",Aux1),
    string_concat(Aux,"\t",Aux2),
    string_concat(Aux2,Aux1,Aux3),
    getCola(Commits,Cola),
    commits2String(Cola,Aux3,String).

getArchivosRemote(Remote,Workspace,Archivos):-Remote=[],Archivos=Workspace,!.
getArchivosRemote(Remote,Workspace,Archivos):-
    getCabeza(Remote,[_,_|Cabeza]),
    append(Workspace,Cabeza,Aux),
    getCola(Remote,Cola),
    getArchivosRemote(Cola,Aux,Archivos).

ultimosCommits2String(Remote,Cant,Aux,StringCommits):-
    getUltimoElem(Remote,Commit),
    commits2String([Commit],"",String),
    string_concat(Aux,String,Aux2),
    Cant is Cant-1,
    getCola(Remote,Cola),
    ultimosCommits2String(Cola,)


%-----FIN DEL TDA-----

%FUNCIONES OBLIGATORIAS
gitInit(NombreRep,Autor,RepOutput):-
    string(NombreRep), string(Autor),
    getFecha(Fecha),
    repositorio(NombreRep,Autor,Fecha,[],[],[],[],RepOutput).

gitAdd(RepInput,ListaArchivos,RepOutput):-
    is_list(ListaArchivos), isListaStrings(ListaArchivos), isRep(RepInput),
    getWorkspace(RepInput, Workspace),
    lista2InLista1(Workspace,ListaArchivos),
    getIndex(RepInput,Index),
    append(Index,ListaArchivos,NewIndex),
    setIndex(NewIndex,RepInput,RepOutput).

gitCommit(RepInput,Mensaje,RepOutput):-
    string(Mensaje), isRep(RepInput),
    getIndex(RepInput,Index),
    not(Index=[]),
    getLocal(RepInput,Local),
    addCommit(Local,"master",Mensaje,Index,NewLocal),
    setLocal(NewLocal,RepInput,Aux),
    setIndex([],Aux,RepOutput).

gitPush(RepInput,RepOutput):-
    isRep(RepInput),
    getLocal(RepInput,Local),
    not(Local=[]),
    getRemote(RepInput,Remote),
    append(Remote,Local,Aux),
    setRemote(Aux,RepInput,Aux2),
    setLocal([],Aux2,RepOutput).

git2String(RepInput,RepAsString):-
    isRep(RepInput),
    getInfoRep(RepInput,[NombreRep,Autor,Fecha|_]),
    string_concat("###REPOSITORIO ",NombreRep,Aux),
    string_concat(Aux," ###\nAUTOR: ",Aux2),
    string_concat(Aux2,Autor,Aux3),
    string_concat(Aux3,"\nFECHA DE CREACION: ",Aux4),
    string_concat(Aux4,Fecha,Aux5),
    string_concat(Aux5,"\nRAMA ACTUAL: ",Aux6),
    getRama(RepInput, Rama),
    string_concat(Aux6, Rama, Aux7),
    string_concat(Aux7, "\nARCHIVOS EN EL WORKSPACE: \n",Aux8),
    getWorkspace(RepInput,Workspace),
    archivos2String(Workspace,"\t",Workspace2String),
    string_concat(Aux8,Workspace2String,Aux9),
    string_concat(Aux9,"ARCHIVOS EN EL INDEX: \n",Aux10),
    getIndex(RepInput,Index),
    archivos2String(Index,"\t",Index2String),
    string_concat(Aux10,Index2String,Aux11),
    string_concat(Aux11, "COMMITS EN EL LOCAL\n",Aux12),
    getLocal(RepInput,Local),
    commits2String(Local,"",Local2String),
    string_concat(Aux12,Local2String,Aux13),
    string_concat(Aux13, "COMMITS EN EL REMOTE\n",Aux14),
    getRemote(RepInput,Remote),
    commits2String(Remote,"",Remote2String),
    string_concat(Aux14,Remote2String,RepAsString).

gitPull(RepInput,RepOutput):-
    isRep(RepInput),
    getLocal(RepInput,Local),
    getRemote(RepInput,Remote),
    addCommits(Local,Remote,NewLocal),
    setLocal(NewLocal,RepInput,Aux),
    getWorkspace(RepInput,Workspace),
    getArchivosRemote(Remote,Workspace,Archivos),
    setWorkspace(Archivos,Aux,RepOutput).

gitStatus(RepInput,RepStatusStr):-
    getIndex(RepInput,Index),
    archivos2String(Index,"\t",Index2String),
    string_concat("ARCHIVOS AGREGADOS AL INDEX:\n",Index2String,Aux),
    string_concat(Aux,"CANTIDAD DE COMMITS EN EL LOCAL REPOSITORY:\n",Aux2),
    getLocal(RepInput,Local),
    length(Local,CantCommits),
    string_concat(Aux2,CantCommits,Aux3),
    string_concat(Aux3,"\nRAMA ACTUAL:\n",Aux4),
    getRama(RepInput,Rama),
    string_concat(Aux4,Rama,RepStatusStr).

gitLog(_,RepLogStr):-RepLogStr="REALICE COMO MINIMO 5 COMMITS Y VUELVA A INTENTARLO",!.
gitLog(RepInput,RepLogStr):-
    isRep(RepInput),
    getRemote(RepInput,Remote),
    length(Remote, CantCommits),
    CantCommits>4,
    invertirLista(Remote,[],NewRemote)
    ultimosCommits2String(NewRemote,5,StringCommits),
    string_concat("LOS ULTIMOS 5 COMMITS SON:\n",StringCommits,RepLogStr).








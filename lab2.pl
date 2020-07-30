%%%%%%%%%%%%%%%%%%%%%%%%%%
repositorio([["lab2", "Roa", "Wed Jul 30 03:53:17 2020"], [], [], [], []]).
repositorio([["lab1", "Cañoles", "Wed Jul 29 03:53:17 2020"], ["arch1","arch0"], ["arch2"], [["master","mensaje1","arch3","arch5"]], [["master","mensaje2","arch4"]]]).
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
addCommits(Commits,Rama,Mensaje,Archivos,NewCommits):-
    append([Rama],[Mensaje],Aux),
    append(Aux,Archivos,Commit),
    append(Commits,[Commit],NewCommits).


archivos2String(Archivos,Aux,String):-Archivos=[],String=Aux,!.
archivos2String(Archivos,Aux,String):-getCabeza(Archivos,Cabeza),
    string_concat(Aux,Cabeza,Aux2),
    string_concat(Aux2,"\n",Aux3),
    getCola(Archivos,Cola),
    archivos2String(Cola,Aux3,String).



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
    addCommits(Local,"master",Mensaje,Index,NewLocal),
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

git2String(RepInput,RepoAsString):-
    isRep(RepInput),
    getInfoRep(RepInput,[NombreRep,Autor,Fecha|_]),
    string_concat("###REPOSITORIO ",NombreRep,Aux),
    string_concat(Aux," ###\nAutor: ",Aux2),
    string_concat(Aux2,Autor,Aux3),
    string_concat(Aux3,"\nFecha de creacion: ",Aux4),
    string_concat(Aux4,Fecha,Aux5),
    string_concat(Aux5,"\nRama actual: ",Aux6),
    getRama(RepInput, Rama),
    string_concat(Aux6, Rama, Aux7),
    string_concat(Aux7, "\nArchivos en workspace: \n",Aux8),
    getWorkspace(RepInput,Workspace),
    archivos2String(Workspace,"",Workspace2String),
    string_concat(Aux8,Workspace2String,Aux9),
    string_concat(Aux9,"\nArchivos en el index: \n",Aux10),
    getIndex(RepInput,Index),
    archivos2String(Index,"",Index2String),
    string_concat(Aux10,Index2String,RepoAsString).








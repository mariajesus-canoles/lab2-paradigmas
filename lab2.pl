%Programa que realizaba una simulacion del software Git con el lenguaje de
%programacion Prolog, el cual se rige por el paradigma logico
%Autora: Maria Jesus Cañoles Roa

%%%%%%%%%%%%%%%%%%%%%%%%%%
repositorio([["lab2", "Roa", "Wed Jul 30 03:53:17 2020"], [], [], [], []]).
repositorio([["lab1", "Cañoles", "Wed Jul 29 03:53:17 2020"], ["arch1","arch0"], ["arch2"], [["master","mensaje2","arch32","arch15","archXX"],["master","mensaje1","arch3","arch5"]], [["master","mensaje2","arch4"]]]).
%%%%%%%%%%%%%%%%%%%%%%%%%%

%Dominio:   Fecha=Atomo
%Predicado: getFecha(Fecha)
%Meta:      Secundaria
%objetivo:  Obtiene la fecha/hora actual
getFecha(Fecha):-get_time(X),convert_time(X,Fecha).

%Dominio:   Lista=Lista
%Predicado: isListaString(Lista)
%Meta:      Secundaria
%objetivo:  Comprueba si todos los elementos de una lista son strings
isListaStrings([]).
isListaStrings([Elemento|Cola]):-string(Elemento),isListaStrings(Cola).

%Dominio:   Lista=Lista
%Predicado: isListadeListasStrings(Lista)
%Meta:      Secundaria
%objetivo:  Comprueba si todos los elementos de una lista son listas que 
%           contienen strings
isListaDeListasStrings([]).
isListaDeListasStrings([Elemento|Cola]):-is_list(Elemento),isListaStrings(Elemento),
    isListaDeListasStrings(Cola).

%Dominio:   Lista=Lista
%Predicado: lista2InLista1(Lista,Lista)
%Meta:      Secundaria
%objetivo:  Comprueba si todos los elementos de una lista se encuentran
%           contenidos en otra lista
lista2InLista1(_,Lista2):-Lista2=[],!.
lista2InLista1(Lista1,Lista2):-Lista2=[Cabeza|Cola],member(Cabeza,Lista1),
    lista2InLista1(Lista1,Cola),!.

%Dominio:   Lista=Lista, Elemento=Atomo
%Predicado: getUltimoElem(Lista,Elemento)
%Meta:      Secundaria
%objetivo:  Obtiene el ultimo elemento de una lista
getUltimoElem([Cabeza|[]], Elemento):- !, Elemento = Cabeza.
getUltimoElem([_|Cola], Elemento):- getUltimoElem(Cola, Elemento).

%Dominio:   Lista=Lista
%Predicado: invertirLista(Lista,Lista,Lista)
%Meta:      Secundaria
%objetivo:  Invierte los elementos de una lista
invertirLista([],NewLista,NewLista).
invertirLista([Cabeza|Cola],Aux,NewLista):-
    invertirLista(Cola,[Cabeza|Aux],NewLista).

%Dominio:   Lista=Lista, Cabeza=Atomo
%Predicado: getCabeza(Lista,Cabeza)
%Meta:      Secundaria
%objetivo:  Obtiene la cabeza de una lista
getCabeza([Cabeza|_],Cabeza).

%Dominio:   Lista=Lista, Cola=Atomo
%Predicado: getCola(Lista,Cola)
%Meta:      Secundaria
%objetivo:  Obtiene la cola de una lista
getCola([_|Cola],Cola).

%-----TDA REPOSITORIO-----

%CONSTRUCTOR

%Dominio:   NombreRepositorio,Autor,Fecha=Atomo, Workspace,Index,Local,Remote,Repositorio=Lista
%Predicado: repositorio(NombreRepositorio,Autor,Fecha,Workspace,Index,Local, Remote,Repositorio)
%Meta:      Secundaria
%objetivo: Crea un repositorio con la informacion entregada
repositorio(NombreRep,Autor,Fecha,Workspace,Index,Local,Remote,RepOutput):-
    string(NombreRep), string(Autor), string(Fecha),
    is_list(Workspace), isListaStrings(Workspace),
    is_list(Index), isListaStrings(Index),
    is_list(Local), isListaDeListasStrings(Local),
    is_list(Remote), isListaDeListasStrings(Remote),
    Info=[NombreRep,Autor,Fecha],
    RepOutput=[Info,Workspace,Index,Local,Remote].

%PERTENENCIA

%Dominio:   Repositorio=Lista
%Predicado: isRep(Repositorio)
%Meta:      Secundaria
%objetivo:  Comprueba si un repositorio contiene todos los elementos para 
%           considerarse como tal
isRep(RepInput):-is_list(RepInput),
    length(RepInput,5), RepInput=[InfoRep,Workspace,Index,Local,Remote],
    is_list(InfoRep), length(InfoRep,3), isListaStrings(InfoRep),
    is_list(Workspace), isListaStrings(Workspace),
    is_list(Index), isListaStrings(Index),
    is_list(Local), isListaDeListasStrings(Local),
    is_list(Remote), isListaDeListasStrings(Remote).

%SELECTORES

%Dominio:   Repositorio,Informacion=Lista
%Predicado: getInfoRep(Repositorio,Informacion)
%Meta:      Secundaria
%objetivo:  Obtiene la informacion de un repositorio
getInfoRep(RepInput,Info):-isRep(RepInput), RepInput=[Info|_].

%Dominio:   Repositorio,Workspace=Lista
%Predicado: getWorkspace(Repositorio,Workspace)
%Meta:      Secundaria
%objetivo:  Obtiene la informacion almacenada en la zona de trabajo Workspace
getWorkspace(RepInput, Workspace):-isRep(RepInput), RepInput=[_,Workspace|_].

%Dominio:   Repositorio,Index=Lista
%Predicado: getIndex(Repositorio,Index)
%Meta:      Secundaria
%objetivo:  Obtiene la informacion almacenada en la zona de trabajo Index
getIndex(RepInput, Index):-isRep(RepInput), RepInput=[_,_,Index|_].

%Dominio:   Repositorio,Local = Lista
%Predicado: getLocal(Repositorio,Local)
%Meta:      Secundaria
%objetivo:  Obtiene la informacion almacenada en la zona de trabajo Local
getLocal(RepInput, Local):-isRep(RepInput), RepInput=[_,_,_,Local|_].

%Dominio:   Repositorio,Remote = Lista
%Predicado: getRemote(Repositorio,Remote)
%Meta:      Secundaria
%objetivo:  Obtiene la informacion almacenada en la zona de trabajo Remote
getRemote(RepInput, Remote):-isRep(RepInput), RepInput=[_,_,_,_,Remote|_].

%Dominio:   Repositorio=Lista, Rama=Atomo
%Predicado: getRama(Repositorio,Rama)
%Meta:      Secundaria
%objetivo:  Obtiene la rama en la cual se esta trabajando en un repositorio
getRama(RepInput, Rama):-getLocal(RepInput,Local), 
    getUltimoElem(Local,Commit),
    getCabeza(Commit,Rama).
    
%MODIFICADORES  

%Dominio:   Workspace,Repositorio=Lista
%Predicado: setWorkspace(Workspace,Repositorio,Repositorio)
%Meta:      Secundaria
%objetivo:  Modifica el contenido de la zona de trabajo Workspace en un repositorio
setWorkspace(Workspace,RepInput,RepOutput):-
    is_list(Workspace), isListaStrings(Workspace), isRep(RepInput),
    getInfoRep(RepInput, Info),
    getIndex(RepInput, Index),
    getLocal(RepInput, Local),
    getRemote(RepInput, Remote),
    RepOutput=[Info,Workspace,Index,Local,Remote].

%Dominio:   Index,Repositorio=Lista
%Predicado: setIndex(Index,Repositorio,Repositorio)
%Meta:      Secundaria
%objetivo:  Modifica el contenido de la zona de trabajo Index en un repositorio
setIndex(Index,RepInput,RepOutput):-
    is_list(Index), isListaStrings(Index), isRep(RepInput),
    getInfoRep(RepInput, Info),
    getWorkspace(RepInput, Workspace),
    getLocal(RepInput, Local),
    getRemote(RepInput, Remote),
    RepOutput=[Info,Workspace,Index,Local,Remote].

%Dominio:   Local,Repositorio=Lista
%Predicado: setLocal(Local,Repositorio,Repositorio)
%Meta:      Secundaria
%objetivo:  Modifica el contenido de la zona de trabajo Local en un repositorio
setLocal(Local,RepInput,RepOutput):-
    is_list(Local), isListaDeListasStrings(Local), isRep(RepInput),
    getInfoRep(RepInput, Info),
    getWorkspace(RepInput, Workspace),
    getIndex(RepInput, Index),
    getRemote(RepInput, Remote),
    RepOutput=[Info,Workspace,Index,Local,Remote].

%Dominio:   Remote,Repositorio=Lista
%Predicado: setRemote(Remote,Repositorio,Repositorio)
%Meta:      Secundaria
%objetivo:  Modifica el contenido de la zona de trabajo Remote en un repositorio
setRemote(Remote,RepInput,RepOutput):-
    is_list(Remote), isListaDeListasStrings(Remote), isRep(RepInput),
    getInfoRep(RepInput, Info),
    getWorkspace(RepInput, Workspace),
    getIndex(RepInput, Index),
    getLocal(RepInput, Local),
    RepOutput=[Info,Workspace,Index,Local,Remote].

%OTRAS FUNCIONES

%Dominio:   Commits,Archivos,NewCommits=Lista, Rama,Mensaje=Atomo
%Predicado: addCommit(Commits,Rama,Mensaje,Archivos,NewCommits)
%Meta:      Secundaria
%objetivo:  Crea un commit a partir de una rama, mensaje descriptivo y archivos
%           seleccionados
addCommit(Commits,Rama,Mensaje,Archivos,NewCommits):-
    append([Rama],[Mensaje],Aux),
    append(Aux,Archivos,Commit),
    append(Commits,[Commit],NewCommits).

%Dominio:   Commits,CommitsAux,NewCommits=Lista
%Predicado: addCommits(Commits,CommitsAux,NewCommits)
%Meta:      Secundaria
%objetivo:  Agrega los commits almacenados en nueva variable de forma ordenada
addCommits(Commits,CommitsAux,NewCommits):-CommitsAux=[],NewCommits=Commits,!.
addCommits(Commits,CommitsAux,NewCommits):-
    getCabeza(CommitsAux,Cabeza),
    append(Commits,[Cabeza],Aux),
    getCola(CommitsAux,Cola),
    addCommits(Aux,Cola,NewCommits).

%Dominio:   Archivos=Lista,AuxContenido,Contenido=Atomo
%Predicado: archivos2String(Archivos,,AuxContenido,Contenido)
%Meta:      Secundaria
%objetivo:  Crea un string con los archivos almacenados
archivos2String(Archivos,Aux,String):-Archivos=[],string_concat(Aux,"\n",String),!.
archivos2String(Archivos,Aux,String):-getCabeza(Archivos,Cabeza),
    string_concat(Aux,Cabeza,Aux2),
    string_concat(Aux2,", ",Aux3),
    getCola(Archivos,Cola),
    archivos2String(Cola,Aux3,String).

%Dominio:   Commits=Lista,AuxContenido,Contenido=Atomo
%Predicado: commits2String(Commits,AuxContenido,Contenido)
%Meta:      Secundaria
%objetivo:  Crea un string con los commits almacenados
commits2String(Commits,Aux,String):-Commits=[],String=Aux,!.
commits2String(Commits,Aux,String):-getCabeza(Commits,[_|Commit]),
    archivos2String(Commit,"",Aux1),
    string_concat(Aux,"\t",Aux2),
    string_concat(Aux2,Aux1,Aux3),
    getCola(Commits,Cola),
    commits2String(Cola,Aux3,String).

%Dominio:   Remote,Workspace,Archivos=Lista
%Predicado: getArchivosRemote(Remote,Workspace,Archivos)
%Meta:      Secundaria
%objetivo:  Selecciona los archivos contenidos en el Remote Repository
getArchivosRemote(Remote,Workspace,Archivos):-Remote=[],Archivos=Workspace,!.
getArchivosRemote(Remote,Workspace,Archivos):-
    getCabeza(Remote,[_,_|Cabeza]),
    append(Workspace,Cabeza,Aux),
    getCola(Remote,Cola),
    getArchivosRemote(Cola,Aux,Archivos).

%Dominio:   Commits=Lista, CantCommits=Numero, AuxContenido,Contenido=Atomo
%Predicado: ultimosCommits2String(Commits,CantCommits,AuxContenido,Contenido)
%Meta:      Secundaria
%objetivo:  Crea un string con los ultimos 'n' commits
ultimosCommits2String(_,0,Aux,StringCommits):-StringCommits=Aux,!.
ultimosCommits2String([Commit|Cola],Cant,Aux,StringCommits):-
    commits2String([Commit],"",String),
    string_concat(Aux,String,Aux2),
    CantAux is Cant-1,
    ultimosCommits2String(Cola,CantAux,Aux2,StringCommits).


%-----FIN DEL TDA-----

%FUNCIONES OBLIGATORIAS

%Dominio:   NombreRepositorio,Autor=Atomo, Repositorio=Lista
%Predicado: gitInit(NombreRepositorio,Autor,Repositorio)
%Meta:      Primaria
%objetivo:  Inicializa un repositorio con sus zonas de trabajo vacias y con 
%           informacion tal como el nombre del repositorio, el autor y la fecha/hora
gitInit(NombreRep,Autor,RepOutput):-
    string(NombreRep), string(Autor),
    getFecha(Fecha),
    repositorio(NombreRep,Autor,Fecha,[],[],[],[],RepOutput).

%Dominio:   Repositorio,Archivos=Lista
%Predicado: gitAdd(Repositorio,Archivos,Repositorio)
%Meta:      Primaria
%objetivo:  Agrega los cambios almacenados en el Workspace al Index
gitAdd(RepInput,ListaArchivos,RepOutput):-
    is_list(ListaArchivos), isListaStrings(ListaArchivos), isRep(RepInput),
    getWorkspace(RepInput, Workspace),
    lista2InLista1(Workspace,ListaArchivos),
    getIndex(RepInput,Index),
    append(Index,ListaArchivos,NewIndex),
    setIndex(NewIndex,RepInput,RepOutput).

%Dominio:   Repositorio=Lista, Mensaje=Atomo
%Predicado: gitCommit(Repositorio,Mensaje,Repositorio)
%Meta:      Primaria
%objetivo:  Crea un commit con los archivos almacenados en el Index y a partir
%           de un mensaje descriptivo y la rama en la cual se trabaja
gitCommit(RepInput,Mensaje,RepOutput):-
    string(Mensaje), isRep(RepInput),
    getIndex(RepInput,Index),
    not(Index=[]),
    getLocal(RepInput,Local),
    addCommit(Local,"master",Mensaje,Index,NewLocal),
    setLocal(NewLocal,RepInput,Aux),
    setIndex([],Aux,RepOutput).

%Dominio:   Repositorio=Lista
%Predicado: gitPush(Repositorio,Repositorio)
%Meta:      Primaria
%objetivo:  Envia los commits almacenados en el Local al Remote Repository
gitPush(RepInput,RepOutput):-
    isRep(RepInput),
    getLocal(RepInput,Local),
    not(Local=[]),
    getRemote(RepInput,Remote),
    append(Remote,Local,Aux),
    setRemote(Aux,RepInput,Aux2),
    setLocal([],Aux2,RepOutput).

%Dominio:   Repositorio=Lista, Contenido=Atomo
%Predicado: git2String(Repositorio,Contenido)
%Meta:      Primaria
%objetivo:  Crea un string con el contenido de las zonas de trabajo de
%           un repositorio y la información de este
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

%Dominio:   Repositorio=Lista
%Predicado: gitPull(Repositorio,Repositorio)
%Meta:      Primaria
%objetivo:  Copia los commits del Remote al Local Repository y copia los archivos
%           contenidos en el Remote al Workspace
gitPull(RepInput,RepOutput):-
    isRep(RepInput),
    getLocal(RepInput,Local),
    getRemote(RepInput,Remote),
    addCommits(Local,Remote,NewLocal),
    setLocal(NewLocal,RepInput,Aux),
    getWorkspace(RepInput,Workspace),
    getArchivosRemote(Remote,Workspace,Archivos),
    setWorkspace(Archivos,Aux,RepOutput).

%Dominio:   Repositorio=Lista, Contenido=Atomo
%Predicado: gitStatus(Repositorio, Contenido)
%Meta:      Primaria
%objetivo:  Crea un string con la infromacion de un repositorio
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

%Dominio:   Repositorio=Lista, Contenido=Atomo
%Predicado: gitLog(Repositorio, Contenido)
%Meta:      Primaria
%objetivo:  Crea un string con los ultimos 5 commits agregados
gitLog(RepInput,RepLogStr):-
    isRep(RepInput),
    getRemote(RepInput,Remote),
    length(Remote, CantCommits),
    CantCommits>4,
    invertirLista(Remote,[],NewRemote),!,
    ultimosCommits2String(NewRemote,5,"",StringCommits),
    string_concat("LOS ULTIMOS 5 COMMITS SON:\n",StringCommits,RepLogStr).
gitLog(_,RepLogStr):-RepLogStr="REALICE COMO MINIMO 5 COMMITS Y VUELVA A INTENTARLO",!.

%Dominio:   Repositorio=Lista, Rama=Atomo
%Predicado: gitBranch(Repositorio,Rama,Repositorio)
%Meta:      Primaria
%objetivo:  Crea una nueva rama con el historial del ultimo commit
gitBranch(RepInput,NewRama,RepOutput):-
    isRep(RepInput), string(NewRama),
    getRemote(RepInput,Remote),
    invertirLista(Remote,[],Aux),
    getCabeza(Aux,Commit),
    getCola(Commit,ColaCommit),
    getCola(Aux,ColaCommits),
    append([NewRama],ColaCommit,NewCommit),
    append([NewCommit],ColaCommits,Aux2),
    invertirLista(Aux2,[],NewRemote),
    setRemote(NewRemote,RepInput,RepOutput).

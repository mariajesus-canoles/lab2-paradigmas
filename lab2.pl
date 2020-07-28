getFecha(Fecha):-get_time(X),convert_time(X,Fecha).

%-----TDA REPOSITORIO-----
%CONSTRUCTOR
repositorio(NombreRep,Autor,Fecha,Workspace,Index,Local,Remote,RepoOutput):-
    Info=[NombreRep,Autor,Fecha],
    RepoOutput=[Info,Workspace,Index,Local,Remote],!.

%PERTENENCIA
isListaStrings([]).
isListaStrings([Elemento|Cola]):-string(Elemento),isListaStrings(Cola).

isCommits([]).
isCommits([Elemento|Cola]):-is_list(Elemento),
    isListaStrings(Elemento),
    isCommits(Cola).

isRep(RepInput):-is_list(RepInput),
    length(RepInput,5),
    RepInput=[InfoRep,Workspace,Index,Local,Remote],
    is_list(InfoRep),
    length(InfoRep,3),
    isListaStrings(InfoRep),
    is_list(Workspace),
    isListaStrings(Workspace),
    is_list(Index),
    isListaStrings(Index),
    is_list(Local),
    isCommits(Local),
    is_list(Remote),
    isCommits(Remote).


%SELECTORES
getInfoRep([Info|_],Info).

    
%MODIFICADORES
setNombreRep(NombreRep,RepInput,RepoOutput):-
    getAutorRep(RepInput,AutorRep),
    getFechaRep(RepInput,FechaRep),
    getWorkspace(RepInput,Workspace),
    getIndex(RepInput,Index),
    getLocal(RepInput,Local),
    getRemote(RepInput,Remote),
    RepoOutput=[[NombreRep,AutorRep,FechaRep],Workspace,Index,Local,Remote].

%FUNCIONES OBLIGATORIAS
gitInit(NombreRep,Autor,RepoOutput):-
    getFecha(Fecha),
    repositorio(NombreRep,Autor,Fecha,[],[],[],[],RepoOutput).
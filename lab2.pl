getFecha(Fecha):-get_time(X),convert_time(X,Fecha).

%-----TDA REPOSITORIO-----
%CONSTRUCTOR
repositorio(NombreRep,Autor,Fecha,Workspace,Index,Local,Remote,RepoOut):-
    Info=[NombreRep,Autor,Fecha],
    RepoOut=[Info,Workspace,Index,Local,Remote],!.

%PERTENENCIA
%SELECTORES
%getNombreRep(RepInput,NombreRep):-
    
%MODIFICADORES

%FUNCIONES OBLIGATORIAS
gitInit(NombreRep,Autor,RepoOut):-
    getFecha(Fecha),
    repositorio(NombreRep,Autor,Fecha,[],[],[],[],RepoOut).
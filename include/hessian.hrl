-define(M, 2).
-define(m, 0).

-define(CHUNK_SIZE, 1024).

-define(MegaSeconds, 1000000000).
-define(Seconds, 1000).
-define(MicroSeconds, 1000).
-define(UnixEpoch, 62167219200).

%% Equivalents: type_def and class
-record(type_def,{native_type, foreign_type, fieldnames}). 
-record(class, {typeNo=-1, encoded=false, name=[], fields=[]}).

-record(list, {refNo=-1, len=-1, type=untyped, values=[]}).
-record(map, {refNo=-1, type=untyped, dict=dict:new()}).
-record(object, {refNo=-1, typeRef=-1, class=auto, values=[]}).

-record(set, {ref=-1, value=[]}).

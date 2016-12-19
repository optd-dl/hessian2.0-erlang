#Hessian 2.0 Library for Erlang
*******************************

##DESCRIPTION
-------------
**This is a Hessian 2.0 implementation for the Erlang programming language.**

###Base protocol:
* [Hessian 2.0 Serialization Protocol](http://hessian.caucho.com/doc/hessian-serialization.html "Serialization")
* [Hessian 2.0 Web Services Protocol](http://hessian.caucho.com/doc/hessian-ws.html "Web Services")

###Base source code:
* [Cotton](http://cotton.sourceforge.net/ "Cotton code")

###Motive of creating this library by basing [Cotton](http://cotton.sourceforge.net/):
* [Cotton](http://cotton.sourceforge.net/) is not the newest Hessian 2.0; actually, it realized the obsolete Hessian 2.0
* [Cotton](http://cotton.sourceforge.net/) does not support UTF-8 characters(e.g. Chinese)

###Author:
* **RongCapital(DaLian) information service Ltd.**

###Contact us:
* [gaoliang@rongcapital.cn](mailto:gaoliang@rongcapital.cn)
* [jinxin@rongcapital.cn](mailto:jinxin@rongcapital.cn)

##Hessian 2.0 vs Erlang
-----------------------
```
Hessian    ----->       Erlang
null       ----->       undefined | null(EN)
binary     ----->       {binary, Bin}(EN) | binary(DE)
boolean    ----->       boolean
class-def  ----->       #class{}(EN) | #type_def{}
date       ----->       {date, {MegaSecs, Secs, MicroSecs}}(EN) |
                        {date, MilliSecs}(EN) |
                        {MegaSecs, Secs, MicroSecs}(DE)
double     ----->       float
int        ----->       integer
list       ----->       #list{}
long       ----->       integer
map        ----->       #map{}
object     ----->       #object{}
ref        ----->       {ref, Index}
string     ----->       string(EN) | binary
type       ----->       string | integer
```
* `EN`: *encode only*
* `DE`: *decode only*

##Build the library
-------------------
$ `make`

##Run Encode
------------
***Refer to:***  
[test/testEncode.erl](https://github.com/optd-dl/hessian2.0-erlang/blob/master/test/testEncode.erl "testEncode.erl")  
***e.g. encode object***
```erlang
%---------------------------------------------------------------------------
% example.testcalss{ 
% 	string fieldname="name";
% 	int count=10;
% }
%---------------------------------------------------------------------------
Class = #class{name="example.testcalss",
               fields=["fieldname", "count"]},
Object = #object{class="example.testcalss",
                 values=["name", 10]},
{Bin,_} = hessianEncode:encode({Class,Object},[]).
```

##Run Decode
------------
```erlang
true = is_binary(DecodedBin), hessianDecode:decode(DecodedBin, hessianDecode:init()).
```

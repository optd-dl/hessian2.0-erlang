%% @author liang
%% @doc @todo Add description to testEncodeList.

-module(testEncode).

-include("hessian.hrl").

%% ====================================================================
%% API functions
%% ====================================================================
-export([test_all/0]).

test_all() ->
	test_objects_in_list(),
	test_objects_in_list_2(),
	test_objects_in_list_3(),
	test_objects_in_list_4(),
	test_objects_in_map(),
	test_objects_in_map_2(),
	test_objects_in_map_3(),
	test_list_with_type_ref(),
	test_binary(),
	test_date(),
	test_int(),
	test_int_2(),
	test_long(),
	test_long_2(),
	test_long_3(),
	test_long_4(),
	test_double(),
	test_boolean(),
	test_null(),
	test_string(),
	test_string_2(),
	test_call(),
	all_ok.

%% ====================================================================
%% Internal functions
%% ====================================================================
%---------------------------------------------------------------------------
% Test Class, Object, Ref and List
% 0x72 20 java.util.LinkedList 
% C 18 example.BasicClass 0x94 1 a 1 b 1 c 1 l 0x60 2 a1 2 b1 Q 0x91 Q 0x90 
% C 19 example.BasicClass2 0x95 1 a 1 b 2 c2 1 c 1 l 0x61 2 a2 2 b2 Q 0x92 Q 0x91 Q 0x90
%---------------------------------------------------------------------------
test_objects_in_list() ->
	FieldsH = ["a","b"],
	FieldsE = ["c","l"],
	C1 = #class{name="example.BasicClass", fields=FieldsH++FieldsE},
	RefBase = [{ref,1},{ref,0}],
	Values1 = ["a1","b1"|RefBase],
	O1 = #object{values=Values1},
	C2 = #class{name="example.BasicClass2", fields=FieldsH++["c2"]++FieldsE},
	Values2 = ["a2","b2",{ref,2}|RefBase],
	O2 = #object{class=C2,values=Values2},
	List = #list{len=2,type="java.util.LinkedList",values=[C1,O1,C2,O2]},%{list, 2, "java.util.LinkedList", [C1,O1,C2,O2]},
	{R,_State} = hessianEncode:encode(List, []),
	Expected = <<114,20,106,97,118,97,46,117,116,105,108,46,76,105,110,107,
				 101,100,76,105,115,116,67,18,101,120,97,109,112,108,101,46,66,97,
				 115,105,99,67,108,97,115,115,148,1,97,1,98,1,99,1,108,96,2,97,49,2,
				 98,49,81,145,81,144,67,19,101,120,97,109,112,108,101,46,66,97,115,
				 105,99,67,108,97,115,115,50,149,1,97,1,98,2,99,50,1,99,1,108,97,2,
				 97,50,2,98,50,81,146,81,145,81,144>>,
	Expected = R.

test_objects_in_list_2() ->
	Params = <<72,2,0,82,114,20,106,97,118,97,46,117,116,105,108,46,76,105,110,107,101,100,76,105,115,116,67,18,101,120,97,109,112,108,101,46,66,97,115,105,99,67,108,97,115,115,148,1,97,1,98,1,99,1,108,96,2,97,49,2,98,49,81,145,81,144,67,19,101,120,97,109,112,108,101,46,66,97,115,105,99,67,108,97,115,115,50,149,1,97,1,98,2,99,50,1,99,1,108,97,2,97,50,2,98,50,81,146,81,145,81,144>>,
	{List, ClassList} = hessianDecode:decode(Params, type_decoding:init()),
	{EncodeBin, _State} = hessianEncode:encode_for_decode(List, ClassList),
	{List2, ClassList2} = hessianDecode:decode(<<72,2,0,82,EncodeBin/binary>>, type_decoding:init()),
	List = List2,
	ClassList = ClassList2.

test_objects_in_list_3() ->
	Params = <<72,2,0,82,114,20,106,97,118,97,46,117,116,105,108,46,76,105,110,107,101,100,76,105,115,116,67,18,101,120,97,109,112,108,101,46,66,97,115,105,99,67,108,97,115,115,148,1,97,1,98,1,99,1,108,96,2,97,49,2,98,49,81,145,81,144,67,19,101,120,97,109,112,108,101,46,66,97,115,105,99,67,108,97,115,115,50,149,1,97,1,98,2,99,50,1,99,1,108,97,2,97,50,2,98,50,81,146,81,145,81,144>>,
	{List, ClassList} = hessianDecode:decode(Params, type_decoding:init()),
	{return,<<"a1">>} = hessianEncode:get_value(List, 1, "a", ClassList),
	NewObj1 = #object{refNo=1,typeRef=0,values=["a@class1","b@class2",{ref,1},{ref,0}]},
	{EncodeBin, _State} = hessianEncode:encode_for_decode(List, [{set,[#set{ref=1,value=NewObj1}]},ClassList]),
	{List2, ClassList2} = hessianDecode:decode(<<72,2,0,82,EncodeBin/binary>>, type_decoding:init()),
	{return,<<"a@class1">>} = hessianEncode:get_value(List2, 1, "a", ClassList2).
	
test_objects_in_list_4() ->
	Params = <<72,2,0,82,114,20,106,97,118,97,46,117,116,105,108,46,76,105,110,107,101,100,76,105,115,116,67,18,101,120,97,109,112,108,101,46,66,97,115,105,99,67,108,97,115,115,148,1,97,1,98,1,99,1,108,96,2,97,49,2,98,49,81,145,81,144,67,19,101,120,97,109,112,108,101,46,66,97,115,105,99,67,108,97,115,115,50,149,1,97,1,98,2,99,50,1,99,1,108,97,2,97,50,2,98,50,81,146,81,145,81,144>>,
	{List, ClassList} = hessianDecode:decode(Params, type_decoding:init()),
	{return,<<"a1">>} = hessianEncode:get_value(List, 1, "a", ClassList),
	NewObj1 = #object{refNo=1,typeRef=0,values=["a@class1","b@class2",{ref,1},{ref,0}]},
	{EncodeBin, _State} = hessianEncode:encode_for_decode(List, [{set,[#set{ref="example.BasicClass",value=NewObj1}]},ClassList]),
	{List2, ClassList2} = hessianDecode:decode(<<72,2,0,82,EncodeBin/binary>>, type_decoding:init()),
	{return,<<"a@class1">>} = hessianEncode:get_value(List2, 1, "a", ClassList2).

%---------------------------------------------------------------------------
% Test Class, Object, Ref and Map
% H 2 c2 C 19 example.BasicClass2 0x95 1 a 1 b 2 c2 1 c 1 m 0x60 2 a2 2 b2 Q 0x91
% C 18 example.BasicClass 0x94 1 a 1 b 1 c 1 m 0x61 2 a1 2 b1 Q 0x92 Q 0x90 Q 0x90
% 1 c Q 0x92 2 c3 0x61 2 a3 2 b3 Q 0x92 N Z
%---------------------------------------------------------------------------
test_objects_in_map() ->
	FieldsH = ["a","b"],
	FieldsE = ["c","m"],
	% C1
	C1 = #class{name="example.BasicClass", fields=FieldsH++FieldsE},
	Values1 = ["a1","b1",{ref,2},{ref,0}],
	O1 = #object{class="example.BasicClass", values=Values1},
	% C2
	C2 = #class{name="example.BasicClass2", fields=FieldsH++["c2"]++FieldsE},
	Values2 = ["a2","b2",{ref,1},{C1,O1},{ref,0}],
	O2 = #object{class=C2,values=Values2},
	% C3
	Values3 = ["a3","b3",{ref,2},null],
	O3 = #object{typeRef=1,values=Values3},
	% Map
	Dict = dict:from_list([{<<"c2">>, {C2,O2}},{<<"c">>, {ref,2}},{<<"c3">>, O3}]),
	Map = #map{dict = Dict},
	{R,_State} = hessianEncode:encode(Map, []),
	Expected = <<72,2,99,50,67,19,101,120,97,109,112,108,101,46,66,97,115,
				 105,99,67,108,97,115,115,50,149,1,97,1,98,2,99,50,1,99,1,109,96,2,
				 97,50,2,98,50,81,145,67,18,101,120,97,109,112,108,101,46,66,97,115,
				 105,99,67,108,97,115,115,148,1,97,1,98,1,99,1,109,97,2,97,49,2,98,
				 49,81,146,81,144,81,144,1,99,81,146,2,99,51,97,2,97,51,2,98,51,81,
				 146,78,90>>,
	Expected = R.

test_objects_in_map_2() ->
	Params = <<72,2,0,82,72,2,99,50,67,19,101,120,97,109,112,108,101,46,66,97,115,105,99,67,108,97,115,115,50,149,1,97,1,98,2,99,50,1,99,1,109,96,2,97,50,2,98,50,81,145,67,18,101,120,97,109,112,108,101,46,66,97,115,105,99,67,108,97,115,115,148,1,97,1,98,1,99,1,109,97,2,97,49,2,98,49,81,146,81,144,81,144,1,99,81,146,2,99,51,97,2,97,51,2,98,51,81,146,78,90>>,
	{Map, ClassList} = hessianDecode:decode(Params, type_decoding:init()),
	{EncodeBin, _State} = hessianEncode:encode_for_decode(Map, ClassList),
	{Map2, ClassList2} = hessianDecode:decode(<<72,2,0,82,EncodeBin/binary>>, type_decoding:init()),
	Map = Map2,
	ClassList = ClassList2.

test_objects_in_map_3() ->
	Params = <<72,2,0,82,72,2,99,50,67,19,101,120,97,109,112,108,101,46,66,97,115,105,99,67,108,97,115,115,50,149,1,97,1,98,2,99,50,1,99,1,109,96,2,97,50,2,98,50,81,145,67,18,101,120,97,109,112,108,101,46,66,97,115,105,99,67,108,97,115,115,148,1,97,1,98,1,99,1,109,97,2,97,49,2,98,49,81,146,81,144,81,144,1,99,81,146,2,99,51,97,2,97,51,2,98,51,81,146,78,90>>,
	{Map, ClassList} = hessianDecode:decode(Params, type_decoding:init()),
	{return,<<"a3">>} = hessianEncode:get_value(Map, 3, "a", ClassList),
	NewObj1 = #object{refNo=3,typeRef=1,values=["a@object2","b@object2",{ref,2},undefined]},
	{EncodeBin, _State} = hessianEncode:encode_for_decode(Map, [{set,[#set{ref=3,value=NewObj1}]},ClassList]),
	{Map2, ClassList2} = hessianDecode:decode(<<72,2,0,82,EncodeBin/binary>>, type_decoding:init()),
	{return,<<"a@object2">>} = hessianEncode:get_value(Map2, 3, "a", ClassList2).

%---------------------------------------------------------------------------
% Test List and use type reference
%% x72                # typed list length=2
%%   x04 [int         # type for int[] (save as type #0)
%%   x90              # integer 0
%%   x91              # integer 1
%% 
%% x73                # typed list length = 3
%%   x90              # type reference to int[] (integer #0)
%%   x92              # integer 2
%%   x93              # integer 3
%%   x94              # integer 4
%---------------------------------------------------------------------------
test_list_with_type_ref() ->
	R = hessianEncode:encode(list, 0, [2,3,4], []),
	{<<16#73,16#90,16#92,16#93,16#94>>, []} = R.

%---------------------------------------------------------------------------
% Test Binary
%% x23 x01 x02 x03   # 3 octet data
%---------------------------------------------------------------------------
test_binary() ->
	R = hessianEncode:encode({binary,<<1,2,3>>}, []),
	<<16#23,16#1,16#2,16#3>> = R.

%---------------------------------------------------------------------------
% Test Date
%% x4a x00 x00 x00 xd0 x4b x92 x84 xb8   # 09:51:31 May 8, 1998 UTC
%% x00 x00 x00 xd0 x4b x92 x84 xb8 == 894621091000
%% calendar:now_to_datetime({894,621091,0}). -> {{1998,5,8},{9,51,31}}
%---------------------------------------------------------------------------
test_date() ->
	R = hessianEncode:encode({date,{894,621091,0}}, []),
	<<16#4a,16#00,16#00,16#00,16#d0,16#4b,16#92,16#84,16#b8>> = R.

%---------------------------------------------------------------------------
% Test Int
%---------------------------------------------------------------------------
test_int() ->
	R = hessianEncode:encode(16#7FFFFFFF, []),
	<<$I,16#7F,16#FF,16#FF,16#FF>> = R.

test_int_2() ->
	R = hessianEncode:encode(-16#80000000, []),
	<<$I,16#80,16#00,16#00,16#00>> = R.

%---------------------------------------------------------------------------
% Test Long
%---------------------------------------------------------------------------
test_long() ->
	R = hessianEncode:encode(16#1FFFFFFFF, []),
	<<$L,0,0,0,1,16#FF,16#FF,16#FF,16#FF>> = R.

test_long_2() ->
	R = hessianEncode:encode(-16#1FFFFFFFF, []),
	<<$L,16#FF,16#FF,16#FF,16#FE,16#00,16#00,16#00,16#01>> = R.

test_long_3() ->
	R = hessianEncode:encode(long, 16#7FFFFFFF, []),
	<<$Y,16#7F,16#FF,16#FF,16#FF>> = R.

test_long_4() ->
	R = hessianEncode:encode(long, -16#80000000, []),
	<<$Y,16#80,16#00,16#00,16#00>> = R.

%---------------------------------------------------------------------------
% Test Double
%% D x40 x28 x80 x00 x00 x00 x00 x00  # 12.25
%---------------------------------------------------------------------------
test_double() ->
	R = hessianEncode:encode(12.25, []),
	<<16#5F,16#40,16#28,16#80,0>> = R.

%---------------------------------------------------------------------------
% Test Boolean
%---------------------------------------------------------------------------
test_boolean() ->
	<<$T>> = hessianEncode:encode(true, []),
	<<$F>> = hessianEncode:encode(false, []).

%---------------------------------------------------------------------------
% Test Null
%---------------------------------------------------------------------------
test_null() ->
	<<$N>> = hessianEncode:encode(null, []),
	<<$N>> = hessianEncode:encode(undefined, []).

%---------------------------------------------------------------------------
% Test String
%% x05 hello           # "hello"
%---------------------------------------------------------------------------
test_string() ->
	Expected = <<5,104,101,108,108,111>>,
	Expected = hessianEncode:encode("hello", []),
	Expected = hessianEncode:encode(<<"hello">>, []).

test_string_2() ->
	S1 = "123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345",
	S2 = "123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345",
	S3 = "123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345",
	S4 = "1234567890高亮345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345",
	S = "0000" ++ S1 ++ S2 ++ S3 ++ S4,
	CharList = xmerl_ucs:to_utf8(S),
	R = hessianEncode:encode(CharList, []),
	B = list_to_binary(CharList),
	<<$S, 4, 0, B/binary>> = R.

%---------------------------------------------------------------------------
% Test Call Function
%% call ::= C string int value*
%% <<72,2,0,67,9,99,97,108,108,95,102,117,110,99,146,6,112,97,114,97,109,49,146>>
%% H 2 0 C 9 call_func 0x92 6 param1 0x92
%---------------------------------------------------------------------------
test_call() ->
	EncodingState = [],
	R = hessianEncode:encode(call, <<"call_func">>, ["param1", 2], EncodingState),
	<<72,2,0,67,9,99,97,108,108,95,102,117,110,99,146,6,112,97,114,97,109,49,146>> = R.

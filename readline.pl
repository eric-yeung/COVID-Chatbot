%% char is in ASCII code.
%% type can be whitespace, punctuation, number, letter, or special char.

char_Type(46,period) :- !.
char_Type(X,letternumber) :- X >= 65, X =< 90, !.
char_Type(X,letternumber) :- X >= 97, X =< 123, !.
char_Type(X,letternumber) :- X >= 48, X =< 57, !.
char_Type(X,whitespace) :- X =< 32, !.
char_Type(X,punctuation) :- X >= 33, X =< 47, !.
char_Type(X,punctuation) :- X >= 58, X =< 64, !.
char_Type(X,punctuation) :- X >= 91, X =< 96, !.
char_Type(X,punctuation) :- X >= 123, X =< 126, !.
char_Type(_,special).

%% matches ASCII code to its actual number

digit_Value(48,0).
digit_Value(49,1).
digit_Value(50,2).
digit_Value(51,3).
digit_Value(52,4).
digit_Value(53,5).
digit_Value(54,6).
digit_Value(55,7).
digit_Value(56,8).
digit_Value(57,9).

%% if X is the uppercase letter, then Y is the lowercase one in ASCII

lower_case(X,Y) :-
	X >= 65,
	X =< 90,
	Y is X + 32, !.

lower_case(X,X).

%% changes uppercase letters to lowercase in the string

lower_case_String(String) :-
	get0(FirstChar),
	lower_case(FirstChar,LChar),
	lower_case_String_Aux(LChar,String).

lower_case_String_Aux(10,[]) :- !.  % end of line

lower_case_String_Aux(-1,[]) :- !.  % end of file

lower_case_String_Aux(LChar,[LChar|Rest]) :- lower_case_String(Rest). 
%% recursive call if needed


%% grabs first word from string 

word_Find([C|Chars],Rest,[C|RestOfWord]) :-
	char_Type(C,Type),
	word_Find_Aux(Type,Chars,Rest,RestOfWord).

word_Find_Aux(special,Rest,Rest,[]) :- !.
%% if the char is a special char, don't read more chars.

word_Find_Aux(Type,[C|Chars],Rest,[C|RestOfWord]) :-
	char_Type(C,Type), !,
	word_Find_Aux(Type,Chars,Rest,RestOfWord).

word_Find_Aux(_,Rest,Rest,[]).   
%% if previous clause did not succeed.

%% remove blanks from beginning of words

blank_Remove([C|Chars],Result) :-
	char_Type(C,whitespace), !,
	blank_Remove(Chars,Result).

blank_Remove(X,X).
%% if previous clause did not succeed.

%% converts the string to number

string_To_Number(S,N) :-
	string_To_Number_Aux(S,0,N).

string_To_Number_Aux([D|Digits],ValueSoFar,Result) :-
	digit_Value(D,V),
	NewValueSoFar is 10*ValueSoFar + V,
	string_To_Number_Aux(Digits,NewValueSoFar,Result).

string_To_Number_Aux([],Result,Result).


%% converts string to atoms

string_To_Atomic([C|Chars],Number) :-
	string_To_Number([C|Chars],Number), !.

string_To_Atomic(String,Atom) :- name(Atom,String).
%% only if before failed.


%% converts string to list of atoms so we can pattern match in the main program

atomic_Find(String,ListOfAtomics) :-
	blank_Remove(String,NewString),
	atomic_Find_Aux(NewString,ListOfAtomics).

atomic_Find_Aux([C|Chars],[A|Atomics]) :-
	word_Find([C|Chars],Rest,Word),
	string_To_Atomic(Word,A),
	atomic_Find(Rest,Atomics).

atomic_Find_Aux([],[]).

%% removes punctuation from string

punc_Remove([C|Chars],L) :-
	char_Type(C,punctuation),
	punc_Remove(Chars,L), !.
punc_Remove([C|Chars],[C|L]) :-
	punc_Remove(Chars,L), !.
punc_Remove([C|[]],[]) :-
	char_Type(C,punctuation), !.
punc_Remove([C|[]],[C]).

%% Converts input from user into list of atoms
read_Atomic(ListOfAtomics) :-
	lower_case_String(String),
	punc_Remove(String,NoPuncString),
	atomic_Find(NoPuncString,ListOfAtomics).

readline(A) :-
	read_Atomic(A).
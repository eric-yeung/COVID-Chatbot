/*Program really just checks user input against one of 3 major symptoms (ie fever, cough and/or tiredness) and
recommends if the user should get tested or not.
Also has commands like <help>, <symptoms>, <test> for information on those things.*/

%% Reads input line and converts to atom list so you can pattern match

/************************************************************************************/
%% YOU MUST HAVE THE READLINE.PL FILE IN THE SAME DIRECTORY IN ORDER FOR THIS TO WORK
/************************************************************************************/

:- [readline].

chatbot_start:- 
	write('This is a rudimentary COVID Chatbot'), nl, 
	write('The bot is not a replacement for an actual doctor.'), nl,
	write('However you can use this as help to see if you should get tested.'), nl,
	write('To start, type in <hi_chatbot.> in the prompt. To end your session simply type <bye>.').

hi_chatbot :- 
	write('Hi, I am the COVID Chatbot. How are you feeling? Type <help> if you need help starting.'), nl,
  	readline(Input),
  	chatbot(Input),!.

chatbot(['bye']) :-
	reply(['Bye, thank you for using this basic COVID Chatbot']). 
	
%% recursive algorithm to conduct the conversation with the user
chatbot(Input) :-
	pattern(Stim, Response), %% checking for pattern from user input
	match(Stim, Dict, Input), 
	match(Response, Dict, Output), 
	reply(Output), 
	readline(Input1),
	!, chatbot(Input1). 

%% matching the input to the correct pair
match([N|Pattern], Dict, Target) :-
	integer(N), lookup(N,Dict,Lt),
	append(Lt,Rt, Target), 
	match(Pattern, Dict, Rt).

match([Word|Pattern], Dictionary, [Word|Target]) :-
	atom(Word), match(Pattern, Dictionary, Target).

match([], _,[]).

%% lookup dictionary
lookup(Key, [(Key, Value)|_], Value).
lookup(Key, [(Key1, _)|Dictionary], Value) :-
    \=(Key, Key1), lookup(Key, Dictionary, Value).


:- dynamic(pattern/1).

%% Testing information/response
pattern([test],['Visit https://covid-19.ontario.ca/ for more information on where you can get tested.']).

%% help
pattern([help], ['Enter your symptoms one at a time or tell me if you have been exposed to COVID and I can provide insight.']).

%% Less common symptoms
pattern([symptoms], ['Less common symptom are aches and pains, sore throat, diarrhoea, conjunctivitis, headache, loss of taste or smell, a rash on skin, or discolouration of fingers or toes. You should get tested if you have any signs of these. Type <test> for more information on getting tested.']).

%% Response for COVID exposure
pattern([exposure], ['If you have been exposed to someone with COVID, you must get tested. Type <test> for more information on getting tested.']).
pattern([i, have, been, exposed], ['If you have been exposed to someone with COVID, you must get tested. Type <test> for more information on getting tested.']).
pattern([i, got, exposed], ['If you have been exposed to someone with COVID, you must get tested. Type <test> for more information on getting tested.']).

%% Symptoms check
pattern([fever], ['A fever is a common symptom of COVID, you should get tested if it exceeds 100.4 F or 38 C. Type <test> for more information on getting tested.']).
pattern([i, have, a, fever], ['A fever is a common symptom of COVID, you should get tested if it exceeds 100.4 F or 38 C. Type <test> for more information on getting tested.']).
pattern([i, have, a, _, fever], ['A fever is a common symptom of COVID, you should get tested if it exceeds 100.4 F or 38 C. Type <test> for more information on getting tested.']).
pattern([i, may, have, a, fever], ['A fever is a common symptom of COVID, you should get tested if it exceeds 100.4 F or 38 C. Type <test> for more information on getting tested.']).

pattern([cough], ['A cough is a common symptom of COVID, you should get tested. Type <test> for more information on getting tested.']).
pattern([i, have, a, cough], ['A cough is a common symptom of COVID, you should get tested. Type <test> for more information on getting tested.']).
pattern([i, am, coughing], ['A cough is a common symptom of COVID, you should get tested. Type <test> for more information on getting tested.']).
pattern([im, coughing], ['A cough is a common symptom of COVID, you should get tested. Type <test> for more information on getting tested.']).
pattern([i, may, have, a, cough], ['A cough is a common symptom of COVID, you should get tested. Type <test> for more information on getting tested.']).
pattern([i, have, a, _, cough], ['A cough is a common symptom of COVID, you should get tested. Type <test> for more information on getting tested.']).

pattern([tired], ['Tiredness is a common symptom of COVID, you should get tested. Type <test> for more information on getting tested.']).
pattern([im, tired], ['Tiredness is a common symptom of COVID, you should get tested. Type <test> for more information on getting tested.']).
pattern([im, _, tired], ['Tiredness is a common symptom of COVID, you should get tested. Type <test> for more information on getting tested.']).
pattern([i, am, tired], ['Tiredness is a common symptom of COVID, you should get tested. Type <test> for more information on getting tested.']).
pattern([i, am, _, tired], ['Tiredness is a common symptom of COVID, you should get tested. Type <test> for more information on getting tested.']).

%% Check if user is just putting random inputs

pattern([i, am, _], ['That does not seem like one of the 3 major symptoms. Type <symptoms> to see if your case is one of those.']).
pattern([im, _], ['That does not seem like one of the 3 major symptoms. Type <symptoms> to see if your case is one of those.']).
pattern([i, have, _], ['That does not seem like one of the 3 major symptoms. Type <symptoms> to see if your case is one of those.']).

%% Generic reponse if user doesn't reply properly
pattern([1], ['Please provide more information or type <help> for help starting. If you do not have any common symptoms, type <symptoms> for more information']).

% reply
reply([Head|Tail]) :- write(Head), write(' '), reply(Tail). 
reply([]) :- nl.

:- chatbot_start.
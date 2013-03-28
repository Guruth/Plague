use_module(library(wgraphs)).



getLines(Lines) :-
    open('bla.txt', read, Str),
    read_file(Str,Lines),
    close(Str).

read_file(Stream,[]) :-
    at_end_of_stream(Stream).

read_file(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream),
    read(Stream,X),
    write(X),
    read_file(Stream,L).

%% Format Dict = [[Wort, Wahrscheinlichkeit],...]
				%Dict
lookup(Sentence,  PredictedWord):-
%	reverse(Sentence, ReversedSentence),
	findTrigramsRecursive(Sentence , [
['Hallo','Welt','was',10],
['Hallo','Bucks','wie',20],
['Hallo','Welt','wie',30],
['Hallo','Bucks','wann',40],
['Hallo','Micha','was',50],
['Tschüs','Micha','bla',60],
['Tschüs','Bucks','bla',70]
] , PredictedWord).

%			 Liste mit zwei Wörtern, werden über Console mit lookup(['Blaa','Blub'], ...) rein gereicht
%							Dictionary mit Trigrammen sowie deren Wahrscheinlichkeit [[1,2,3,Prop],[1, 2,3,Prop],...]
%																					Return Liste  mit möglichen Wörtern so wie deren Wahrscheinlichkeit 
findTrigramsRecursive(WordList,[],[]).
findTrigramsRecursive([Word, Word2], [[Word,Word2|RestDictEntry]|Dict], [RestDictEntry|ReturnList]):-
	findTrigramsRecursive([Word,Word2],Dict,ReturnList).
findTrigramsRecursive([Word|RestWord], [[DictWord|RestDictEntry]|Dict], ReturnList):-
	findTrigramsRecursive([Word,Word2],Dict,ReturnList).


findBigrams([Word], [[DictWord, DictWord2, DictProp] | Dict], [[ReurnWord|ReturnProp]| ReturnList]):-
	(Word = DictWort -> ReturnWord = DictWord2, ReturnProp = DictProp; true).

%['Hallo'-['Welt'],['Bucks'-['wie']]]
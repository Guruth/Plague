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
lookup(Sentence,  HighestPropWord):-
%	reverse(Sentence, ReversedSentence),
	findTrigrams(Sentence , [
    ['Hallo','Welt','was',10],
    ['Hallo','Bucks','wie',20],
    ['Hallo','Welt','wie',30],
    ['Hallo','Bucks','wann',40],
    ['Hallo','Micha','was',50],
    ['Tschüs','Micha','bla',60],
    ['Tschüs','Bucks','bla',70],
    ['Hallo','Bucks','bla',30]
    ] , PredictedWord),
    findHighestProp(PredictedWord,HighestPropWord).

%						 Liste mit zwei Wörtern, werden über Console mit lookup(['Blaa','Blub'], ...) rein gereicht
%									Dictionary mit Trigrammen sowie deren Wahrscheinlichkeit [[1,2,3,Prop],[1, 2,3,Prop],...]
%																		Return Liste  mit möglichen Wörtern so wie deren Wahrscheinlichkeit 
findTrigrams(WordList,[],[]).
findTrigrams([Word, Word2], [[Word,Word2|RestDictEntry]|Dict], [RestDictEntry|ReturnList]):-
	findTrigrams([Word,Word2], Dict, ReturnList).
findTrigrams([Word,Word2|RestWord], [[DictWord,DictWord2|RestDictEntry]|Dict], ReturnList):-
	findTrigrams([Word,Word2], Dict, ReturnList).
%findTrigrams([Word,Word2|RestWord], [[DictWord,Word2|RestDictEntry]|Dict], ReturnList):-
%	findTrigrams([Word,Word2], Dict, ReturnList).


findBigrams([Word],[],[]).
findBigrams([Word], [[Word|RestDictEntry]|Dict], [RestDictEntry|ReturnList]):-
	findBigrams([Word], Dict, ReturnList).
findBigrams([Word],[[DictWord|DictWordRest]| Dict],ReturnList):-
	findBigrams([Word], Dict, Returnlist).
%['Hallo'-['Welt'],['Bucks'-['wie']]]

findHighestProp([Word],Word).
findHighestProp([Word|RestList], Return):-
    findHighestProp(RestList,Rec),
    compareWords(Word,Rec,Return).

compareWords([Word|Prop],[CompWord,Prop],[Word|Prop]).
compareWords([Word,Prop],[CompWord,CompProp],[ReturnWord,ReturnProp]):-
    (Prop > CompProp ->
    ReturnWord = Word, ReturnProp = Prop ;
    ReturnWord = CompWord, ReturnProp = CompProp ).

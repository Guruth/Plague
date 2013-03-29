autoComplete(Sentence,  Return):-
    openBigrams(BigramHandle),
    openTrigrams(TrigramHandle),
    findBigram(BigramHandle,Sentence,Bigram),
    findTrigrams(TrigramHandle,Sentence,Trigrams),
    calculateProps(Bigram, Trigrams, ReturnWords),
    findHighestProp(ReturnWords,Return).

% Handling large lists of data http://www.swi-prolog.org/pldoc/package/table.html

openBigrams(Handle):-
    new_table(
        'wordlists/w2_.txt', 
        [count(integer), word(string), word2(string)], 
        [],
        Handle).
openTrigrams(Handle):-
    new_table(
        'wordlists/w3_.txt', 
        [count(integer), word(string), word2(string), word3(string)], 
        [],
        Handle).

findBigram(Handle,[Word,Word2], Return):-
    findall(
        [Word, Word2, Count],
        in_table(Handle, [word(Word), word2(Word2), count(Count)], _),
        Return).

findTrigrams(Handle,[Word,Word2], ReturnList):-
    findall(
        [Word, Word2, Word3, Count], 
        in_table( Handle, [word(Word), word2(Word2), word3(Word3),count(Count)], _), 
        ReturnList).

calculateProps(Words,[],[]).
calculateProps([[BiWord,BiWord2,BiCount]],[[TriWord,TriWord2,TriWord3,TriCount]| TriList],[[TriWord3,Prop]|ReturnList]):-
   calculateProps([[BiWord,BiWord2,BiCount]],TriList,ReturnList),
    Prop is TriCount/BiCount.


findHighestProp([Word],Word).
findHighestProp([Word|RestList], Return):-
    findHighestProp(RestList,Rec),
    compareWords(Word,Rec,Return). 

compareWords([Word|Prop],[CompWord,Prop],[Word|Prop]).
compareWords([Word,Prop],[CompWord,CompProp],[ReturnWord,ReturnProp]):-
    (Prop > CompProp ->
    ReturnWord = Word, ReturnProp = Prop ;
    ReturnWord = CompWord, ReturnProp = CompProp ).

%						 Liste mit zwei Wörtern, werden über Console mit lookup(['Blaa','Blub'], ...) rein gereicht
%									Dictionary mit Trigrammen sowie deren Wahrscheinlichkeit [[1,2,3,Prop],[1, 2,3,Prop],...]
%																		Return Liste  mit möglichen Wörtern so wie deren Wahrscheinlichkeit 
findHighestTrigrams(WordList,[],[]).
findHighestTrigrams([Word, Word2], [[Word,Word2|RestDictEntry]|Dict], [RestDictEntry|ReturnList]):-
	findHighestTrigrams([Word,Word2], Dict, ReturnList).
findHighestTrigrams([Word,Word2|RestWord], [[DictWord,DictWord2|RestDictEntry]|Dict], ReturnList):-
	findHighestTrigrams([Word,Word2], Dict, ReturnList).
%findTrigrams([Word,Word2|RestWord], [[DictWord,Word2|RestDictEntry]|Dict], ReturnList):-
%	findTrigrams([Word,Word2], Dict, ReturnList).


findHighestBigrams([Word],[],[]).
findHighestBigrams([Word], [[Word|RestDictEntry]|Dict], [RestDictEntry|ReturnList]):-
	findHighestBigrams([Word], Dict, ReturnList).
findHighestBigrams([Word],[[DictWord|DictWordRest]| Dict],ReturnList):-
	findHighestBigrams([Word], Dict, Returnlist).

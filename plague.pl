% Word lists from : http://www.ngrams.info/

start:-
    openBigramFile(BigramHandle),
    openTrigramFile(TrigramHandle),
    read(Word),
    inputLoop(Word,Word,BigramHandle,TrigramHandle).

inputLoop(OldSentence, OldWord, BigramHandle, TrigramHandle):-
    read(NewWord),
    autoComplete([OldWord, NewWord], BigramHandle, TrigramHandle, AutoCompletedWord),
    string_concat(OldSentence, ' ', Sentence),
    string_concat(Sentence, NewWord, NewSentence),
    printLine([NewSentence,AutoCompletedWord]),
    inputLoop(NewSentence, NewWord, BigramHandle, TrigramHandle).

autoComplete(Sentence, BigramHandle, TrigramHandle, Return):-
    findBigram(BigramHandle,Sentence,Bigram),
    findTrigrams(TrigramHandle,Sentence,Trigrams),
    calculateProps(Bigram, Trigrams, ReturnWords),
    findHighestProp(ReturnWords,Return).

openBigramFile(Handle):-
    new_table(
        'wordlists/w2_.txt', 
        [count(integer), word(string), word2(string)], 
        [],
        Handle).

openTrigramFile(Handle):-
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

calculateProps(_Sentence,[],[]).
calculateProps([[BiWord,BiWord2,BiCount]], [[_TriWord, _TriWord2, TriWord3,TriCount]| TriList], [[TriWord3,Prop]|ReturnList]):-
    calculateProps([[BiWord,BiWord2,BiCount]],TriList,ReturnList),
    Prop is TriCount/BiCount.

findHighestProp([],Word):-
    Word = '[Word combination not in knowledge base]'.
findHighestProp([Word],Word).
findHighestProp([Word|RestList], Return):-
    findHighestProp(RestList,Rec),
    compareWords(Word,Rec,Return). 

compareWords([Word|Prop],[_CompWord,Prop],[Word|Prop]).
compareWords([Word,Prop],[CompWord,CompProp],[ReturnWord,ReturnProp]):-
    (>(Prop,CompProp) ->
    ReturnWord = Word, ReturnProp = Prop ;
    ReturnWord = CompWord, ReturnProp = CompProp ).

printLine([]):-
    nl.
printLine([Sentence|Rest]):-
    write(Sentence),
    write(' '),
    printLine(Rest).
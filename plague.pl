% Plague - a prolog word auto completion
%
% Written by Alexander Rust & Kai Weller
% 

% Prerequisites:
% Word lists must have the format: Count Word Word [Word] 
% Currently, two wordlists are bundled with the source. 

% Different word lists can be aquired from : http://www.ngrams.info/
% Free samples are good enough, but require registration
% Should be packed to Plague/wordlists/

% Usage: 
% Consult the file and call the function 'start/0'. 
% Afterwards, words can be inputted by enterting the word followed by a . and pressing enter. 
% Note, that currently only lower-case words are supported. 
% After two words, completions and their probability are suggested automatically. 

% Sample input: 
% ?- consult(plague).
% % plague compiled 0.00 sec, 17 clauses
% true.
% ?- start.
% |: this.
% |: is.
% this is [a,0.16518969216948529]
% |: a.
% this is a [very,0.026205563017224095]
% |: ...

% References:
% [1] http://www.swi-prolog.org/pldoc/package/table.html

% Starts the completion
start:-
    openBigramFile(BigramHandle),
    openTrigramFile(TrigramHandle),
    read(Word),
    inputLoop(Word,Word,BigramHandle,TrigramHandle).

% Main loop for continous input of words. 
% Reads words, gets most likely next word, prints it and reads next word.  
inputLoop(OldSentence, OldWord, BigramHandle, TrigramHandle):-
    read(NewWord),
    autoComplete([OldWord, NewWord], BigramHandle, TrigramHandle, AutoCompletedWord),
    string_concat(OldSentence, ' ', Sentence),
    string_concat(Sentence, NewWord, NewSentence),
    printLine([NewSentence,AutoCompletedWord]),
    inputLoop(NewSentence, NewWord, BigramHandle, TrigramHandle).

% Returns the most probable next word according the the current sentence based on the information contained 
% in the word lists
autoComplete(Sentence, BigramHandle, TrigramHandle, Return):-
    findBigram(BigramHandle,Sentence,Bigram),
    findTrigrams(TrigramHandle,Sentence,Trigrams),
    calculateProps(Bigram, Trigrams, ReturnWords),
    findHighestProp(ReturnWords,Return).

% Open word lists containing  2-/3- grams using the prolog table handling mechanism (see [1])
% Returns the File Handle used in findBi/Trigram(...)
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
%Finds all matching table entries 
%Returns a list of entries 
%   [[Word, Word2, (Word3,) Count]|...]
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

%Calculates the propability based on the maximum likelihood method
%   TrigramCount/BigramCount = Propability 
%Returns a list of word, propability combinations
%   [[ThirdWordOfTrigram , Propability]|...]
calculateProps(_Sentence,[],[]).
calculateProps([[BiWord,BiWord2,BiCount]], [[_TriWord, _TriWord2, TriWord3,TriCount]| TriList], [[TriWord3,Prop]|ReturnList]):-
    calculateProps([[BiWord,BiWord2,BiCount]],TriList,ReturnList),
    Prop is TriCount/BiCount.


%Finds the Word with the highest propability
%Returns the element with the highest propability
%   [Word,Propability]
%or, if the input list is empty, a message that no estimation is possible
findHighestProp([],Word):-
    Word = '[Word combination not in knowledge base]'.
findHighestProp([Word],Word).
findHighestProp([Word|RestList], Return):-
    findHighestProp(RestList,Rec),
    compareWords(Word,Rec,Return). 

%Compares two word, propability combination
%If both propabilities are equal, the first element to be compared is returned
%Returns the word, propability combination with the highest propability
%   [Word, Propabilitiy]
compareWords([Word|Prop],[_CompWord,Prop],[Word|Prop]).
compareWords([Word,Prop],[CompWord,CompProp],[ReturnWord,ReturnProp]):-
    (>(Prop,CompProp) ->
    ReturnWord = Word, ReturnProp = Prop ;
    ReturnWord = CompWord, ReturnProp = CompProp ).

%Prints a list of Strings followed by a newline
printLine([]):-
    nl.
printLine([Sentence|Rest]):-
    write(Sentence),
    write(' '),
    printLine(Rest).
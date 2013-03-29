
Y=[
['Hallo','Welt','was',10],
['Hallo','Bucks','wie',10],
['Hallo','Welt','wie',20],
['Hallo','Bucks','wann',10],
['Hallo','Micha','was',10],
['Tschüs','Micha','bla',30],
['Tschüs','Bucks','bla',30]
].

	findHighestTrigrams(Sentence , [
    ['Hallo','Welt','was',10],
    ['Hallo','Bucks','wie',20],
    ['Hallo','Welt','wie',30],
    ['Hallo','Bucks','wann',40],
    ['Hallo','Micha','was',50],
    ['Tschüs','Micha','bla',60],
    ['Tschüs','Bucks','bla',70],
    ['Hallo','Bucks','bla',40]
    ] , PredictedWord),
    findHighestProp(PredictedWord,HighestPropWord).
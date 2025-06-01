select
   getPathByValue (v.valueId)
from 
   Value as v
where
   v.sessionId is null
and 
not exists(
   select
      *
   from
      ValueParentChild as vpc,
      ValueWord as vw,
      Word as w
   where
      vpc.parentValueId = v.valueId
      and
      vpc.childValueId = vw.valueId
      and
      vw.wordId = w.wordId
      and
      w.word = 'hospital'
)
and  exists(
   select
      *
   from
      ValueParentChild as vpc,
      ValueWord as vw,
      Word as w
   where
      vpc.parentValueId = v.valueId
      and
      vpc.childValueId = vw.valueId
      and
      vw.wordId = w.wordId
      and
      w.word = 'white'
) 
and  exists(
   select
      *
   from
      ValueParentChild as vpc,
      ValueWord as vw,
      Word as w
   where
      vpc.parentValueId = v.valueId
      and
      vpc.childValueId = vw.valueId
      and
      vw.wordId = w.wordId
      and
      w.word = 'marijuana' 
) limit 10
set @userId = ?;

select distinct
    getPathByValue(v.valueId, @userId) as path
from 
    Value as v
where
    exists
    (
        select
            *
        from
            ValueWord as vw,
            Word as w
        where
            w.word = 'large'
        and
            vw.valueId = v.valueId
        and
            vw.wordId = w.wordId
            
    )
and
exists
    (
        select
            *
        from
            ValueWord as vw,
            Word as w
        where
            w.word = 'female'
        and
            vw.valueId = v.valueId
        and
            vw.wordId = w.wordId
            
    )
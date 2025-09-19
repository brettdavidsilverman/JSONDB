select distinct
    getPathByValue(v.valueId) as path
from 
    Value as v
where
    exists
    (
        select
            *
        from
            ValueWord as vw,
            Word as w,
            ValueParentChild as vpc
        where
            w.word = 'large'
        and
            vw.valueId = vpc.childValueId
        and
            vw.wordId = w.wordId
        and
            vpc.parentValueId = v.valueId
            
    )
and
exists
    (
        select
            *
        from
            ValueWord as vw,
            Word as w,
            ValueParentChild as vpc
        where
            w.word = 'female'
        and
            vw.valueId = vpc.childValueId
        and
            vw.wordId = w.wordId
        and
            vpc.parentValueId = v.valueId
            
    )
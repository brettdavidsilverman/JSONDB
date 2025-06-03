select distinct
    getPathByValue(v.valueId) as path
from 
    Value as v
inner join
    ValueParentChild as vpc
on
    vpc.parentValueId = 57443148
and
    vpc.childValueId = v.valueId
where
    exists(
        select
            vw.valueId as valueId
        from
            ValueWord as vw,
            Word as w,
            ValueParentChild as vpc
        where
            w.word = 'heroin'
        and
            vw.valueId = vpc.childValueId
        and
            vw.wordId = w.wordId
        and
            vpc.parentValueId = v.valueId
            
    )

and
    exists(
        select
            vw.valueId as valueId
        from
            ValueWord as vw,
            Word as w,
            ValueParentChild as vpc
        where
            w.word = 'black'
        and
            vw.valueId = vpc.childValueId
        and
            vw.wordId = w.wordId
        and
            vpc.parentValueId = v.valueId
            
    )
and
    exists(
        select
            vw.valueId as valueId
        from
            ValueWord as vw,
            Word as w,
            ValueParentChild as vpc
        where
            w.word = 'black'
        and
            vw.valueId = vpc.childValueId
        and
            vw.wordId = w.wordId
        and
            vpc.parentValueId = v.valueId
            
    )

limit 10;
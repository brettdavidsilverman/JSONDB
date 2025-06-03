select distinct
    getPathByValue(v.valueId) as path
from 
    Value as v
inner join
    ValueParentChild as vpc
on
    vpc.parentValueId = 57443148
and
    vpc.childValueId = v.valueId,

    (
        select
            vpcWord.parentValueId as parentValueId
        from
            ValueWord as vw,
            Word as w,
            ValueParentChild as vpcWord
        where
            w.word = 'heroin'
        and
            vw.wordId = w.wordId
        and
            vpcWord.childValueId = vw.valueId

    ) as word1,

    (
        select
            vpcWord.parentValueId as parentValueId
        from
            ValueWord as vw,
            Word as w,
            ValueParentChild as vpcWord
        where
            w.word = 'white'
        and
            vw.wordId = w.wordId
        and
            vpcWord.childValueId = vw.valueId
        
    ) as word2
where
    word1.parentValueId = v.valueId
and
    word2.parentValueId = v.valueId
limit 10
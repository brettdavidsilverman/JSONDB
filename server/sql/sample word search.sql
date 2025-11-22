with matches as (
    select
        v.valueId,
        row_number() over 
           (order  by v.valueId)
           as rowNumber
    from
        Value as v
    inner join
        ValueParentChild as vpc
    on
        vpc.childValueId = v.valueId
    inner join
        (
            select distinct
                parents.parentValueId as valueId
            from
                ValueParentChild as vpc
            inner join
                ValueWord as vw
            on
                vw.valueId = vpc.parentValueId
            inner join
                Word as w
            on
                w.wordId = vw.wordId
            inner join
                ValueParentChild as parents
            on
                parents.childValueId = vpc.childValueId
            where
                w.lowerWord = 'heroin'

        ) as w0
    on
        w0.valueId = v.valueId
    inner join
        (
            select distinct
                parents.parentValueId as valueId
            from
                ValueParentChild as vpc
            inner join
                ValueWord as vw
            on
                vw.valueId = vpc.parentValueId
            inner join
                Word as w
            on
                w.wordId = vw.wordId
            inner join
                ValueParentChild as parents
            on
                parents.childValueId = vpc.childValueId
            where
                w.lowerWord = 'female'

        ) as w1
    on
        w1.valueId = v.valueId
    where
        vpc.parentValueId in (
            select
                v.valueId
            from
                Value as v
            where
                v.parentValueId is null
        )
    and
        not exists(
            select
                *
            from
                Value as _v
            inner join
                ValueParentChild as _vpc
            on
                _vpc.parentValueId = _v.valueId
            and
                _vpc.childValueId = v.valueId
            where
                v.locked = 1
            or
                v.locked is null
                
        )
    
)

select
    (
        select
            count(*)
        from
            matches
    ) as totalCount,
    getPathByValue (
        matches.valueId,
        118
    ) as path

from
    matches
    
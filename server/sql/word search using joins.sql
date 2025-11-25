with matches as (
    select distinct
        v.valueId
    from
        ValueParentChild as vpc
    inner join
        Value as v
    on
        vpc.childValueId = v.valueId
    
    inner join
        ValueParentChild as parents0
    on
        parents0.parentValueId = v.valueId
    inner join
        ValueWord as vw0
    on
        vw0.valueId = parents0.childValueId
    inner join
        Word as w0
    on
        w0.lowerWord = 'process'
    and
        w0.wordId = w0.wordId
        
    inner join
        ValueParentChild as parents1
    on
        parents1.parentValueId = v.valueId
    inner join
        ValueWord as vw1
    on
        vw1.valueId = parents1.childValueId
    inner join
        Word as w1
    on
        w1.lowerWord = 'deaths'
    and
        w1.wordId = w1.wordId
        
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
    matches.valueId,
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
inner join
    (
        select
            m.valueId,
            row_number() over 
           (order by m.valueId)
           as rowNumber
       from
           matches as m
    ) as rowNumbers
on
    rowNumbers.valueId = matches.valueId
where
    rowNumbers.rowNumber between 1 and 100
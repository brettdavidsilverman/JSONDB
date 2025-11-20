    with matches as (

            select
                v.valueId,
                row_number() over 
                (order  by v.valueId)
                as rowNumber
            from
                Value as v
            where
          
            exists
                (
                    select
                        *
                    from
                        ValueParentChild as vpc
                    inner join
                        ValueWord as vw
                    on
                        vpc.parentValueId = vw.valueId
                    and
                        vpc.childValueId = v.valueId
                    inner join
                        Word as w
                    on
                        w.wordId = vw.wordId
                    where
                        w.lowerWord = "key1"
                )

            and 
            
            exists
                (
                    select
                        *
                    from
                        ValueParentChild as vpc
                    inner join
                        ValueWord as vw
                    on
                        vpc.parentValueId = vw.valueId
                    and
                        vpc.childValueId = v.valueId
                    inner join
                        Word as w
                    on
                        w.wordId = vw.wordId
                    where
                        w.lowerWord = "key2"
                )
            and
            exists
                (
                    select
                        *
                    from
                        ValueParentChild as vpc
                    inner join
                        ValueWord as vw
                    on
                        vpc.parentValueId = vw.valueId
                    and
                        vpc.childValueId = v.valueId
                    inner join
                        Word as w
                    on
                        w.wordId = vw.wordId
                    where
                        w.lowerWord = "value2"
                )
                
    )

    select
        getPathByValue (
            matches.valueId,
            118
        ) as path
    from
        matches
    where
        matches.rowNumber between 1 and  100
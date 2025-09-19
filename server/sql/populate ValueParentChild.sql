delete
from
ValueParentChild;

insert into
    ValueParentChild(
        parentValueId,
        childValueId
    )
    
with recursive parent(
   parentValueId,
   childValueId
) as
(
    select
        Value.valueId,
        Value.valueId
    from
        Value
    union
    
    select
        parent.parentValueId,
        children.valueId
    from
        parent
    inner join
        Value as children
    where
        children.parentValueId =
        parent.childValueId
)

select
    parent.parentValueId,
    parent.childValueId
from
    parent;
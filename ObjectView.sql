select
    `JSONDB`.`Object`.`objectId` AS `objectId`,
    `JSONDB`.`Object`.`parentId` AS `parentId`,
    `JSONDB`.`Object`.`type` AS `type`,
    `JSONDB`.`Object`.`ownerId` AS `ownerId`,
    `JSONDB`.`Value`.`valueId` AS `valueId`,
    `JSONDB`.`Value`.`objectIndex` AS `objectIndex`,
    `JSONDB`.`Value`.`objectKey` AS `objectKey`,
    `JSONDB`.`Value`.`numericValue` AS `numericValue`,
    `JSONDB`.`Value`.`stringValue` AS `stringValue`,
    `JSONDB`.`Value`.`idValue` AS `idValue`,
    `JSONDB`.`Value`.`boolValue` AS `boolValue`,
    `JSONDB`.`Value`.`isNull` AS `isNull`
from
    `JSONDB`.`Object` left join
    `JSONDB`.`Value`
on
    `JSONDB`.`Object`.`objectId` =
    `JSONDB`.`Value`.`objectId`
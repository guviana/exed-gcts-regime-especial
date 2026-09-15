managed implementation in class ZBP_R_REGESPPLANT unique;
strict ( 2 );
with draft;
extensible;
define behavior for ZR_REGESPPLANT alias Plant
persistent table ZTBREGESPPLANT
extensible
draft table ZTBREGESPPLANT_D
etag master LocalLastChangedAt
lock master total etag LastChangedAt
authorization master( global )
{
  field ( mandatory : create )
   Plant,
   ValidityBegin,
   ValidityEnd;

  field ( readonly )
   PlantName,
   LocalCreatedBy,
   LocalCreatedAt,
   LocalLastChangedBy,
   LocalLastChangedAt,
   LastChangedAt;

  field ( readonly : update )
   Plant,
   ValidityBegin,
   ValidityEnd;

  create;
  update;
  delete;

  draft action Activate optimized;
  draft action Discard;
  draft action Edit;
  draft action Resume;
  draft determine action Prepare;

  mapping for ZTBREGESPPLANT corresponding extensible
  {
    Plant = PLANT;
    ValidityBegin = VALIDITY_BEGIN;
    ValidityEnd = VALIDITY_END;
    LocalCreatedBy = LOCAL_CREATED_BY;
    LocalCreatedAt = LOCAL_CREATED_AT;
    LocalLastChangedBy = LOCAL_LAST_CHANGED_BY;
    LocalLastChangedAt = LOCAL_LAST_CHANGED_AT;
    LastChangedAt = LAST_CHANGED_AT;
  }

}
managed implementation in class ZBP_R_REGESPPERC unique;
strict ( 2 );
with draft;
extensible;
define behavior for ZR_REGESPPERC alias ZrRegespperc
persistent table ZTBREGESPPERC
extensible
draft table ZTBREGESPPERC_D
etag master LocalLastChangedAt
lock master total etag LastChangedAt
authorization master( global )
{
  field ( mandatory : create )
   Ncm,
   Cest,
   Matkl,
   Matnr,
   ValidityBegin;

  field ( readonly )
   LocalCreatedBy,
   LocalCreatedAt,
   LocalLastChangedBy,
   LocalLastChangedAt,
   LastChangedAt;

  field ( readonly : update )
   Ncm,
   Cest,
   Matkl,
   Matnr,
   ValidityBegin;


  create;
  update;
  delete;

  draft action Activate optimized;
  draft action Discard;
  draft action Edit;
  draft action Resume;
  draft determine action Prepare;

  mapping for ZTBREGESPPERC corresponding extensible
  {
    Ncm = NCM;
    Cest = CEST;
    Matkl = MATKL;
    Matnr = MATNR;
    ValidityBegin = VALIDITY_BEGIN;
    InternalTaxRate = INTERNAL_TAX_RATE;
    DeferralRate = DEFERRAL_RATE;
    MvaRate = MVA_RATE;
    LocalCreatedBy = LOCAL_CREATED_BY;
    LocalCreatedAt = LOCAL_CREATED_AT;
    LocalLastChangedBy = LOCAL_LAST_CHANGED_BY;
    LocalLastChangedAt = LOCAL_LAST_CHANGED_AT;
    LastChangedAt = LAST_CHANGED_AT;
  }

}
managed implementation in class ZBP_R_REGESPPERC unique;
strict ( 2 );
with draft;
extensible;
define behavior for ZR_REGESPPERC alias ZrRegespperc
persistent table ztbregespperc
extensible
draft table ztbregespperc_d
etag master LocalLastChangedAt
lock master total etag LastChangedAt
authorization master ( global )
{
  field ( mandatory : create )
  Ncm,
  Cest,
  MaterialGroup,
  //   Material,
  ValidityBegin,
  InternalTaxRate,
  DeferralRate,
  MVARate;

  field ( readonly )
  LocalCreatedBy,
  LocalCreatedAt,
  LocalLastChangedBy,
  LocalLastChangedAt,
  LastChangedAt;

  field ( readonly : update )
  Ncm,
  Cest,
  MaterialGroup,
  Material,
  ValidityBegin;


  create;
  update;
  delete;

  draft action Activate optimized;
  draft action Discard;
  draft action Edit;
  draft action Resume;
  draft determine action Prepare;

  mapping for ztbregespperc corresponding extensible
    {
      Ncm                = NCM;
      Cest               = CEST;
      MaterialGroup      = MATERIAL_GROUP;
      Material           = MATERIAL;
      ValidityBegin      = VALIDITY_BEGIN;
      InternalTaxRate    = INTERNAL_TAX_RATE;
      DeferralRate       = DEFERRAL_RATE;
      MvaRate            = MVA_RATE;
      LocalCreatedBy     = LOCAL_CREATED_BY;
      LocalCreatedAt     = LOCAL_CREATED_AT;
      LocalLastChangedBy = LOCAL_LAST_CHANGED_BY;
      LocalLastChangedAt = LOCAL_LAST_CHANGED_AT;
      LastChangedAt      = LAST_CHANGED_AT;
    }

}
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_OS_02_T_COURSE
  provider contract transactional_query
  as projection on ZR_OS_02_T_COURSE
{
  key Course,
  Coursedesc,
  Difficulty,
  Price,
//  @Semantics.currencyCode: true
  Currency,
  LocalCreatedBy,
  LocalCreatedAt,
  LocalLastChangedBy,
  LocalLastChangedAt,
  LastChangedAt
  
}

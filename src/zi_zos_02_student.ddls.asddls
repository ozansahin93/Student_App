@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for student'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_ZOS_02_STUDENT
  as select from zos_02_t_student
  association to ZI_ZOS_02_GENDER  as _gender on $projection.Gender = _gender.Value
  association to ZR_OS_02_T_COURSE as _course on $projection.Course = _course.Course
{
  key id                  as Id,
      firstname           as FirstName,
      lastname            as LastName,
      age                 as Age,
      course              as Course,
      courseduration      as CourseDuration,
      status              as Status,
      gender              as Gender,
      dob                 as Dob,
      _gender.Description as GenderDesc,
      _course.Coursedesc  as CourseDesc, 
//       cast( 'Determine Age here' as abap.char(100) ) as DetermineAge,
      determineage as DetermineAge,
      _gender,
      _course


}

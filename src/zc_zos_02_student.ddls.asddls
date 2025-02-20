@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Student'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZC_ZOS_02_STUDENT
  as projection on ZI_ZOS_02_STUDENT as Student
{
    @EndUserText.label: 'Student ID'
    key Id,
    @EndUserText.label: 'First Name'
    FirstName,
    @EndUserText.label: 'Last Name'
    LastName,
    @EndUserText.label: 'Age'
    Age,
    @EndUserText.label: 'Determine Age'
    DetermineAge, 
    @EndUserText.label: 'Course'
    Course,
    @EndUserText.label: 'Course Description'
    CourseDesc,
    @EndUserText.label: 'Course Duration'
    CourseDuration,
    @EndUserText.label: 'Status'
    Status,
    @EndUserText.label: 'Gender'
    Gender,
    GenderDesc,
    @EndUserText.label: 'Dob'
    Dob          
  }

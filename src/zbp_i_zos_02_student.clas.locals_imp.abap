CLASS lhc_Student DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Student RESULT result.
    METHODS setadmitted FOR MODIFY
      IMPORTING keys FOR ACTION student~setadmitted RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR student RESULT result.
    METHODS setnotadmitted FOR MODIFY
      IMPORTING keys FOR ACTION student~setnotadmitted RESULT result.
    METHODS checkcourse FOR VALIDATE ON SAVE
      IMPORTING keys FOR student~checkcourse.
    METHODS determineage FOR DETERMINE ON save
      IMPORTING keys FOR student~determineage.
ENDCLASS.

CLASS lhc_Student IMPLEMENTATION.

  METHOD get_instance_authorizations.

** Status İşaretli ise => Set Admitted pasif,
** Status boşsa => setNotAdmitted pasif
    READ ENTITIES OF zi_zos_02_student IN LOCAL MODE
    ENTITY Student
    FIELDS ( Status ) WITH CORRESPONDING #( keys )
    RESULT DATA(studentadmitted)
    FAILED failed.

    result =
    VALUE #(
    FOR stud IN studentadmitted
    LET statusval = COND #( WHEN stud-Status = abap_true
                            THEN if_abap_behv=>fc-o-disabled
                            ELSE if_abap_behv=>fc-o-enabled )

                            IN ( %tky = stud-%tky %action-setAdmitted = statusval
                                                  %action-setNotAdmitted = COND #( WHEN statusval = if_abap_behv=>fc-o-enabled
                           														   THEN if_abap_behv=>fc-o-disabled
                                                                                   ELSE if_abap_behv=>fc-o-enabled )																				  )

           ).

*    result =
*    VALUE #(
*    FOR stud IN studentadmitted
*    LET statusval = COND #( WHEN stud-Status = abap_true
*                            THEN if_abap_behv=>fc-o-disabled
*                            ELSE if_abap_behv=>fc-o-enabled )
*
*                            IN ( %tky = stud-%tky %action-setAdmitted = statusval )
*
*           ).

  ENDMETHOD.

  METHOD setAdmitted.

    MODIFY ENTITIES OF zi_zos_02_student
    ENTITY Student
    UPDATE
    FIELDS ( Status )
    WITH VALUE #( FOR key IN keys ( %tky = key-%tky Status = abap_true ) )
    FAILED failed
    REPORTED reported.

    READ ENTITIES OF zi_zos_02_student IN LOCAL MODE
    ENTITY Student
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(studentdata).

    result = VALUE #( FOR studentrec IN studentdata
                       ( %tky = studentrec-%tky %param = studentrec )
                     ).


  ENDMETHOD.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD setNotAdmitted.

    MODIFY ENTITIES OF zi_zos_02_student
    ENTITY Student
    UPDATE
    FIELDS ( Status )
    WITH VALUE #( FOR key IN keys ( %tky = key-%tky Status = abap_false ) )
    FAILED failed
    REPORTED reported.

    READ ENTITIES OF zi_zos_02_student IN LOCAL MODE
    ENTITY Student
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(studentdata).

    result = VALUE #( FOR studentrec IN studentdata
                       ( %tky = studentrec-%tky %param = studentrec )
                     ).

  ENDMETHOD.

  METHOD checkCourse.

    DATA read_keys   TYPE TABLE FOR READ IMPORT zi_zos_02_student.
    DATA lt_student  TYPE TABLE FOR READ RESULT zi_zos_02_student.
    DATA reported_record LIKE LINE OF reported-student.

    read_keys = CORRESPONDING #( keys ).

    READ ENTITIES OF zi_zos_02_student IN LOCAL MODE
           ENTITY Student
           FIELDS ( Course )
             WITH read_keys
           RESULT lt_student.


    LOOP AT lt_student INTO DATA(ls_student).
      SELECT FROM zos_02_t_course
      FIELDS course, coursedesc
      WHERE course = @ls_student-Course
      UNION
      SELECT FROM zos_02_t_cours_d
      FIELDS course, coursedesc
      WHERE course = @ls_student-Course
      INTO TABLE @DATA(lt_check_course).

      IF  lt_check_course IS INITIAL.
        DATA(ls_message) = me->new_message(
                             id       = 'ZOS_02_MSG'
                             number   = 001
                             severity = ms-error
                              v1       = ls_student-Course
                              v2       = ls_student-CourseDesc
*                             v3       =
*                             v4       =
                           ).

      ELSE.
        ls_message  = me->new_message(
                          id       = 'ZOS_02_MSG'
                          number   = 002
                          severity = if_abap_behv_message=>severity-success
                          v1       = ls_student-Course
                          v2       = ls_student-CourseDesc
*                             v3       =
*                             v4       =
                          ).
      ENDIF.

      reported_record-%tky = ls_student-%tky.
      reported_record-%msg = ls_message.
      reported_record-%element-course = if_abap_behv=>mk-on.
      APPEND reported_record TO reported-student.

    ENDLOOP.

  ENDMETHOD.

  METHOD DetermineAge.


    DATA read_keys   TYPE TABLE FOR READ IMPORT zi_zos_02_student.
    DATA lt_student  TYPE TABLE FOR READ RESULT zi_zos_02_student.
    DATA reported_record LIKE LINE OF reported-student.

    read_keys = CORRESPONDING #( keys ).

    READ ENTITIES OF zi_zos_02_student IN LOCAL MODE
           ENTITY Student
           FIELDS ( FirstName LastName Age )
             WITH read_keys
           RESULT lt_student.


    LOOP AT lt_student INTO DATA(ls_student).

      ls_student-DetermineAge = |{ ls_student-FirstName }| && | | && |is| && | | && |{ ls_student-Age }| && | | && |Years old|.
      MODIFY lt_student FROM ls_student.



    ENDLOOP.

*    DATA: student_upd type table for update zi_zos_02_student.
**    student_upd = CORRESPONDING #( lt_student ).

    MODIFY ENTITIES OF zi_zos_02_student IN LOCAL MODE
            ENTITY Student
            UPDATE
            FIELDS ( DetermineAge )
*            with student_upd
            WITH VALUE #( ( %tky = ls_student-%tky DetermineAge  = ls_student-DetermineAge  ) ).
*            WITH VALUE #( ( %tky = ls_student-%tky  ) ) .

*    reported-student = CORRESPONDING  #( Deep reported_records-student ).

*    modify entities of zr_btp_zos_t_003_c in local mode
*            entity ZBTP_ZOS_Connection
*            UPDATE
*            FIELDS ( CityFrom CountryFrom CityTo CountryTo )
**            with connections_upd
*            with VALUE #( ( %tky = connection-%tky CityFrom    = connection-CityFrom
*                                                   CountryFrom = connection-CountryFrom
*                                                   CityTo      = connection-CityTo
*                                                   CountryTo   = connection-CountryTo ) ).




  ENDMETHOD.


ENDCLASS.

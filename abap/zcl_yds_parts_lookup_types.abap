*&---------------------------------------------------------------------*
*& Types for YDS Parts Lookup - Supplier Lead Time (SLT)
*&---------------------------------------------------------------------*

" ESD result structure (returned by get_esd)
TYPES: BEGIN OF ty_esd,
         matnr TYPE matnr,
         esd   TYPE string,
       END OF ty_esd,
       ty_esd_tt TYPE STANDARD TABLE OF ty_esd WITH EMPTY KEY.

" SLT result structure (returned by get_slt)
TYPES: BEGIN OF ty_slt,
         matnr TYPE matnr,
         slt   TYPE char35,            " e.g. '6 weeks' or '1 week'
       END OF ty_slt,
       ty_slt_tt TYPE STANDARD TABLE OF ty_slt WITH NON-UNIQUE KEY matnr.

" Plant / storage location configuration from SET_FIXED_VALUES
TYPES: BEGIN OF ty_plant_lgort,
         werks    TYPE werks_d,
         lgort    TYPE lgort_d,
         priority TYPE i,
       END OF ty_plant_lgort,
       ty_plant_lgort_tt TYPE STANDARD TABLE OF ty_plant_lgort
                            WITH NON-UNIQUE KEY priority werks.

CONSTANTS:
  gc_no_esd TYPE string VALUE 'No ESD',
  gc_week  TYPE char5  VALUE 'week',
  gc_weeks TYPE char5  VALUE 'weeks'.

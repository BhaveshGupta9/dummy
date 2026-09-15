*&---------------------------------------------------------------------*
*& Class definition excerpt - add to your existing OData DPC/DPC_EXT class
*&---------------------------------------------------------------------*

CLASS zcl_yds_parts_lookup DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
      ty_esd_tt         TYPE ty_esd_tt,
      ty_slt_tt         TYPE ty_slt_tt,
      ty_plant_lgort_tt TYPE ty_plant_lgort_tt.

    METHODS get_slt
      IMPORTING
        it_esd         TYPE ty_esd_tt
        it_plant_lgort TYPE ty_plant_lgort_tt
      EXPORTING
        et_slt         TYPE ty_slt_tt.

  PRIVATE SECTION.
    DATA gt_plant_lgort TYPE ty_plant_lgort_tt.

    METHODS set_fixed_values
      IMPORTING
        iv_vkorg TYPE vkorg.

ENDCLASS.

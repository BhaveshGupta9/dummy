*&---------------------------------------------------------------------*
*& Class definition excerpt
*&---------------------------------------------------------------------*

CLASS zcl_yds_parts_lookup DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
      ty_esd_tt         TYPE ty_esd_tt,
      ty_slt_tt         TYPE ty_slt_tt,
      ty_plant_lgpro_tt TYPE ty_plant_lgpro_tt.

    METHODS get_slt
      IMPORTING
        it_esd TYPE ty_esd_tt
      EXPORTING
        et_slt TYPE ty_slt_tt.

  PRIVATE SECTION.
    DATA gt_plant_lgpro TYPE ty_plant_lgpro_tt.

    METHODS set_fixed_values
      IMPORTING
        iv_vkorg TYPE vkorg.

ENDCLASS.

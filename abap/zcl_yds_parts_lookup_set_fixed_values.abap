*&---------------------------------------------------------------------*
*& Method SET_FIXED_VALUES (excerpt)
*&---------------------------------------------------------------------*

METHOD set_fixed_values.

  " ... existing fixed-value logic ...

  gt_plant_lgpro = VALUE #(
    WHEN iv_vkorg = 'YDS1' " adjust per implementation
    (
      ( werks = '3035' lgpro = '3520' priority = 1 )
      ( werks = '3036' lgpro = '3610' priority = 2 )
      ( werks = '3037' lgpro = '3710' priority = 3 )
    )
    ELSE VALUE #( )
  ).

ENDMETHOD.

*&---------------------------------------------------------------------*
*& Method SET_FIXED_VALUES (excerpt)
*&---------------------------------------------------------------------*

METHOD set_fixed_values.

  " ... existing fixed-value logic ...

  gt_plant_lgort = VALUE #(
    WHEN iv_vkorg = 'YDS1' " adjust per implementation
    (
      ( werks = '3035' lgort = '3520' priority = 1 )
      ( werks = '3036' lgort = '3610' priority = 2 )
      ( werks = '3037' lgort = '3710' priority = 3 )
    )
    ELSE VALUE #( )
  ).

ENDMETHOD.

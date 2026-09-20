  PRIVATE SECTION.

    CONSTANTS gc_hundred TYPE decfloat34 VALUE '100'.

    CLASS-METHODS resolve_key_date
      IMPORTING iv_key_date    TYPE datum
      RETURNING VALUE(rv_date) TYPE datum.

    "! Converte percentual gravado (18,00000) em fração (0,18)
    CLASS-METHODS to_fraction
      IMPORTING iv_percentage      TYPE any
      RETURNING VALUE(rv_fraction) TYPE decfloat34.

ad_page_contract {

  Swaps two sort keys for a survey, sort_order and sort_order - 1.

  @param  section_id  survey we're acting upon
  @param  sort_order   integer determining position of question which is
                     about to be replaced with previous one

  @author nstrug@arsdigita.com

  @cvs-id $Id$

} {
  survey_id:integer,notnull
  section_id:integer,notnull
  sort_order:integer,notnull
  direction:notnull
}

ad_require_permission $section_id survey_modify_survey

if { $direction=="up" } {
     set next_sort_order [expr { $sort_order - 1 }]
} else {
     set next_sort_order [expr { $sort_order + 1 }]
}
db_transaction {
    db_dml swap_sort_orders "update survey_questions
set sort_order = decode(sort_order, :sort_order, :next_sort_order, :next_sort_order, :sort_order)
where section_id = :section_id
and sort_order in (:sort_order, :next_sort_order)"

ad_returnredirect "one?survey_id=$survey_id&#${sort_order}"

} on_error {

    ad_return_error "Database error" "A database error occured while trying
to swap your questions. Here's the error:
<pre>
$errmsg
</pre>
"
}


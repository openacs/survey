# /www/survey/admin/responses-export.tcl
ad_page_contract {

  CSV export of responses to particular survey.

  @author  sebastian@arsdigita.com
  @date    July 2000
  @cvs-id  $Id$

} {

  survey_id:integer,notnull
  {unique_users_p f}
  on_what_id:optional,integer
  {start:naturalnum 1}
  {end:naturalnum 10000}
}
set csv_export ""
set package_id [ad_conn package_id]
ad_require_permission $package_id survey_admin_survey

set question_id_list [list]
set responses_table survey_responses

set headline "email,first_names,last_name,user_id,submission_date,ip_address,response_id"

db_foreach get_question_data_types {} {
    lappend question_id_list $question_id
    regsub -all {"} $question_text {""} question_text
    append headline ",\"$question_text"
    append headline "\""
    set question_data_type($question_id) $abstract_data_type
    switch -- $abstract_data_type {
	"date" {
	    set question_column($question_id) "date_answer"
	}
	"text" {
	    set question_column($question_id) "clob_answer"
	}
	"shorttext" {
	    set question_column($question_id) "varchar_answer"
	}
	"boolean" {
	    set question_column($question_id) "boolean_answer"
	}
	"integer" -
	"number" {
	    set question_column($question_id) "number_answer"
	}
	"choice" {
	    set question_column($question_id) "label"
	}
	"blob" {
	    set question_column($question_id) "attachment_answer"
	}
	default {
	    set question_column($question_id) "varchar_answer"
	}
    }

}

#  We're looping over all question responses in survey_question_responses

set current_response_id ""
set current_response ""
set current_question_id ""
set current_question_list [list]
set csv_export ""
set r 0
ReturnHeaders "application/text"
ns_write "$headline \r\n"

db_foreach get_all_survey_question_responses "" {

    if { $response_id != $current_response_id } {
	if { ![empty_string_p $current_question_id] } {
	    append current_response ",\"[join $current_question_list ","]\""
	}

	if { ![empty_string_p $current_response_id] } {
	    append csv_export "$current_response \r\n"
	}
	set current_response_id $response_id
	set one_response [list $email $first_names $last_name $user_id $creation_date $response_id]
	regsub -all {"} $one_response {""} one_response
	set current_response "\"[join $one_response {","}]\""

	set current_question_id ""
	set current_question_list [list]
    }

      set response_value [set $question_column($question_id)]
      #  Properly escape double quotes to make Excel & co happy
      regsub -all {"} $response_value {""} response_value
  
      #  Remove any CR or LF characters that may be present in text fields
      regsub -all {[\r\n]} $response_value {} response_value

      if { $question_id != $current_question_id } {
  	if { ![empty_string_p $current_question_id] } {
  	    append current_response ",\"[join $current_question_list ","]\""
  	}
  	set current_question_id $question_id
  	set current_question_list [list]
      }
# decode boolean answers
	if {$question_data_type($question_id)=="boolean"} {
	    set response_value [survey_decode_boolean_answer -response $response_value -question_id $question_id]
	}
	if {$question_data_type($question_id)=="blob"} {
	    set response_value [db_string get_filename {} -default ""]
	}
      lappend current_question_list $response_value
	
	incr r
	if {$r>99} {
	    ns_write "${csv_export} "
	    set csv_export ""
	    set rows 0
	}

    }

  if { ![empty_string_p $current_question_id] } {
      append current_response ",\"[join $current_question_list ","]\""
  }
  if { ![empty_string_p $current_response_id] } {
     append csv_export "$current_response\r\n"
 }
    if {[empty_string_p $csv_export]} {
	set csv_export "\r\n"
    }
    ns_write $csv_export

ns_conn close
# /www/survsimp/admin/question-delete.tcl
ad_page_contract {

    Delete a question from a survey
    (or ask for confirmation if there are responses).

    @param  question_id  question we're about to delete

    @author jsc@arsdigita.com
    @date   March 13, 2000
    @cvs-id question-delete.tcl,v 1.5.2.4 2000/07/21 04:04:15 ron Exp
} {

    question_id:integer
    {sort_order ""}
}

ad_require_permission $question_id survey_delete_question

db_1row section_id_from_question_id ""

get_survey_info -section_id $section_id
set survey_id $survey_info(survey_id)

set n_responses [db_string survey_number_responses {} ]

ad_form -name confirm_delete -export {sort_order} -form {
    question_id:key
    {question_text:text(inform) {label "Delete:"}}
    {from:text(inform) {label "From:"} {value $survey_info(name)}}
}

if {$n_responses > 0} {
    if {$n_responses >1} {
	set response_text "responses"
    } else {
	set response_text "response"
    }
    ad_form -extend -name confirm_delete -form {
	{warning:text(inform) {value "This question has $n_responses $response_text that will be deleted if you continue. (Note: This can not be undone.)"}
	{label "Warning!"}}
    }
 
}

ad_form -extend -name confirm_delete -form {
   {confirmation:text(radio) {label " "}
	{options
	    {{"Continue with Delete" t }
	     {"Cancel and return to survey responses" f }}	}
	     {value f}}
    } -select_query_name {get_question_details} -on_submit {
	if {$confirmation} {
	    db_transaction {

		db_dml survey_question_responses_delete {}

		db_dml survey_question_choices_delete {}

		db_exec_plsql survey_delete_question {}
		if {![empty_string_p $sort_order]} {
		    db_exec_plsql survey_renumber_questions {}
		}
	    } on_error {
    
		ad_return_error "Database Error" "There was an error while trying to delete the question:
		<pre>
		$errmsg
		</pre>
		<p> Please go back using your browser.
		"
                ad_script_abort
	    }

	    db_release_unused_handles
	    set sort_order [expr {$sort_order -1}]
	}
        ad_returnredirect "one?[export_url_vars survey_id]&#${sort_order}"
        ad_script_abort
    }

set context_bar [ad_context_bar "Delete Question"]    
ad_return_template


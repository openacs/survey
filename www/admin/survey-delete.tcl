ad_page_contract {

    This page allows the admin to delete survey and all responses.

    @param survey_id

    @author dave@thedesignexperience.org
    @date   August 7, 2002
    @cvs-id $Id$
} {

   survey_id:integer

}

set package_id [ad_conn package_id]
ad_require_permission $package_id survey_admin_survey

get_survey_info -survey_id $survey_id

set questions_count ""
set responses_count ""

ad_form -name confirm_delete -form {
    {survey_id:text(hidden) {value $survey_id}}
    {warning:text(inform) {label "Warning:"} {value "Deleting this survey will delete all $questions_count questions and all $responses_count responses associated with this survey!"}}
    {confirmation:text(radio) {label " "}
	{options
	    {{"Continue with Delete" t }
	     {"Cancel and return to survey administration" f }}	}
	    {value f}
    }

} -on_submit {
    if {$confirmation} {
	db_exec_plsql delete_survey {}
	ad_returnredirect "."
    } else {
	ad_returnredirect "one.tcl?[export_vars survey_id]"
    }
}

set context_bar [ad_context_bar "Delete Survey"]